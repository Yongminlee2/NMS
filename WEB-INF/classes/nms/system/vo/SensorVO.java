package nms.system.vo;
/**
 * 센서 정보(코드별 Desc)를 담는 VO 클래스
 * @author Administrator
 * @since 2016. 11. 16.
 * @version 
 * @see
 * 
 * <pre>
 * << 수정이력(Modification Information) >>
 *   
 *  날짜		 		      작성자 					   비고
 *  --------------   ---------    ---------------------------
 *  2016. 11. 16.      박태진                    		   	 최초
 *
 * </pre>
 */
public class SensorVO {
	private String sen_no; 
	private String sta_no=""; 
	private String net=""; 
	private String obs_id=""; 
	private String sen_id=""; 
	private String sen_location=""; 
	private String sen_company=""; 
	private String sen_model=""; 
	private String sen_serial=""; 
	private String sen_kind=""; 
	private String sen_gubun=""; 
	private String sen_position=""; 
	private String sen_channel=""; 
	private String sen_lon=""; 
	private String sen_lat=""; 
	private String sen_z_resp=""; 
	private String sen_n_resp=""; 
	private String sen_e_resp=""; 
	private String sen_z_sens=""; 
	private String sen_n_sens=""; 
	private String sen_e_sens=""; 
	private String sen_rec_id=""; 
	private String regdate=""; 
	private String sen_pic1=""; 
	private String sen_pic2=""; 
	private String sen_pic3=""; 
	private String sen_pic4=""; 
	private String sen_tmp1=""; 
	private String sen_tmp2=""; 
	private String sen_tmp3="";
	
	private String obs_name="";
	
	/*코드 네임 관련*/
	private String sen_kind_desc="";
	private String sen_gubun_desc="";

	
	/*히스토리 관련*/
	private String history_date="";
	private String history;
	private String user_id;
	private String obs_desc;
	
