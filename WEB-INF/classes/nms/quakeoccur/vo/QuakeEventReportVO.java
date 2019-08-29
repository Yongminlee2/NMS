package nms.quakeoccur.vo;

public class QuakeEventReportVO {
	private String date;
	private String time;
	private double lat;
	private double lon;
	private String area;
	private String distance;
	private String kmeter;
	private float mag;
	private String org;
	private String obs_id;
	private String req_id;
	private String req_date;
	private String req_starttime;
	private String req_endtime;
	private int cnt;
	
	private String obs_name;
	private String station_type;
	private String sen_id;
	private String address;
	private String net;
	
	private String timearea;
	private String epoch_time;
	private String delay_time;
	private String full_date;
	
	private String max_time;
	private String max_g;
	private String max_z;
	private String max_n;
	private String max_e;
	
	private String comment;
	private String user_info;
	private String etc;
	
	private String ac100_z;
	private String ac100_n;
	private String ac100_e;
	
	private String sp100_z;
	private String sp100_n;
	private String sp100_e;
	
	private String g_z;
	private String g_n;
	private String g_e;
	
	private String b_z;
	private String b_n;
	private String b_e;
	
	private String m_n;
	private String m_e;
	
	private String r_n;
	private String r_e;
	
	private String image_path;
	
	
	
	
	public String getReq_starttime() {
		return req_starttime;
	}
	public void setReq_starttime(String req_starttime) {
		this.req_starttime = req_starttime;
	}
	public String getReq_endtime() {
		return req_endtime;
	}
	public void setReq_endtime(String req_endtime) {
		this.req_endtime = req_endtime;
	}
	public String getStation_type() {
		return station_type;
	}
	public void setStation_type(String station_type) {
		this.station_type = station_type;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getReq_date() {
		return req_date;
	}
	public void setReq_date(String req_date) {
		this.req_date = req_date;
	}
	public String getReq_id() {
		return req_id;
	}
	public void setReq_id(String req_id) {
		this.req_id = req_id;
	}
	public String getR_n() {
		return r_n;
	}
	public void setR_n(String r_n) {
		this.r_n = r_n;
	}
	public String getR_e() {
		return r_e;
	}
	public void setR_e(String r_e) {
		this.r_e = r_e;
	}
	public String getObs_id() {
		return obs_id;
	}
	public void setObs_id(String obs_id) {
		this.obs_id = obs_id;
	}
	public String getImage_path() {
		return image_path;
	}
	public void setImage_path(String image_path) {
		this.image_path = image_path;
	}
	public String getAc100_z() {
		return ac100_z;
	}
	public void setAc100_z(String ac100_z) {
		this.ac100_z = ac100_z;
	}
	public String getAc100_n() {
		return ac100_n;
	}
	public void setAc100_n(String ac100_n) {
		this.ac100_n = ac100_n;
	}
	public String getAc100_e() {
		return ac100_e;
	}
	public void setAc100_e(String ac100_e) {
		this.ac100_e = ac100_e;
	}
	public String getSp100_z() {
		return sp100_z;
	}
	public void setSp100_z(String sp100_z) {
		this.sp100_z = sp100_z;
	}
	public String getSp100_n() {
		return sp100_n;
	}
	public void setSp100_n(String sp100_n) {
		this.sp100_n = sp100_n;
	}
	public String getSp100_e() {
		return sp100_e;
	}
	public void setSp100_e(String sp100_e) {
		this.sp100_e = sp100_e;
	}
	public String getG_z() {
		return g_z;
	}
	public void setG_z(String g_z) {
		this.g_z = g_z;
	}
	public String getG_n() {
		return g_n;
	}
	public void setG_n(String g_n) {
		this.g_n = g_n;
	}
	public String getG_e() {
		return g_e;
	}
	public void setG_e(String g_e) {
		this.g_e = g_e;
	}
	public String getB_z() {
		return b_z;
	}
	public void setB_z(String b_z) {
		this.b_z = b_z;
	}
	public String getB_n() {
		return b_n;
	}
	public void setB_n(String b_n) {
		this.b_n = b_n;
	}
	public String getB_e() {
		return b_e;
	}
	public void setB_e(String b_e) {
		this.b_e = b_e;
	}
	public String getM_n() {
		return m_n;
	}
	public void setM_n(String m_n) {
		this.m_n = m_n;
	}
	public String getM_e() {
		return m_e;
	}
	public void setM_e(String m_e) {
		this.m_e = m_e;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public String getUser_info() {
		return user_info;
	}
	public void setUser_info(String user_info) {
		this.user_info = user_info;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	public String getEpoch_time() {
		return epoch_time;
	}
	public void setEpoch_time(String epoch_time) {
		this.epoch_time = epoch_time;
	}
	public String getDelay_time() {
		return delay_time;
	}
	public void setDelay_time(String delay_time) {
		this.delay_time = delay_time;
	}
	public String getFull_date() {
		return full_date;
	}
	public void setFull_date(String full_date) {
		this.full_date = full_date;
	}
	public String getMax_time() {
		return max_time;
	}
	public void setMax_time(String max_time) {
		this.max_time = max_time;
	}
	public String getMax_g() {
		return max_g;
	}
	public void setMax_g(String max_g) {
		this.max_g = max_g;
	}
	public String getMax_z() {
		return max_z;
	}
	public void setMax_z(String max_z) {
		this.max_z = max_z;
	}
	public String getMax_n() {
		return max_n;
	}
	public void setMax_n(String max_n) {
		this.max_n = max_n;
	}
	public String getMax_e() {
		return max_e;
	}
	public void setMax_e(String max_e) {
		this.max_e = max_e;
	}
	public String getNet() {
		return net;
	}
	public void setNet(String net) {
		this.net = net;
	}
	public String getTimearea() {
		return timearea;
	}
	public void setTimearea(String timearea) {
		this.timearea = timearea;
	}
	public String getObs_name() {
		return obs_name;
	}
	public void setObs_name(String obs_name) {
		this.obs_name = obs_name;
	}
	public String getSen_id() {
		return sen_id;
	}
	public void setSen_id(String sen_id) {
		this.sen_id = sen_id;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getOrg() {
		return org;
	}
	public void setOrg(String org) {
		this.org = org;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public double getLat() {
		return lat;
	}
	public void setLat(double lat) {
		this.lat = lat;
	}
	public double getLon() {
		return lon;
	}
	public void setLon(double lon) {
		this.lon = lon;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getDistance() {
		return distance;
	}
	public void setDistance(String distance) {
		this.distance = distance;
	}
	public String getKmeter() {
		return kmeter;
	}
	public void setKmeter(String kmeter) {
		this.kmeter = kmeter;
	}
	public float getMag() {
		return mag;
	}
	public void setMag(float mag) {
		this.mag = mag;
	} 
	
	
}
