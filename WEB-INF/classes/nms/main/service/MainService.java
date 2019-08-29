package nms.main.service;


import java.util.List;

import javax.annotation.Resource;

import nms.main.mapper.MainMapper;
import nms.quakeoccur.vo.QuakeEventListVO;

import org.springframework.stereotype.Repository;

@Repository(value = "mainService")
public class MainService {
	@Resource(name = "mainMapper")
	private MainMapper mainMapper;
	
	public List<QuakeEventListVO> mainQuakeInfo() throws Exception
	{
		return mainMapper.mainQuakeInfo();
	}
	
	public void deleteAlarmList() throws Exception{
		mainMapper.deleteAlarmList();
	}
}
