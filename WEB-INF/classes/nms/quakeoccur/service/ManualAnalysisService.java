package nms.quakeoccur.service;

import nms.quakeoccur.mapper.ManualAnalysisMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository(value="manualAnalysisService")
public class ManualAnalysisService {

	@Autowired
	ManualAnalysisMapper manualAnalysisMapper;
}
