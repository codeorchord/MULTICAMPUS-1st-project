package lab.project.outliers.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import lab.project.outliers.model.CCTVVO;
import lab.project.outliers.model.GuCrimeVO;
import lab.project.outliers.model.PstationVO;
import lab.project.outliers.rserve.RServeClient;
import lab.project.outliers.service.IGuCrimeService;
import lab.project.outliers.service.ISpotService;


@Controller
public class APIsController {
	
	@Resource(name = "spotService")
	private ISpotService spotService;
	
	@Resource(name = "guCrimeService")
	private IGuCrimeService guCrimeService;
	
	@Resource(name="envProperties")
	private Properties envs;

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(APIsController.class);
	

	@RequestMapping(value = "/apis/getStations", method = RequestMethod.POST)
	@ResponseBody
	public List<PstationVO> getStations(@RequestBody HashMap<String, Object> params) {
		
		@SuppressWarnings("unchecked")
		List<PstationVO> listStation = spotService.getStationsInRect(params);
		
		return listStation;
	}
	
	@RequestMapping(value = "/apis/getCCTVs", method = RequestMethod.POST)
	@ResponseBody
	public List<CCTVVO> getCCTVs(@RequestBody HashMap<String, Object> params) {
		
		@SuppressWarnings("unchecked")
		List<CCTVVO> listCCTV = spotService.getCCTVsInRect(params);
		
		return listCCTV;
	}
	
	
	@RequestMapping(value = "/apis/analysis", method = RequestMethod.POST)
	@ResponseBody
	public String getAnalysis(@RequestBody HashMap<String, Object> params, HttpSession session) {
		RServeClient rclient = new RServeClient();
		String retVal = rclient.genResultOveray(params, session.getId() , envs);
		
		if(retVal != null && retVal.endsWith(".png")) {
			return "{ \"URI\" : \"" + retVal + "\" }";
		}
		else {
			return "{ \"URI\" : \"failed\" }";
		}
		
	}
	
	@RequestMapping(value = "/apis/getGuCrime", method = RequestMethod.POST)
	@ResponseBody
	public List<GuCrimeVO> getGuCrime(@RequestBody HashMap<String, Object> params) {
		
		@SuppressWarnings("unchecked")
		List<GuCrimeVO> list = guCrimeService.getGuCrimeByGu(params.get("guName").toString());
		
		return list;
	}
	
}
