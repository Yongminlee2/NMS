package nms.sec;

import nms.sec.vo.UserExt;
import nms.sec.vo.UserVO;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;

public class AccessUserInfoManager {
	/**
	 * 접속중인 사용자 이름 조회
	 * @return 사용자 이름
	 */
	public static String getUserName()
	{
		String userName = null;	
		
		if (SecurityContextHolder.getContext().getAuthentication().getPrincipal() instanceof User)
		{
			UserExt user = (UserExt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			UserVO userVO = (UserVO) user.getUserVO();
			userName = userVO.getUserName();
		}
		
		return userName;
	}
	
	/**
	 * 접속중인 사용자 ID 조회
	 * @return 사용자 ID
	 */
	public static String getUserID()
	{
		String userID = null;
		
		if (SecurityContextHolder.getContext().getAuthentication().getPrincipal() instanceof User)
		{
			UserExt user = (UserExt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			UserVO userVO = (UserVO) user.getUserVO();
			userID = userVO.getUserId();
		}
		
		return userID;
	}
	/**
	 * 접속허가조회
	 * @return 사용자 ID
	 */
	public static String getAccept()	{
		String userID = null;
		
		if (SecurityContextHolder.getContext().getAuthentication().getPrincipal() instanceof User)
		{
			UserExt user = (UserExt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			UserVO userVO = (UserVO) user.getUserVO();
			userID = userVO.getAccept();
		}
		
		return userID;
	}	
	
	/**
	 * 접속중인 사용자 권한 조회
	 * @return 사용자 권한
	 */
	public static String getUserAuthority()
	{
		String userAuthority = null;
		
		if (SecurityContextHolder.getContext().getAuthentication().getPrincipal() instanceof User)
		{
			UserExt user = (UserExt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			
			Object[] authorities = user.getAuthorities().toArray();
		
			if (authorities.length > 0)
				userAuthority = authorities[0].toString();
		}
		
		return userAuthority;
	}
	
	/**
	 * 화면으로 접속중인 사용자 정보(사용자 이름, 사용자 ID, 사용자 권한) 전달
	 * @param model
	 * @return
	 */
	public static void addAttributeUserInfo(Model model)
	{
		if (SecurityContextHolder.getContext().getAuthentication().getPrincipal() instanceof User)
		{
			UserExt user = (UserExt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			UserVO userVO = (UserVO) user.getUserVO();
			
			model.addAttribute("userName", 		userVO.getUserName());
			model.addAttribute("userId", 		userVO.getUserId());
			
			Object[] authorities = user.getAuthorities().toArray();
		
			if (authorities.length > 0)
				model.addAttribute("authority", authorities[0].toString());
		}
	}
}
