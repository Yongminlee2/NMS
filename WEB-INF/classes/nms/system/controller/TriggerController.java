package nms.system.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.system.service.TriggerService;
import nms.system.vo.AccessVO;
import nms.system.vo.TriggerVO;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
/**
 * 트리거 정보를 가져오는 controller 컨트롤러
 * @author Administrator
 * @since 2016. 11. 16.
 * @version 
 * @see
 * 
 * <pre>
 * << 수정이력(Modification Information) >>
 *   
 *  날짜		 		      작성자 					   비고
 *  --------------   ---------    ---------------------------
 *  2016. 11. 16.      박태진                    		   	 최초
 *
 * </pre>
 */
@Controller
@RequestMapping(value = "/system/trigger")
public class TriggerController {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	
	@Resource(name = "triggerService")
	private TriggerService triggerService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join trigger page");
		SearchDataVO search = new SearchDataVO();
		int page = 0;
		if(request.getParameter("page")==null)
		{
			page = 1;
		}
		else
		{
			page = Integer.parseInt(request.getParameter("page"));
		}
		
//		(Integer) (request.getParameter("page")==null?1:request.getParameter("page"));
		
		search.setCurrentPage(page);
		search.setSearchKeyword((request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword")));
		
		List<TriggerVO> triggerList = triggerService.getTriggerList(search);
		if(triggerList.size()>0){
			triggerList.get(0).setCurrentPage(page);
			model.addAttribute("pagingInfo",triggerList.get(0));
			model.addAttribute("totalCnt",triggerList.get(0).getTotalCnt());
			
		}else{
			model.addAttribute("pagingInfo",new TriggerVO());
			model.addAttribute("totalCnt","0");
		}
		model.addAttribute("searchKeyword",search.getSearchKeyword());
		model.addAttribute("triggerList", triggerList);
		model.addAttribute("triggerData", triggerList.get(0));
		
		return "/system/trigger/list";
	}
	
	/**
	 * 트리거 정보를 수정한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/modyTrigger.ws")
	public @ResponseBody ResponseDataListVO modyAccess(@RequestBody List<TriggerVO> triggerVO, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		ObjectMapper mapper = new ObjectMapper();
		List<TriggerVO> tv = mapper.convertValue(triggerVO,  new TypeReference<List<TriggerVO>>() {});
		String returnValue = "success";
		
//		responseVO.setData(UtilController.ACCESS_MAP);
//		responseVO.setData2(AccessUserInfoManager.getUserAuthority());
//		System.out.println(tv.get(0).getTr_no());
		try {
			triggerService.updateTriggerInfo(tv);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
//		System.out.println(ac.get(0).getM1());
//		for(AccessVO a : accessVO)
//		{
//			System.out.println(a.getM1());
//		}
		return responseVO;
	}
}
