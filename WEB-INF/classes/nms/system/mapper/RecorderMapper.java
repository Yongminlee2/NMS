package nms.system.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import nms.system.vo.RecorderVO;
import nms.util.vo.SearchDataVO;


/**
 * 레코더 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "recorderMapper")
public interface RecorderMapper {
	
	
	/**
	 * 레코더 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<RecorderVO> getRecorderList(@Param("sta_no")String sta_no) throws Exception;
	public int 	getRecorderLastInsertNo() throws Exception;
	/**
	 * 레코더 이미지를 가져온다.
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public RecorderVO getRecorderImages(@Param("no")String no) throws Exception;
	
	/**
	 * 기록계 히스토리 정보를 가져온다.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public RecorderVO getRecorderHistoryInfo(SearchDataVO search) throws Exception;
	/**
	 * 레코더 정보를 입력한다.
	 * @return
	 * @throws Exception
	 */
	public void insertRecorder(RecorderVO recVo) throws Exception;
	/**
	 * 레코더 정보를 입력한다.
	 * @return
	 * @throws Exception
	 */
	public void insertReportRecorder(RecorderVO recVo) throws Exception;
	/**
	 * 기록계 점검을 입력한다.
	 * @param no
	 * @param msg
	 * @throws Exception
	 */
	public void insertMaintenanceRecorder(@Param("no")String no, @Param("msg")String msg,@Param("date")String date) throws Exception;
	/**
	 * 레코더 정보를 수정한다.
	 * @return
	 * @throws Exception
	 */
	public int updateRecorder(RecorderVO recVO) throws Exception;
	/**
	 * 레코더 정보를 수정한다.
	 * @return
	 * @throws Exception
	 */
	public int updateReportRecorder(RecorderVO recVO) throws Exception;
	/**
	 * 레코더 정보를 삭제한다.
	 * @return
	 * @throws Exception
	 */
	public int deleteRecorder(@Param("rec_no")String rec_no) throws Exception;
	/**
	 * 레코더 정보를 삭제한다.
	 * @return
	 * @throws Exception
	 */
	public int deleteReportRecorder(@Param("rec_no")String rec_no) throws Exception;
	
	/**
	 * 레코더 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<RecorderVO> getRecorderMngList(@Param("l_no")String l_no) throws Exception;
	
	/**
	 * 기록계 점검 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<RecorderVO> getRecorderMaintenanceList(@Param("rec_no")String rec_no) throws Exception;
	
}
