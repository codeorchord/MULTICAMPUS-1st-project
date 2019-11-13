var bDebug = false;
var g_map = null;
var g_overlay = null;
var g_curGu = {
	name : "",
	polygon : null
}
var g_hashmap = null;



window.addEventListener("load", function(){
	
	makeHashMap();
	loadMap();
	
	g_hashmap.keys().forEach(function(d){
		var bCurrent = $("#guname").val() == d ? true : false;
		gupolygon( g_hashmap.get(d), bCurrent );
	});
	
	drawChart();
	
	
	$('#guCombo').on('change', function() {
	    var name = $(this).val();
	    changeGu(name);
	    
	    setTimeout(function(){
	    	var points = []; // 중심좌표 구하기 위한 지역구 좌표들 
		    var path = g_curGu.polygon.getPath();
		    path.forEach(function(xy){
		    	var point = new Object();
				point.x = xy.Ha;
				point.y = xy.Ga;
				points.push(point);
		    });

		    var latLng = centroid (points);
		    g_map.setCenter(latLng);
	    }, 100);
	});

}, false);


function changeGu(name) {
	g_curGu.polygon.setMap(null);
	
	gupolygon( g_hashmap.get(name), true );
	gupolygon( g_hashmap.get(g_curGu.name), false);
	
	requestData(name);
}



function loadMap() {
	var gupath = $("#gupath").val();
	var gupoint = $("#gupoint").val();

	
	var centerpoint = eval("(" + gupoint + ")");
	
	
	kakao.maps.load(function() {
		debug("maps.load");
		setTimeout(function(){
	
			
			
		}, 500);
	});
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(centerpoint.x, centerpoint.y), // 지도의 중심좌표
        level: 8 // 지도의 확대 레벨
    };

	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	g_map = new kakao.maps.Map(mapContainer, mapOption); 
	
	
}



function displayArea(coordinates, name2, bCurrent){
		
	var path = []; // 폴리곤 그려줄 path
	var points = []; // 중심좌표 구하기 위한 지역구 좌표들 

	$.each(coordinates[0], function(index, coordinate){
		
		var pathTmp = new kakao.maps.LatLng(coordinate[1], coordinate[0]);
		path.push(pathTmp); //인식을 위한 배열 추가

	})

	
    var polygon = new kakao.maps.Polygon({
    	  map: g_map, // 다각형을 표시할 지도 객체
    	  path: path,
          strokeWeight: 2,
          strokeColor: '#000',
          strokeOpacity: bCurrent ? 0.5 : 0.3,
          fillColor: '#ff0',
          fillOpacity: bCurrent ? 0.3 : 0.01 //0.3
          
          
	});
	
	if(bCurrent) {
		g_curGu.name = name2;
		g_curGu.polygon = polygon;
	}
	
	kakao.maps.event.addListener(polygon, 'click', function(mouseEvent) {
		changeGu(name2);
	});
	  	
}


function requestData(name) {
	var parcel = {
			guName : name
	};
	
	$.ajax({
        url: '../apis/getGuCrime',
        type: 'post',
        dataType: 'json',
        contentType: 'application/json',
        success: function(data){
        	updateTable(data);
        },
        data: JSON.stringify(parcel)
    });
}
	

function gupolygon(guname, bCurrent) {
	$.getJSON("/outliers/resources/geojson/" + guname, function(geojson){
		var data = geojson.features;
		var coordinates = []; // 좌표 저장할 배열
	
		$.each(data, function(index, val){
			var coordinates = val.geometry.coordinates;
			var name2 = val.properties.name
			
			displayArea(coordinates, name2, bCurrent);
			
		})
	})
}


function makeHashMap() {
	
	g_hashmap = new HashMap();
	g_hashmap.put("도봉구", "dobong.geojson");
	g_hashmap.put("동대문구", "dongdaemun.geojson");
	g_hashmap.put("동작구", "dongjak.geojson");
	g_hashmap.put("은평구", "eunpyeong.geojson");
	g_hashmap.put("강북구", "gangbuk.geojson");
	g_hashmap.put("강남구", "gangnam.geojson");
	g_hashmap.put("강서구", "gangseo.geojson");
	g_hashmap.put("강동구", "gangdong.geojson");
	g_hashmap.put("금천구", "geumcheon.geojson");
	g_hashmap.put("구로구", "guro.geojson");
	g_hashmap.put("관악구", "gwanak.geojson");
	g_hashmap.put("광진구", "gwangjin.geojson");
	g_hashmap.put("종로구", "jongno.geojson");
	g_hashmap.put("중구", "junggu.geojson");
	g_hashmap.put("중량구", "jungnang.geojson");
	g_hashmap.put("마포구", "mapo.geojson");
	g_hashmap.put("노원구", "nowon.geojson");
	g_hashmap.put("서초구", "seocho.geojson");
	g_hashmap.put("서대문구", "seodaemun.geojson");
	g_hashmap.put("성북구", "seongbuk.geojson");
	g_hashmap.put("성동구", "seongdong.geojson");
	g_hashmap.put("송파구", "songpa.geojson");
	g_hashmap.put("양천구", "yangcheon.geojson");
	g_hashmap.put("영등포구", "yeongdeungpo.geojson");
	g_hashmap.put("용산구", "yongsan.geojson");
}


