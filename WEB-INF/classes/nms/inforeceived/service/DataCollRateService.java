package nms.inforeceived.service;

import java.util.List;

import nms.inforeceived.mapper.DataCollRateMapper;
import nms.inforeceived.vo.DataCollRateListVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "dataCollRateService")
public class DataCollRateService {
	@Autowired
	DataCollRateMapper dataCollRateMapper;
	
	public List<List<Object>> getDataCollRateExcelList(String dateS, String dateE, String type, String sta_type) throws Exception
	{
		return dataCollRateMapper.getDataCollRateExcelList(dateS, dateE, type, sta_type);
	}
	
	public List<DataCollRateListVO> getDataCollRateList(String dateS, String dateE, String type, String sta_type) throws Exception
	{
		return dataCollRateMapper.getDataCollRateList(dateS, dateE, type, sta_type);
	}
	
	public List<DataCollRateListVO> getDataCollRateListCheck(String dateS, String dateE, String type, String sta_type) throws Exception
	{
		return dataCollRateMapper.getDataCollRateListCheck(dateS, dateE, type, sta_type);
	}
}
