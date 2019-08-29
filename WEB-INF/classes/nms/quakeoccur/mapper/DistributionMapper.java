package nms.quakeoccur.mapper;

import java.util.List;

import nms.quakeoccur.vo.QuakeEventListVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "distributionMapper")
public interface DistributionMapper {
	public List<List<Object>> getDistributionList(@Param("date_str")String date_str, @Param("date_end")String date_end, @Param("page")String page) throws Exception;
	
	public List<QuakeEventListVO> getDistributionMap(@Param("date_str")String date_str, @Param("date_end")String date_end) throws Exception;
	
	public List<QuakeEventListVO> getQuakeList(@Param("stDate")String date_str, @Param("enDate")String date_end) throws Exception;
}
