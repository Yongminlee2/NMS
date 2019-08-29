package nms.system.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import nms.sec.AccessUserInfoManager;
import nms.sec.vo.UserVO;
import nms.system.service.UserService;
import nms.system.vo.TriggerVO;
import nms.system.vo.UserInfoVO;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

/**
 * 사용자 정보를 가져오는 컨트롤러
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
@RequestMapping(value = "/system/user")
public class UserController {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	
	@Resource(name = "userService")
	private UserService userService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join user page");
		SearchDataVO search = new SearchDataVO();
		String unaUser = (request.getParameter("switchKey")==null?"y":request.getParameter("switchKey"));
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
		search.setSearchKeyword2((request.getParameter("searchKeyword2")==null?"":request.getParameter("searchKeyword2")));
		search.setSwitchKey(unaUser);
		
		List<UserInfoVO> userList = userService.getUserList(search);
		if(userList.size()>0){
			userList.get(0).setCurrentPage(page);
			model.addAttribute("pagingInfo",userList.get(0));
			model.addAttribute("totalCnt",userList.get(0).getTotalCnt());
			for(UserInfoVO u : userList)
			{
				if(!u.getName().equals("") && u.getName().length()>2){
					u.setName2(u.getName().substring(0,1)+"*"+u.getName().substring(u.getName().length()-1, u.getName().length()));
				}
//				System.out.println(u.getTel().length());
				if(!u.getTel().equals("") && u.getTel().length()>7){
					u.setTel2(u.getTel().substring(0, 3)+"****"+u.getTel().substring(u.getTel().length()-4, u.getTel().length()));
				}
			}
		}else{
			model.addAttribute("pagingInfo",new UserInfoVO());
			model.addAttribute("totalCnt","0");
		}
		
		model.addAttribute("userList", userList);
		model.addAttribute("role",AccessUserInfoManager.getUserAuthority());
		model.addAttribute("searchKeyword",search.getSearchKeyword());
		model.addAttribute("searchKeyword2",search.getSearchKeyword2());
		model.addAttribute("unaUser",(unaUser.equals("y")?"y":"n"));
		
		
		
		return "/system/user/list";
	}
	
	/**
	 * 회원 정보를 입력 또는 수정한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/InsertMember.ws")
	public @ResponseBody ResponseDataListVO InsertMember(@RequestBody UserInfoVO userVO, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		if(userVO.getType().equals("new") || userVO.getPw() != ""){
			userVO.setPw(BCrypt.hashpw(userVO.getPw(), BCrypt.gensalt()));
		}
		userVO.setTmp2((userVO.getTmp2().equals("on")?"y":"n"));
		userVO.setTmp3((userVO.getTmp3().equals("on")?"y":"n"));
		
		try {
			userService.InsertMember(userVO);
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

	/**
	 * 회원 정보를 삭제한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/DeleteMember.ws")
	public @ResponseBody ResponseDataListVO DeleteMember(@RequestBody String userId, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		
		try {
			userService.deleteMember(userId);
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
	
	@RequestMapping(value = "/AcceptJoinMember.ws")
	public @ResponseBody ResponseDataListVO AcceptJoinMember(@RequestBody String id, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		try {
			userService.acceptJoinMember(id);
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
	/**
	 * 회원 정보를 입력 또는 수정한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkId.ws")
	public @ResponseBody ResponseDataListVO checkId(@RequestBody String id, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		
		try {
			int checkId = userService.checkId(id);
			if(checkId>0){
				returnValue = "fail";
			}
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
