package nms.sec.vo;

import java.io.Serializable;


public class UserVO implements Serializable{
	private static final long serialVersionUID = 1L;
	
	/** 사용자 ID **/
	private String userId;
	/** 사용자명 **/
	private String userName;
	/** 소속회사 */
	private String company;
	/** 권한 **/
	private String authority;
	/** 허가 **/
	private String accept = "";
	
	
	
	public String getAccept() {
		return accept;
	}
	public void setAccept(String accept) {
		this.accept = accept;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
		
}
