package nms.quakeoccur.service;

import java.util.List;

import nms.quakeoccur.mapper.QuakeInfoMapper;
import nms.quakeoccur.vo.QuakeEventListVO;
import nms.quakeoccur.vo.QuakeEventReportVO;
import nms.quakeoccur.vo.SelfEventListVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "quakeInfoService")
public class QuakeInfoService {

	@Autowired
	QuakeInfoMapper quakeInfoMapper;
	
	public List<List<Object>> getQuakeEventList(String date,String date2, String obs_kind, String sta_type, String page) throws Exception
	{
		return quakeInfoMapper.getQuakeEventList(date,date2, obs_kind, sta_type, page);
	}
	
	public List<List<Object>> getSelfEventList(String date,String date2, String obs_kind, String sta_type, String page) throws Exception
	{
		return quakeInfoMapper.getSelfEventList(date,date2, obs_kind, sta_type, page);
	}
	
	public SelfEventListVO getSelfReportData(String replaceWord,String no) throws Exception
	{
		return quakeInfoMapper.getSelfReportData(replaceWord, no);
	}
	
	public QuakeEventReportVO getQuakeReportData(String no) throws Exception
	{
		return quakeInfoMapper.getQuakeReportData(Integer.parseInt(no));
	}
	public List<QuakeEventReportVO> getQuakeReportHistoryData(String no,String date, String time) throws Exception
	{
		return quakeInfoMapper.getQuakeReportHistoryData(no,date+" "+time);
	}
	
	public List<QuakeEventReportVO> getQuakeReportDataAll(String replaceWord, String org) throws Exception
	{
		return quakeInfoMapper.getQuakeReportDataAll(replaceWord, org);
	}
	
	public List<QuakeEventReportVO> getQuakeSummaryReportDataAll(String replaceWord, String org) throws Exception
	{
		return quakeInfoMapper.getQuakeSummaryReportDataAll(replaceWord, org);
	}
	
	public List<QuakeEventReportVO> getSelfReportDataAll(String replaceWord, String org) throws Exception
	{
		return quakeInfoMapper.getSelfReportDataAll(replaceWord, org);
	}
	
	public List<QuakeEventListVO> getQuakeEventSubList(String req_id,String req_org,String req_sta) throws Exception
	{
		return quakeInfoMapper.getQuakeEventSubList(req_id, req_org, req_sta);
	}
}
