package nms.system.controller;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nms.system.service.ObservatoryService;
import nms.system.service.RecorderService;
import nms.system.service.SensorService;
import nms.system.vo.ObservatoryVO;
import nms.system.vo.RecorderVO;
import nms.system.vo.SensorVO;
import nms.util.DateSetting;
import nms.util.ExcelFnc;
import nms.util.controller.UtilController;
import nms.util.service.FileService;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * 관측소에 대한 정보를 입력/수정/삭제/조회하는 역할을 처리하는 Controller 클래스
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
@Controller
@RequestMapping(value = "/system/observatory")
public class ObservatoryController {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	private static String idx = "";
	private static String type = "";
	@Resource(name = "observatoryService")
	private ObservatoryService observatoryService;
	
	@Resource(name = "sensorService")
	private SensorService sensorService;
	
	@Resource(name = "recorderService")
	private RecorderService recorderService;	
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	/**
	 * 관측소 리스트 페이지를 호출한다.
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join Observatory List!");
		SearchDataVO search = new SearchDataVO();
		
		int page = 0;
		if(request.getParameter("page")==null)
		{
			page = 1;
		}
		else
		{
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		
		
		search.setCurrentPage(page);
		search.setSearchKeyword("");
		String req = request.getParameter("obs_kind");
		if(req == null){
			req = "";
		}
		search.setSearchKeyword2(req);
		
		List<ObservatoryVO> stationInfoList = observatoryService.getStationInfoList(search);
		
		int totalCnt = observatoryService.getStationInfoListTotalCnt(search);
		System.out.println(totalCnt);
		if(totalCnt>0){
			stationInfoList.get(0).setTotalCnt(totalCnt);
			stationInfoList.get(0).setCurrentPage(page);
			stationInfoList.get(0).setSearchKeyword(request.getParameter("obs_kind"));
			model.addAttribute("pagingInfo",stationInfoList.get(0));
		}else{
			model.addAttribute("pagingInfo",new ObservatoryVO());
		}
		
		model.addAttribute("stationList", stationInfoList);
		model.addAttribute("stations",UtilController.CODE_MAP.get("obs_kind"));
		model.addAttribute("totalCnt",totalCnt);
		return "/system/observatory/list";
	}
	/**
	 * 관측소 리스트 페이지를 호출한다.
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/history")
	public String historyList(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join Observatory List!");
		
		logger.info("Join Observatory List!");
		SearchDataVO search = new SearchDataVO();
		
		int page = 0;
		if(request.getParameter("page")==null)
		{
			page = 1;
		}
		else
		{
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		search.setCurrentPage(page);
		search.setSearchKeyword("");
		
		if(request.getParameter("startDate")==null)
		{
			search.setStartDate(DateSetting.getbeforeDate(30));
			search.setEndDate(DateSetting.getbeforeDate(0));
			
		}else{
			search.setStartDate(request.getParameter("startDate"));
			search.setEndDate(request.getParameter("endDate"));
		}
		
		List<ObservatoryVO> stationHistoryList = observatoryService.getStationHistoryList(search);
		int totalCnt = observatoryService.getStationHistoryInfoListTotalCnt(search);
		
		if(totalCnt>0){	
			stationHistoryList.get(0).setTotalCnt(totalCnt);
			stationHistoryList.get(0).setCurrentPage(page);
			stationHistoryList.get(0).setStDate(search.getStartDate());
			stationHistoryList.get(0).setEnDate(search.getEndDate());
			model.addAttribute("pagingInfo",stationHistoryList.get(0));
		}else{
			model.addAttribute("pagingInfo",new ObservatoryVO());
		}
		model.addAttribute("stationHistoryList", stationHistoryList);
		model.addAttribute("totalCnt",totalCnt);
		
		return "/system/observatory/history";
	}	
	/**
	 * 관측소 상세 팝업을 호출한다.
	 * @param model
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup")
	public String popup(Model model,@ModelAttribute("sta_no")String sta_no,@ModelAttribute("history")String history) throws Exception{
		
//		System.out.println("sta_no : "+sta_no);
		if(sta_no.equals("new"))
		{
			model.addAttribute("status","new");
		}else{
			SearchDataVO search = new SearchDataVO();
			search.setSearchKeyword(sta_no);
			
			ObservatoryVO observatoryVO = observatoryService.getStationInfoList(search).get(0);
			String sno = observatoryVO.getSta_no();
			List<SensorVO> sensorList = sensorService.getSensorList(sno);
			List<RecorderVO> recorderList = recorderService.getRecorderList(sno);
			List<ObservatoryVO> stationHistoryList;
			
//			if(history.equals("y")){
//				stationHistoryList = observatoryService.getStationHistoryList(sta_no);
//			}else{
//				stationHistoryList = observatoryService.getStationHistoryList(obs_id);
//				
//			}
			
			model.addAttribute("status","mody");
			
			model.addAttribute("stationInfo",observatoryVO);
//			model.addAttribute("stationHistory",stationHistoryList);
			model.addAttribute("sta_pic1",observatoryVO.getSta_pic1());
			model.addAttribute("sta_pic2",observatoryVO.getSta_pic2());
			model.addAttribute("sta_pic3",observatoryVO.getSta_pic3());
			model.addAttribute("sta_pic4",observatoryVO.getSta_pic4());
			
			model.addAttribute("senCnt", sensorList.size());
			model.addAttribute("sensorList",sensorList);
			model.addAttribute("recCnt", recorderList.size());
			model.addAttribute("recorderList",recorderList);
			
			model.addAttribute("historySwitch", history);
		}
		return "/system/observatory/popup/observatoryPopup";
	}
	/**
	 * 관측소 상세 팝업을 호출한다.
	 * @param model
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/history/popup")
	public String historyPopup(Model model,@ModelAttribute("sh_no")String sh_no,@ModelAttribute("type")String type) throws Exception{
		
//		System.out.println("sta_no : "+sta_no);
		SearchDataVO search = new SearchDataVO();
		search.setSearchKeyword(sh_no);
		Object observatoryVO = null;
		Object historyListVO = null;
		
		System.out.println(type);
		System.out.println(sh_no);
		if(type.equals("sta")){
			observatoryVO = observatoryService.getStationHistoryInfo(search);
			ObservatoryVO ob = (ObservatoryVO)observatoryVO;
			historyListVO = observatoryService.getStationMaintenanceList(ob.getSta_no());
		}else if(type.equals("sen")){
			observatoryVO = sensorService.getSensorHistoryInfo(search);
			SensorVO sen = (SensorVO)observatoryVO;
			historyListVO = sensorService.getSensorMaintenanceList(sen.getSen_no());
			
		}else{
			observatoryVO = recorderService.getRecorderHistoryInfo(search);
			RecorderVO rec = (RecorderVO)observatoryVO;
			historyListVO = recorderService.getRecorderMaintenanceList(rec.getRec_no());
			
		}
		
		model.addAttribute("status","mody");
		model.addAttribute("type",type);
		model.addAttribute("historyInfo",observatoryVO);
		model.addAttribute("historyList",historyListVO);
			
		return "/system/observatory/popup/observatoryHistoryPopup";
	}	
	@RequestMapping(value = "/recorderInsert.ws")
	public @ResponseBody ResponseDataListVO insertRecorder(@RequestBody String jsonStr, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		System.out.println(jsonStr);
		recorderService.insertRecorder(jsonStr);
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc("success");
		return responseVO;
	}
	@RequestMapping(value = "/setValue.ws")
	public @ResponseBody ResponseDataListVO setValue(@RequestBody String Str, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		System.out.println("Setting Value");
		String[] split = Str.split("&");
		idx = split[0];
		type = split[1];
		responseVO.setResultDesc(type);
		return responseVO;
	}
	@RequestMapping(value = "/getImages.ws")
	public @ResponseBody ResponseDataListVO getImages(@RequestBody String Str, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String[] split = Str.split("&");
		System.out.println(split[1]);
		if(split[1].equals("sen")){
			responseVO.setData(sensorService.getSensorImages(split[0]));
		}else{
			responseVO.setData(recorderService.getRecorderImages(split[0]));
		}
		responseVO.setResultDesc(split[1]);
		
		return responseVO;
	}	
	@RequestMapping(value = "/recorderDelete.ws")
	public @ResponseBody ResponseDataListVO deleteRecorder(@RequestBody String rec_no, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		ResponseDataListVO responseVO = new ResponseDataListVO();
		try {
			int dR = recorderService.deleteRecorder(rec_no,request.getSession().getServletContext().getRealPath(File.separator+"images"+File.separator+"observatory"+File.separator));
			if(dR>0){
				responseVO.setResultDesc("success");
			}else{
				responseVO.setResultDesc("e");
			}
		} catch (Exception e) {
			responseVO.setResultDesc("fail");
		}
		
//		responseVO.setResultDesc("success");
		return responseVO;
	}	
	
	@RequestMapping(value = "/sensorInsert.ws")
	public @ResponseBody ResponseDataListVO insertSensor(@RequestBody String jsonStr, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		System.out.println(jsonStr);
		sensorService.insertSensor(jsonStr);
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc("success");
		return responseVO;
	}	
	
	@RequestMapping(value = "/sensorDelete.ws")
	public @ResponseBody ResponseDataListVO deleteSensor(@RequestBody String sen_no, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		int deleteSensor = sensorService.deleteSensor(sen_no,request.getSession().getServletContext().getRealPath(File.separator+"images"+File.separator+"observatory"+File.separator));
		ResponseDataListVO responseVO = new ResponseDataListVO();
		
//		responseVO.setResultDesc("success");
		return responseVO;
	}	
	
	@RequestMapping(value = "/insert.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO insertObseratory(@RequestBody ObservatoryVO obVO, HttpServletRequest request) throws Exception
	{
		String returnVal = "success";
		try {
			idx = ""+observatoryService.insertStation(obVO);
			type = "sta";
		} catch (Exception e) {
			// TODO: handle exception
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		
		return responseVO;
	}
	@RequestMapping(value = "/fileUpload.ws", method = RequestMethod.POST)
	public @ResponseBody String uploadFile(MultipartHttpServletRequest request) throws Exception
	{
		System.out.println("업로드!!!!");
		fileService.imgFileUpload(request,type,idx);
		String returnValue = "success";
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
			returnValue = "fail";
		}
		return returnValue;
	}
	public String nowDate(){
		SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
		Date currentTime = new Date ();
		String mTime = mSimpleDateFormat.format ( currentTime );
		return mTime;
	}
	@RequestMapping(value = "/update.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO updateObseratory(@RequestBody ObservatoryVO obVO, HttpServletRequest request) throws Exception
	{	
		
		String returnVal = "success";
		try {
			idx = obVO.getSta_no();
			observatoryService.insertStationMaintenance(idx, "수정",nowDate());
			observatoryService.updateStation(obVO);
			type = "sta";
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		
		return responseVO;
	}
	
	@RequestMapping(value = "/insertMaintenance.ws")
	public @ResponseBody ResponseDataListVO insertMaintenance(@RequestBody String str, HttpServletRequest request) throws Exception{
		String[] strs = str.split("&");
		String returnVal = "success";
		try {
			if(strs[0].equals("sta")){
				observatoryService.insertStationMaintenance(strs[1], strs[2], strs[3]);
			}else if(strs[0].equals("sen")){
				sensorService.insertMaintenanceSensor(strs[1], strs[2], strs[3]);
			}else{
				recorderService.insertMaintenanceRecorder(strs[1], strs[2], strs[3]);
			}
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		return responseVO;
	}
	
	@RequestMapping(value = "/getStationExcel.do", method = RequestMethod.POST)
	public void getStationExcel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		ExcelFnc excel = new ExcelFnc();
		SearchDataVO search = new SearchDataVO();
		search.setSearchKeyword(request.getParameter("sta_no"));
		String excelName = "";
		String downName = "";
		
		String type = request.getParameter("type");// 타입 구분 = station or histroy
		ObservatoryVO observatoryVO = null;
		List<SensorVO> sensorList = null;
		List<RecorderVO> recorderList = null;
		if(type.equals("station")){
			observatoryVO = observatoryService.getStationInfoList(search).get(0);
			String sno = observatoryVO.getSta_no();
			
			sensorList = sensorService.getSensorList(sno);
			recorderList = recorderService.getRecorderList(sno);
		}
		excelName = (type.equals("station")?"station_info":"station_history");
		downName = (type.equals("station")?"관측소":"점검내역");
		
		/*엑셀파일 셀렉트*/
		String folder = request.getSession().getServletContext().getRealPath("/excel");
		String fileName = folder+File.separator+excelName+".xls";
		
		
		
