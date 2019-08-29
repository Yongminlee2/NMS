package nms.util.mapper;

import java.util.List;

import nms.util.vo.FileVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 파일 업로드를 처리하는 Mapper
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
@Repository(value = "fileMapper")
public interface FileMapper {
	/**
	 * 파일 업로드
	 * @param m_key
	 * @param f_path
	 * @param f_name
	 * @throws Exception
	 */
	public void insertFile(@Param("m_key")String m_key, @Param("f_path")String f_path, @Param("f_name")String f_name, @Param("f_realname")String f_realname) throws Exception;
	/**
	 * 파일 정보를 가져온다
	 * @param f_no
	 * @return
	 * @throws Exception
	 */
	public FileVO selectFileInfo(@Param("f_no")String f_no) throws Exception;
	/**
	 * 파일 목록을 가져온다.
	 * @param m_key
	 * @return
	 * @throws Exception
	 */
	public List<FileVO> selectFileInfoList(@Param("m_key")String m_key) throws Exception;
	/**
	 * 파일 정보를 삭제한다.
	 * @param f_no
	 * @return
	 * @throws Exception
	 */
	public int deleteFile(@Param("f_no")String f_no) throws Exception;
	
	/**
	 * 관측소 이미지 정보를 수정한다
	 * @param pic_name
	 * @param pic_path
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public int updateStationImg(@Param("picName")String pic_name,@Param("pic_path")String pic_path,@Param("no")String no)throws Exception;
	/**
	 * 센서 이미지 정보를 수정한다
	 * @param pic_name
	 * @param pic_path
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public int updateSensorImg(@Param("picName")String pic_name,@Param("pic_path")String pic_path,@Param("no")String no)throws Exception;
	/**
	 * 레코더 이미지 정보를 수정한다
	 * @param pic_name
	 * @param pic_path
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public int updateRecorderImg(@Param("picName")String pic_name,@Param("pic_path")String pic_path,@Param("no")String no)throws Exception;
}
