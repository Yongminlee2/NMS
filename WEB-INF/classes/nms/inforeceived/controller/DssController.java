package nms.inforeceived.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import nms.inforeceived.service.DssService;
import nms.inforeceived.vo.DssListVO;
import nms.util.vo.ResponseDataListVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/inforeceived/dss")
public class DssController {
	
	@Autowired
	DssService dssService;

	@RequestMapping("/list")
	public String datareceivedListView(ModelMap model) throws Exception
	{
		return "/inforeceived/dss";
	}
	
	@RequestMapping("/getDssList.ws")
	public @ResponseBody ResponseDataListVO getDssList(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		
		ResponseDataListVO datasets = new ResponseDataListVO();
		String date_s = sch_data.get("date_s").toString();
		String date_e = sch_data.get("date_e").toString();
		String obs_kind = sch_data.get("obs_kind").toString();
		String sta_type = sch_data.get("sta_type").toString();
		String page = (String) sch_data.get("page").toString();
		
		
		List<List<Object>> results = dssService.getDssList(date_s, date_e, obs_kind, sta_type, page);
		
		if(results != null && results.size() != 0)
		{
			List<DssListVO> list = getDataset(results, 0);
			
			datasets.setData(list);
			datasets.setTotalDataCount((String) results.get(1).get(0).toString());
		}
		
		return datasets;
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
