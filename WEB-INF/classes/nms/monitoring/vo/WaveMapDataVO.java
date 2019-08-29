package nms.monitoring.vo;

public class WaveMapDataVO {

	private String tablename;
	private String st_epochtime;
	private String pga_val;
	private String color;
	private String maptype;
	private String sen_rep;
	public String getTablename() {
		return tablename;
	}
	public void setTablename(String tablename) {
		this.tablename = tablename;
	}
	public String getSt_epochtime() {
		return st_epochtime;
	}
	public void setSt_epochtime(String st_epochtime) {
		this.st_epochtime = st_epochtime;
	}
	public String getPga_val() {
		return pga_val;
	}
	public void setPga_val(String pga_val) {
		this.pga_val = pga_val;
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
	public String getSen_rep() {
		return sen_rep;
	}
	public void setSen_rep(String sen_rep) {
		this.sen_rep = sen_rep;
	}
	
}
