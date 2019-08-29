package nms.googlemaps.mapper;

import org.springframework.stereotype.Repository;

@Repository(value = "chartMapper")
public interface TestMapper {
	public String retrieveDatas() throws Exception;
}
