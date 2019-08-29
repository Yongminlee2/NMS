package nms.report.service;

import java.util.List;

import nms.report.mapper.EventAlarmMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value="eventAlarmService")
public class EventAlarmService {

	@Autowired
	EventAlarmMapper eventAlarmMapper;
	
	public List<List<Object>> getEventAlarmList(String date,String date2, String obs_kind, String page) throws Exception
	{
		return eventAlarmMapper.getEventAlarmList(date,date2, obs_kind, page);
	}
	
}
