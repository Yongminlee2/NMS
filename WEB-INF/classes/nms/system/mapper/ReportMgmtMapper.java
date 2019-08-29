package nms.system.mapper;

import java.util.List;

import nms.system.vo.InitReportMainVO;
import nms.system.vo.InitReportRecorderVO;
import nms.system.vo.InitReportSensorVO;
import nms.system.vo.MaintenanceReportVO;
import nms.system.vo.ReportMgmtVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 보고서 정보를 가져오는 Mapper 인터페이스
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
@Repository(value = "reportMgmtMapper")
public interface ReportMgmtMapper {

	/**
	 * 보고서 리스트를 가져온다.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public List<ReportMgmtVO> getReportList(SearchDataVO search) throws Exception;
	
	/**
	 * 보고서 리스트의 개수를 가져온다.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public int getReportListTotalCnt(SearchDataVO search) throws Exception;
	
	/**
	 * 정기점검 보고서를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public MaintenanceReportVO getMaintenanceReport(@Param("l_no")String l_no) throws Exception;
	/**
	 * 초기점검 보고서 A를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public InitReportMainVO getReport_a(@Param("l_no")String l_no) throws Exception;
	/**
	 * 초기점검 보고서 B를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public List<InitReportSensorVO> getReport_b(@Param("l_no")String l_no) throws Exception;
	
	/**
	 * 보고서를 업데이트한다.
	 * @param l_no
	 * @throws Exception
	 */
	public void updateSendTime(@Param("l_no")String l_no) throws Exception;
	/**
	 * 보고서를 점검 일자를 업데이트한다.
	 * @param l_no
	 * @throws Exception
	 */
	public void updateReportDate(@Param("rpt_no")String rpt_no,@Param("date")String date) throws Exception;
	/**
	 * 초기점검 보고서 C를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public List<InitReportRecorderVO> getReport_c(@Param("l_no")String l_no) throws Exception;	
	
	/**
	 * 보고서를 입력한다.
	 * @param l_type
	 * @param user_id
	 * @param sta_no
	 * @throws Exception
	 */
	public int insertReport(@Param("l_type")String l_type,@Param("user_id")String user_id,@Param("sta_no")String sta_no) throws Exception;
	
	/**
	 * 정기점검 보고서를 업데이트한다.
	 * @param mtVO
	 * @return
	 * @throws Exception
	 */
	public int updateMaintenance(MaintenanceReportVO mtVO) throws Exception;
	
	/**
	 * 초기점검 보고서 a를 업데이트한다.
	 * @param itVO
	 * @throws Exception
	 */
	public void updateInitReport_A(InitReportMainVO itVO) throws Exception;
	
	/**
	 * 초기점검 보고서 b를 입력한다.
	 * @param senVO
	 * @throws Exception
	 */
	public void insertInitReport_B(InitReportSensorVO senVO) throws Exception;
	/**
	 * 초기점검 보고서 b를 업데이트 한다.
	 * @param senVO
	 * @return
	 * @throws Exception
	 */
	public int updateInitReport_B(InitReportSensorVO senVO) throws Exception;
	/**
	 * 초기점검 보고서 b를 삭제한다.
	 * @param rpt_sno
	 * @return
	 * @throws Exception
	 */
	public int deleteInitReport_B(@Param("rpt_sno")String rpt_sno) throws Exception;
	/**
	 * 초기점검 보고서 c를 입력한다.
	 * @param recVO
	 * @throws Exception
	 */
	public void insertInitReport_C(InitReportRecorderVO recVO) throws Exception;
	
	/**
	 * 초기점검 보고서 c를 업데이트한다. 
	 * @param recVO
	 * @return
	 * @throws Exception
	 */
	public int updateInitReport_C(InitReportRecorderVO recVO) throws Exception;
	
	/**
	 * 초기점검 보고서 c를 삭제한다.
	 * @param rpt_rno
	 * @return
	 * @throws Exception
	 */
	public int deleteInitReport_C(@Param("rpt_rno")String rpt_rno) throws Exception;
	
	/**
	 * 보고서를 업데이트 또는 삭제한다.
	 * @param l_type
	 * @param act
	 * @param l_no
	 * @throws Exception
	 */
	public void deleteNUpdateReport(@Param("l_type")String l_type,@Param("act")String act,@Param("l_no")String l_no) throws Exception;
	
	
}
