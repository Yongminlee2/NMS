package nms.report.service;

import java.util.List;

import nms.report.mapper.QuakeAnalysisMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "quakeAnalysisService")
public class QuakeAnalysisService {
	
	@Autowired
	QuakeAnalysisMapper quakeAnalysisMapper;
	
	public List<List<Object>> getQuakeAnalysisList(String date, String obs_kind, String page) throws Exception
	{
		return quakeAnalysisMapper.getQuakeAnalysisList(date, obs_kind, page);
	}
}
