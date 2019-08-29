package nms.system.vo;
/**
 * 레코더 정보(코드별 Desc)를 담는 VO 클래스
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
public class RecorderVO {
	
	private String dataStatus="";
	private String rec_no=""; 
    private String sta_no=""; 
    private String net=""; 
    private String obs_id=""; 
    private String rec_id=""; 
    private String rec_company=""; 
    private String rec_model=""; 
    private String rec_serial=""; 
    private String warrenty=""; 
    private String wformat=""; 
    private String protocol=""; 
    private String regdate=""; 
    private String rec_pic1=""; 
    private String rec_pic2=""; 
    private String rec_pic3=""; 
    private String rec_pic4=""; 
    private String rec_tmp1=""; 
    private String rec_tmp2=""; 
    private String rec_tmp3="";
	
	/*코드 네임 관련*/

	
	/*히스토리 관련*/
	private String history_date="";
	private String history;
	private String user_id;
	private String obs_desc;
	private String obs_name;
	
	
	
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
	public String getRec_no() {
		return rec_no;
	}
	public void setRec_no(String rec_no) {
		this.rec_no = rec_no;
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
	public String getRec_id() {
		return rec_id;
	}
	public void setRec_id(String rec_id) {
		this.rec_id = rec_id;
	}
	public String getRec_company() {
		return rec_company;
	}
	public void setRec_company(String rec_company) {
		this.rec_company = rec_company;
	}
	public String getRec_model() {
		return rec_model;
	}
	public void setRec_model(String rec_model) {
		this.rec_model = rec_model;
	}
	public String getRec_serial() {
		return rec_serial;
	}
	public void setRec_serial(String rec_serial) {
		this.rec_serial = rec_serial;
	}
	public String getWarrenty() {
		return warrenty;
	}
	public void setWarrenty(String warrenty) {
		this.warrenty = warrenty;
	}
	public String getWformat() {
		return wformat;
	}
	public void setWformat(String wformat) {
		this.wformat = wformat;
	}
	public String getProtocol() {
		return protocol;
	}
	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getRec_pic1() {
		return rec_pic1;
	}
	public void setRec_pic1(String rec_pic1) {
		this.rec_pic1 = rec_pic1;
	}
	public String getRec_pic2() {
		return rec_pic2;
	}
	public void setRec_pic2(String rec_pic2) {
		this.rec_pic2 = rec_pic2;
	}
	public String getRec_pic3() {
		return rec_pic3;
	}
	public void setRec_pic3(String rec_pic3) {
		this.rec_pic3 = rec_pic3;
	}
	public String getRec_pic4() {
		return rec_pic4;
	}
	public void setRec_pic4(String rec_pic4) {
		this.rec_pic4 = rec_pic4;
	}
	public String getRec_tmp1() {
		return rec_tmp1;
	}
	public void setRec_tmp1(String rec_tmp1) {
		this.rec_tmp1 = rec_tmp1;
	}
	public String getRec_tmp2() {
		return rec_tmp2;
	}
	public void setRec_tmp2(String rec_tmp2) {
		this.rec_tmp2 = rec_tmp2;
	}
	public String getRec_tmp3() {
		return rec_tmp3;
	}
	public void setRec_tmp3(String rec_tmp3) {
		this.rec_tmp3 = rec_tmp3;
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
