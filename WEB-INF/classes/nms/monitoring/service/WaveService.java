package nms.monitoring.service;

import java.util.List;

import nms.monitoring.mapper.WaveMapper;
import nms.monitoring.vo.WaveChartDataVO;
import nms.monitoring.vo.WaveMapDataVO;
import nms.quakeoccur.vo.SelfEventListVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "waveService")
public class WaveService {

	@Autowired
	WaveMapper waveMapper;
	public List<List<Object>> staTypeByDatas(String dataType, String staType) throws Exception {
		return waveMapper.staTypeByDatas(dataType, staType);
	}
	
	public List<WaveMapDataVO> mapDatas(String type) throws Exception
	{
		return waveMapper.mapDatas(type);
	}
	
	public List<WaveChartDataVO> chartDatas(String staType) throws Exception{
		return waveMapper.chartDatas(staType);
	}
	
	public List<SelfEventListVO> alarmDatas() throws Exception{
		return waveMapper.alarmDatas();
	}
	
	public void endAlarm(String reqNo) throws Exception{
		waveMapper.endAlarm(reqNo);
	}
}
