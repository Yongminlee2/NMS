package nms.system.service;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import nms.system.mapper.ReportMgmtMapper;
import nms.system.vo.InitReportMainVO;
import nms.system.vo.InitReportRecorderVO;
import nms.system.vo.InitReportSensorVO;
import nms.system.vo.MaintenanceReportVO;
import nms.system.vo.ReportMgmtVO;
import nms.util.vo.SearchDataVO;

/**
 * 보고서 정보를 가져오는 Service 클래스
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
@Repository(value = "reportMgmtService")
public class ReportMgmtService {
	
	@Resource(name = "reportMgmtMapper")
	private ReportMgmtMapper reportMgmtMapper;
	private Gson gson = new Gson();
	
	/**
	 * 보고서 리스트를 가져온다.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public List<ReportMgmtVO> getReportList(SearchDataVO search) throws Exception
	{
		return reportMgmtMapper.getReportList(search);
	}
	
	/**
	 * 보고서 리스트의 개수를 가져온다.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public int getReportListTotalCnt(SearchDataVO search) throws Exception
	{
		return reportMgmtMapper.getReportListTotalCnt(search);
	}
	/**
	 * 보고서를 업데이트한다.
	 * @param l_no
	 * @throws Exception
	 */
	public void updateSendTime(String l_no) throws Exception
	{
		reportMgmtMapper.updateSendTime(l_no);
	}
	/**
	 * 정기점검 보고서를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public MaintenanceReportVO getMaintenanceReport(String l_no) throws Exception
	{
		return reportMgmtMapper.getMaintenanceReport(l_no);
	}
	
	/**
	 * 초기점검 보고서 A를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public InitReportMainVO getReport_a(String l_no) throws Exception
	{
		return reportMgmtMapper.getReport_a(l_no);
	}
	/**
	 * 초기점검 보고서 B를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public List<InitReportSensorVO> getReport_b(String l_no) throws Exception
	{
		return reportMgmtMapper.getReport_b(l_no);
	}
	/**
	 * 초기점검 보고서 C를 가져온다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	public List<InitReportRecorderVO> getReport_c(String l_no) throws Exception
	{
		return reportMgmtMapper.getReport_c(l_no);
	}
	
	/**
	 * 보고서를 입력한다.
	 * @param l_type
	 * @param user_id
	 * @param sta_no
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertReport(String l_type,String user_id,String sta_no) throws Exception
	{
		return reportMgmtMapper.insertReport(l_type, user_id, sta_no);
	}
	
	/**
	 * 정기점검 보고서를 업데이트한다.
	 * @param mtVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateMaintenance(MaintenanceReportVO mtVO) throws Exception
	{	
		reportMgmtMapper.updateReportDate(mtVO.getRpt_rno(),mtVO.getRpt_date());
		return reportMgmtMapper.updateMaintenance(mtVO);
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public boolean updateInit(InitReportMainVO itVO) throws Exception
	{	
		List<InitReportSensorVO> sensors = itVO.getSensors();
		List<InitReportRecorderVO> recorders = itVO.getRecorders();
		try {
			reportMgmtMapper.updateInitReport_A(itVO);
			reportMgmtMapper.updateReportDate(itVO.getRpt_no(),itVO.getRpt_date());
			for(InitReportSensorVO s : sensors)
			{
				s.setRpt_no(itVO.getRpt_no());
				s.setObs_id(itVO.getObs_id());
				s.setNet(itVO.getNet());
				s.setS_sen_id(itVO.getNet()+"_"+itVO.getObs_id()+"_"+s.getS_cnt());
				if(s.getType().equals("insert")){
					reportMgmtMapper.insertInitReport_B(s);
				}else if(s.getType().equals("update")){
					reportMgmtMapper.updateInitReport_B(s);
				}else if(s.getType().equals("delete")){
					reportMgmtMapper.deleteInitReport_B(s.getRpt_sno());
				}
			}
			
			for(InitReportRecorderVO r : recorders)
			{
				r.setRpt_no(itVO.getRpt_no());
				r.setObs_id(itVO.getObs_id());
				r.setNet(itVO.getNet());
				r.setR_sen_id(itVO.getNet()+"_"+itVO.getObs_id()+"_R0"+r.getR_cnt());
				if(r.getType().equals("insert")){
					reportMgmtMapper.insertInitReport_C(r);
				}else if(r.getType().equals("update")){
					reportMgmtMapper.updateInitReport_C(r);
				}else if(r.getType().equals("delete")){
					reportMgmtMapper.deleteInitReport_C(r.getRpt_rno());
				}
			}
				
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			return false;
		}
		return true;
	}
	/**
	 * 보고서를 업데이트 또는 삭제한다.
	 * @param l_type
	 * @param act
	 * @param l_no
	 * @throws Exception
	 */
	public void deleteNUpdateReport(String l_type,String act,String l_no) throws Exception
	{
		reportMgmtMapper.deleteNUpdateReport(l_type, act, l_no);
	}
}
