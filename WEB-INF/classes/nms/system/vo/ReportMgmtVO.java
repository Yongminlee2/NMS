package nms.system.vo;


import nms.util.vo.BaseVO;

/**
 * 보고서 정보(코드별 Desc)를 담는 VO 클래스
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
public class ReportMgmtVO extends BaseVO {
	private String l_date="";
	private String l_sta="";
	private String l_type="";
	private String l_type_desc="";
	private String l_send="";
	private String l_recv="";
	private String l_writer="";
	private String l_status="";
	private String l_reason="";
	private String l_tmp1="";
	private String l_tmp2="";
	private String l_tmp3="";
	private String l_no="";
	private String l_idx = "";
	
	private String obs_name="";
	private String obs_kind="";
	
	private String ls = "";
	
	
	
	public String getLs() {
		return ls;
	}
	public void setLs(String ls) {
		this.ls = ls;
	}
	public String getL_idx() {
		return l_idx;
	}
	public void setL_idx(String l_idx) {
		this.l_idx = l_idx;
	}
	public String getObs_name() {
		return obs_name;
	}
	public void setObs_name(String obs_name) {
		this.obs_name = obs_name;
	}
	public String getObs_kind() {
		return obs_kind;
	}
	public void setObs_kind(String obs_kind) {
		if(obs_kind.equals("NC")){
			obs_kind = "원전부지";
		}else if(obs_kind.equals("HP")){
			obs_kind = "수력발전";
		}else{
			obs_kind = "양수발전";
		}
		this.obs_kind = obs_kind;
	}
	public String getL_type_desc() {
		return l_type_desc;
	}
	public void setL_type_desc(String l_type_desc) {
		this.l_type_desc = l_type_desc;
	}
	public String getL_no() {
		return l_no;
	}
	public void setL_no(String l_no) {
		this.l_no = l_no;
	}
	public String getL_date() {
		return l_date;
	} 
	public void setL_date(String l_date) {
		this.l_date = l_date;
	}
	public String getL_sta() {
		return l_sta;
	}
	public void setL_sta(String l_sta) {
		this.l_sta = l_sta;
	}
	public String getL_type() {
		return l_type;
	}
	public void setL_type(String l_type) {
		this.l_type = l_type;
	}
	public String getL_send() {
		return l_send;
	}
	public void setL_send(String l_send) {
		this.l_send = l_send;
	}
	public String getL_recv() {
		return l_recv;
	}
	public void setL_recv(String l_recv) {
		this.l_recv = l_recv;
	}
	public String getL_writer() {
		return l_writer;
	}
	public void setL_writer(String l_writer) {
		this.l_writer = l_writer;
	}
	public String getL_status() {
		return l_status;
	}
	public void setL_status(String l_status) {
		this.l_status = l_status;
	}
	public String getL_reason() {
		return l_reason;
	}
	public void setL_reason(String l_reason) {
		this.l_reason = l_reason;
	}
	public String getL_tmp1() {
		return l_tmp1;
	}
	public void setL_tmp1(String l_tmp1) {
		this.l_tmp1 = l_tmp1;
	}
	public String getL_tmp2() {
		return l_tmp2;
	}
	public void setL_tmp2(String l_tmp2) {
		this.l_tmp2 = l_tmp2;
	}
	public String getL_tmp3() {
		return l_tmp3;
	}
	public void setL_tmp3(String l_tmp3) {
		this.l_tmp3 = l_tmp3;
	} 
}
