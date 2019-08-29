package nms.quakeoccur.service;

import java.util.List;

import nms.quakeoccur.mapper.DistributionMapper;
import nms.quakeoccur.vo.QuakeEventListVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "distributionService")
public class DistributionService {
	@Autowired
	DistributionMapper distributionMapper;
	
	public List<List<Object>> getDistributionList(String date_str, String date_end, String page) throws Exception
	{
		return distributionMapper.getDistributionList(date_str, date_end, page);
	}
	
	public List<QuakeEventListVO> getDistributionMap(String date_str, String date_end) throws Exception
	{
		return distributionMapper.getDistributionMap(date_str, date_end);
	}
	public List<QuakeEventListVO> getQuakeList(@Param("stDate")String date_str, @Param("enDate")String date_end) throws Exception
	{
		return distributionMapper.getQuakeList(date_str, date_end);
	}
}
