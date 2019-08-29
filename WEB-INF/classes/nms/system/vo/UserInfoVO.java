package nms.system.vo;

import nms.util.vo.BaseVO;

public class UserInfoVO  extends BaseVO{
	private String id="";
	private String pw="";
	private String pw2="";
	private String name="";
	private String name2="";
	private String org="";
	private String org2="";
	private String department="";
	private String duty="";
	private String tel="";
	private String tel2="";
	private String email="";
	private String auth="";
	private String update="";
	private String start="";
	private String last="";
	private String tmp1="";
	private String tmp2="";
	private String tmp3="";
	private String type="";

	
	
	public String getName2() {
		return name2;
	}
	public void setName2(String name2) {
		this.name2 = name2;
	}
	public String getTel2() {
		return tel2;
	}
	public void setTel2(String tel2) {
		this.tel2 = tel2;
	}
	public String getOrg2() {
		return org2;
	}
	public void setOrg2(String org2) {
		this.org2 = org2;
	}
	public String getPw2() {
		return pw2;
	}
	public void setPw2(String pw2) {
		this.pw2 = pw2;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getOrg() {
		return org;
	}
	public void setOrg(String org) {
		this.org = org;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getDuty() {
		return duty;
	}
	public void setDuty(String duty) {
		this.duty = duty;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAuth() {
		return auth;
	}
	public void setAuth(String auth) {
		this.auth = auth;
	}
	public String getUpdate() {
		return update.replace(".0","");
	}
	public void setUpdate(String update) {
		this.update = update;
	}
	public String getStart() {
		return start.replace(".0","");
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getLast() {
		return last.replace(".0","");
	}
	public void setLast(String last) {
		this.last = last;
	}
	public String getTmp1() {
		return tmp1;
	}
	public void setTmp1(String tmp1) {
		this.tmp1 = tmp1;
	}
	public String getTmp2() {
		return tmp2;
	}
	public void setTmp2(String tmp2) {
		this.tmp2 = tmp2;
	}
	public String getTmp3() {
		return tmp3;
	}
	public void setTmp3(String tmp3) {
		this.tmp3 = tmp3;
	}
	
	
}
