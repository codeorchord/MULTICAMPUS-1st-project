package lab.project.outliers.service;

import java.util.List;

public interface IGuCrimeService {
	@SuppressWarnings("rawtypes")
	public List getGuCrimeAll();
	@SuppressWarnings("rawtypes")
	public List getGuCrimeByGu(String gu);

}
