package nms.quakeoccur.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import nms.quakeoccur.service.DistributionService;
import nms.quakeoccur.vo.QuakeEventListVO;
import nms.util.vo.ResponseDataListVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/quakeoccur/distribution")
public class DistributionController {
	
	@Autowired
	DistributionService distributionService;

	@RequestMapping("/list")
	public String distributionListView(ModelMap model) throws Exception
	{
		return "/quakeoccur/distribution";
	}
	
	@RequestMapping("/getDistributionList.ws")
	public @ResponseBody ResponseDataListVO getDistributionList(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String date_str = sch_data.get("date_str").toString();
		String date_end = sch_data.get("date_end").toString();
		String page = (String) sch_data.get("page").toString();
		
		List<List<Object>> results = distributionService.getDistributionList(date_str, date_end, page);
		List<QuakeEventListVO> quakeList = distributionService.getQuakeList(date_str, date_end);
		if(results != null && results.size() != 0)
		{
			List<QuakeEventListVO> list = getDataset(results, 0);
			
			datasets.setData(list);
			datasets.setTotalDataCount((String) results.get(1).get(0).toString());
		}
		datasets.setData2(quakeList);
		
		return datasets;
	}
	
	@RequestMapping("/getDistributionMap.ws")
	public @ResponseBody ResponseDataListVO getDistributionMap(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String date_str = sch_data.get("date_str").toString();
		String date_end = sch_data.get("date_end").toString();
		
		datasets.setData(distributionService.getDistributionMap(date_str, date_end));
		
		return datasets;
	}
	
	/**보고자료
	 * 파일다운로드
	 * @param
	 * @return
	 * @throws Exception
	 * **/
	@RequestMapping(value = "/getExcel.do", method = RequestMethod.POST)
	public String getReportExcel(ModelMap model, HttpServletRequest request) throws Exception
	{
		try {
			
			String date_str = request.getParameter("sch_date_str").toString();
			String date_end = request.getParameter("sch_date_end").toString();
			List<QuakeEventListVO> distributionList = distributionService.getDistributionMap(date_str, date_end);

			List<String> header = new ArrayList<String>();
			header.add("진원시");
			header.add("규모");
			header.add("위도");
			header.add("경도");
			header.add("위치");

			List<String> dataFields = new ArrayList<String>();

			dataFields.add("origintime");
			dataFields.add("mag");
			dataFields.add("rlong");
			dataFields.add("lat");
			dataFields.add("origin_area");
			
			model.addAttribute("fileName", date_str + "-" + date_end +"지진 진도분포도.xls");
			model.addAttribute("header", header);
			model.addAttribute("dataFields", dataFields);
			model.addAttribute("dataList", distributionList);

			return "exportExcel";

		} catch (Exception e) {
			throw new Exception();
		}
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
	protected <T> List<T> getDataset(List<List<Object>> datasets, int index)  throws Exception{
		return (List<T>) datasets.get(index);
	}
}
