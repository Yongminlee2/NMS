package nms.board.vo;

import org.springframework.web.multipart.MultipartFile;

import nms.util.vo.BaseVO;

public class BoardVO  extends BaseVO{
	private String board_type="";
	private String no="";
	private String board_dt="";
	private String user_id="";
	private String user_nm="";
	private String board_title="";
	private String board_content="";
	private String views ="";
	private String file1="";
	
	/*�낅줈�*/
	private MultipartFile uploadFile;
	private MultipartFile uploadFile2;
	private MultipartFile uploadFile3;
	
	
	
	public MultipartFile getUploadFile() {
		return uploadFile;
	}
	public void setUploadFile(MultipartFile uploadFile) {
		this.uploadFile = uploadFile;
	}
	public MultipartFile getUploadFile2() {
		return uploadFile2;
	}
	public void setUploadFile2(MultipartFile uploadFile2) {
		this.uploadFile2 = uploadFile2;
	}
	public MultipartFile getUploadFile3() {
		return uploadFile3;
	}
	public void setUploadFile3(MultipartFile uploadFile3) {
		this.uploadFile3 = uploadFile3;
	}
	public String getBoard_type() {
		return board_type;
	}
	public void setBoard_type(String board_type) {
		this.board_type = board_type;
	}
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}

	public String getBoard_dt() {
		return board_dt;
	}
	public void setBoard_dt(String board_dt) {
		this.board_dt = board_dt.replace(".0", "");
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_nm() {
		return user_nm;
	}
	public void setUser_nm(String user_nm) {
		this.user_nm = user_nm;
	}
	public String getBoard_title() {
		return board_title;
	}
	public void setBoard_title(String board_title) {
		this.board_title = board_title;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public String getViews() {
		return views;
	}
	public void setViews(String views) {
		this.views = views;
	}
	public String getFile1() {
		return file1;
	}
	public void setFile1(String file1) {
		this.file1 = file1;
	}
	
	
}
