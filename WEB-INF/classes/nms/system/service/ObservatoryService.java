package nms.system.service;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import nms.system.mapper.ObservatoryMapper;
import nms.system.vo.ObservatoryVO;
import nms.system.vo.SensorVO;
import nms.system.vo.StationInfoVO;
import nms.util.vo.SearchDataVO;

/**
 * 愿�痢≪냼 �젙蹂대�� 媛��졇�삤�뒗 Service �겢�옒�뒪
 * @author Administrator
 * @since 2016. 11. 16.
 * @version 
 * @see
 * 
 * <pre>
 * << �닔�젙�씠�젰(Modification Information) >>
 *   
 *  �궇吏�		 		      �옉�꽦�옄 					   鍮꾧퀬
 *  --------------   ---------    ---------------------------
 *  2016. 11. 16.      諛뺥깭吏�                    		   	 理쒖큹
 *
 * </pre>
 */
@Repository(value = "observatoryService")
public class ObservatoryService {
	@Resource(name = "observatoryMapper")
	private ObservatoryMapper observatoryMapper;
	/**
	 * 愿�痢≪냼 �젙蹂대�� 媛��졇�삩�떎.
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationInfoList(SearchDataVO search) throws Exception
	{
		return observatoryMapper.getStationInfoList(search);
	}
	/**
	 * 愿�痢≪냼 �젙蹂댁쓽 珥� 移댁슫�듃 �닔瑜� 媛��졇�삩�떎.
	 * @return
	 * @throws Exception
	 */
	public int getStationInfoListTotalCnt(SearchDataVO search) throws Exception
	{
		return observatoryMapper.getStationInfoListTotalCnt(search);
	}
	/**
	 * 愿�痢≪냼 �엳�뒪�넗由� �젙蹂대�� 媛��졇�삩�떎.
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationHistoryList(SearchDataVO search) throws Exception
	{
		return observatoryMapper.getStationHistoryList(search);
	}
	/**
	 * 愿�痢≪냼 �엳�뒪�넗由� �젙蹂댁쓽 珥� 移댁슫�듃 �닔瑜� 媛��졇�삩�떎.
	 * @return
	 * @throws Exception
	 */
	public int getStationHistoryInfoListTotalCnt(SearchDataVO search) throws Exception
	{
		return observatoryMapper.getStationHistoryInfoListTotalCnt(search);
	}
	
	/**
	 * 愿�痢≪냼 �엳�뒪�넗由� �젙蹂대�� 媛��졇�삩�떎.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public ObservatoryVO getStationHistoryInfo(SearchDataVO search) throws Exception
	{
		return observatoryMapper.getStationHistoryInfo(search);
	}
	/**
	 * 愿�痢≪냼 �젙蹂대�� 異붽��븳�떎.
	 * @param obVO
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertStation(ObservatoryVO obVO) throws Exception
	{	
		if(obVO.getObs_kind().equals("수력발전")){
			obVO.setObs_kind("WP");
		}else if(obVO.getObs_kind().equals("원전부지")){
			obVO.setObs_kind("NF");
		}else if(obVO.getObs_kind().equals("양수발전")){
			obVO.setObs_kind("HP");
		}else{
			obVO.setObs_kind("CJ");
		}
		observatoryMapper.insertStation(obVO);
		//�뀒�씠釉� �깮�꽦(�듃由ш굅 �젅踰� �씠踰ㅽ듃)
		observatoryMapper.createTriggerLevelTable("trigger_level_"+obVO.getSta_type());
		return observatoryMapper.getStationLastInsertNo();
	}
	
	/**
	 * �젏寃��궡�슜�쓣 �엯�젰�븳�떎.
	 * @param no
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public void insertStationMaintenance(String no, String msg,String date) throws Exception
	{
		observatoryMapper.insertStationMaintenance(no, msg,date);
	}
	/**
	 * 愿�痢≪냼 �젙蹂대�� �닔�젙�븳�떎.
	 * @param obVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateStation(ObservatoryVO obVO) throws Exception
	{
		if(obVO.getObs_kind().equals("수력발전")){
			obVO.setObs_kind("WP");
		}else if(obVO.getObs_kind().equals("원전부지")){
			obVO.setObs_kind("NF");
		}else if(obVO.getObs_kind().equals("양수발전")){
			obVO.setObs_kind("HP");
		}else{
			obVO.setObs_kind("CJ");
		}
		
		return observatoryMapper.updateStation(obVO);
	}
	/**
	 * 愿�痢≪냼 �젙蹂대�� �닔�젙�븳�떎.
	 * @param obVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateReportStation(ObservatoryVO obVO) throws Exception
	{
		return observatoryMapper.updateReportStation(obVO);
	}	
	/**
	 * 愿�痢≪냼 �젙蹂대�� 媛��졇�삩�떎.
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationMngInfoList(SearchDataVO search) throws Exception
	{
		return observatoryMapper.getStationMngInfoList(search);
	}
	
	/**
	 * �젏寃� �궡�뿭�쓣 媛��졇�삩�떎.
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	public List<ObservatoryVO> getStationMaintenanceList(String sta_no) throws Exception
	{
		
		return observatoryMapper.getStationMaintenanceList(sta_no);
	}
}
