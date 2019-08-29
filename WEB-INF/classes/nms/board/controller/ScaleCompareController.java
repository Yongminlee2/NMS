package nms.board.controller;

import javax.annotation.Resource;

import nms.board.service.ScaleCompareService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 알림마당>규모, 진도 비교표에 대한 요청을 받아 처리하는 Controller
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

@Controller
@RequestMapping("/board")
public class ScaleCompareController {
	private static final Logger logger = LoggerFactory.getLogger(ScaleCompareController.class);
	@Resource(name = "scaleCompareService")
	private ScaleCompareService scaleCompareService;
}
