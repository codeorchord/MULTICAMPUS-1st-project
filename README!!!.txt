1. ����
  - apache-tomcat-cdn : CDN ������
  - apache-tomcat-outliers : ���� �� ���� ������ (Blindspot Finder)
  - Rserve : Rserve ���� ȯ�� (R�� ���� ����־���ϸ� ���� ��Ű���� ��ġ�Ǿ� �־�� �մϴ�)
  - misc : DB export �� ���ϵ�
  - PPT : ��ǥ�ڷ�
  - source : eclipse project source (���� �� ����)


2. ���� ��� 1(���� ����ȯ��. '�ٸ�' �Ǿ����� �����Ƿ� �����Ͽ� �̿��ϸ� ������ localhost �����̶� �м� �������̰� ǥ�õ��� ����. )
  (0) ���������� c:\Team_Outliers �� Ǳ�ϴ�(��ġ/������ �߿�)
  (1) misc �� DB ������ ����ŬDB�� import �մϴ�(������ commit).
  (2) R(x64�� ��ġ)�� �ش� PC�� ��ġ(��� Rserve���� �ƴϰ� ���ͳݿ���...)�ϰ� install.packages("��Ű����")���� �Ʒ� ��� ��Ű������ ��ġ�մϴ�.
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
  (3) startup_cdn �ٷΰ��⸦ �����Ͽ� CDN ������ ������ŵ�ϴ�.
  (4) startup_rserve �ٷα�⸦ �����Ͽ� rserve ������ ������ŵ�ϴ�. (R�� ����ǰ����� �ʾƵ� ��� ����)
  (5) startup_outliers �ٷα�⸦ �����Ͽ� ���� ���� ������ ������ŵ�ϴ�.
  (6) localhost:8080/outliers �� �����մϴ�!


3. ���� ��� 2(�ܺο��� �����Ƿ� �����ص� ���� �̿��� ������ ���� ����) - eclipse
  (0)~(4) ��
  (5) eclipse���� source ������ �ҽ��� import �մϴ�.
  (6) properties ���� ����!
	outliers\src\main\resources\properties\envs.properties �� �����մϴ�.

	(Ư���� ������ �ƴ϶�� localhost �� �ڽ��� PC IP�� �ٲٱ⸸ �ϸ� ��)

	r_wd=C:/Team_Outliers/apache-tomcat-cdn/webapps/MyCDN/images
	r_server_url=localhost
	r_server_port=6312
	cdn_url=http://localhost:8081/MyCDN/images/
	db_server=localhost:1521/orcl
	oracle_driver=D:/dev/env/oracle/product/11.2.0/dbhome_1/jdbc/lib/ojdbc6.jar

  (7) �����ϰ� Ÿ�� ��Ÿ�ӿ��� �����մϴ�(server.xml Ư�̻��� ����)


