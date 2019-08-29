package nms.monitoring.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import nms.monitoring.service.WaveService;
import nms.monitoring.vo.WaveChartDataVO;
import nms.monitoring.vo.WaveMapDataVO;
import nms.monitoring.vo.WaveResponseVO;
import nms.util.vo.ResponseDataListVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/monitoring/wave")
public class WaveController {
	
	@Autowired
	WaveService waveService;
	
	
	@RequestMapping("/list")
	public String waveListView(ModelMap model) throws Exception
	{
		return "/monitoring/wave";
	}
	
	/*@RequestMapping("/list2")
	public String waveListView2(ModelMap model) throws Exception
	{
		return "/monitoring/wave_new";
	}*/
	
	@RequestMapping("/alldatas.ws")
	public @ResponseBody WaveResponseVO allDataWS(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		WaveResponseVO datasets = new WaveResponseVO();
		List<List<Object>> results = waveService.staTypeByDatas(sch_data.get("dataType"), sch_data.get("staType"));
		
		if(results.size() != 0)
		{
			List<WaveChartDataVO> codes = getDataset(results, results.size()-1);
			
			if(results != null && results.size() != 0)
			{
				results.remove(results.size() -1);
				datasets.setData(results);
				datasets.setChartSize(String.valueOf(results.size()));
				datasets.setChartGubun(codes.get(0).getLabel().substring(0, codes.get(0).getLabel().length() -1));
				datasets.setStaType(sch_data.get("staType"));
			}
		}
		
		return datasets;
	}
	
	@RequestMapping("/datas.ws")
	public @ResponseBody WaveResponseVO dataWS(HttpServletRequest request)throws Exception
	{
		WaveResponseVO datasets = new WaveResponseVO();
		
		String staType = request.getParameter("staType");
		
		long start = System.currentTimeMillis();
		List<List<Object>> results = waveService.staTypeByDatas("", staType);
		long end = System.currentTimeMillis();
		
		long time = end - start;
		
		if(time < 1500)
		{
			Thread.sleep(1500 - time);
		}
		
		if(results.size() != 0)
		{
			List<WaveChartDataVO> codes = getDataset(results, results.size()-1);
			
			if(results != null && results.size() != 0)
			{
				results.remove(results.size() -1);
				datasets.setData(results);
				datasets.setChartSize(String.valueOf(results.size()));
				datasets.setChartGubun(codes.get(0).getLabel().substring(0, codes.get(0).getLabel().length() -1));
				datasets.setStaType(staType);
			}
		}
		
		return datasets;
	}
	
	@RequestMapping("/mapdatas.ws")
	public @ResponseBody ResponseDataListVO mapdatasWS(HttpServletRequest request)throws Exception
	{
		String type = request.getParameter("type");
		ResponseDataListVO result = new ResponseDataListVO();
		
		long start = System.currentTimeMillis();
		List<WaveMapDataVO> mapdatas = waveService.mapDatas(type);
		long end = System.currentTimeMillis();
		
		long time = end - start;
		
		if(time < 1500)
		{
			Thread.sleep(1500 - time);
		}
		if(mapdatas.size() != 0)
		{
			result.setData(mapdatas);
		}
		
		
		return result;
	}
	
	@RequestMapping("/popup")
	public String alarmPop(HttpServletRequest request, ModelMap model)throws Exception
	{
		return "/monitoring/popup/alarmPop";
	}
	
	@RequestMapping("/popup2")
	public String chartPop(HttpServletRequest request, ModelMap model)throws Exception
	{
		return "/monitoring/popup/chartPop";
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
