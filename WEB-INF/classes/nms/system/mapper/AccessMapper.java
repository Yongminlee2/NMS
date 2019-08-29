package nms.system.mapper;

import java.util.List;

import nms.system.vo.AccessVO;

import org.springframework.stereotype.Repository;

/**
 * 접속권한 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "accessMapper")
public interface AccessMapper {
	/**
	 * 접속권한 목록을 받아간다
	 * @return
	 * @throws Exception
	 */
	public List<AccessVO> getAccessList() throws Exception;
	/**
	 * 접속권한 수정한다.
	 * @param access
	 * @return
	 * @throws Exception
	 */
	public int updateAccessInfo(AccessVO access) throws Exception;
		
}
