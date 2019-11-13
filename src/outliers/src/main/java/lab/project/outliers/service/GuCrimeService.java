package lab.project.outliers.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lab.project.outliers.dao.IGuCrimeDAO;
import lab.project.outliers.model.GuCrimeVO;

@Service("guCrimeService")
public class GuCrimeService implements IGuCrimeService{
	
	@Autowired
	private IGuCrimeDAO dao;

	@Override
	public List<GuCrimeVO> getGuCrimeAll() {
		return dao.getGuCrimeAll();
	}
	@Override
	public List<GuCrimeVO> getGuCrimeByGu(String gu) {
		return dao.getGuCrimeByGu(gu);
	}
	
}
