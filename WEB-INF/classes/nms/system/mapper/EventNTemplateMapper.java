package nms.system.mapper;

import java.util.List;

import nms.system.vo.EventNTemplateVO;

import org.springframework.stereotype.Repository;

/**
 * 이벤트 및 템플릿 관리 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "eventNTemplateMapper")
public interface EventNTemplateMapper {
	/**
	 * 이벤트 및 템플릿 목록을 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<EventNTemplateVO> selectEventNTemplate() throws Exception;
	
	/**
	 * 이벤트 및 템플릿 수정
	 * @param eventVO
	 * @return
	 * @throws Exception
	 */
	public int updateEventNTemplate(EventNTemplateVO eventVO) throws Exception;
}
