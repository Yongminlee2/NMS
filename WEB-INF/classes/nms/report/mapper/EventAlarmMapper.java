package nms.report.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value="eventAlarmMapper")
public interface EventAlarmMapper {
	public List<List<Object>> getEventAlarmList(@Param("date")String date,@Param("date2")String date2, @Param("obs_kind")String obs_kind, @Param("page")String page) throws Exception;
}
