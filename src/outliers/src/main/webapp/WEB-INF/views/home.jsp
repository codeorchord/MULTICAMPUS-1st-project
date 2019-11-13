<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Jekyll v3.8.5">
    <!-- global resources -->
    <%@ include file="global/resources_header.jsp" %>

    <!-- Custom styles for this template -->
    <link href="/outliers/resources/css/home.css" rel="stylesheet"> 
    <link href="/outliers/resources/css/carousel.css" rel="stylesheet">

    <title>Blindspot Finder</title>
</head>
<body>
  

   
  <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="/outliers">Blindspot Finder</a>
  </nav>
 

  <main role="main">

    <div id="myCarousel" class="carousel slide" data-ride="carousel">
      <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src = "/outliers/resources/images/2.jpg" width="100%" height="100%" /> 
          <div class="container">
            <div class="carousel-caption">
              <h1>늦은 밤 </h1>
              <p>당신의 길은 안녕하신가요??</p>
              <p><a class="button-3d" href="./map" role="button">start</a></p>
            </div>
          </div>
        </div>
        <div class="carousel-item">
          <img src = "/outliers/resources/images/3.jpg" width="100%" height="100%" />        
        <div class="container">
            <div class="carousel-caption">
              <h1>CCTV가 </h1>
              <p>모든 구역을 지켜볼 수 없기에 ....</p>
              <p><a class="button-3d" href="./map" role="button">start</a></p>
            </div>
          </div>
        </div>
        <div class="carousel-item">
          <img src = "/outliers/resources/images/4.jpg" width="100%" height="100%" />
            <div class="container">
            <div class="carousel-caption">
               <h1>범죄사각지대 예측시스템이</h1>
              <p>당신의 범죄를 예방해드립니다.</p>
              <p><a class="button-3d" href="./map" role="button">start</a></p>
            </div>
          </div>
        </div>
      </div>
      <a class="carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="carousel-control-next" href="#myCarousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
    </div>
  </main>


  <!-- Marketing messaging and featurettes
  ================================================== -->
  <!-- Wrap the rest of the page in another container to center all the content. -->

  <div class="container marketing">
    <h2 style="text-align:center;">기능 한눈에 보기</h2><br>
    <!-- Three columns of text below the carousel -->
    <div class="row">
      <div class="col-lg-4">
        <img src = "/outliers/resources/images/5.jpg" width="200px" height="200px" style="border-radius:50%;border:1px solid black"  style="cursor: pointer;" onclick="doImgPop('/outliers/resources/images/5.jpg')" " />
        <h3>1</h3>
        <p>검색 기능을 사용하여 해당 지역으로 이동할 수 있고 cctv와 경찰서가 지도에 표시되어 있습니다.</p>
     
      </div><!-- /.col-lg-4 -->
      <div class="col-lg-4">
        <img src = "/outliers/resources/images/6.jpg" width="200px" height="200px" style="border-radius:50%;border:1px solid black"  style="cursor: pointer;" onclick="doImgPop('/outliers/resources/images/6.jpg')" " />
        <h3>2</h3>
        <p>방범시설을  분석하여 사각 지대로 예측이 되는 지역을 색상으로 확인 할 수 있습니다.</p>
        
      </div><!-- /.col-lg-4 -->
      <div class="col-lg-4">
        <img src = "/outliers/resources/images/7.jpg" width="200px" height="200px" style="border-radius:50%;border:1px solid black"  style="cursor: pointer;" onclick="doImgPop('/outliers/resources/images/7.jpg')" " />
        <h3>3</h3>
        <p>각 구의 2014~ 2017년의 5대범죄 현황을 그래프 및 차트로 확인할 수 있습니다.</p>
        
      </div><!-- /.col-lg-4 -->
    </div><!-- /.row -->
  </div><!-- /.container -->


  <!-- global resources -->
  <%@ include file="global/resources_body.jsp" %>
  
  <!-- current resources -->
  <script type="text/javascript" src="/outliers/resources/js/home.js"></script>

</body>
</html>
