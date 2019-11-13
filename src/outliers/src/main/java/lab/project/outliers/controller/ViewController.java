package lab.project.outliers.controller;



import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lab.project.outliers.model.GuCrimeVO;
import lab.project.outliers.service.IGuCrimeService;


@Controller
public class ViewController {
	
	@Resource(name = "guCrimeService")
	private IGuCrimeService guCrimeService;
	
	@RequestMapping(value = "/map/view", method = RequestMethod.POST)
	public String sendpolygon(String path, String name, String point, Model model) {	
	 
		model.addAttribute("name", name);
		model.addAttribute("path", path);  
		model.addAttribute("point", point);
	  
		System.out.println(name);
		@SuppressWarnings("unchecked")
		List<GuCrimeVO> list = guCrimeService.getGuCrimeByGu(name);

		model.addAttribute("list", list);
	
		return "view";
	}
	 
}