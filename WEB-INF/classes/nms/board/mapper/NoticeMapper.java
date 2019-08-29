package nms.board.mapper;

import java.util.List;

import nms.board.vo.BoardVO;
import nms.util.vo.FileVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;


/**
 * 알림마당>공지사항에 대한 요청을 받아 처리하는 Mapper
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
@Repository(value = "noticeMapper")
public interface NoticeMapper {
	/**
	 * 공지사항 리스트
	 * @return
	 * @throws Exception
	 */
	public List<BoardVO> NoticeList(SearchDataVO search) throws Exception;
	/**
	 * 공지사항 리스트 총 숫자
	 * @return
	 * @throws Exception
	 */
	public int NoticeListTotalCnt(SearchDataVO search) throws Exception;
	/**
	 * 공지사항 게시글 확인
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public BoardVO getNoticeView(@Param("notice_no")String no) throws Exception;
	/**
	 * 파일 목록을 가져온다.
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public List<FileVO> getNoticeFileList(@Param("no")String no) throws Exception; 
	/**
	 * 공지사항 입력
	 * @param notice
	 * @throws Exception
	 */
	public void insertNotice(BoardVO notice) throws Exception;
	
	public int lastInsertNo() throws Exception;
	
	/**
	 * 공지사항 수정
	 * @param notice
	 * @throws Exception
	 */
	public int updateNotice(BoardVO notice) throws Exception;
	
	
	/**
	 * 공지사항 삭제
	 * @param notice
	 * @throws Exception
	 */
	public int deleteNotice(@Param("notice_no")String no) throws Exception;
}

