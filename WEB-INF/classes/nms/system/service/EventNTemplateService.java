package nms.system.service;

import java.util.List;

import javax.annotation.Resource;

import nms.system.mapper.EventNTemplateMapper;
import nms.system.vo.EventNTemplateVO;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 이벤트 및 템플릿 관리 정보를 가져오는 Service 클래스
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
@Repository(value = "eventNTemplateService")
public class EventNTemplateService {
	
	@Resource(name = "eventNTemplateMapper")
	private EventNTemplateMapper eventNTemplateMapper;
	
	/**
	 * 이벤트 및 템플릿 목록을 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<EventNTemplateVO> selectEventNTemplate() throws Exception
	{
		return eventNTemplateMapper.selectEventNTemplate();
	}
	
	/**
	 * 이벤트 및 템플릿 수정
	 * @param eventVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateEventNTemplate(List<EventNTemplateVO> eventVO) throws Exception{
		int returnInt = 0;
		for(EventNTemplateVO ent : eventVO)
		{	
			returnInt += eventNTemplateMapper.updateEventNTemplate(ent);
		}
		return returnInt;
	}
}
