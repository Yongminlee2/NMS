package nms.system.service;

import java.util.List;

import javax.annotation.Resource;

import nms.system.mapper.UserMapper;
import nms.system.vo.UserInfoVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 사용자 정보를 가져오는 Mapper 클래스
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
@Repository(value = "userService")
public class UserService {
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	
	/**
	 * 사용자 목록을 받아온다.
	 * @return
	 * @throws Exception
	 */
	public List<UserInfoVO> getUserList(SearchDataVO searchVO) throws Exception
	{	
//		System.out.println(searchVO.getSearchKeyword());
//		System.out.println(searchVO.getSearchKeyword2());
		List<UserInfoVO> userList = userMapper.getUserList(searchVO);
		if(userList.size()>0){
			userList.get(0).setTotalCnt(userMapper.getUserListTotalCnt(searchVO));
		}
		return userList;
	}
//	BCrypt.hashpw("test", BCrypt.gensalt())
	
	
	public void InsertMember(UserInfoVO user) throws Exception
	{
		if(user.getType().equals("new")){
			userMapper.insertMember(user);
		}else{
			System.out.println(user.getPw());
			userMapper.updateMember(user);
		}
	}
	
	/**
	 * 아이디를 체크한다.
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public int checkId(String id) throws Exception
	{
		return userMapper.checkId(id);
	}
	
	/**
	 * 유저 가입을 승인한다.
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public int acceptJoinMember(String id) throws Exception
	{
		return userMapper.acceptJoinMember(id);
	}
	
	/**
	 * 메일 전송을 위한 리스트를 받아간다.
	 * @return
	 * @throws Exception
	 */
	public List<UserInfoVO> sendMailMember(String type) throws Exception
	{
		return userMapper.sendMailMember(type);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public void sendMail(String id, String user_id,String type) throws Exception
	{
		int cnt = userMapper.checkEventSendLog(id,user_id);
		try{
		if(cnt > 0){
			userMapper.updateEventSendLog(id, user_id);
		}else{
			userMapper.insertEventSendLog(id, user_id,type);
		}
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}
	
	/**
	 * 회원 정보를 삭제한다.
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public int deleteMember(String id) throws Exception
	{
		return userMapper.deleteMember(id);
	}

}
