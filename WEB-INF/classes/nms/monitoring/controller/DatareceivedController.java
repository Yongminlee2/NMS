package nms.monitoring.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import nms.monitoring.service.DatareceivedService;
import nms.monitoring.vo.DataReceivedResponseVO;
import nms.util.controller.UtilController;
import nms.util.service.UtilService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/monitoring/datareceived")
public class DatareceivedController {
	
	@Autowired
	DatareceivedService datareceivedService;
	
	@Autowired
	UtilService utilService;
	
	@RequestMapping("/list")
	public String datareceivedListView(ModelMap model) throws Exception
	{
		return "/monitoring/datarecevied";
	}
	
	@RequestMapping("/datas.ws")
	public @ResponseBody DataReceivedResponseVO dataWS(HttpServletRequest request)throws Exception
	{
		DataReceivedResponseVO datasets = new DataReceivedResponseVO();
		
		long start = System.currentTimeMillis();
		List<List<Object>> results = datareceivedService.receviedTableDatas();
		long end = System.currentTimeMillis();
		
		long time = end - start;
		
		if(time < 1500)
		{
			Thread.sleep(1500 - time);
		}
		
		if(results.size() != 0)
		{
			datasets.setData(results);
		}
		
		return datasets;
	}
	
	@RequestMapping("/popup")
	public String datareceivedPop(HttpServletRequest request, ModelMap model)throws Exception
	{
		model.addAttribute("sta", datareceivedService.stationDetail(request.getParameter("sta_code")));
		return "/monitoring/popup/stationinfo";
	}
}
