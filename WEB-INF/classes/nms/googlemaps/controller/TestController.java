package nms.googlemaps.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.googlemaps.service.TestService;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {
	
	@Resource(name="chartService")
	private TestService chartService; 
	
	@RequestMapping("/googlemaps")
	public String googlemaps() throws Exception
	{
		return "/googlemaps";
	}
	
	@RequestMapping("/chart")
	public String realtimegraph() throws Exception
	{
		return "/chart";
	}
	
	@RequestMapping("/datas.ws")
	public @ResponseBody String dataWS(@RequestBody String jsonData, HttpServletRequest request)throws Exception
	{
		String result = chartService.retrieveDatas();
		return result;
	}
}
