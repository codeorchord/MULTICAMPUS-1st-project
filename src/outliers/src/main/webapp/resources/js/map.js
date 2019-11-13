/**
 * map.js
 */
var bDebug = true;

var g_map = null;
var g_drawingMgr = null;
var g_overlay = null;
var g_stations = [];
var g_cctvs = [];
var g_ps = null;
var g_infowindow=null;
var g_markers=[];

var g_status = {
	hasAnalysis : false,
	influence : 1,
	lastLatLng : null,
	needCntrRcvr : false
};


/*
 * Window event functions
 */
window.addEventListener("load", function(){
	
	uiTask();
	
	kakao.maps.load(function() {
		debug("maps.load");
		
		loadMap();
		addBtnEvent();
		addMapEvent();
		
		setTimeout(function(){
			lookPolygon();
			loadSpot()
		}, 500);
	});
	

}, false);


window.addEventListener("resize", function (){
	
	g_status.hasAnalysis = false;
	if( $('#btnAnalysis').hasClass('active') ) {
		$('#btnAnalysis').trigger( "click" )
	}	
	
}, false);



/*
 * Map event
 */
function addMapEvent() {
	kakao.maps.event.addListener(g_map, 'idle', function() {
	    loadSpot();
	    
	    if( !($('#btnAnalysis').hasClass('active')) ) {
	    	g_status.hasAnalysis = false;
		}
	});
	
	
	kakao.maps.event.addListener(g_map, 'zoom_changed', function() {

		if( g_map.getLevel() >= 7 ) {
			$('.alert').css('display', 'block');
			unSetCCTVs();
			rmCCTVs();
			$('#cctv-cnt').html("-")
		}
		else {
			$('.alert').css('display', 'none');
		}
	});
	
	
	kakao.maps.event.addListener(g_map, 'center_changed', function() {
		if( $('#btnAnalysis').hasClass('active') ) {
			setTimeout(function(){
				g_status.needCntrRcvr = true;
			}, 100)
		}
	});
	
	
	
	$("#map").mouseup(function(){
		if(g_status.needCntrRcvr) {
			g_status.needCntrRcvr = false;
			g_map.setCenter(g_status.lastLatLng);
		}
	});
	
	
	"drawend cancel".split(" ").forEach(function(e){
		g_drawingMgr.addListener(e, function(data){
		    unSetDrawingMode();
		});
	});

	
	kakao.maps.event.addListener(g_map, 'click', function(mouseEvent) {
		if( $('#btnRoadView').hasClass('active') ) {
			var latLng = mouseEvent.latLng;
			
			var roadviewContainer = document.getElementById('roadview'); //로드뷰를 표시할 div
			var roadview = new kakao.maps.Roadview(roadviewContainer); //로드뷰 객체
			var roadviewClient = new kakao.maps.RoadviewClient(); //좌표로부터 로드뷰 파노ID를 가져올 로드뷰 helper객체

			// 특정 위치의 좌표와 가까운 로드뷰의 panoId를 추출하여 로드뷰를 띄운다.
			roadviewClient.getNearestPanoId(latLng, 50, function(panoId) {
			    roadview.setPanoId(panoId, latLng); //panoId와 중심좌표를 통해 로드뷰 실행
			    $( document ).ready( function() {
			        var jbHtml = $( '#exampleModal' ).modal('show');
			        
			      } );
			});
		}
	});
	
}

/*
 * Button event
 */
