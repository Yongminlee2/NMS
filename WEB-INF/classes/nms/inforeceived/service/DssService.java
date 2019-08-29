package nms.inforeceived.service;

import java.util.List;

import nms.inforeceived.mapper.DssMapper;
import nms.monitoring.mapper.DatareceivedMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "dssService")
public class DssService {

	@Autowired
	DssMapper dssMapper;
	
	public List<List<Object>> getDssList(String date_s, String date_e, String obs_kind, String sta_type, String page) throws Exception {
		return dssMapper.getDssList(date_s, date_e, obs_kind, sta_type, page);
	}
}
