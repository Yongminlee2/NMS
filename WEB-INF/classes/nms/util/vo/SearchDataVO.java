package nms.util.vo;

public class SearchDataVO extends BaseVO {
	private String searchKeyword="";
	private String searchKeyword2="";
	private String searchType="";
	private String switchKey = "";
	private String startDate="";
	private String endDate="";
	
	
	public String getSwitchKey() {
		return switchKey;
	}
	public void setSwitchKey(String switchKey) {
		this.switchKey = switchKey;
	}
	public String getSearchKeyword2() {
		return searchKeyword2;
	}
	public void setSearchKeyword2(String searchKeyword2) {
		this.searchKeyword2 = searchKeyword2;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getSearchKeyword() {
		return searchKeyword;
	}
	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	
}