function centroid (points){
	
	var i, j, len, p1, p2, f, area, x, y;
	
	area = x = y = 0;
	
	for(i = 0, len = points.length, j = len -1; i < len; j= i++){
		p1 = points[i];
		p2 = points[j];
		
		f = p1.y * p2.x - p2.y * p1.x;
		x += (p1.x + p2.x) * f;
		y += (p1.y + p2.y) * f;
		area += f * 3;
		
		
	}
	
	return new kakao.maps.LatLng(x / area, y / area);
}

function drawChart() {
	google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawVisualization);
    
    
    var table = $(id_table).children().eq(1);
    var table_row_0 = table.children().eq(0);
    var table_row_1 = table.children().eq(1);
    var table_row_2 = table.children().eq(2);
    var table_row_3 = table.children().eq(3);

    function drawVisualization() {
      // Some raw data (not necessarily accurate)
      var data = google.visualization.arrayToDataTable([
        ['year', 'murder', 'sexual_assault', 'violence', 'robber', 'theft', 'total'],
        [
				table_row_0.children().eq(0).html(),  
				parseInt(table_row_0.children().eq(1).html()),      
				parseInt(table_row_0.children().eq(2).html()),         
				parseInt(table_row_0.children().eq(3).html()),             
				parseInt(table_row_0.children().eq(4).html()),           
				parseInt(table_row_0.children().eq(5).html()),      
				parseInt(table_row_0.children().eq(6).html())
     		],
        [		table_row_1.children().eq(0).html(),  
      	  	parseInt(table_row_1.children().eq(1).html()),      
      	  	parseInt(table_row_1.children().eq(2).html()),        
      	  	parseInt(table_row_1.children().eq(3).html()),             
      	  	parseInt(table_row_1.children().eq(4).html()),          
      	  	parseInt(table_row_1.children().eq(5).html()),      
      	  	parseInt(table_row_1.children().eq(6).html())
      	  ],
   	  [		table_row_2.children().eq(0).html(),  
         	  	parseInt(table_row_2.children().eq(1).html()),      
         	  	parseInt(table_row_2.children().eq(2).html()),        
         	  	parseInt(table_row_2.children().eq(3).html()),             
         	  	parseInt(table_row_2.children().eq(4).html()),          
         	  	parseInt(table_row_2.children().eq(5).html()),      
         	  	parseInt(table_row_2.children().eq(6).html())
         	  ],
        [		table_row_3.children().eq(0).html(),  
        	  	parseInt(table_row_3.children().eq(1).html()),      
        	  	parseInt(table_row_3.children().eq(2).html()),        
        	  	parseInt(table_row_3.children().eq(3).html()),             
        	  	parseInt(table_row_3.children().eq(4).html()),          
        	  	parseInt(table_row_3.children().eq(5).html()),      
        	  	parseInt(table_row_3.children().eq(6).html())
        	  ]
        ]
        	  );

      var options = {
        title : '2014~2017 서울시 구별 5대 범죄 현황',
        vAxis: {title: '발생건수',logScale: true},
        hAxis: {title: '년도'},
        seriesType: 'bars',
        series: {5: {type: 'line'}}
      };

      var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    }
}


function updateTable(data) {
	data.forEach(function(d, i) {
		var table_row =  $(id_table).children().eq(1).children().eq(i);
		
		table_row.children().eq(0).html(d.year);
		table_row.children().eq(1).html(d.murder);
		table_row.children().eq(2).html(d.sexual_assault);
		table_row.children().eq(3).html(d.violence);
		table_row.children().eq(4).html(d.robber);
		table_row.children().eq(5).html(d.theft);
		table_row.children().eq(6).html(d.total);
	});
	
	drawChart();
}


	


function debug(obj) {
	if(bDebug ) {
		console.log(obj);
	}
}






	