function addBtnEvent() {
	$('#map_type_base').children().each(function(i){
		this.addEventListener("click", function(){
			
			var changeMapytype;
			switch(i) {
			case 0:
				changeMaptype = kakao.maps.MapTypeId.ROADMAP;
				break;
			case 1:
				changeMaptype = kakao.maps.MapTypeId.HYBRID;
				break;
			}
			
			g_map.setMapTypeId(changeMaptype);
			
		}, false);
		
	});
	
	
	$('#map_type_overlay').children().each(function(i){
		this.addEventListener("click", function(){
			
			if(g_overlay != null) {
				 g_map.removeOverlayMapTypeId(g_overlay);
			}
			
			switch(i) {
			case 1 :
				g_overlay = kakao.maps.MapTypeId.ROADVIEW;
				break;
			case 2 :
				g_overlay = kakao.maps.MapTypeId.TRAFFIC;
				break;
			case 3 :
				g_overlay = kakao.maps.MapTypeId.USE_DISTRICT;
				break;
			default:
				return;
			}
			
			g_map.addOverlayMapTypeId(g_overlay);
			
		}, false);
		
	});
	
	
	$(function () {
	  $('#btnAnalysis').popover({
		    container: 'body'
	  });
	});


	$("#btnAnalysis").click(function(){
		g_drawingMgr.cancel();
		if( $(this).hasClass('active') ) {
			hideImgOverlay();
		}
		else {
			if(g_status.hasAnalysis) {
		    	showImgOverlay();
		    }
		    else {
		    	debug(getMapBounds());
				showLoading();
				adjustImgOverlay();
				
				let parcel = getMapBounds();
				parcel.influence = g_status.influence;
				
				$.ajax({
			        url: 'apis/analysis',
			        type: 'post',
			        dataType: 'json',
			        contentType: 'application/json',
			        success: function(data){
			        	hideLoading();
			        	
			        	if(data.URI != 'failed')
			        		applyAnalysis(data);
			        	else
			        		alert("R서버에서 문제가 발생하였습니다.")
			        },
			        error: function(equest,status,error) {
			        	hideLoading();
			        	console.error(error);
			        },
			        data: JSON.stringify(parcel)
			    });
		    }
		}
	});
	
	
	$("#btnSpot").click(function(){
		
		if( $(this).hasClass('active') ) {
			unSetStations();
			unSetCCTVs();
		}
		else {
			setStations(g_map);
			setCCTVs(g_map);
		}
	});
	
	
	$("#btnDraw").click(function() {	
		setDrawingMode();
		selectOverlay('POLYGON');
	});
	
	
	$("#btnErase").click(function() {
		g_drawingMgr.clear();
	});
	
	//검색 이벤트
	$("#searchPlaces").attr("onsubmit","searchPlaces(); return false;");
	
}



/*
 *  API functions
 */
function loadMap() {
	var mapContainer = document.getElementById('map'),
    mapOption = { 
        center: new kakao.maps.LatLng(37.50121991746371, 127.03946043730475), 
        level: 5 
    };
	g_map = new kakao.maps.Map(mapContainer, mapOption); 
	
	var options = { 
	    map: g_map, 
	    drawingMode: [ 
	        kakao.maps.drawing.OverlayType.POLYGON
	    ],
	    guideTooltip: ['draw', 'drag', 'edit'], 
	    polygonOptions: {
	        //draggable: true,
	        removable: true,
	        //editable: true,
	        strokeColor: '#f00',
	        fillColor: '#f00',
	        fillOpacity: 0.5,
	        hintStrokeStyle: 'dash',
	        hintStrokeOpacity: 0.5
	    }
	};
	g_drawingMgr = new kakao.maps.drawing.DrawingManager(options);
	
	
	// 장소 검색 객체를 생성합니다
	g_ps = new kakao.maps.services.Places();
	// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
    g_infowindow = new kakao.maps.InfoWindow({zIndex:4});
}


function loadSpot() {
	let bounds = getMapBounds();
	bounds.left -= 0.002;
	bounds.top += 0.002;
	bounds.right += 0.002;
	bounds.bottom -= 0.002;

	//경찰서 가져오기
    $.ajax({
        url: 'apis/getStations',
        type: 'post',
        dataType: 'json',
        contentType: 'application/json',
        success: function(data){
        	drawSpot(data, 'station');
        },
        data: JSON.stringify(bounds)
    });
    
    //CCTV 가져오기 (범위가 너무 크면 가져오지 않는다)
    if(g_map.getLevel() < 7) {
	    $.ajax({
	        url: 'apis/getCCTVs',
	        type: 'post',
	        dataType: 'json',
	        contentType: 'application/json',
	        success: function(data){
	        	drawSpot(data, 'cctv');
	        },
	        data: JSON.stringify(bounds)
	    });
    }
}


