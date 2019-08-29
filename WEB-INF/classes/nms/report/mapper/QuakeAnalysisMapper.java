package nms.report.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "quakeAnalysisMapper")
public interface QuakeAnalysisMapper {
	public List<List<Object>> getQuakeAnalysisList(@Param("date")String date, @Param("obs_kind")String obs_kind, @Param("page")String page) throws Exception;
}
