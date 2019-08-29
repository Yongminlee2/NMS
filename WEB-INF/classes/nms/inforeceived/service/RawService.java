package nms.inforeceived.service;

import java.util.List;

import nms.inforeceived.mapper.RawMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "rawService")
public class RawService {

	@Autowired
	RawMapper rawMapper;
	
	public List<List<Object>> getRawList(String date_s, String date_e, String obs_kind, String sta_type, String page) throws Exception {
		return rawMapper.getRawList(date_s, date_e, obs_kind, sta_type, page);
	}
}
