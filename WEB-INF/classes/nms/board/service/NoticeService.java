package nms.board.service;

import java.util.List;

import javax.annotation.Resource;

import nms.board.mapper.NoticeMapper;
import nms.board.vo.BoardVO;
import nms.util.vo.FileVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


/**
 * 알림마당>공지사항에 대한 요청을 받아 처리하는 Service
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
@Repository(value = "noticeService")
public class NoticeService {
	@Resource(name = "noticeMapper")
	private NoticeMapper noticeMapper;
	
	/**
	 * 공지사항 리스트
	 * @return
	 * @throws Exception
	 */
	public List<BoardVO> NoticeList(SearchDataVO search) throws Exception
	{
		return noticeMapper.NoticeList(search);
	}
	/**
	 * 공지사항 리스트 총 숫자
	 * @return
	 * @throws Exception
	 */
	public int NoticeListTotalCnt(SearchDataVO search) throws Exception
	{
		return noticeMapper.NoticeListTotalCnt(search);
	}
	
	/**
	 * 공지사항 게시글 확인
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public BoardVO getNoticeView(String no) throws Exception
	{
		return noticeMapper.getNoticeView(no);
	}
	
	/**
	 * 파일 목록을 가져온다.
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public List<FileVO> getNoticeFileList(String no) throws Exception
	{	
//		System.out.println(no);
		return noticeMapper.getNoticeFileList(no);
	}
	
	/**
	 * 공지사항 입력
	 * @param notice
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertNotice(BoardVO notice) throws Exception
	{	
		try {
			noticeMapper.insertNotice(notice);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
		}
		return noticeMapper.lastInsertNo();
	}
	
	/**
	 * 공지사항 수정
	 * @param notice
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateNotice(BoardVO notice) throws Exception
	{
		return noticeMapper.updateNotice(notice);
	}
	
	
	/**
	 * 공지사항 삭제
	 * @param notice
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteNotice(String no) throws Exception
	{
		return noticeMapper.deleteNotice(no);
	}
}
