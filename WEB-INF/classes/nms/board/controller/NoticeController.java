package nms.board.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.board.service.NoticeService;
import nms.board.vo.BoardVO;
import nms.sec.AccessUserInfoManager;
import nms.util.DateSetting;
import nms.util.service.FileService;
import nms.util.vo.FileVO;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mysql.jdbc.StringUtils;

/**
 * 알림마당>공지사항에 대한 요청을 받아 처리하는 Controller
 * @author 박병규
 * @since 2016.10.20
 * @version 1.0
 * @see
 * 
 * <pre>
 * << 개정이력(Modification Information) >>
 *   

 * </pre>
 */

@Controller
@RequestMapping("/board/notice")
public class NoticeController {
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	private static String idx = "";
	
	@Resource(name = "noticeService")
	private NoticeService noticeService;
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join Notice List!");
		SearchDataVO search = new SearchDataVO();
		
		int page = 0;
		if(StringUtils.isNullOrEmpty(request.getParameter("page")))
		{
			page = 1;
		}
		else
		{
			page = Integer.parseInt(request.getParameter("page"));
		}
		search.setCurrentPage(page);
		search.setSearchKeyword((request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword")));
		if(StringUtils.isNullOrEmpty(request.getParameter("startDate")))
		{
			search.setStartDate(DateSetting.getbeforeDate(365));
			search.setEndDate(DateSetting.getbeforeDate(0));
			
		}else{
			search.setStartDate(request.getParameter("startDate"));
			search.setEndDate(request.getParameter("endDate"));
		}
		
		List<BoardVO> noticeList = noticeService.NoticeList(search);
		int totalCnt = noticeService.NoticeListTotalCnt(search);
		if(totalCnt>0){
			noticeList.get(0).setTotalCnt(totalCnt);
			noticeList.get(0).setCurrentPage(page);
			noticeList.get(0).setStDate(search.getStartDate());
			noticeList.get(0).setEnDate(search.getEndDate());
			model.addAttribute("totalCnt",totalCnt);
			model.addAttribute("pagingInfo",noticeList.get(0));
		}else{
			model.addAttribute("totalCnt","0");
			model.addAttribute("pagingInfo",new BoardVO());
		}
		
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("userAuth",AccessUserInfoManager.getUserAuthority());
		model.addAttribute("searchKeyword",search.getSearchKeyword());
		
		return "/board/notice";
	}
	@RequestMapping(value = "/view.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO getNoticeView(@RequestBody String noticeNo, HttpServletRequest request) throws Exception
	{
//		System.out.println(noticeNo.replaceAll("=", ""));
		ResponseDataListVO responseVO = new ResponseDataListVO();
		BoardVO noticeView = noticeService.getNoticeView(noticeNo);
		List<FileVO> noticeFileList = noticeService.getNoticeFileList("notice_"+noticeNo.replace("=",""));
		String returnValue = "success";
		if(noticeView.equals(null) || noticeView == null){
			returnValue = "fail";
		}
		responseVO.setData(noticeView);
		responseVO.setData2(noticeFileList);
		responseVO.setResultDesc(returnValue);
		
		return responseVO;
	}		
	@RequestMapping(value = "/insert.ws", method = RequestMethod.POST)
//	public @ResponseBody ResponseDataListVO insertNotice(MultipartHttpServletRequest request) throws Exception
	public @ResponseBody ResponseDataListVO insertNotice(@RequestBody BoardVO boVO, HttpServletRequest request) throws Exception
	{	
		System.out.println("Insert");
//		System.out.println(boVO.getBoard_title());
		/*
		 * 현재 로그인이 없어 임시 아이디로 대체
		 */
		boVO.setUser_id(AccessUserInfoManager.getUserID());
		boVO.setUser_nm(AccessUserInfoManager.getUserName());
		String returnValue = "success";
//		System.out.println(boVO.getBoard_content());
		try {
			int in = noticeService.insertNotice(boVO);
			System.out.println("in : "+in);
			idx = ""+in;
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
		}
//		System.out.println(idx);
//		System.out.println("입력 전");
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnValue);
		
		return responseVO;
	}
	@RequestMapping(value = "/fileUpload.ws", method = RequestMethod.POST)
	public @ResponseBody String uploadFile(MultipartHttpServletRequest request) throws Exception
	{
//		System.out.println("입력 후" + idx);
		fileService.fileUpload(request,"notice_"+idx);
		String returnValue = "success";
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
		}
		return returnValue;
	}
	@RequestMapping(value = "/update.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO updateNotice(@RequestBody BoardVO boVO, HttpServletRequest request) throws Exception
	{
		String returnValue = "success";
		try {
			noticeService.updateNotice(boVO);
			idx = boVO.getNo();
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
			System.out.println(e.toString());
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnValue);
		
		return responseVO;
	}
	@RequestMapping(value = "/delete.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO deleteNotice(@RequestBody String no, HttpServletRequest request) throws Exception
	{
//		System.out.println(no);
		String returnValue = "success";
		try {
			fileService.deleteFiles("notice_"+no);
			noticeService.deleteNotice(no);
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
			System.out.println(e.toString());
		}
		
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnValue);
		
		return responseVO;
	}	
	
	@RequestMapping(value = "/deleteFile.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO deleteFile(@RequestBody String no, HttpServletRequest request) throws Exception
	{
//		System.out.println(no);
		String returnValue = "success";
		try {
			fileService.deleteFile(no);
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
			System.out.println(e.toString());
		}
		
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnValue);
		
		return responseVO;
	}	
}
