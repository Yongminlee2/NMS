package nms.monitoring.vo;

public class WaveChartDataVO {
	
	private String label; // sensor 구분자
	private String epochtime; // UNIX_TIMESTAMP chart y축 data
	private String pga_z;	// chart x축 data 
	private String pga_n;	// chart x축 data
	private String pga_e;	// chart x축 data
	private String pga_2d;	// chart x축 data
	private String pga_3d;	// chart x축 data
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getEpochtime() {
		return epochtime;
	}
	public void setEpochtime(String epochtime) {
		this.epochtime = epochtime;
	}
	public String getPga_z() {
		return pga_z;
	}
	public void setPga_z(String pga_z) {
		this.pga_z = pga_z;
	}
	public String getPga_n() {
		return pga_n;
	}
	public void setPga_n(String pga_n) {
		this.pga_n = pga_n;
	}
	public String getPga_e() {
		return pga_e;
	}
	public void setPga_e(String pga_e) {
		this.pga_e = pga_e;
	}
	public String getPga_2d() {
		return pga_2d;
	}
	public void setPga_2d(String pga_2d) {
		this.pga_2d = pga_2d;
	}
	public String getPga_3d() {
		return pga_3d;
	}
	public void setPga_3d(String pga_3d) {
		this.pga_3d = pga_3d;
	}
}
