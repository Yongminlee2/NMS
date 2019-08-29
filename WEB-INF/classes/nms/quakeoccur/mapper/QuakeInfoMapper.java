package nms.quakeoccur.mapper;

import java.util.List;

import nms.quakeoccur.vo.QuakeEventListVO;
import nms.quakeoccur.vo.QuakeEventReportVO;
import nms.quakeoccur.vo.SelfEventListVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "quakeInfoMapper")
public interface QuakeInfoMapper {
	public List<List<Object>> getQuakeEventList(@Param("date")String date,@Param("date2")String date2, @Param("obs_kind")String obs_kind, @Param("sta_type")String sta_type, @Param("page")String page) throws Exception;
	
	public List<List<Object>> getSelfEventList(@Param("date")String date,@Param("date2")String date2, @Param("obs_kind")String obs_kind, @Param("sta_type")String sta_type, @Param("page")String page) throws Exception;
	
	public SelfEventListVO getSelfReportData(@Param("replaceWord")String replaceWord,@Param("no")String no) throws Exception;
	
	public QuakeEventReportVO getQuakeReportData(@Param("no")int no) throws Exception;
	
	public List<QuakeEventReportVO> getQuakeReportHistoryData(@Param("no")String type,@Param("date")String date) throws Exception;
	
	public List<QuakeEventReportVO> getQuakeReportDataAll(@Param("replaceWord")String replaceWord, @Param("org")String org) throws Exception;
	
	public List<QuakeEventReportVO> getQuakeSummaryReportDataAll(@Param("replaceWord")String replaceWord, @Param("org")String org) throws Exception;
	
	public List<QuakeEventReportVO> getSelfReportDataAll(@Param("replaceWord")String replaceWord, @Param("org")String org) throws Exception;
	
	public List<QuakeEventListVO> getQuakeEventSubList(@Param("req_id")String req_id, @Param("req_org")String req_org,@Param("req_sta")String req_sta) throws Exception;
}
