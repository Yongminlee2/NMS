package nms.util.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import nms.util.mapper.UtilMapper;
import nms.util.vo.CodeVO;
import nms.util.vo.StationVO;

import org.springframework.stereotype.Repository;
/**
 * 자주 사용되는 정보들의 호출에 사용되는 Service 클래스
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
@Repository(value = "utilService")
public class UtilService {
	@Resource(name = "utilMapper")
	private UtilMapper utilMapper;
	/**
	 * 관측소 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<StationVO> getStationInfo() throws Exception
	{
		return utilMapper.getStationInfo();
	}
	
	/**
	 * 관측소 코드 정보를 가져온다.
	 * @param mainCode
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getStationCodeInfoList(String mainCode) throws Exception
	{
		return utilMapper.getStationCodeInfoList(mainCode);
	}
	
	/**
	 * 전체 코드 정보를 가져온다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<CodeVO> getCodeInfoList() throws Exception
	{
		return utilMapper.getCodeInfoList();
	}
	
	/**
	 * 관측소의 정보와 센서의 정보를 가져온다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<StationVO> getStationOfSensorInfo() throws Exception
	{
		return utilMapper.getStationOfSensorInfo();
	}
	
	/**
	 * 관측소의 정보와 센서의 정보를 가져온다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public List<StationVO> getStationOfSensorInfo2() throws Exception
	{
		return utilMapper.getStationOfSensorInfo2();
	}
	
	/**
	 * 처음 시작시 seis_nf, seis_hp, seis_pp 의 셋팅한다.
	 * @param
	 * @return
	 * @throws Exception
	 */
	public void setStationSensorTable() throws Exception
	{
		utilMapper.setStationSensorTable();
	}
	
	public List<StationVO> getStationNames() throws Exception
	{
		return utilMapper.getStationNames();
	}
}


