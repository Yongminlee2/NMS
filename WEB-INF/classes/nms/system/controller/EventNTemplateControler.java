package nms.system.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.board.vo.BoardVO;
import nms.system.service.EventNTemplateService;
import nms.system.vo.EventNTemplateVO;
import nms.system.vo.ObservatoryVO;
import nms.util.controller.UtilController;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 이벤트 및 템플릿의 입력/수정/삭제/조회하는 역할을 처리하는 Controller 클래스
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
@RequestMapping(value = "/system/ent")
public class EventNTemplateControler {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	
	@Resource(name = "eventNTemplateService")
	private EventNTemplateService eventNTemplateService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		
		logger.info("Join event N Template!");
		List<EventNTemplateVO> ent = eventNTemplateService.selectEventNTemplate();
		model.addAttribute("value1",ent.get(0));
		model.addAttribute("value2",ent.get(1));
		model.addAttribute("value3",ent.get(2));
		model.addAttribute("value4",ent.get(3));
		model.addAttribute("value5",ent.get(4));
		model.addAttribute("value6",ent.get(5));
//		(Integer) (request.getParameter("page")==null?1:request.getParameter("page"));
		
		
		return "/system/event/eventNTemplate";
	}
	
	@RequestMapping(value = "/update.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO updateEventNTemplate(@RequestBody List<EventNTemplateVO> eventVO, HttpServletRequest request) throws Exception
	{	
		/*
		 * 현재 로그인이 없어 임시 아이디로 대체
//		 */
		String returnValue = "success";
		ObjectMapper mapper = new ObjectMapper();
		List<EventNTemplateVO> al =  mapper.convertValue(eventVO, new TypeReference<List<EventNTemplateVO>>() {});
//		System.out.println(boVO.getBoard_content());
		try {
//			infoService.insertInfo(boVO);
			int entCnt = eventNTemplateService.updateEventNTemplate(al);
			if(entCnt < 1){
				returnValue="zero";
			}
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
		}
		
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnValue);
		
		return responseVO;
	}
}
