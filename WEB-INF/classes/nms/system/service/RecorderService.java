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

import nms.system.mapper.RecorderMapper;
import nms.system.vo.RecorderVO;
import nms.util.vo.SearchDataVO;

/**
 * �덉퐫���뺣낫瑜�媛�졇�ㅻ뒗 Service �대옒��
 * @author Administrator
 * @since 2016. 11. 16.
 * @version 
 * @see
 * 
 * <pre>
 * << �섏젙�대젰(Modification Information) >>
 *   
 *  �좎쭨		 		      �묒꽦��					   鍮꾧퀬
 *  --------------   ---------    ---------------------------
 *  2016. 11. 16.      諛뺥깭吏�                   		   	 理쒖큹
 *
 * </pre>
 */
@Repository(value = "recorderService")
public class RecorderService {
	@Resource(name = "recorderMapper")
	private RecorderMapper recorderMapper;
	private Gson gson = new Gson();
	/**
	 * �덉퐫���뺣낫瑜�媛�졇�⑤떎.
	 * @return
	 * @throws Exception
	 */
	public List<RecorderVO> getRecorderList(String sta_no) throws Exception
	{
		return recorderMapper.getRecorderList(sta_no);
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public String insertRecorder(String jsonStr) throws Exception
	{
		List<RecorderVO> recVO = new ArrayList<RecorderVO>(Arrays.asList(gson.fromJson(jsonStr, RecorderVO[].class)));
		for(RecorderVO rec : recVO)
		{
			if(rec.getDataStatus().equals("mody"))
			{
				System.out.println("------------------------------------------------�섏젙��---------------------------------------------------");
				recorderMapper.updateRecorder(rec);
			}else if(rec.getDataStatus().equals("add"))
			{
				System.out.println("------------------------------------------------�낅젰��---------------------------------------------------");
				recorderMapper.insertRecorder(rec);
			}
		}

//		System.out.println(recVO.get(0).getObs_id());
		return "ok";
	}
	public String nowDate(){
		SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
		Date currentTime = new Date ();
		String mTime = mSimpleDateFormat.format ( currentTime );
		return mTime;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public String insertReportRecorder(String jsonStr) throws Exception
	{
		List<RecorderVO> recVO = new ArrayList<RecorderVO>(Arrays.asList(gson.fromJson(jsonStr, RecorderVO[].class)));
		for(RecorderVO rec : recVO)
		{
			if(rec.getDataStatus().equals("mody"))
			{
				System.out.println("------------------------------------------------�섏젙��---------------------------------------------------");
				recorderMapper.insertMaintenanceRecorder(rec.getRec_no(), "수정", nowDate());
				recorderMapper.updateReportRecorder(rec);
			}else if(rec.getDataStatus().equals("add"))
			{
				System.out.println("------------------------------------------------�낅젰��---------------------------------------------------");
				recorderMapper.insertReportRecorder(rec);
			}
		}

//		System.out.println(recVO.get(0).getObs_id());
		return "ok";
	}
	/**
	 * 湲곕줉怨��먭����낅젰�쒕떎.
	 * @param no
	 * @param msg
	 * @throws Exception
	 */
	public void insertMaintenanceRecorder(String no, String msg,String date) throws Exception
	{
		recorderMapper.insertMaintenanceRecorder(no, msg, date);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteRecorder (String rec_no, String path) throws Exception
	{
		System.out.println("�쒕━�");
//		System.out.println(rec_no);
		RecorderVO recorderImages = recorderMapper.getRecorderImages(rec_no);
		String uploadPath = path;
		File f = new File(uploadPath+File.separator+recorderImages.getRec_pic1());
		File f2 = new File(uploadPath+File.separator+recorderImages.getRec_pic2());
		File f3 = new File(uploadPath+File.separator+recorderImages.getRec_pic3());
		File f4 = new File(uploadPath+File.separator+recorderImages.getRec_pic4());
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
		return recorderMapper.deleteRecorder(rec_no);
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteReportRecorder (String rec_no) throws Exception
	{
		return recorderMapper.deleteReportRecorder(rec_no);
	}
	/**
	 * �덉퐫���뺣낫瑜�媛�졇�⑤떎.
	 * @return
	 * @throws Exception
	 */
	public List<RecorderVO> getRecorderMngList(String l_no) throws Exception
	{
		return recorderMapper.getRecorderMngList(l_no);
	}
	/**
	 * 湲곕줉怨��덉뒪�좊━ �뺣낫瑜�媛�졇�⑤떎.
	 * @param search
	 * @return
	 * @throws Exception
	 */
	public RecorderVO getRecorderHistoryInfo(SearchDataVO search) throws Exception
	{
		return recorderMapper.getRecorderHistoryInfo(search);
	}
	/**
	 * �덉퐫���대�吏�� 媛�졇�⑤떎.
	 * @param no
	 * @return
	 * @throws Exception
	 */
	public RecorderVO getRecorderImages(String no) throws Exception
	{	
		System.out.println(no);
		RecorderVO recorderImages = recorderMapper.getRecorderImages(no);
		System.out.println(recorderImages.getRec_pic1());
		return recorderMapper.getRecorderImages(no);
	}
	
	/**
	 * 기록계 점검 정보를 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<RecorderVO> getRecorderMaintenanceList(String rec_no) throws Exception
	{
		return recorderMapper.getRecorderMaintenanceList(rec_no);
	}
}
