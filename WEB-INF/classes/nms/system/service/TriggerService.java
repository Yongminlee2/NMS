package nms.system.service;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import nms.system.mapper.TriggerMapper;
import nms.system.vo.TriggerVO;
import nms.util.vo.SearchDataVO;
/**
 * 트리거 정보를 가져오는 Service 클래스
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
@Repository(value = "triggerService")
public class TriggerService {
	@Resource(name = "triggerMapper")
	private TriggerMapper triggerMapper;
	BigDecimal bd;
	
	/**
	 * 트리거 목록을 받아온다.
	 * @return
	 * @throws Exception
	 */
	public List<TriggerVO> getTriggerList(SearchDataVO searchVO) throws Exception
	{
		List<TriggerVO> triggerList = triggerMapper.getTriggerList(searchVO);
		if(triggerList.size()>0){
			triggerList.get(0).setTotalCnt(triggerMapper.getTriggerListTotalCnt(searchVO));
			for(TriggerVO t : triggerList)
			{
				t.setTr_pga_1(galChangeG(t.getTr_pga_1()));
				t.setTr_pga_2(galChangeG(t.getTr_pga_2()));
				t.setTr_pga_3(galChangeG(t.getTr_pga_3()));
			}
		}
		return triggerList;
	}
	
	/**
	 * 트리거 정보 수정
	 * @param trigger
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateTriggerInfo(List<TriggerVO> trigger) throws Exception
	{	
		String det = "";
		for(TriggerVO tv : trigger)
		{	
			tv.setTr_pga_1(gChangeGal(tv.getTr_pga_1()));
			tv.setTr_pga_2(gChangeGal(tv.getTr_pga_2()));
			tv.setTr_pga_3(gChangeGal(tv.getTr_pga_3()));
			det = tv.getTr_detection();
			triggerMapper.updateTriggerInfo(tv);
		}
		triggerMapper.updateTriggerDetection(det);
		return 0; 
	}
	/**
	 * gal 값을 g로 변환한다.(소수점자리 제한없이)
	 * @param gal
	 * @return
	 */
	public String galChangeG(String gal){
//		BigDecimal bd;
//		bd = new BigDecimal
		Double bd = (Double.parseDouble(gal)/980);
		if(bd<1){
			double parseDouble = Math.round(bd*1000000);
			return ""+(parseDouble/1000000.0);
		}else{
			return (""+Math.round(bd));
		}
	}
	
	/**
	 * g값을 gal값으로 변환한다. (소수점 최대 8자리)
	 * @param g
	 * @return
	 */
	public String gChangeGal(String g){
//		BigDecimal bd;
//		bd = new BigDecimal(Double.parseDouble(g)*980);
		Double bd = Double.parseDouble(g)*980;
//		if((""+bd).length()>8){
//			return (""+bd).substring(0,8);
//		}else{
			return (""+bd);
//		}
	}	
}
