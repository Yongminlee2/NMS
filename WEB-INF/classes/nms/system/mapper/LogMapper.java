package nms.system.mapper;

import java.util.List;

import nms.system.vo.LogVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 로그 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "logMapper")
public interface LogMapper {
	/**
	 * 로그 목록을 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<LogVO> getLogList(SearchDataVO searchVO) throws Exception;
	/**
	 * 로그 목록 총 수를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public int getLogListTotalCnt(SearchDataVO searchVO) throws Exception;
	/**
	 * 로그 아이디 목록을 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<LogVO> getLogIdList(SearchDataVO searchVO) throws Exception;
	/**
	 * 로그 아이디 목록 총 수를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public int getLogIdListTotalCnt() throws Exception;
	/**
	 * 로그 타입 목록을 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<LogVO> getLogTypeList(SearchDataVO searchVO) throws Exception;
	/**
	 * 로그 타입 목록 총 수를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public int getLogTypeListTotalCnt() throws Exception;
	/**
	 * 로그 아이디를 입력한다.
	 * @param log
	 * @throws Exception
	 */
	public void insertLogId(LogVO log) throws Exception;
	/**
	 * 로그 타입을 입력한다.
	 * @param log
	 * @throws Exception
	 */
	public void insertLogType(LogVO log) throws Exception;
	/**
	 * 로그 아이디를 수정한다.
	 * @param log
	 * @throws Exception
	 */
	public int updateLogId(LogVO log) throws Exception;
	/**
	 * 로그 타입을 수정한다.
	 * @param log
	 * @throws Exception
	 */
	public int updateLogType(LogVO log) throws Exception;
	/**
	 * 로그 아이디를 삭제한다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public int deleteLogId(@Param("l_no")String l_no) throws Exception;
	/**
	 * 로그 타입을 삭제한다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public int deleteLogType(@Param("l_no")String l_no) throws Exception;	
}
