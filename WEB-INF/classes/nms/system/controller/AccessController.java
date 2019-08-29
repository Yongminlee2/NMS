package nms.system.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import scala.util.parsing.json.JSONArray;

import com.google.gson.Gson;

import nms.sec.AccessUserInfoManager;
import nms.system.service.AccessService;
import nms.system.vo.AccessVO;
import nms.system.vo.UserInfoVO;
import nms.util.controller.UtilController;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

/**
 * 페이지 접속정보를 가져오는 컨트롤러
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
@Controller
@RequestMapping(value = "/system/access")
public class AccessController {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	@Resource(name = "accessService")
	private AccessService accessService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join access page");
//		model.addAttribute("accessInfoTxt",);
		model.addAttribute("accessInfo",UtilController.ACCESS_MAP);
		
		return "/system/access/list";
	}
	/**
	 * 접속 정보를 받아간다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessInfo.ws")
	public @ResponseBody ResponseDataListVO getAccessinfo(HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc("success");
		responseVO.setData(UtilController.ACCESS_MAP);
		responseVO.setData2(AccessUserInfoManager.getUserAuthority());
//		System.out.println(AccessUserInfoManager.getUserAuthority());
		return responseVO;
	}
	
	/**
	 * 접속 정보를 받아간다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/modyAccess.ws")
	public @ResponseBody ResponseDataListVO modyAccess(@RequestBody List<AccessVO> accessVO, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		ObjectMapper mapper = new ObjectMapper();
		List<AccessVO> ac = mapper.convertValue(accessVO,  new TypeReference<List<AccessVO>>() {});
		String returnValue = "success";
		
//		responseVO.setData(UtilController.ACCESS_MAP);
//		responseVO.setData2(AccessUserInfoManager.getUserAuthority());
		try {
			accessService.updateAccessInfo(ac);
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
//		System.out.println(ac.get(0).getM1());
//		for(AccessVO a : accessVO)
//		{
//			System.out.println(a.getM1());
//		}
		return responseVO;
	}
}


