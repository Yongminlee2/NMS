package nms.util.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import nms.util.vo.ResponseDataListVO;
import nms.util.vo.StationVO;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/util/common")
public class CommonController {
	
	@RequestMapping("/stationobskind.ws")
	public @ResponseBody ResponseDataListVO stationObsKindWS(@RequestBody String obsKind, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO result = new ResponseDataListVO();
		
		List <StationVO> stationInfoList =  (List<StationVO>) UtilController.STATION_MAP.get("stationInfo");
		
		List <StationVO> obsKindList = new ArrayList<StationVO>();
		
		for (StationVO stationVO : stationInfoList) {
			if(obsKind.equals(stationVO.getSta_tmp1()))
			{
				obsKindList.add(stationVO);
			}
		}
		
		result.setData(obsKindList);
		
		return result;
	}
	
	@RequestMapping("/station.ws")
	public @ResponseBody ResponseDataListVO stationWS(HttpServletRequest request)throws Exception
	{
		ResponseDataListVO result = new ResponseDataListVO();
		
		List <StationVO> stationInfoList =  (List<StationVO>) UtilController.STATION_MAP.get("stationInfo");
		
		result.setData(stationInfoList);
		
		return result;
	}
	
	@RequestMapping("/stationofsensor.ws")
	public @ResponseBody ResponseDataListVO stationOfSensorWS(@RequestBody String obsKind, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO result = new ResponseDataListVO();
		
		List <StationVO> stationofSensorInfoList =  (List<StationVO>) UtilController.STATION_MAP.get("stationofsensor");
		if(StringUtils.isEmpty(obsKind)){
			result.setData(stationofSensorInfoList);
		}else{
			List <StationVO> obsKindList = new ArrayList<StationVO>();
			
			for (StationVO stationVO : stationofSensorInfoList) {
				if(obsKind.equals(stationVO.getSta_tmp1()))
				{
					obsKindList.add(stationVO);
				}
			}
			result.setData(obsKindList);
		}
		return result;
		
	}
	
	@RequestMapping("/stationofsensor2.ws")
	public @ResponseBody ResponseDataListVO stationOfSensor2WS(HttpServletRequest request)throws Exception
	{
		ResponseDataListVO result = new ResponseDataListVO();
		
		List <StationVO> stationofSensorInfoList =  (List<StationVO>) UtilController.STATION_MAP.get("stationofsensor2");
		
		result.setData(stationofSensorInfoList);
		
		return result;
	}
}