function drawSpot(list, type ){
	
	//그려놓은 모든 방법시설을 삭제한다
	if(type == 'station') {
		unSetStations();
		rmStations();
	} else {
		unSetCCTVs();
		rmCCTVs();
	}
	
	//새로 그린다
	list.forEach(function(d, i){
		let colorStationStroke = 'blue'
		let colorStationFill = 'blue'
		let colorCCTVStroke = 'magenta'
		let colorCCTVFill = 'magenta'

		var circle = new kakao.maps.Circle({
			center : new kakao.maps.LatLng(d.latitude, d.longitude),  // 원의 중심좌표 입니다 
			radius: type == 'station' ? 200 : Math.ceil(Math.sqrt(d.count) * 10), // 미터 단위의 원의 반지름입니다 
			strokeWeight: type == 'station'? 2 : 1, // 선의 두께입니다 
			strokeColor: type == 'station' ? colorStationStroke : colorCCTVStroke, // 선의 색깔입니다
			strokeOpacity: 1, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
			strokeStyle: 'solid', // 선의 스타일 입니다
			fillColor: type == 'station' ? colorStationFill : colorCCTVFill, // 채우기 색깔입니다
			fillOpacity: 0.5  // 채우기 불투명도 입니다   
		}); 

		// 지도에 원을 표시합니다 
		if( $('#btnSpot').hasClass('active') ) {
			circle.setMap(g_map); 
		}

		if(type == 'station') {
			g_stations.push(circle);
			$('#station-cnt').html(g_stations.length);
		} else {
			g_cctvs.push(circle);
			$('#cctv-cnt').html(g_cctvs.length);
		}

	});
}


//키워드 검색을 요청하는 함수입니다
function searchPlaces() {
	if( $('#btnAnalysis').hasClass('active') ) {
		$('#btnAnalysis').trigger( "click" )
	}

    var keyword = document.getElementById('keyword').value;
    
    //alert(keyword)

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    
    g_ps.keywordSearch( keyword, placesSearchCB); 
}

//장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);
     
        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;
    }
}

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {
    var listEl = document.getElementById('placesList'),
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();

    for ( var i=0; i<places.length; i++ ) {

        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
        var marker = addMarker(placePosition, i);
        var itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다
        
        $(itemEl).click(function(e, i) {
        	let index = $(this).attr("data");
        	g_markers[index].setMap(g_map);
        	g_map.setCenter(g_markers[index].getPosition());
        	$("#menu_wrap").css('visibility', "collapse");
        

        });
        
        fragment.appendChild(itemEl);
    }
   

    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;
}

// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';
    $(el).attr("data", index);

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수
function addMarker(position, idx, title) {
	
	$("#menu_wrap").css('visibility', "visible");
	
    var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    g_markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < g_markers.length; i++ ) {
    	g_markers[i].setMap(null);
    }   
    g_markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:2;">' + title + '</div>';

    g_infowindow.setContent(content);
    g_infowindow.open(g_map, marker);
}

// 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}







function showLoading() {
	$("#loading").css('visibility', 'visible' )
}

function hideLoading() {
	$("#loading").css('visibility', 'collapse' )
}


function showImgOverlay() {
	$("#imgOverlay").css('visibility', 'visible' )
}

function hideImgOverlay() {
	$("#imgOverlay").css('visibility', 'collapse' )
}



function applyAnalysis(data){
	$("#imgOverlay").attr("src", data.URI+"?"+Math.floor(Math.random()*1000000000));
	showImgOverlay();
	
	g_status.hasAnalysis = true;
}


function setStations(map) {
	g_stations.forEach(function(d, i){ d.setMap(map)	});
}

function setCCTVs(map) {
	g_cctvs.forEach(function(d, i){ d.setMap(map)	});
}

function unSetStations() {
	g_stations.forEach(function(d, i){ d.setMap(null)	});
}

function unSetCCTVs() {
	g_cctvs.forEach(function(d, i){ d.setMap(null)	});
}

function rmStations() {
	g_stations = [];
}

function rmCCTVs() {
	g_cctvs = [];
}


function getMapBounds() {
	let mapBounds = g_map.getBounds();
	let latLngNE = mapBounds.getNorthEast();
	let latLngSW = mapBounds.getSouthWest();
	
	let bounds = {
        left : latLngSW.getLng(),
        top : latLngNE.getLat(),
        right : latLngNE.getLng(),
        bottom : latLngSW.getLat()
    };
	
	return bounds;
}


function selectOverlay(type) {
	g_drawingMgr.cancel();
	
	if(type != 'POLYGON') 
		return;

	g_drawingMgr.select(kakao.maps.drawing.OverlayType[type]);
}


