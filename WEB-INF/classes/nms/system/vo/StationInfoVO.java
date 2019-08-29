package nms.system.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import nms.util.vo.BaseVO;

/**
 * 愿�륫���뺣낫(肄붾뱶蹂�Desc)瑜��대뒗 VO �대옒��
 * @author Administrator
 * @since 2016. 11. 16.
 * @version 
 * @see
 * 
 * <pre>
 * << �섏젙�대젰(Modification Information) >>
 *   
 *  �좎쭨		 		      �묒꽦��					   鍮꾧퀬
 *  --------------   ---------    ---------------------------
 *  2016. 11. 16.      諛뺥깭吏�                   		   	 理쒖큹
 *
 * </pre>
 */
public class StationInfoVO extends BaseVO {
	
	private String sh_no="";
	private String sta_no="";
	private String net="";
	private String obs_id="";
	private String obs_name="";
	private String contractdate="";
	private String completedate="";
	private String price_contract="";
	private String price_sw="";
	private String price_hw="";
	private String opendate="";
	private String offdate="";
	private String area="";
	private String address="";
	private String obs_kind="";
	private String position="";
	private String lon="";
	private String lat="";
	private String altitude="";
	private String ground_ht="";
	private String uground_ht="";
	private String base="";
	private String str_cd="";
	private String seis_cd="";
	private String ground="";
	private String hole="";
	private String seis_ds="";
	private String design_acc="";
	private String threshold_acc="";
	private String build_floor="";
	private String eq_area="";
	private String hole_map="";
	private String charge="";
	private String contact="";
	private String user_id="";
	private String regdate="";
	private String sta_type="";
	private String sta_ip="";
	private String sta_pic1="";
	private String sta_pic2="";
	private String sta_pic3="";
	private String sta_pic4="";
	private String sta_tmp1="";
	private String sta_tmp2="";
	private String sta_tmp3="";
	
	/*肄붾뱶 �ㅼ엫 愿�젴*/
	private String obs_desc="";
	private String obs_kind_desc="";
	private String base_desc="";
	private String str_cd_desc="";
	private String seis_cd_desc="";
	private String ground_desc="";
	
	/*�덉뒪�좊━ 愿�젴*/
	private String history_date="";
	private String history;
	private String history_no;
	
	private MultipartFile profile;
	
	private String status;
	
	private List<SensorVO> sensors;
	private List<RecorderVO> recorders;
	
	
	
