package nms.system.vo;

import java.util.List;

public class InitReportMainVO {
	private String rpt_no="";
	private String rpt_date="";
	private String net="";
	private String obs_id="";
	private String obs_name="";
	private String f_sen_id="";
	private String f_q1="";
	private String f_q2_1="";
	private String f_q2_2="";
	private String f_q3_1="";
	private String f_q3_2="";
	private String r_q9_1="";
	private String r_q9_2="";
	private String r_q9_3="";
	private String r_q9_4="";
	private String r_q9_5="";
	private String r_q9_6="";
	private String r_q9_7="";
	private String r_q10_1="";
	private String r_q10_2="";
	private String r_q10_3="";
	private String r_q10_4="";
	private String r_q11_1="";
	private String r_q11_2="";
	private String r_q11_3="";
	private String r_q11_4="";
	private String r_q12_1="";
	private String r_q12_2="";
	private String bigo="";
	private String result="";
	private String user_dept="";
	private String user_duty="";
	private String user_name="";
	private String user_tel="";
	
	/*report_b,c*/
	
	private List<InitReportSensorVO> sensors;
	private List<InitReportRecorderVO> recorders;
	private String l_status="";
	
	
	public String getL_status() {
		return l_status;
	}
	public void setL_status(String l_status) {
		this.l_status = l_status;
	}
	public List<InitReportSensorVO> getSensors() {
		return sensors;
	}
	public void setSensors(List<InitReportSensorVO> sensors) {
		this.sensors = sensors;
	}
	public List<InitReportRecorderVO> getRecorders() {
		return recorders;
	}
	public void setRecorders(List<InitReportRecorderVO> recorders) {
		this.recorders = recorders;
	}
	public String getRpt_no() {
		return rpt_no;
	}
	public void setRpt_no(String rpt_no) {
		this.rpt_no = rpt_no;
	}
	public String getRpt_date() {
		return rpt_date;
	}
	public void setRpt_date(String rpt_date) {
		this.rpt_date = rpt_date;
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
	public String getF_sen_id() {
		return f_sen_id;
	}
	public void setF_sen_id(String f_sen_id) {
		this.f_sen_id = f_sen_id;
	}
	public String getF_q1() {
		return f_q1;
	}
	public void setF_q1(String f_q1) {
		this.f_q1 = f_q1;
	}
	public String getF_q2_1() {
		return f_q2_1;
	}
	public void setF_q2_1(String f_q2_1) {
		this.f_q2_1 = f_q2_1;
	}
	public String getF_q2_2() {
		return f_q2_2;
	}
	public void setF_q2_2(String f_q2_2) {
		this.f_q2_2 = f_q2_2;
	}
	public String getF_q3_1() {
		return f_q3_1;
	}
	public void setF_q3_1(String f_q3_1) {
		this.f_q3_1 = f_q3_1;
	}
	public String getF_q3_2() {
		return f_q3_2;
	}
	public void setF_q3_2(String f_q3_2) {
		this.f_q3_2 = f_q3_2;
	}
	public String getR_q9_1() {
		return r_q9_1;
	}
	public void setR_q9_1(String r_q9_1) {
		this.r_q9_1 = r_q9_1;
	}
	public String getR_q9_2() {
		return r_q9_2;
	}
	public void setR_q9_2(String r_q9_2) {
		this.r_q9_2 = r_q9_2;
	}
	public String getR_q9_3() {
		return r_q9_3;
	}
	public void setR_q9_3(String r_q9_3) {
		this.r_q9_3 = r_q9_3;
	}
	public String getR_q9_4() {
		return r_q9_4;
	}
	public void setR_q9_4(String r_q9_4) {
		this.r_q9_4 = r_q9_4;
	}
	public String getR_q9_5() {
		return r_q9_5;
	}
	public void setR_q9_5(String r_q9_5) {
		this.r_q9_5 = r_q9_5;
	}
	public String getR_q9_6() {
		return r_q9_6;
	}
	public void setR_q9_6(String r_q9_6) {
		this.r_q9_6 = r_q9_6;
	}
	public String getR_q9_7() {
		return r_q9_7;
	}
	public void setR_q9_7(String r_q9_7) {
		this.r_q9_7 = r_q9_7;
	}
	public String getR_q10_1() {
		return r_q10_1;
	}
	public void setR_q10_1(String r_q10_1) {
		this.r_q10_1 = r_q10_1;
	}
	public String getR_q10_2() {
		return r_q10_2;
	}
	public void setR_q10_2(String r_q10_2) {
		this.r_q10_2 = r_q10_2;
	}
	public String getR_q10_3() {
		return r_q10_3;
	}
	public void setR_q10_3(String r_q10_3) {
		this.r_q10_3 = r_q10_3;
	}
	public String getR_q10_4() {
		return r_q10_4;
	}
	public void setR_q10_4(String r_q10_4) {
		this.r_q10_4 = r_q10_4;
	}
	public String getR_q11_1() {
		return r_q11_1;
	}
	public void setR_q11_1(String r_q11_1) {
		this.r_q11_1 = r_q11_1;
	}
	public String getR_q11_2() {
		return r_q11_2;
	}
	public void setR_q11_2(String r_q11_2) {
		this.r_q11_2 = r_q11_2;
	}
	public String getR_q11_3() {
		return r_q11_3;
	}
	public void setR_q11_3(String r_q11_3) {
		this.r_q11_3 = r_q11_3;
	}
	public String getR_q11_4() {
		return r_q11_4;
	}
	public void setR_q11_4(String r_q11_4) {
		this.r_q11_4 = r_q11_4;
	}
	public String getR_q12_1() {
		return r_q12_1;
	}
	public void setR_q12_1(String r_q12_1) {
		this.r_q12_1 = r_q12_1;
	}
	public String getR_q12_2() {
		return r_q12_2;
	}
	public void setR_q12_2(String r_q12_2) {
		this.r_q12_2 = r_q12_2;
	}
	public String getBigo() {
		return bigo;
	}
	public void setBigo(String bigo) {
		this.bigo = bigo;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getUser_dept() {
		return user_dept;
	}
	public void setUser_dept(String user_dept) {
		this.user_dept = user_dept;
	}
	public String getUser_duty() {
		return user_duty;
	}
	public void setUser_duty(String user_duty) {
		this.user_duty = user_duty;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getUser_tel() {
		return user_tel;
	}
	public void setUser_tel(String user_tel) {
		this.user_tel = user_tel;
	}
	
	
}
