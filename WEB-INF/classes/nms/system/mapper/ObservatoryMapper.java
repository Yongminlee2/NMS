package nms.system.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import nms.system.vo.ObservatoryVO;
import nms.system.vo.SensorVO;
import nms.system.vo.StationInfoVO;
import nms.util.vo.SearchDataVO;


/**
 * 관측소 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "observatoryMapper")
public interface ObservatoryMapper {
	/**
	 * 관측소 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationInfoList(SearchDataVO search) throws Exception;
	
	public int 	getStationLastInsertNo() throws Exception;

	/**
	 * 관측소 정보의 총 카운트 수를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public int getStationInfoListTotalCnt(SearchDataVO search) throws Exception;
	
	/**
	 * 관측소 히스토리 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationHistoryList(SearchDataVO search) throws Exception;
	/**
	 * 관측소 히스토리 정보를 가져온다.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public ObservatoryVO getStationHistoryInfo(SearchDataVO search) throws Exception;
	/**
	 * 관측소 히스토리 정보의 총 카운트 수를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public int getStationHistoryInfoListTotalCnt(SearchDataVO search) throws Exception;
	/**
	 * 관측소 정보를 추가한다.
	 * @param obVO
	 * @throws Exception
	 */
	public int insertStation(ObservatoryVO obVO) throws Exception;
	/**
	 * 점검내용을 입력한다.
	 * @param no
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public int insertStationMaintenance(@Param("no")String no, @Param("msg")String msg,@Param("date")String date) throws Exception;
	/**
	 * 관측소 정보를 수정한다.
	 * @param obVO
	 * @return
	 * @throws Exception
	 */
	public int updateStation(ObservatoryVO obVO) throws Exception;
	
	/**
	 * 관측소 정보를 수정한다.
	 * @param obVO
	 * @return
	 * @throws Exception
	 */
	public int updateReportStation(ObservatoryVO obVO) throws Exception;
	/**
	 * 관측소 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationMngInfoList(SearchDataVO search) throws Exception;
	
	/**
	 * 점검 내역을 가져온다.
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationMaintenanceList(@Param("sta_no")String sta_no) throws Exception;
	
	
	
	/**
	 * 트리거 이벤트 테이블을 생성한다.
	 * @param tableName
	 * @throws Exception
	 */
	public void createTriggerLevelTable(@Param("tableName")String tableName) throws Exception;
	
}
