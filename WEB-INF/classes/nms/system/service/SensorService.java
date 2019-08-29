package nms.system.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import nms.system.mapper.SensorMapper;
import nms.system.vo.ObservatoryVO;
import nms.system.vo.RecorderVO;
import nms.system.vo.SensorVO;
import nms.util.vo.SearchDataVO;

/**
 * 센서 정보를 가져오는 Service 클래스
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
@Repository(value = "sensorService")
public class SensorService {
	@Resource(name = "sensorMapper")
	private SensorMapper sensorMapper;
	
	private Gson gson = new Gson();
	/**
	 * 센서 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<SensorVO> getSensorList(String sta_no) throws Exception
	{
		return sensorMapper.getSensorList(sta_no);
	}
	
	public String nowDate(){
		SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
		Date currentTime = new Date ();
		String mTime = mSimpleDateFormat.format ( currentTime );
		return mTime;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public String insertSensor(String jsonStr) throws Exception
	{
		List<SensorVO> senVO = new ArrayList<SensorVO>(Arrays.asList(gson.fromJson(jsonStr, SensorVO[].class)));
		for(SensorVO sen : senVO)
		{
			if(sen.getDataStatus().equals("mody"))
			{
				System.out.println("------------------------------------------------수정함----------------------------------------------------");
				sensorMapper.insertMaintenanceSensor(sen.getSen_id(), "수정", "");
				sensorMapper.updateSensor(sen);
			}else if(sen.getDataStatus().equals("add"))
			{
				System.out.println("------------------------------------------------입력함----------------------------------------------------");
				sensorMapper.insertSensor(sen);
				System.out.println(sen.getSen_location());
				if(!sen.getSen_location().equals("H")){
					ObservatoryVO staType = sensorMapper.getStaType(sen.getSta_no());
					String sta_tmp1 = staType.getSta_tmp1();
					String tableName = "";
					
					if(sta_tmp1.equals("NC")){
						tableName = "seis_nf";
					}else if(sta_tmp1.equals("CJ")){
						tableName = "seis_cj";
					}else if(sta_tmp1.equals("WP")){
						tableName = "seis_hp";
					}else if(sta_tmp1.equals("PP")){
						tableName = "seis_ps";
					}
					String name = staType.getSta_type()+"_"+sen.getSen_location().toLowerCase();
					sensorMapper.insertSensorData(tableName, name, (sen.getSen_location().equals("G")?"0.020025":"0"));
					System.out.println("value :::::::::::::::::::::::::::::::::::::::::::::::::: seis_"+name+"_wave");
					//기존 테이블 확인
					sensorMapper.createTableSensorWave("seis_"+name+"_wave");
					sensorMapper.createTriggerSensorWave("tri_"+name, "seis_"+name+"_wave", name);
				}
			}
		}

//		System.out.println(recVO.get(0).getObs_id());
		return "a";
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public String insertReportSensor(String jsonStr) throws Exception
	{
		List<SensorVO> senVO = new ArrayList<SensorVO>(Arrays.asList(gson.fromJson(jsonStr, SensorVO[].class)));
		for(SensorVO sen : senVO)
		{
			if(sen.getDataStatus().equals("mody"))
			{
				System.out.println("------------------------------------------------수정함----------------------------------------------------");
				sensorMapper.updateReportSensor(sen);
			}else if(sen.getDataStatus().equals("add"))
			{
				System.out.println("------------------------------------------------입력함----------------------------------------------------");
				sensorMapper.insertReportSensor(sen);
			}
		}

//		System.out.println(recVO.get(0).getObs_id());
		return "a";
	}
	/**
	 * 점검 이력을 입력한다.
	 * @param no
	 * @param msg
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public void insertMaintenanceSensor(String no, String msg, String date) throws Exception
	{
		sensorMapper.insertMaintenanceSensor(no, msg, date);
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteSensor(String sen_no, String path) throws Exception
	{	
		SensorVO sensorImages = sensorMapper.getSensorImages(sen_no);
		String uploadPath =path;
		File f = new File(uploadPath+File.separator+sensorImages.getSen_pic1());
		File f2 = new File(uploadPath+File.separator+sensorImages.getSen_pic2());
		File f3 = new File(uploadPath+File.separator+sensorImages.getSen_pic3());
		File f4 = new File(uploadPath+File.separator+sensorImages.getSen_pic4());
		if(f.isFile()){
			f.delete();
		}
		if(f2.isFile()){
			f2.delete();
		}
		if(f3.isFile()){
			f3.delete();
		}
		if(f4.isFile()){
			f4.delete();
		}
		return sensorMapper.deleteSensor(sen_no);
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteReportSensor(String sen_no) throws Exception
	{	
		return sensorMapper.deleteReportSensor(sen_no);
	}
	/**
	 * 센서 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<SensorVO> getSensorMngList(String l_no) throws Exception
	{
		return sensorMapper.getSensorMngList(l_no);
	}
	
	/**
	 * 센서 이미지를 가져온다.
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public SensorVO getSensorImages(String no) throws Exception
	{
		return sensorMapper.getSensorImages(no);
	}
	
	/**
	 * 센서 히스토리 정보를 가져온다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public SensorVO getSensorHistoryInfo(SearchDataVO searchVO) throws Exception
	{
		return sensorMapper.getSensorHistoryInfo(searchVO);
	}
	/**
	 * 센서 점검 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<SensorVO> getSensorMaintenanceList(String sen_no) throws Exception
	{
		return sensorMapper.getSensorMaintenanceList(sen_no);
	}
}
