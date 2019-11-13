package lab.project.outliers.service;

import java.util.HashMap;
import java.util.List;

public interface ISpotService {
	@SuppressWarnings("rawtypes")
	public List getStationsAll();
	@SuppressWarnings("rawtypes")
	public List getStationsInRect(HashMap<String, Object> hm);
	@SuppressWarnings("rawtypes")
	public List getCCTVsInRect(HashMap<String, Object> hm);
}
