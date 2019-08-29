package nms.googlemaps.service;

import nms.googlemaps.mapper.TestMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value = "chartService")
public class TestService {
	
	@Autowired
	TestMapper mainMapper;
	
	public String retrieveDatas() throws Exception {
		return mainMapper.retrieveDatas();
	}
}
