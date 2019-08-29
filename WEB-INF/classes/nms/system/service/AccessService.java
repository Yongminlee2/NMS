package nms.system.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import nms.system.mapper.AccessMapper;
import nms.system.vo.AccessVO;
import nms.util.controller.UtilController;
/**
 * 접속권한 관련 Service 클래스
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
@Repository(value = "accessService")
public class AccessService {
	@Resource(name = "accessMapper")
	private AccessMapper accessMapper;
	/**
	 * 접속권한 정보 리스트를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<AccessVO> getAccessList() throws Exception{
		return accessMapper.getAccessList();
	}
	
	/**
	 * 접속권한 수정한다.
	 * @param access
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateAccessInfo(List<AccessVO> access) throws Exception
	{	
		for(AccessVO ac : access){
			accessMapper.updateAccessInfo(ac);
		}
		UtilController.ACCESS_MAP = accessMapper.getAccessList();
		return 0;
	}
}
