package nms.monitoring.service;

import java.util.List;

import nms.monitoring.mapper.DatareceivedMapper;
import nms.monitoring.vo.DataReceivedStationInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "datareceivedService")
public class DatareceivedService {

	@Autowired
	DatareceivedMapper datareceivedMapper;
	
	public List<List<Object>> receviedTableDatas() throws Exception {
		return datareceivedMapper.receviedTableDatas();
	}
	
	public DataReceivedStationInfo stationDetail(String sta_code) throws Exception
	{
		return datareceivedMapper.stationDetail(sta_code);
	}
}
