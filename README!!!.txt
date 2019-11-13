1. 폴더
  - apache-tomcat-cdn : CDN 배포본
  - apache-tomcat-outliers : 메인 웹 서비스 배포본 (Blindspot Finder)
  - Rserve : Rserve 실행 환경 (R은 따로 깔려있어야하며 관련 패키지가 설치되어 있어야 합니다)
  - misc : DB export 된 파일들
  - PPT : 발표자료
  - source : eclipse project source (메인 웹 서비스)


2. 실행 방법 1(로컬 실행환경. '다른' 피씨에서 아이피로 접속하여 이용하면 설정이 localhost 고정이라 분석 오버레이가 표시되지 않음. )
  (0) 압축파일을 c:\Team_Outliers 에 풉니다(위치/폴더명 중요)
  (1) misc 의 DB 파일을 오라클DB에 import 합니다(끝나고 commit).
  (2) R(x64로 설치)을 해당 PC에 설치(상기 Rserve폴더 아니고 인터넷에서...)하고 install.packages("패키지명")으로 아래 모든 패키지들을 설치합니다.
	rJava
	DBI
	RJDBC
	ggmap
	geojsonio
	broom
	viridis
	ggplot2
	dplyr
	cowplot
  (3) startup_cdn 바로가기를 실행하여 CDN 서버를 가동시킵니다.
  (4) startup_rserve 바로기기를 실행하여 rserve 서버를 가동시킵니다. (R은 실행되고있지 않아도 상관 없음)
  (5) startup_outliers 바로기기를 실행하여 메인 서비스 서버를 가동시킵니다.
  (6) localhost:8080/outliers 에 접속합니다!


3. 실행 방법 2(외부에서 아이피로 접근해도 정상 이용이 가능한 서버 실행) - eclipse
  (0)~(4) 상동
  (5) eclipse에서 source 폴더의 소스를 import 합니다.
  (6) properties 파일 수정!
	outliers\src\main\resources\properties\envs.properties 을 수정합니다.

	(특별한 이유가 아니라면 localhost 를 자신의 PC IP로 바꾸기만 하면 됨)

	r_wd=C:/Team_Outliers/apache-tomcat-cdn/webapps/MyCDN/images
	r_server_url=localhost
	r_server_port=6312
	cdn_url=http://localhost:8081/MyCDN/images/
	db_server=localhost:1521/orcl
	oracle_driver=D:/dev/env/oracle/product/11.2.0/dbhome_1/jdbc/lib/ojdbc6.jar

  (7) 빌드하고 타겟 런타임에서 실행합니다(server.xml 특이사항 없음)


