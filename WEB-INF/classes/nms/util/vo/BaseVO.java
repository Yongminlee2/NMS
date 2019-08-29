package nms.util.vo;

import nms.util.DateSetting;

import com.google.gson.Gson;

/**
 * 페이징 및 기초 데이터 정보를 담는 VO 클래스
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
public class BaseVO {
	private int currentPage = 1;
	private int rowsPerPage = 10;
	private int startRow=1;
	private int totalPageCnt = 0;
	private int firstPage = 1;
	private int endPage = 5;
	private int sizeOfPage=5;
	private int totalLastPage = 0;
	private int totalCnt = 0;
	
	private String searchKeyword="";
	private String searchType="";
	
	private String stDate=DateSetting.getbeforeDate(30);
	private String enDate=DateSetting.getbeforeDate(0);
	

	public String getStDate() {
		return stDate;
	}

	public void setStDate(String stDate) {
		this.stDate = stDate;
	}

	public String getEnDate() {
		return enDate;
	}

	public void setEnDate(String enDate) {
		this.enDate = enDate;
	}

	public int getTotalCnt() {
		return totalCnt;
	}

	public void setTotalCnt(int totalCnt) {
		
		this.totalCnt = totalCnt;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getSizeOfPage() {
		return sizeOfPage;
	}

	public void setSizeOfPage(int sizeOfPage) {
		this.sizeOfPage = sizeOfPage;
	}

	public int getTotalLastPage() {
		return totalLastPage;
	}

	public void setTotalLastPage(int totalLastPage) {
		this.totalLastPage = totalLastPage;
	}

	public int getTotalPageCnt() {
		return totalPageCnt;
	}

	public void setTotalPageCnt(int totalPageCnt) {
		this.totalPageCnt = totalPageCnt;
	}

	public int getFirstPage() {
		
		return firstPage;
	}

	public int getCurrentPage() {
		return currentPage;
	}
	
	public void setCurrentPage(int currentPage) {
		float block = 1;
		int lastPage = (int)Math.ceil((float)totalCnt/(float)rowsPerPage);
//		System.out.println("total :"+totalCnt);
		if(currentPage % sizeOfPage == 0)
		{
			block = (float)currentPage / (float)sizeOfPage;
		}
		else
		{
			block = (float)currentPage / (float)sizeOfPage+1;
		}
//		System.out.println(block);
		
		int fPage = (int)(block-1)*sizeOfPage+1;
		this.endPage = (int)block * sizeOfPage;
		
//		System.out.println("first : "+fPage);
//		System.out.println("end : "+endPage);
		
		this.firstPage = fPage;
		if(endPage>lastPage)
		{
			endPage = lastPage;
		}
		this.totalLastPage = lastPage;
		
		this.currentPage = currentPage;
		this.setStartRow((currentPage-1)*10);
	}

	public int getRowsPerPage() {
		return rowsPerPage;
	}

	public void setRowsPerPage(int rowsPerPage) {
		this.rowsPerPage = rowsPerPage;
	}

	public int getStartRow() {
		int reValue = (currentPage-1)*rowsPerPage;
		return reValue;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
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

	public String toString()
	{
		return new Gson().toJson(this);
	}
}
