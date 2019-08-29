package nms.util.vo;

import java.util.Hashtable;
import java.util.List;

public class ResponseDataListVO
{
	private String resultCode;
	private String resultDesc;
	
	/** 데이터 객체 */
	private Object data;
	private Object data2;
	
	/** 전체 데이터 카운트 */
	private String totalDataCount;
	/** 데이터 칼럼 */
	private List<Hashtable<String, String>> columns;
	/** 행 속성 추가 */
	private List<Hashtable<String, String>> rowAttr;

	public String getResultCode() {
		return resultCode;
	}
	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}
	public void setResultCode(String resultCode, Object[] objs) {
		this.resultCode = resultCode;
		
		//setResultDesc(CmsMessage.getMessage(resultCode, objs));
	}
	public String getResultDesc() {
		return resultDesc;
	}
	public void setResultDesc(String resultDesc) {
		this.resultDesc = resultDesc;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
	public String getTotalDataCount() {
		return totalDataCount;
	}
	public void setTotalDataCount(String totalDataCount) {
		this.totalDataCount = totalDataCount;
	}
	public List<Hashtable<String, String>> getColumns() {
		return columns;
	}
	public void setColumns(List<Hashtable<String, String>> columns) {
		this.columns = columns;
	}
	public List<Hashtable<String, String>> getRowAttr() {
		return rowAttr;
	}
	public void setRowAttr(List<Hashtable<String, String>> rowAttr) {
		this.rowAttr = rowAttr;
	}
	public Object getData2() {
		return data2;
	}
	public void setData2(Object data2) {
		this.data2 = data2;
	}
}
