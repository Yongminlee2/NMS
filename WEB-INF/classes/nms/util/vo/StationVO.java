package nms.util.vo;
/**
 * 관측소 정보를 받아오는 VO 클래스
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
public class StationVO {
	private String sta_no="";
	private String net="";
	private String net_name="";
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
	private String obs_kind_name="";
	
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
	public String getNet_name() {
		return net_name;
	}
	public void setNet_name(String net_name) {
		this.net_name = net_name;
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
	public String getObs_kind_name() {
		return obs_kind_name;
	}
	public void setObs_kind_name(String obs_kind_name) {
		this.obs_kind_name = obs_kind_name;
	}
}
