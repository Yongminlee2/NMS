package nms.system.mapper;

import java.util.List;

import nms.system.vo.UserInfoVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 사용자 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "userMapper")
public interface UserMapper {
	/**
	 * 사용자 목록을 받아온다.
	 * @return
	 * @throws Exception
	 */
	public List<UserInfoVO> getUserList(SearchDataVO searchVO) throws Exception; 
	/**
	 * 총 사용자 수를 받아온다.
	 * @return
	 * @throws Exception
	 */
	public int getUserListTotalCnt(SearchDataVO searchVO) throws Exception;
	/**
	 * 아이디를 체크한다.
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public int checkId(@Param("id")String id) throws Exception;
	/**
	 * 신규 사용자등록
	 * @param user
	 * @throws Exception
	 */
	public void insertMember(UserInfoVO user) throws Exception;
	
	/**
	 * 사용자 정보 변경
	 * @param user
	 * @throws Exception
	 */
	public int updateMember(UserInfoVO user) throws Exception;
	/**
	 * 사용자 가입허가
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public int acceptJoinMember(@Param("id")String id) throws Exception;
	
	/**
	 * 메일 전송을 위한 리스트를 받아간다.
	 * @return
	 * @throws Exception
	 */
	public List<UserInfoVO> sendMailMember(@Param("type") String type) throws Exception;
	
	/**
	 * 이벤트 로그 전송 여부를 확인한다.
	 * @param id
	 * @return 0 미전송 1 전송
	 * @throws Exception
	 */
	public int checkEventSendLog(@Param("id")String id, @Param("user_id")String user_id) throws Exception;
	
	public int insertEventSendLog(@Param("id")String id, @Param("user_id")String user_id,@Param("type")String type) throws Exception;
	
	public int updateEventSendLog(@Param("id")String id, @Param("user_id")String user_id) throws Exception;
	
	/**
	 * 회원 정보를 삭제한다.
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public int deleteMember(@Param("id")String id) throws Exception;
}
