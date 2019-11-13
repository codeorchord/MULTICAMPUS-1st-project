<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  
  
  
  <meta charset="UTF-8">
  <meta name="viewport"  content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <!-- global resources -->
  <%@ include file="global/resources_header.jsp"%>
  
  <!-- Custom styles for this template -->
  <link href="/outliers/resources/css/view.css" rel="stylesheet">
  <title>Blindspot Finder - Details</title>
</head>

<body>
  <nav
    class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="/outliers">Blindspot Finder</a>
  </nav>

  <div class="container-fluid">
    <main role="main" class="px-4">
      <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <div class="container">
          <div class="row">
            <div class="col">
              <h3 class="cstm-card-round bg-secondary text-center text-light" style="font-weight:600; margin-bottom: 15px">각 구별 범죄 통계</h3>
            </div>
          </div>
          <div class="row">
            <div class="col col-lg-7 " >
              <div class="cstm-card-round">
               <div id="map" style="width: 100%; height: 550px; min-width:475px;"></div>
              </div>
            </div>
            <div class="col col-lg-5" style="padding-left:0px">
         
                <div id="chart_div" class="cstm-card-round" style="max-width:475px; height:100%;"></div>
              
            </div>
          </div>
          

            <div class="row" style="margin-top:20px;">
              <div class="col col-lg-4 col-md-4 col-sm-4">
                <h3>4개년 범죄통계</h3>
              </div>
              <div class="col col-lg-3 col-md-3 col-sm-3">
                <select class="custom-select mr-sm-2" id="guCombo">
                  <option selected>서울시 구 선택</option>
                  <option value="도봉구">도봉구</option>
                  <option value="동대문구">동대문구</option>
                  <option value="동작구">동작구</option>
                  <option value="은평구">은평구</option>
                  <option value="강북구">강북구</option>
                  <option value="강남구">강남구</option>
                  <option value="강서구">강서구</option>
                  <option value="강동구">강동구</option>
                  <option value="금천구">금천구</option>
                  <option value="구로구">구로구</option>
                  <option value="관악구">관악구</option>
                  <option value="광진구">광진구</option>
                  <option value="종로구">종로구</option>
                  <option value="중구">중구</option>
                  <option value="중량구">중량구</option>
                  <option value="마포구">마포구</option>
                  <option value="노원구">노원구</option>
                  <option value="서초구">서초구</option>
                  <option value="서대문구">서대문구</option>
                  <option value="성북구">성북구</option>
                  <option value="성동구">성동구</option>
                  <option value="송파구">송파구</option>
                  <option value="양천구">양천구</option>
                  <option value="영등포구">영등포구</option>
                  <option value="용산구">용산구</option>
                </select>
              </div>
            </div>
            <div class="row">
              <div class="col">
                <div class="cstm-card-round" style="margin-bottom:20px;">
                  <table class="table" id="id_table" style="margin-right:10px;">
                  <thead class="thead-dark">
                    <tr>
                      <th scope="col">년도</th>
                      <th scope="col">살인</th>
                      <th scope="col">성범죄</th>
                      <th scope="col">폭력</th>
                      <th scope="col">강도</th>
                      <th scope="col">절도</th>
                      <th scope="col">합계</th>
                    </tr>
                  </thead>
                  <tbody>
                  
                    <c:forEach items="${list}" var="gucrime" varStatus="i">
                      <tr>
                        <th scope="row">${gucrime.year}</th>
                        <td>${gucrime.murder}</td>
                        <td>${gucrime.sexual_assault}</td>
                        <td>${gucrime.violence}</td>
                        <td>${gucrime.robber}</td>
                        <td>${gucrime.theft}</td>
                        <td>${gucrime.total}</td>
                      </tr>
                    </c:forEach>
                  </table>
                </div>
              </div>
            </div>
          </div>

      </div>
    </main>
  </div>
  

  <input type="hidden" id="guname" value="${name}" />
  <input type="hidden" id="gupath" value="${path}" />
  <input type="hidden" id="gupoint" value="${point}" />


  <!-- global resources -->
  <%@ include file="global/resources_body.jsp"%>

  <!-- current resources -->
  <script type="text/javascript" src="/outliers/resources/js/util.js"></script>
  <script type="text/javascript" src="/outliers/resources/js/view.js"></script>
  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e4c097578c3266be7fa0ea7907486d92&libraries=services"></script>
</body>
</html>