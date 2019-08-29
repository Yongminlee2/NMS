package nms.inforeceived.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import nms.inforeceived.service.DataCollRateService;
import nms.inforeceived.vo.DataCollRateListVO;
import nms.util.vo.ResponseDataListVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/inforeceived/datacollrate")
public class DataCollRateController {
	
	@Autowired
	DataCollRateService dataCollRateService;

	@RequestMapping("/list")
	public String dataCollRateListView(ModelMap model) throws Exception
	{
		return "/inforeceived/datacollrate";
	}
	
	@RequestMapping("/getRateList.ws")
	public @ResponseBody ResponseDataListVO getRateList(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		
		String type = sch_data.get("type").toString();
		String sta_type = sch_data.get("sta_type").toString();
		
		if("R".equals(type) || "M".equals(type)){
			
			String dateS = sch_data.get("date_s").toString();
			String dateE = sch_data.get("date_e").toString();
			
			List<DataCollRateListVO> data1 =  dataCollRateService.getDataCollRateList(dateS, dateE, type, sta_type);
			datasets.setData(data1);
			
		}else if("D".equals(type)){
			
			String dateS = sch_data.get("date_s").toString();
			String dateE = "";
			
			List<DataCollRateListVO> results = dataCollRateService.getDataCollRateListCheck(dateS, dateE, type, sta_type);
			
			if(results.size() !=0){
				datasets.setData(results);
			}
		}
		
		return datasets;
	}
	
	@RequestMapping(value = "/getExcel.do", method = RequestMethod.POST)
	public String getExcel(ModelMap model, HttpServletRequest request) throws Exception
	{
		String type = request.getParameter("sch_type").toString();
		String sta_type = request.getParameter("sch_sta_type").toString();
		
		if("R".equals(type) || "M".equals(type)){
			
			String dateS = request.getParameter("sch_date_s").toString();
			String dateE = request.getParameter("sch_date_e").toString();
			String chartSta = "";
			
			if(request.getParameter("chartSta") != null){
				chartSta = request.getParameter("chartSta").toString();
			}
			
			List<List<Object>> tableResults = dataCollRateService.getDataCollRateExcelList(dateS, dateE, type, sta_type);
			
			List<DataCollRateListVO> ncTable =  getDataset(tableResults.get(0));
			List<DataCollRateListVO> wpTable =  getDataset(tableResults.get(1));
			List<DataCollRateListVO> ppTable =  getDataset(tableResults.get(2));
			
			//List<DataCollRateListVO> chartDay =  getDataset(chartResults.get(0));
			//List<DataCollRateListVO> chartMonth =  getDataset(chartResults.get(1));
			if("R".equals(type)){
				model.addAttribute("fileName", dateS + "-" + dateE +"_일별_원시데이터 수집률.xls");
			}else{
				model.addAttribute("fileName", dateS + "-" + dateE +"_월별_원시데이터 수집률.xls");
			}
			
			model.addAttribute("type", type);
			model.addAttribute("sta_type", sta_type);
			model.addAttribute("ncTable", ncTable);
			model.addAttribute("wpTable", wpTable);
			model.addAttribute("ppTable", ppTable);
			model.addAttribute("chartSta", chartSta);
			//model.addAttribute("chartDay", chartDay);
			//model.addAttribute("chartMonth", chartMonth);
			
		}else if("D".equals(type)){
			
			String dateY = request.getParameter("sch_date_y").toString();
			String dateE = "";
			
			List<DataCollRateListVO> chartDay = dataCollRateService.getDataCollRateListCheck(dateY, dateE, type, sta_type);
			
			model.addAttribute("fileName", dateY +"원시데이터 누수율.xls");
			model.addAttribute("type", type);
			model.addAttribute("sta_type", sta_type);
			model.addAttribute("chartDay", chartDay);
		}
		
		return "exportExcelDataCollRate";
	}
	
	/**
	 *
	 * <pre>
	 * 1. 개요 : result 이 여러개 일때 사용
	 * 2. 처리내용 : result 이 여러개 일때 사용
	 * </pre>
	 *
	 * @Author	: User
	 * @Date	: 2015. 6. 9.
	 * @Method Name : getDataset
	 * @param datasets
	 * @param index
	 * @return
	 */
	protected <T> List<T> getDataset(List<Object> datasets)  throws Exception{
		return (List<T>) datasets;
	}
}
