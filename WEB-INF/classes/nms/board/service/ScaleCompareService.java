package nms.board.service;

import javax.annotation.Resource;

import nms.board.mapper.ScaleCompareMapper;

import org.springframework.stereotype.Repository;

/**
 * 알림마당>규모, 진도 비교표에 대한 요청을 받아 처리하는 Service
 * @author 박병규
 * @since 2016.10.20
 * @version 1.0
 * @see
 * 
 * <pre>
 * << 개정이력(Modification Information) >>
 *   

 * </pre>
 */

@Repository(value = "scaleCompareService")
public class ScaleCompareService {
	@Resource(name = "scaleCompareMapper")
	private ScaleCompareMapper scaleCompareMapper;
}
