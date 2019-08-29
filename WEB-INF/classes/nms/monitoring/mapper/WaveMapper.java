package nms.monitoring.mapper;

import java.util.List;

import nms.monitoring.vo.WaveChartDataVO;
import nms.monitoring.vo.WaveMapDataVO;
import nms.quakeoccur.vo.SelfEventListVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "waveMapper")
public interface WaveMapper {
	public List<List<Object>> staTypeByDatas(@Param("dataType")String dataType, @Param("staType")String staType) throws Exception;
	
	public List<WaveMapDataVO> mapDatas(@Param("type")String type) throws Exception;
	
	public List<WaveChartDataVO> chartDatas(@Param("staType")String staType) throws Exception;
	
	public List<SelfEventListVO> alarmDatas() throws Exception;
	
	public void endAlarm(@Param("evtNo")String evtNo) throws Exception;
}
