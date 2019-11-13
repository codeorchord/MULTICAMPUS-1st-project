<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- global resources -->
<%@ include file="global/resources_header.jsp" %>

<!-- Custom styles for this template -->
<link href="resources/css/map.css" rel="stylesheet">
<title>Blindspot Finder - Ananlysis</title>
</head>
<body>
  <!-- hidden component -->
  <div id="loading">
    <img src="resources/images/sandglass-time-loading-gif.svg"/>
  </div>
  <img src="" id="imgOverlay" />
  
  <!-- nav -->
  <%@ include file="global/nav_map.jsp" %>
  
  <div class="container-fluid">
    <div class="row">
      <nav class="col-md-2 d-none d-md-block bg-light sidebar">
        <div class="sidebar-sticky">
          <h5 class=" d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>ADVANCED</span>
            <a class="d-flex align-items-center text-muted" href="#">
              <span data-feather="plus-circle"></span>
            </a>
          </h5>
          <h4 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted orange-tooltip">
            <span>Opacity</span>
          </h4>
          <ul class="nav flex-column" data-toggle="tooltip" data-placement="top" title="분석 오버레이의 투명도">
            <li class="nav-item talign-ct">
              <input type="text" class="span2" value="" data-slider-min="0" data-slider-max="0.8" data-slider-step="0.1" data-slider-value="0.4" data-slider-id="adv-opacity" id="adv-op" data-slider-tooltip="show" data-slider-handle="round"/>
            </li>
          </ul>
          <h4 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>Influence</span>
          </h4>
          <ul class="nav flex-column" data-toggle="tooltip" data-placement="top" title="방범시설의 영향력">
            <li class="nav-item talign-ct">
              <input type="text" class="span2" value="" data-slider-min="0.5" data-slider-max="1.5" data-slider-step="0.1" data-slider-value="1" data-slider-id="adv-influence" id="adv-inf" data-slider-tooltip="hide" data-slider-handle="round" />
              <br><small class="text-muted">다음 번 분석부터 적용됩니다.</small>
            </li>
          </ul>
          <h5 class=" d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>ADDITIONAL</span>
          </h5>
          <h4 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>Tools</span>
          </h4>
          <ul class="nav flex-column">
            <li class="nav-item talign-ct">
              <div class="card" style="width:85%; margin:auto;">
                <div class="card-body">
                  <h5 class="card-title">Drawing</h5>
                  <h6 class="card-subtitle mb-2 text-muted">polygons</h6>
                  <p class="card-text"><small class="text-muted">분석 오버레이가 표시중 일 때는 지도 조작이 불가능하므로, 그리기 툴을 이용하여 자세히 살펴볼 지역을 체크해 두세요.</small></p>
                  <div class="btn-group" role="group">
                  <button type="button" class="btn btn-primary btn-sm mr-2" id="btnDraw"><small>그리기</small></button>
                  <button type="button" class="btn btn-warning btn-sm" id="btnErase"><small>지우기</small></button>
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </nav>
  
      <main role="main" class="col-md-10 ml-sm-auto col-lg-10 px-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
          <h1 class="h2">Dashboard</h1>
    	  <div class="map-control">
    	  
    	  	<button type="button" class="btn btn-primary mr-2 active" data-toggle="button" aria-pressed="false" autocomplete="off" id="btnSpot">
			  방범시설
			</button>
			
          	<button type="button" class="btn btn-danger btn-group-toggle mr-2" data-container="body" data-toggle="buttons" 
          		data-placement="top" data-content="분석 오버레이 표시 중에는 지도를 조작할 수 없습니다." id="btnAnalysis">
			  	사각지대 분석
			</button>
          
          	<div class="btn-group mr-2 btn-group-toggle btn-group-sm cstm_btn-md-ko" data-toggle="buttons" id="map_type_base">
			  <label class="btn btn-info active">
			    <input type="radio" name="options" autocomplete="off" checked> 지도
			  </label>
			  <label class="btn btn-info">
			    <input type="radio" name="options" autocomplete="off"> 스카이뷰
			  </label>
			</div>		
			
			<div class="btn-group mr-2 btn-group-toggle btn-group-sm cstm_btn-md-ko" data-toggle="buttons" id="map_type_overlay">
			  <label class="btn btn-secondary active">
			    <input type="radio" name="options" id="" autocomplete="off" checked> 없음
			  </label>
			  <label class="btn btn-secondary" id="btnRoadView">
			    <input type="radio" name="options" autocomplete="off"> 도로
			  </label>
			  <label class="btn btn-secondary">
			    <input type="radio" name="options" autocomplete="off"> 교통량
			  </label>
			  <label class="btn btn-secondary">
			    <input type="radio" name="options" autocomplete="off"> 지역구분
			  </label>
			</div>
		  </div>
   
        </div>
        
  		<div class="alert alert-danger" role="alert">
		  <i class="fas fa-ban"></i>
		   축척이 너무 높아 CCTV 표시가 제한되었습니다.
		</div>
		
        
        <div class="container">
         
          <!-- map -->
          <div class="map_wrap" style="">
            <div class="my-4 w-100" id="map" style="width:100%; height:95%; position:relative; overflow:hidden; z-index: 2">
              <input data-toggle="button" id="polygonbtn" type="button" value="구 자세히보기" style="float:right;background-color:white;
           		Opacity: 0.6;color:black;z-index:2;z-index: 2; position: relative;strokeColor:'#fff';strokeOpacity: 0.1;margin-top: 15px;"/>
            </div>
            <div id="menu_wrap" class="bg_white" style="visibility:collapse;z-index:2">
              <div class="option"></div>
              <hr>
              <ul id="placesList"></ul>
              <div id="pagination"></div>
            </div>
          </div>
          
        </div>
        	
        <div class="container">
          <div class="row">
            <div class="col align-self-start">
    		  <div class="card mb-2">
                <div class="row no-gutters">
                  <div class="col-md-4">
                    <img src="resources/images/police-station.png" class="card-img" alt="...">
                  </div>
                  <div class="col-md-8">
                    <div class="card-body">
                      <h5 class="card-title">경찰서/파출소/지구대</h5>
                      <p class="card-text h3" id="station-cnt">-</p>
                      <p class="card-text"><small class="text-muted">현재 지도에 표시된 유인 방범시설 갯수</small></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col align-self-end">
              <div class="card mb-2">
                <div class="row no-gutters">
                  <div class="col-md-4">
                    <img src="resources/images/cctv3.png" class="card-img" alt="...">
                  </div>
                  <div class="col-md-8">
                    <div class="card-body">
                      <h5 class="card-title">폐쇄회로 텔레비전</h5>
                      <p class="card-text h3" id="cctv-cnt">-</p>
                      <p class="card-text"><small class="text-muted">현재 지도에 표시된 CCTV 갯수</small></p>
                    </div>
                  </div>
                </div>
              </div>
    	    </div>
          </div>
        </div>
        
        <!-- Modal -->
        <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">로드뷰</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
              </div>
              <div class="modal-body">
                 <div class="container">
                    <div id="roadview" style="width:100%; height:350px;"></div>
              </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
       
      </main>
    </div>
  </div>
  

  
  
  <!-- global resources -->
  <%@ include file="global/resources_body.jsp" %>
  
  <!-- current resources -->
  <script type="text/javascript" src="resources/js/util.js"></script>
  <script type="text/javascript" src="resources/js/map.js"></script>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e4c097578c3266be7fa0ea7907486d92&libraries=services,drawing"></script>
  
  
</body>
</html>