		excel.copyExcel(fileName, folder+File.separator+downName+"_report.xls");
		
		File excelFile = new File(folder+File.separator+downName+"_report.xls");
		HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
		HSSFSheet sheetAt = wb.getSheetAt(0);
		HSSFSheet sheetAt2 = wb.getSheetAt(1);
		HSSFSheet sheetAt3 = wb.getSheetAt(2);
		
		if(type.equals("station")){
			byte[] img1 = Base64.decodeBase64(request.getParameter("imgData").replaceAll("data:image/png;base64,", ""));
			byte[] img2 = Base64.decodeBase64(request.getParameter("imgData2").replaceAll("data:image/png;base64,", ""));
			byte[] img3 = Base64.decodeBase64(request.getParameter("imgData3").replaceAll("data:image/png;base64,", ""));
			
			excel.setImage(wb, sheetAt, 1, 7, 17, 23, img1);
			excel.setImage(wb, sheetAt2, 1, 11, 13, 18, img2);
			excel.setImage(wb, sheetAt3, 1, 22, 13, 18, img3);
		
		
			/* 관측소 정보  */
			excel.insertSheetDataNCopyStyle(sheetAt, 3,  2, observatoryVO.getObs_id());		 excel.insertSheetDataNCopyStyle(sheetAt, 3,  4, observatoryVO.getObs_name());      excel.insertSheetDataNCopyStyle(sheetAt, 3,  6, observatoryVO.getNet()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 4,  2, observatoryVO.getSta_tmp1());        excel.insertSheetDataNCopyStyle(sheetAt, 4,  4, observatoryVO.getAddress());      
			excel.insertSheetDataNCopyStyle(sheetAt, 5,  2, observatoryVO.getContractdate());        excel.insertSheetDataNCopyStyle(sheetAt, 5,  4, observatoryVO.getCompletedate());      excel.insertSheetDataNCopyStyle(sheetAt, 5,  6, observatoryVO.getPrice_contract()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 6,  2, observatoryVO.getPrice_sw());        excel.insertSheetDataNCopyStyle(sheetAt, 6,  4, observatoryVO.getPrice_hw());      excel.insertSheetDataNCopyStyle(sheetAt, 6,  6, observatoryVO.getArea()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 7,  2, observatoryVO.getOpendate());        excel.insertSheetDataNCopyStyle(sheetAt, 7,  4, observatoryVO.getOffdate());      excel.insertSheetDataNCopyStyle(sheetAt, 7,  6, observatoryVO.getObs_kind()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 8,  2, observatoryVO.getPosition());        excel.insertSheetDataNCopyStyle(sheetAt, 8,  4, observatoryVO.getGround_ht());      excel.insertSheetDataNCopyStyle(sheetAt, 8,  6, observatoryVO.getUground_ht()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 9,  2, observatoryVO.getLon());        excel.insertSheetDataNCopyStyle(sheetAt,9,  4, observatoryVO.getLat());      excel.insertSheetDataNCopyStyle(sheetAt, 9,  6, observatoryVO.getAltitude()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 10,  2, observatoryVO.getBase());       excel.insertSheetDataNCopyStyle(sheetAt,10,  4, observatoryVO.getStr_cd());      excel.insertSheetDataNCopyStyle(sheetAt, 10,  6, observatoryVO.getSeis_cd()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 11, 2,  observatoryVO.getGround());       excel.insertSheetDataNCopyStyle(sheetAt, 11, 4, observatoryVO.getHole());      excel.insertSheetDataNCopyStyle(sheetAt, 11, 6, observatoryVO.getSeis_ds()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 12, 2,  observatoryVO.getDesign_acc());       excel.insertSheetDataNCopyStyle(sheetAt, 12, 4, observatoryVO.getThreshold_acc());      excel.insertSheetDataNCopyStyle(sheetAt, 12, 6, observatoryVO.getBuild_floor()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 13, 2,  observatoryVO.getSeis_ds());       excel.insertSheetDataNCopyStyle(sheetAt, 13, 4, observatoryVO.getHole_map());      excel.insertSheetDataNCopyStyle(sheetAt, 13, 6, observatoryVO.getCharge()); 
			excel.insertSheetDataNCopyStyle(sheetAt, 14, 2,  observatoryVO.getContact());       excel.insertSheetDataNCopyStyle(sheetAt, 14, 4, observatoryVO.getUser_id());      excel.insertSheetDataNCopyStyle(sheetAt, 14, 6, observatoryVO.getRegdate());
			excel.insertSheetDataNCopyStyle(sheetAt, 15, 2,  observatoryVO.getSta_type());       excel.insertSheetDataNCopyStyle(sheetAt, 15, 4, observatoryVO.getSta_ip());
			
			/* 기록계 정보  */
			int rec_row = 4;
			int rec_col = 1;
			for(RecorderVO r : recorderList)
			{
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getNet());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getObs_id());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getRec_id());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getRec_company());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getRec_model());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getRec_serial());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getWarrenty());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getWformat());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getProtocol());
				excel.insertSheetDataNCopyStyle(sheetAt2, rec_row,  rec_col++, r.getRegdate());
				
				rec_row++;
				rec_col = 1;
			}
			/* 센서 정보  */
			int sen_row = 4;
			int sen_col = 1;
			for(SensorVO s : sensorList)
			{
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getNet());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getObs_id());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_id());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_location());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_company());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_model());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_serial());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_kind());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_gubun());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_position());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_channel());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_lon());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_lat());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_z_resp());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_n_resp());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_e_resp());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_z_sens());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_n_sens());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_e_sens());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getSen_rec_id());
				excel.insertSheetDataNCopyStyle(sheetAt3, sen_row,  sen_col++, s.getRegdate());
				sen_row++;
				sen_col = 1;
			}	
		
		}else{
			SearchDataVO search2 = new SearchDataVO();
			search2.setSearchKeyword(request.getParameter("sta_no"));
			if(type.equals("sta")){
				ObservatoryVO ob = observatoryService.getStationHistoryInfo(search2);
				List<ObservatoryVO> historyList = observatoryService.getStationMaintenanceList(ob.getSta_no());
			/* 관측소 정보  */
				excel.insertSheetDataNCopyStyle(sheetAt, 3,  2, ob.getObs_id());		 excel.insertSheetDataNCopyStyle(sheetAt, 3,  4, ob.getObs_name());      excel.insertSheetDataNCopyStyle(sheetAt, 3,  6, ob.getNet()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 4,  2, ob.getSta_tmp1());        excel.insertSheetDataNCopyStyle(sheetAt, 4,  4, ob.getAddress());      
				excel.insertSheetDataNCopyStyle(sheetAt, 5,  2, ob.getContractdate());        excel.insertSheetDataNCopyStyle(sheetAt, 5,  4, ob.getCompletedate());      excel.insertSheetDataNCopyStyle(sheetAt, 5,  6, ob.getPrice_contract()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 6,  2, ob.getPrice_sw());        excel.insertSheetDataNCopyStyle(sheetAt, 6,  4, ob.getPrice_hw());      excel.insertSheetDataNCopyStyle(sheetAt, 6,  6, ob.getArea()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 7,  2, ob.getOpendate());        excel.insertSheetDataNCopyStyle(sheetAt, 7,  4, ob.getOffdate());      excel.insertSheetDataNCopyStyle(sheetAt, 7,  6, ob.getObs_kind()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 8,  2, ob.getPosition());        excel.insertSheetDataNCopyStyle(sheetAt, 8,  4, ob.getGround_ht());      excel.insertSheetDataNCopyStyle(sheetAt, 8,  6, ob.getUground_ht()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 9,  2, ob.getLon());        excel.insertSheetDataNCopyStyle(sheetAt,9,  4, ob.getLat());      excel.insertSheetDataNCopyStyle(sheetAt, 9,  6, ob.getAltitude()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 10,  2, ob.getBase());       excel.insertSheetDataNCopyStyle(sheetAt,10,  4, ob.getStr_cd());      excel.insertSheetDataNCopyStyle(sheetAt, 10,  6, ob.getSeis_cd()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 11, 2,  ob.getGround());       excel.insertSheetDataNCopyStyle(sheetAt, 11, 4, ob.getHole());      excel.insertSheetDataNCopyStyle(sheetAt, 11, 6, ob.getSeis_ds()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 12, 2,  ob.getDesign_acc());       excel.insertSheetDataNCopyStyle(sheetAt, 12, 4, ob.getThreshold_acc());      excel.insertSheetDataNCopyStyle(sheetAt, 12, 6, ob.getBuild_floor()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 13, 2,  ob.getSeis_ds());       excel.insertSheetDataNCopyStyle(sheetAt, 13, 4, ob.getHole_map());      excel.insertSheetDataNCopyStyle(sheetAt, 13, 6, ob.getCharge()); 
				excel.insertSheetDataNCopyStyle(sheetAt, 14, 2,  ob.getContact());       excel.insertSheetDataNCopyStyle(sheetAt, 14, 4, ob.getUser_id());      excel.insertSheetDataNCopyStyle(sheetAt, 14, 6, ob.getRegdate());
				excel.insertSheetDataNCopyStyle(sheetAt, 15, 2,  ob.getSta_type());       excel.insertSheetDataNCopyStyle(sheetAt, 15, 4, ob.getSta_ip());
				
				int h_row = 18;
				int h_col = 1;
				for(ObservatoryVO h : historyList)
				{
					excel.insertSheetDataNCopyStyle(sheetAt, h_row,  h_col++, h.getSta_tmp3());
					excel.insertSheetDataNCopyStyle(sheetAt, h_row,  h_col, h.getSta_tmp2());
					h_row++;
					h_col = 1;
				}
				wb.removeSheetAt(2);
				wb.removeSheetAt(1);
			}else if(type.equals("rec")){
				RecorderVO r = recorderService.getRecorderHistoryInfo(search2);
//				RecorderVO r = (RecorderVO)obVO;
				List<RecorderVO> historyList = recorderService.getRecorderMaintenanceList(r.getRec_no());
				
				excel.insertSheetDataNCopyStyle(sheetAt2, 3,  2, r.getNet());		 excel.insertSheetDataNCopyStyle(sheetAt2, 3,  4, r.getObs_id());      excel.insertSheetDataNCopyStyle(sheetAt2, 3,  6,r.getRec_id()); 
				excel.insertSheetDataNCopyStyle(sheetAt2, 4,  2, r.getRec_company());        excel.insertSheetDataNCopyStyle(sheetAt2, 4,  4, r.getRec_model());      excel.insertSheetDataNCopyStyle(sheetAt2, 4,  6, r.getRec_serial());
				excel.insertSheetDataNCopyStyle(sheetAt2, 5,  2, r.getWarrenty());        excel.insertSheetDataNCopyStyle(sheetAt2, 5,  4, r.getWformat());      excel.insertSheetDataNCopyStyle(sheetAt2, 5,  6, r.getProtocol()); 
				excel.insertSheetDataNCopyStyle(sheetAt2, 6,  2, r.getRegdate());   
				
				int h_row = 18;
				int h_col = 1;
				for(RecorderVO h : historyList)
				{
					excel.insertSheetDataNCopyStyle(sheetAt2, h_row,  h_col++, h.getRec_tmp3());
					excel.insertSheetDataNCopyStyle(sheetAt2, h_row,  h_col, h.getRec_tmp2());
					h_row++;
					h_col = 1;
				}
				wb.removeSheetAt(2);
				wb.removeSheetAt(0);
									
			}else if(type.equals("sen")){
				SensorVO s =  sensorService.getSensorHistoryInfo(search2);
//				SensorVO s = (SensorVO)obVO;
				List<SensorVO> historyList = sensorService.getSensorMaintenanceList(s.getSen_no());
				
				excel.insertSheetDataNCopyStyle(sheetAt3, 3,  2, s.getNet());		 excel.insertSheetDataNCopyStyle(sheetAt3, 3,  4, s.getObs_id());      excel.insertSheetDataNCopyStyle(sheetAt3, 3,  6, s.getSen_id()); 
				excel.insertSheetDataNCopyStyle(sheetAt3, 4,  2, s.getSen_location());        excel.insertSheetDataNCopyStyle(sheetAt3, 4,  4, s.getSen_company());     excel.insertSheetDataNCopyStyle(sheetAt3, 4,  6, s.getSen_model()); 
				excel.insertSheetDataNCopyStyle(sheetAt3, 5,  2, s.getSen_serial());        excel.insertSheetDataNCopyStyle(sheetAt3, 5,  4, s.getSen_kind());      excel.insertSheetDataNCopyStyle(sheetAt3, 5,  6, s.getSen_gubun()); 
				excel.insertSheetDataNCopyStyle(sheetAt3, 6,  2, s.getSen_position());        excel.insertSheetDataNCopyStyle(sheetAt3, 6,  4, s.getSen_channel());      excel.insertSheetDataNCopyStyle(sheetAt3, 6,  6, s.getSen_lon()+"/"+s.getSen_lat()); 
				excel.insertSheetDataNCopyStyle(sheetAt3, 7,  2, s.getSen_z_resp());        excel.insertSheetDataNCopyStyle(sheetAt3, 7,  4, s.getSen_n_resp());      excel.insertSheetDataNCopyStyle(sheetAt3, 7,  6, s.getSen_e_resp()); 
				excel.insertSheetDataNCopyStyle(sheetAt3, 8,  2, s.getSen_z_sens());        excel.insertSheetDataNCopyStyle(sheetAt3, 8,  4, s.getSen_n_sens());      excel.insertSheetDataNCopyStyle(sheetAt3, 8,  6, s.getSen_e_sens()); 
				excel.insertSheetDataNCopyStyle(sheetAt3, 9,  2, s.getSen_rec_id());        excel.insertSheetDataNCopyStyle(sheetAt3,9,  4, s.getRegdate());
				
				int h_row = 18;
				int h_col = 1;
				for(SensorVO h : historyList)
				{
					excel.insertSheetDataNCopyStyle(sheetAt3, h_row,  h_col++, h.getSen_tmp3());
					excel.insertSheetDataNCopyStyle(sheetAt3, h_row,  h_col, h.getSen_tmp2());
					h_row++;
					h_col = 1;
				}
				wb.removeSheetAt(1);
				wb.removeSheetAt(0);
			}
			
			
		}
		
		FileOutputStream fileOut = new FileOutputStream(excelFile);
        wb.write(fileOut);
        fileOut.close();
		
//		System.out.println(folder+File.separator+imgName1+".jpg");
		long saveTime = System.currentTimeMillis();
		long currTime = 0;
		while( currTime - saveTime < 200){
		    currTime = System.currentTimeMillis();
		}
		response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename="+URLEncoder.encode(downName,"UTF-8")+"_report.xls");
        IOUtils.copy(new ByteArrayInputStream(Files.readAllBytes(Paths.get(folder+File.separator+downName+"_report.xls"))), response.getOutputStream());
        response.flushBuffer();
      
        excelFile.delete();

		
	}	
}
