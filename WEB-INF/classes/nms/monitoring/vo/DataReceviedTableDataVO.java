package nms.monitoring.vo;

public class DataReceviedTableDataVO {
	
	private String tablename;
	private int epochtime;
	private String color;
	private String maptype;
	public String getTablename() {
		return tablename;
	}
	public void setTablename(String tablename) {
		this.tablename = tablename;
	}
	public int getEpochtime() {
		return epochtime;
	}
	public void setEpochtime(int epochtime) {
		this.epochtime = epochtime;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getMaptype() {
		return maptype;
	}
	public void setMaptype(String maptype) {
		this.maptype = maptype;
	}
	
}
