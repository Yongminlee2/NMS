package nms.util.mapper;

import java.util.HashMap;
import java.util.List;

import nms.util.vo.CodeVO;
import nms.util.vo.StationVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
/**
 * 자주 사용되는 정보들의 호출에 사용되는 Mapper 인터페이스
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
@Repository(value = "utilMapper")
public interface UtilMapper {
	/**
	 * 관측소 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<StationVO> getStationInfo() throws Exception;
	
	/**
	 * 관측소 코드 정보를 가져온다.
	 * @param mainCode
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getStationCodeInfoList(@Param("mainCode")String mainCode) throws Exception;
	
	/**
	 * 전체 코드 정보를 가져온다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getCodeInfoList() throws Exception;
	
	/**
	 * 관측소의 정보와 센서의 정보를 가져온다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<StationVO> getStationOfSensorInfo() throws Exception;
	public List<StationVO> getStationOfSensorInfo2() throws Exception;
	public List<StationVO> getStationNames() throws Exception;
	/**
	 * 처음 시작시 seis_nf, seis_hp, seis_pp 의 셋팅한다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public void setStationSensorTable() throws Exception;
	
}