	public List<SensorVO> getSensors() {
		return sensors;
	}
	public void setSensors(List<SensorVO> sensors) {
		this.sensors = sensors;
	}
	public List<RecorderVO> getRecorders() {
		return recorders;
	}
	public void setRecorders(List<RecorderVO> recorders) {
		this.recorders = recorders;
	}
	public String getSh_no() {
		return sh_no;
	}
	public void setSh_no(String sh_no) {
		this.sh_no = sh_no;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public MultipartFile getProfile() {
		return profile;
	}
	public void setProfile(MultipartFile profile) {
		this.profile = profile;
	}
	public String getHistory_no() {
		return history_no;
	}
	public void setHistory_no(String history_no) {
		this.history_no = history_no;
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
	public String getObs_name() {
		return obs_name;
	}
	public void setObs_name(String obs_name) {
		this.obs_name = obs_name;
	}
	public String getContractdate() {
		return contractdate;
	}
	public void setContractdate(String contractdate) {
		this.contractdate = contractdate;
	}
	public String getCompletedate() {
		return completedate;
	}
	public void setCompletedate(String completedate) {
		this.completedate = completedate;
	}
	public String getPrice_contract() {
		return price_contract;
	}
	public void setPrice_contract(String price_contract) {
		this.price_contract = price_contract;
	}
	public String getPrice_sw() {
		return price_sw;
	}
	public void setPrice_sw(String price_sw) {
		this.price_sw = price_sw;
	}
	public String getPrice_hw() {
		return price_hw;
	}
	public void setPrice_hw(String price_hw) {
		this.price_hw = price_hw;
	}
	public String getOpendate() {
		return opendate;
	}
	public void setOpendate(String opendate) {
		this.opendate = opendate;
	}
	public String getOffdate() {
		return offdate;
	}
	public void setOffdate(String offdate) {
		this.offdate = offdate;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getObs_kind() {
		return obs_kind;
	}
	public void setObs_kind(String obs_kind) {
		this.obs_kind = obs_kind;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getLon() {
		return lon;
	}
	public void setLon(String lon) {
		this.lon = lon;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getAltitude() {
		return altitude;
	}
	public void setAltitude(String altitude) {
		this.altitude = altitude;
	}
	public String getGround_ht() {
		return ground_ht;
	}
	public void setGround_ht(String ground_ht) {
		this.ground_ht = ground_ht;
	}
	public String getUground_ht() {
		return uground_ht;
	}
	public void setUground_ht(String uground_ht) {
		this.uground_ht = uground_ht;
	}
	public String getBase() {
		return base;
	}
	public void setBase(String base) {
		this.base = base;
	}
	public String getStr_cd() {
		return str_cd;
	}
	public void setStr_cd(String str_cd) {
		this.str_cd = str_cd;
	}
	public String getSeis_cd() {
		return seis_cd;
	}
	public void setSeis_cd(String seis_cd) {
		this.seis_cd = seis_cd;
	}
	public String getGround() {
		return ground;
	}
	public void setGround(String ground) {
		this.ground = ground;
	}
	public String getHole() {
		return hole;
	}
	public void setHole(String hole) {
		this.hole = hole;
	}
	public String getSeis_ds() {
		return seis_ds;
	}
	public void setSeis_ds(String seis_ds) {
		this.seis_ds = seis_ds;
	}
	public String getDesign_acc() {
		return design_acc;
	}
	public void setDesign_acc(String design_acc) {
		this.design_acc = design_acc;
	}
	public String getThreshold_acc() {
		return threshold_acc;
	}
	public void setThreshold_acc(String threshold_acc) {
		this.threshold_acc = threshold_acc;
	}
	public String getBuild_floor() {
		return build_floor;
	}
	public void setBuild_floor(String build_floor) {
		this.build_floor = build_floor;
	}
	public String getEq_area() {
		return eq_area;
	}
	public void setEq_area(String eq_area) {
		this.eq_area = eq_area;
	}
	public String getHole_map() {
		return hole_map;
	}
	public void setHole_map(String hole_map) {
		this.hole_map = hole_map;
	}
	public String getCharge() {
		return charge;
	}
	public void setCharge(String charge) {
		this.charge = charge;
	}
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getSta_type() {
		return sta_type;
	}
	public void setSta_type(String sta_type) {
		this.sta_type = sta_type;
	}
	public String getSta_ip() {
		return sta_ip;
	}
	public void setSta_ip(String sta_ip) {
		this.sta_ip = sta_ip;
	}
	public String getSta_pic1() {
		return sta_pic1;
	}
	public void setSta_pic1(String sta_pic1) {
		this.sta_pic1 = sta_pic1;
	}
	public String getSta_pic2() {
		return sta_pic2;
	}
	public void setSta_pic2(String sta_pic2) {
		this.sta_pic2 = sta_pic2;
	}
	public String getSta_pic3() {
		return sta_pic3;
	}
	public void setSta_pic3(String sta_pic3) {
		this.sta_pic3 = sta_pic3;
	}
	public String getSta_pic4() {
		return sta_pic4;
	}
	public void setSta_pic4(String sta_pic4) {
		this.sta_pic4 = sta_pic4;
	}
	public String getSta_tmp1() {
		return sta_tmp1;
	}
	public void setSta_tmp1(String sta_tmp1) {
		this.sta_tmp1 = sta_tmp1;
	}
	public String getSta_tmp2() {
		return sta_tmp2;
	}
	public void setSta_tmp2(String sta_tmp2) {
		this.sta_tmp2 = sta_tmp2;
	}
	public String getSta_tmp3() {
		return sta_tmp3;
	}
	public void setSta_tmp3(String sta_tmp3) {
		this.sta_tmp3 = sta_tmp3;
	}
	public String getObs_desc() {
		return obs_desc;
	}
	public void setObs_desc(String obs_desc) {
		this.obs_desc = obs_desc;
	}
	public String getObs_kind_desc() {
		return obs_kind_desc;
	}
	public void setObs_kind_desc(String obs_kind_desc) {
		this.obs_kind_desc = obs_kind_desc;
	}
	public String getBase_desc() {
		return base_desc;
	}
	public void setBase_desc(String base_desc) {
		this.base_desc = base_desc;
	}
	public String getStr_cd_desc() {
		return str_cd_desc;
	}
	public void setStr_cd_desc(String str_cd_desc) {
		this.str_cd_desc = str_cd_desc;
	}
	public String getSeis_cd_desc() {
		return seis_cd_desc;
	}
	public void setSeis_cd_desc(String seis_cd_desc) {
		this.seis_cd_desc = seis_cd_desc;
	}
	public String getGround_desc() {
		return ground_desc;
	}
	public void setGround_desc(String ground_desc) {
		this.ground_desc = ground_desc;
	}
	
}
