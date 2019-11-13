package lab.project.outliers.rserve;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Properties;

import org.rosuda.REngine.REXP;
import org.rosuda.REngine.Rserve.RConnection;

public class RServeClient {

	public String genResultOveray(HashMap<String, Object> parcel, String dest, Properties envs) 
	{
		REXP rexp = null;
	    RConnection conn = null;
	    String retStr = "";

		try {
			StringBuffer sbEval = new StringBuffer();
			
			//환경 변수들
			//프로텍트 파일 경로 입력해야하지만 배포용을 만들기위해 임시로 하드코딩
			File file = new File("C:/Team_Outliers/Rserve/prj_analysis3.R");
			
			String r_wd = envs.getProperty("r_wd");// R의   워킹 디렉토리
			String r_server_url = envs.getProperty("r_server_url"); //R server IP
			int r_server_port = Integer.parseInt(envs.getProperty("r_server_port"));// R server Port;
			String cdn_url = envs.getProperty("cdn_url"); //R 결과 image URL
			String db_server = envs.getProperty("db_server");// R에서 사용할 DB server
			String oracle_driver = envs.getProperty("oracle_driver");//R에서 사용할 오라클드라이버. R 실행 서버에 적절한 오라클 DB가 깔려 있으면 패스를 잘못 넣어도 동작 하는 듯 하다...
			
	        FileReader fr = new FileReader(file);
	        BufferedReader br = new BufferedReader(fr);
	        String line;
	        while((line = br.readLine()) != null){
	        	sbEval.append(line + "\n");
	        }
	        br.close();
	        fr.close();
	        
	        String strEval = sbEval.toString();
	        strEval = strEval.replace("REPLACEME_WD", r_wd);
	        strEval = strEval.replace("REPLACEME_DBSERVER", db_server);
	        strEval = strEval.replace("REPLACEME_ORACLEDRIVER", oracle_driver);
	        strEval = strEval.replace("REPLACEME_CDNURL", cdn_url);
	        strEval = strEval.replace("REPLACEME_INFLUENCE", "" + parcel.get("influence"));
	        strEval = strEval.replace("REPLACEME_LEFT", "" + parcel.get("left"));
	        strEval = strEval.replace("REPLACEME_TOP", "" + parcel.get("top"));
	        strEval = strEval.replace("REPLACEME_RIGHT", "" + parcel.get("right"));
	        strEval = strEval.replace("REPLACEME_BOTTOM", "" + parcel.get("bottom"));
	        strEval = strEval.replace("REPLACEME_FILENAME", dest);
	        
	        System.out.println("##### Waiting for R Connection ####");
	        conn = new RConnection(r_server_url, r_server_port);
	        System.out.println("############ EVAL start ###########");
	        rexp = conn.eval(strEval);
	        retStr = rexp.asString();
	        System.out.println("############# EVAL end ############");
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			if(conn != null) conn.close();
		}
		
		return retStr;
	}
	
	
}
