package nms.system.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.system.service.LogService;
import nms.system.vo.LogVO;
import nms.system.vo.TriggerVO;
import nms.system.vo.UserInfoVO;
import nms.util.DateSetting;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 로그 정보를 가져오는 컨트롤러
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
@RequestMapping(value = "/system/log")
public class LogController {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	
	@Resource(name = "logService")
	private LogService logService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join user page");
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
		
		search.setCurrentPage(page);
		search.setSearchKeyword((request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword")));
		search.setSearchKeyword2((request.getParameter("searchKeyword2")==null?"":request.getParameter("searchKeyword2")));
		
		if(request.getParameter("startDate")==null)
		{
			search.setStartDate(DateSetting.getbeforeDate(30));
			search.setEndDate(DateSetting.getbeforeDate(0));
			
		}else{
			search.setStartDate(request.getParameter("startDate"));
			search.setEndDate(request.getParameter("endDate"));
		}
		
		List<LogVO> logList = logService.getLogList(search);
//		LogVO logVO = logList.get(0);
//		logVO.setCurrentPage(page);
//		System.out.println(search.getStDate());
//		System.out.println(search.getEnDate());
		if(logList.size()>0){
			logList.get(0).setStDate(search.getStartDate());
			logList.get(0).setEnDate(search.getEndDate());
			logList.get(0).setCurrentPage(page);
			
			model.addAttribute("logList", logList);
			model.addAttribute("totalCnt",logList.get(0).getTotalCnt());
			model.addAttribute("pagingInfo",logList.get(0));
		}else{
			model.addAttribute("totalCnt","0");
			model.addAttribute("pagingInfo",new LogVO());

		}
		
		model.addAttribute("idList", logService.getLogIdList(search));
		model.addAttribute("typeList", logService.getLogTypeList(search));
		model.addAttribute("searchKeyword",search.getSearchKeyword());
		model.addAttribute("searchKeyword2",search.getSearchKeyword2());
		
		return "/system/log/list";
	}
	
	@RequestMapping(value = "/popup/id")
	public String popup1(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join popup1 page");
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
		
		search.setCurrentPage(page);
		search.setSwitchKey("mody");
		List<LogVO> logList = logService.getLogIdList(search);
		model.addAttribute("idList", logList);
		logList.get(0).setCurrentPage(page);
		model.addAttribute("pagingInfo",logList.get(0));
		
		
		return "/system/log/popup/idList";
	}
	
	/**
	 * 로그 아이디 정보를 수정한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertLogId.ws")
	public @ResponseBody ResponseDataListVO insertLogId(@RequestBody List<LogVO> logVO, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		ObjectMapper mapper = new ObjectMapper();
		List<LogVO> lv = mapper.convertValue(logVO,  new TypeReference<List<LogVO>>() {});
		String returnValue = "success";
		
		try {
			logService.insertNUpdateLogId(lv);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
		return responseVO;
	}
	/**
	 * 로그 아이디 정보를 삭제한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteLogId.ws")
	public @ResponseBody ResponseDataListVO deleteLogId(@RequestBody String l_no, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		System.out.println(l_no);
		try {
			logService.deleteLogId(l_no);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
		return responseVO;
	}
	@RequestMapping(value = "/popup/type")
	public String popup2(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join popup2 page");
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
		
		search.setCurrentPage(page);
		search.setSwitchKey("mody");
		
		List<LogVO> logList = logService.getLogTypeList(search);
		model.addAttribute("typeList", logList);
		logList.get(0).setCurrentPage(page);
		model.addAttribute("pagingInfo",logList.get(0));
		
		
		return "/system/log/popup/typeList";
	}
	
	/**
	 * 로그 아이디 정보를 수정한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertLogType.ws")
	public @ResponseBody ResponseDataListVO insertLogType(@RequestBody List<LogVO> logVO, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		ObjectMapper mapper = new ObjectMapper();
		List<LogVO> lv = mapper.convertValue(logVO,  new TypeReference<List<LogVO>>() {});
		String returnValue = "success";
		
		try {
			logService.insertNUpdateLogType(lv);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
		return responseVO;
	}
	/**
	 * 로그 아이디 정보를 삭제한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteLogType.ws")
	public @ResponseBody ResponseDataListVO deleteLogType(@RequestBody String l_no, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		System.out.println(l_no);
		try {
			logService.deleteLogType(l_no);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
		return responseVO;
	}
}
