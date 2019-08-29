package nms.main.mapper;


import java.util.List;

import nms.quakeoccur.vo.QuakeEventListVO;

import org.springframework.stereotype.Repository;

@Repository(value = "mainMapper")
public interface MainMapper {
	public List<QuakeEventListVO> mainQuakeInfo() throws Exception;
	
	public void deleteAlarmList() throws Exception;
}
