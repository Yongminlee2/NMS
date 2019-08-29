package nms.inforeceived.mapper;

import java.util.List;

import nms.inforeceived.vo.DataCollRateListVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "dataCollRateMapper")
public interface DataCollRateMapper {
	
	public List<List<Object>> getDataCollRateExcelList(@Param("dateS")String dateS, @Param("dateE")String dateE, @Param("type")String type, @Param("sta_type")String sta_type) throws Exception;
	
	public List<DataCollRateListVO> getDataCollRateList(@Param("dateS")String dateS, @Param("dateE")String dateE, @Param("type")String type, @Param("sta_type")String sta_type) throws Exception;
	
	public List<DataCollRateListVO> getDataCollRateListCheck(@Param("dateS")String dateS, @Param("dateE")String dateE, @Param("type")String type, @Param("sta_type")String sta_type) throws Exception;
}
