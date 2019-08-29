package nms.monitoring.vo;

public class WaveResponseVO {
	private String staType;
	private String chartGubun;
	private String chartSize;
	
	/** 데이터 객체 */
	private Object data;

	public String getStaType() {
		return staType;
	}

	public void setStaType(String staType) {
		this.staType = staType;
	}

	public String getChartGubun() {
		return chartGubun;
	}

	public void setChartGubun(String chartGubun) {
		this.chartGubun = chartGubun;
	}

	public String getChartSize() {
		return chartSize;
	}

	public void setChartSize(String chartSize) {
		this.chartSize = chartSize;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}
}
