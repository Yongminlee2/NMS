package nms.inforeceived.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository(value = "dssMapper")
public interface DssMapper {
	public List<List<Object>> getDssList(@Param("date_s")String date_s, @Param("date_e")String date_e, @Param("obs_kind")String obs_kind, @Param("sta_type")String sta_type, @Param("page")String page) throws Exception;
}
