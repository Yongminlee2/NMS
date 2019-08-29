package nms.system.service;

import java.util.List;

import javax.annotation.Resource;

import nms.system.mapper.LogMapper;
import nms.system.vo.LogVO;
import nms.util.vo.SearchDataVO;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 로그 정보를 가져오는 Service 클래스
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
@Repository(value = "logService")
public class LogService {
	@Resource(name = "logMapper")
	private LogMapper logMapper;
	
	/**
	 * 로그 목록을 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<LogVO> getLogList(SearchDataVO searchVO) throws Exception
	{	
		List<LogVO> logList = logMapper.getLogList(searchVO);
		if(logList.size()>0){
			logList.get(0).setTotalCnt(logMapper.getLogListTotalCnt(searchVO));
		}
		return logList;
	}
	/**
	 * 로그 아이디 목록을 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<LogVO> getLogIdList(SearchDataVO searchVO) throws Exception
	{	
		List<LogVO> logIdList = logMapper.getLogIdList(searchVO);
		if(logIdList.size()>0){
			logIdList.get(0).setTotalCnt(logMapper.getLogIdListTotalCnt());
//			System.out.println(logMapper.getLogIdListTotalCnt());
		}
		return logIdList;
	}
	/**
	 * 로그 타입 목록을 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<LogVO> getLogTypeList(SearchDataVO searchVO) throws Exception
	{	
		List<LogVO> logTypeList = logMapper.getLogTypeList(searchVO);
		if(logTypeList.size()>0){
			logTypeList.get(0).setTotalCnt(logMapper.getLogTypeListTotalCnt());
		}
		return logTypeList;
	}
	/**
	 * 로그 아이디를 입력 또는 수정한다.
	 * @param log
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public void insertNUpdateLogId(List<LogVO> log) throws Exception
	{
		for(LogVO lv : log)
		{
			if(lv.getL_tmp3().equals("new")){
				logMapper.insertLogId(lv);
			}else{
				logMapper.updateLogId(lv);
			}
		}
	}
	/**
	 * 로그 타입을 입력 또는 수정한다.
	 * @param log
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public void insertNUpdateLogType(List<LogVO> log) throws Exception
	{
		for(LogVO lv : log)
		{
			if(lv.getL_tmp3().equals("new")){
				logMapper.insertLogType(lv);
			}else{
				logMapper.updateLogType(lv);
			}
		}
	}
	/**
	 * 로그 아이디를 삭제한다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteLogId(String l_no) throws Exception
	{
		return logMapper.deleteLogId(l_no);
	}
	/**
	 * 로그 타입을 삭제한다.
	 * @param l_no
	 * @return
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteLogType(String l_no) throws Exception
	{
		return logMapper.deleteLogType(l_no);
	}
}
