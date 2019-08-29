package nms.system.mapper;

import java.util.List;

import nms.system.vo.TriggerVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 트리거 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "triggerMapper")
public interface TriggerMapper {
	/**
	 * 트리거 목록을 받아온다.
	 * @return
	 * @throws Exception
	 */
	public List<TriggerVO> getTriggerList(SearchDataVO searchVO) throws Exception; 
	/**
	 * 총 트리거 수를 받아온다.
	 * @return
	 * @throws Exception
	 */
	public int getTriggerListTotalCnt(SearchDataVO searchVO) throws Exception;
	/**
	 * 트리거 정보 수정
	 * @param trigger
	 * @return
	 * @throws Exception
	 */
	public int updateTriggerInfo(TriggerVO trigger) throws Exception;
	
	public int updateTriggerDetection(@Param("tr_detection")String tr_detection) throws Exception;
}
