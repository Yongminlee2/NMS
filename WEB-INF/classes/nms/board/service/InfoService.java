package nms.board.service;

import java.util.List;

import javax.annotation.Resource;

import nms.board.mapper.InfoMapper;
import nms.board.vo.BoardVO;
import nms.util.vo.FileVO;
import nms.util.vo.SearchDataVO;

import org.springframework.stereotype.Repository;


/**
 * 알림마당>자료실 게시판에 대한 요청을 받아 처리하는 Service
 * @author 박병규
 * @since 2016.10.20
 * @version 1.0
 * @see
 * 
 * <pre>
 * << 개정이력(Modification Information) >>
 *   

 * </pre>
 */
@Repository(value = "infoService")
public class InfoService {
	@Resource(name = "infoMapper")
	private InfoMapper infoMapper;
	
	/**
	 * 공지사항 리스트
	 * @return
	 * @throws Exception
	 */
	public List<BoardVO> InfoList(SearchDataVO search) throws Exception
	{
		return infoMapper.InfoList(search);
	}
	/**
	 * 공지사항 리스트 총 숫자
	 * @return
	 * @throws Exception
	 */
	public int InfoListTotalCnt(SearchDataVO search) throws Exception
	{
		return infoMapper.InfoListTotalCnt(search);
	}
	
	/**
	 * 공지사항 게시글 확인
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public BoardVO getInfoView(String no) throws Exception
	{
		return infoMapper.getInfoView(no);
	}
	
	public List<FileVO> getNoticeFileList(String no) throws Exception
	{	
//		System.out.println(no);
		return infoMapper.getNoticeFileList(no);
	}
	/**
	 * 공지사항 입력
	 * @param info
	 * @throws Exception
	 */
	public int insertInfo(BoardVO info) throws Exception
	{
		infoMapper.insertInfo(info);
		return infoMapper.lastInsertNo();
	}
	
	/**
	 * 공지사항 수정
	 * @param info
	 * @throws Exception
	 */
	public int updateInfo(BoardVO info) throws Exception
	{
		return infoMapper.updateInfo(info);
	}
	
	
	/**
	 * 공지사항 삭제
	 * @param info
	 * @throws Exception
	 */
	public int deleteInfo(String no) throws Exception
	{
		return infoMapper.deleteInfo(no);
	}
}