	private String dataStatus="";
	
	
	public String getObs_name() {
		return obs_name;
	}
	public void setObs_name(String obs_name) {
		this.obs_name = obs_name;
	}
	public String getDataStatus() {
		return dataStatus;
	}
	public void setDataStatus(String dataStatus) {
		this.dataStatus = dataStatus;
	}
	public String getSen_no() {
		return sen_no;
	}
	public void setSen_no(String sen_no) {
		this.sen_no = sen_no;
	}
	public String getSta_no() {
		return sta_no;
	}
	public void setSta_no(String sta_no) {
		this.sta_no = sta_no;
	}
	public String getNet() {
		return net;
	}
	public void setNet(String net) {
		this.net = net;
	}
	public String getObs_id() {
		return obs_id;
	}
	public void setObs_id(String obs_id) {
		this.obs_id = obs_id;
	}
	public String getSen_id() {
		return sen_id;
	}
	public void setSen_id(String sen_id) {
		this.sen_id = sen_id;
	}
	public String getSen_location() {
		return sen_location;
	}
	public void setSen_location(String sen_location) {
		this.sen_location = sen_location;
	}
	public String getSen_company() {
		return sen_company;
	}
	public void setSen_company(String sen_company) {
		this.sen_company = sen_company;
	}
	public String getSen_model() {
		return sen_model;
	}
	public void setSen_model(String sen_model) {
		this.sen_model = sen_model;
	}
	public String getSen_serial() {
		return sen_serial;
	}
	public void setSen_serial(String sen_serial) {
		this.sen_serial = sen_serial;
	}
	public String getSen_kind() {
		return sen_kind;
	}
	public void setSen_kind(String sen_kind) {
		this.sen_kind = sen_kind;
	}
	public String getSen_gubun() {
		return sen_gubun;
	}
	public void setSen_gubun(String sen_gubun) {
		this.sen_gubun = sen_gubun;
	}
	public String getSen_position() {
		return sen_position;
	}
	public void setSen_position(String sen_position) {
		this.sen_position = sen_position;
	}
	public String getSen_channel() {
		return sen_channel;
	}
	public void setSen_channel(String sen_channel) {
		this.sen_channel = sen_channel;
	}
	public String getSen_lon() {
		return sen_lon;
	}
	public void setSen_lon(String sen_lon) {
		this.sen_lon = sen_lon;
	}
	public String getSen_lat() {
		return sen_lat;
	}
	public void setSen_lat(String sen_lat) {
		this.sen_lat = sen_lat;
	}
	public String getSen_z_resp() {
		return sen_z_resp;
	}
	public void setSen_z_resp(String sen_z_resp) {
		this.sen_z_resp = sen_z_resp;
	}
	public String getSen_n_resp() {
		return sen_n_resp;
	}
	public void setSen_n_resp(String sen_n_resp) {
		this.sen_n_resp = sen_n_resp;
	}
	public String getSen_e_resp() {
		return sen_e_resp;
	}
	public void setSen_e_resp(String sen_e_resp) {
		this.sen_e_resp = sen_e_resp;
	}
	public String getSen_z_sens() {
		return sen_z_sens;
	}
	public void setSen_z_sens(String sen_z_sens) {
		this.sen_z_sens = sen_z_sens;
	}
	public String getSen_n_sens() {
		return sen_n_sens;
	}
	public void setSen_n_sens(String sen_n_sens) {
		this.sen_n_sens = sen_n_sens;
	}
	public String getSen_e_sens() {
		return sen_e_sens;
	}
	public void setSen_e_sens(String sen_e_sens) {
		this.sen_e_sens = sen_e_sens;
	}
	public String getSen_rec_id() {
		return sen_rec_id;
	}
	public void setSen_rec_id(String sen_rec_id) {
		this.sen_rec_id = sen_rec_id;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getSen_pic1() {
		return sen_pic1;
	}
	public void setSen_pic1(String sen_pic1) {
		this.sen_pic1 = sen_pic1;
	}
	public String getSen_pic2() {
		return sen_pic2;
	}
	public void setSen_pic2(String sen_pic2) {
		this.sen_pic2 = sen_pic2;
	}
	public String getSen_pic3() {
		return sen_pic3;
	}
	public void setSen_pic3(String sen_pic3) {
		this.sen_pic3 = sen_pic3;
	}
	public String getSen_pic4() {
		return sen_pic4;
	}
	public void setSen_pic4(String sen_pic4) {
		this.sen_pic4 = sen_pic4;
	}
	public String getSen_tmp1() {
		return sen_tmp1;
	}
	public void setSen_tmp1(String sen_tmp1) {
		this.sen_tmp1 = sen_tmp1;
	}
	public String getSen_tmp2() {
		return sen_tmp2;
	}
	public void setSen_tmp2(String sen_tmp2) {
		this.sen_tmp2 = sen_tmp2;
	}
	public String getSen_tmp3() {
		return sen_tmp3;
	}
	public void setSen_tmp3(String sen_tmp3) {
		this.sen_tmp3 = sen_tmp3;
	}
	public String getSen_kind_desc() {
		return sen_kind_desc;
	}
	public void setSen_kind_desc(String sen_kind_desc) {
		this.sen_kind_desc = sen_kind_desc;
	}
	public String getSen_gubun_desc() {
		return sen_gubun_desc;
	}
	public void setSen_gubun_desc(String sen_gubun_desc) {
		this.sen_gubun_desc = sen_gubun_desc;
	}
	public String getHistory_date() {
		return history_date;
	}
	public void setHistory_date(String history_date) {
		this.history_date = history_date;
	}
	public String getHistory() {
		return history;
	}
	public void setHistory(String history) {
		this.history = history;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getObs_desc() {
		return obs_desc;
	}
	public void setObs_desc(String obs_desc) {
		this.obs_desc = obs_desc;
	}
	
}
