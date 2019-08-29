package nms.sec.controller;

import javax.servlet.http.HttpServletRequest;

import nms.sec.AccessUserInfoManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class LoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	private static String LOGIN_VIEW = "login";
	
	/**
	 * 로그인 페이지 호출
	 * @param request
	 * @param model
	 * @return login
	 */
	@RequestMapping("/login")
	public String viewlogin(HttpServletRequest request, ModelMap model)
	{
		logger.info("Call login");
		logger.info("login_error : " + request.getParameter("login_error"));
		
		String referrer = request.getHeader("Referer");
	    request.getSession().setAttribute("prevPage", referrer);
		
		String loginError = request.getParameter("login_error");
		model.addAttribute("login_error", loginError);
		
		if(AccessUserInfoManager.getUserID() != null && AccessUserInfoManager.getAccept().equals("y"))
			return "redirect:/";
		
		if(loginError != null)
			return LOGIN_VIEW;

		return LOGIN_VIEW;
	}
	
	/**
	 * 로그아웃
	 * @param model
	 * @return login
	 */
	@RequestMapping(value="/logout.do", method = RequestMethod.GET)
	public String logout(ModelMap model)
	{
		System.out.println("/logout.do");
		logger.info("Call /logout.do");
		return LOGIN_VIEW;
	}
	
	/**
	 * 로그인 실패
	 * @param model
	 * @return forward:/login
	 */
	@RequestMapping(value="/loginfailed.do")
	public String loginerror(ModelMap model)
	{
		logger.info("login failed");
		model.addAttribute("error", "true");
		return "forward:/" + LOGIN_VIEW;
	}
	
}