function setDrawingMode(){
	g_status.lastLatLng = g_map.getCenter();
	
	if( $('#btnAnalysis').hasClass('active') ) {
		console.log("들어왔고");
		$('#imgOverlay').css({"opacity":1, "z-index": 1});
		$('#map').css("opacity", 1 - $('#adv-op').slider().data('slider').getValue());
		
		g_map.setZoomable(false);
	}
}


function unSetDrawingMode() {
	if( $('#btnAnalysis').hasClass('active') ) {
		$('#imgOverlay').css({"opacity" : $('#adv-op').slider().data('slider').getValue(), "z-index": 3 });
		$('#map').css("opacity", 1);
		
		g_map.setZoomable(true);
	}
}



function adjustImgOverlay() {
	let elemMap = $("#map");
	let elemImgOverlay = $("#imgOverlay");
	elemImgOverlay.css("width", elemMap.width());
	elemImgOverlay.css("height", elemMap.height());
	elemImgOverlay.css("left", elemMap.offset().left);
	elemImgOverlay.css("top", elemMap.offset().top);
}


function uiTask() {
	var opacity = $('#adv-op').slider()
	.on('slide', function(){
		$('#imgOverlay').css('opacity', opacity.getValue());
	})
	.data('slider');
	
	var influence = $('#adv-inf').slider()
	.on('slide', function(){
		g_status.influence = influence.getValue();
		g_status.hasAnalysis = false;
		if( $('#btnAnalysis').hasClass('active') ) {
			$('#btnAnalysis').trigger( "click" )
		}	
	})
	.data('slider');
	
	$(function () {
	  $('[data-toggle="tooltip"]').tooltip()
	});
}



function lookPolygon(){
	$.getJSON("./resources/geojson/seoul_municipalities1.geojson", function(geojson){
		var data = geojson.features;
		var coordinates = []; // 좌표 저장할 배열
	
		
		$.each(data, function(index, val){
			var coordinates = val.geometry.coordinates;
			var name = val.properties.name
			
			displayArea(coordinates, name);
			
		})
		
	})
}


function displayArea(coordinates, name){
	var path = []; // 폴리곤 그려줄 path
	var points = []; // 중심좌표 구하기 위한 지역구 좌표들 

	$.each(coordinates[0], function(index, coordinate){
		var point = new Object();
		point.x = coordinate[1];
		point.y = coordinate[0];
		points.push(point);
		
		var pathTmp = new kakao.maps.LatLng(coordinate[1], coordinate[0]);
		path.push(pathTmp); //인식을 위한 배열 추가

	})
	
    var polygon = new kakao.maps.Polygon({
    	  map: g_map, // 다각형을 표시할 지도 객체
    	  path: path,
          strokeWeight: 2,
          strokeColor: '#000',
          strokeOpacity: 0.5,
          fillOpacity: 0.01 
	});
	$("#polygonbtn").click(function javascript_onclick(){	  
	    kakao.maps.event.addListener(polygon, 'click', function(mouseEvent) {
	    	var centerpoint = centroid (points);
	    	console.log(centerpoint);
	    	
	
	    	let point = "{ y : " + centerpoint.getLng() +  ", x : " + centerpoint.getLat() + "}";
	    	console.log(point);
	    
		   	var form = document.createElement("form");     
		    form.setAttribute("method","post");             
		    form.setAttribute("action","./map/view");     
		    document.body.appendChild(form);               
		  
		    var insert = document.createElement("input");   
		    insert.setAttribute("type","hidden");          
		    insert.setAttribute("name", "name");               
		    insert.setAttribute("value", name);             
		    form.appendChild(insert);                     	 
		                               
		    
		    var insert2 = document.createElement("input");   
		    insert2.setAttribute("type","hidden");           
		    insert2.setAttribute("name", "path");              
		    insert2.setAttribute("value", path);             
		    
		    var insert3 = document.createElement("input");   
		    insert3.setAttribute("type","hidden");           
		    insert3.setAttribute("name", "point");              
		    insert3.setAttribute("value", point); 
		    form.appendChild(insert3);                    
		    
		    form.submit();                                
		});
	});
}








function debug(obj) {
	if(bDebug ) {
		console.log(obj);
	}
}




