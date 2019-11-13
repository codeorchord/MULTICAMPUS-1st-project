package lab.project.outliers.dao;

import java.util.List;

import lab.project.outliers.model.GuCrimeVO;

public interface IGuCrimeDAO {
	
	public List<GuCrimeVO> getGuCrimeAll();
	
	public List<GuCrimeVO> getGuCrimeByGu(String gu);
}
