package nms.monitoring.mapper;

import java.util.List;

import nms.monitoring.vo.DataReceivedStationInfo;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "datareceivedMapper")
public interface DatareceivedMapper {
	public List<List<Object>> receviedTableDatas() throws Exception;
	
	public DataReceivedStationInfo stationDetail(@Param(value = "sta_code") String sta_code) throws Exception;
}
