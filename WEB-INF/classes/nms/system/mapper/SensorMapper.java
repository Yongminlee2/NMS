package nms.system.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import nms.system.vo.ObservatoryVO;
import nms.system.vo.RecorderVO;
import nms.system.vo.SensorVO;
import nms.util.vo.SearchDataVO;


/**
 * 센서 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "sensorMapper")
public interface SensorMapper {
	
	/**
	 * 센서 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<SensorVO> getSensorList(@Param("sta_no")String sta_no) throws Exception;
	public int 	getSensorLastInsertNo() throws Exception;
	
	
	/**
	 * 센서 이미지를 가져온다.
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public SensorVO getSensorImages(@Param("no")String no) throws Exception;
	/**
	 * 센서 히스토리 정보를 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public SensorVO getSensorHistoryInfo(SearchDataVO searchVO) throws Exception;
	/**
	 * 센서 정보를 입력한다.
	 * @return
	 * @throws Exception
	 */	
	public void insertSensor(SensorVO senVO) throws Exception;
	/**
	 * 센서 정보를 입력한다.
	 * @return
	 * @throws Exception
	 */	
	public void insertReportSensor(SensorVO senVO) throws Exception;	
	/**
	 * 점검 이력을 입력한다.
	 * @param no
	 * @param msg
	 * @throws Exception
	 */
	public void insertMaintenanceSensor(@Param("no")String no, @Param("msg")String msg,@Param("date")String date) throws Exception;
	/**
	 * 센서 정보를 수정한다.
	 * @return
	 * @throws Exception
	 */	
	public int updateSensor(SensorVO senVO) throws Exception;
	/**
	 * 센서 정보를 수정한다.
	 * @return
	 * @throws Exception
	 */	
	public int updateReportSensor(SensorVO senVO) throws Exception;	
	/**
	 * 센서 정보를 삭제한다.
	 * @return
	 * @throws Exception
	 */	
	public int deleteSensor(@Param("sen_no")String sen_no) throws Exception;
	/**
	 * 센서 정보를 삭제한다.
	 * @return
	 * @throws Exception
	 */	
	public int deleteReportSensor(@Param("sen_no")String sen_no) throws Exception;
	/**
	 * 센서 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<SensorVO> getSensorMngList(@Param("l_no")String l_no) throws Exception;

	/**
	 * 센서 점검 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<SensorVO> getSensorMaintenanceList(@Param("sen_no")String sen_no) throws Exception;
	
	
	
	/*테이블 생성 및 트리거 관련 이벤트*/
	
	/**
	 * 센서 데이터 값을 테이블에 넣는다.
	 * @param tableName
	 * @param name
	 * @param epoch
	 * @param sen_rep
	 * @param pga_val
	 * @return
	 * @throws Exception
	 */
	public int insertSensorData(@Param("tableName")String tableName, @Param("name")String name, @Param("pga_val")String pga_val) throws Exception;
	
	/**
	 * 정보 수집을 위한 테이블을 생성한다.
	 * @param tableName
	 * @throws Exception
	 */
	public void createTableSensorWave(@Param("tableName")String tableName) throws Exception;
	/**
	 * 테이블에 트리거 정보를 입력한다.
	 * @param triggerName
	 * @param tableName
	 * @param name
	 * @throws Exception
	 */
	public void createTriggerSensorWave(@Param("triggerName")String triggerName, @Param("tableName")String tableName,@Param("name")String name) throws Exception;
	
	/**
	 * 트리거 및 테이블 생성에 필요한 정보를 Station 정보에서 가져온다.
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	public ObservatoryVO getStaType(@Param("sta_no")String sta_no) throws Exception;
	
}
