package nms.main.controller;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.main.service.MainService;
import nms.quakeoccur.vo.QuakeEventListVO;
import nms.sec.AccessUserInfoManager;
import nms.util.vo.ResponseDataListVO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mysql.jdbc.StringUtils;


@Controller
public class MainController {
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Resource(name = "mainService")
	private MainService mainService;
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String index(Model model) throws Exception{
		logger.info("Welcome NMS!");
		
		if(AccessUserInfoManager.getUserID() != null)
			return "redirect:/main";
		
		return "/index";
	}
	
	@PostConstruct
	public void init() throws Exception{
		mainService.deleteAlarmList();
	}
	
	@RequestMapping(value = "/main")
	public String main(Model model) throws Exception{
		System.out.println(AccessUserInfoManager.getAccept());
		
		if(StringUtils.isNullOrEmpty(AccessUserInfoManager.getAccept()) || AccessUserInfoManager.getAccept().equals("n"))
		{
			System.out.println("접속허가 없음");
			return "redirect:/login?login_error=2";
		}
		
		logger.info("Welcome NMS!");
		return "/index";
	}
	
	@RequestMapping("/getMainQuakeEventList.ws")
	public @ResponseBody ResponseDataListVO getMainQuakeEventList(HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		
		List<QuakeEventListVO> results = mainService.mainQuakeInfo();
		
		if(results != null && results.size() != 0)
		{
			datasets.setData(results);
		}
		
		return datasets;
	}
	
}
