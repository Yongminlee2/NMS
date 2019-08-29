package nms.quakeoccur.controller;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nms.inforeceived.vo.DataCollRateListVO;
import nms.quakeoccur.service.QuakeInfoService;
import nms.quakeoccur.vo.MailVO;
import nms.quakeoccur.vo.QuakeEventListVO;
import nms.quakeoccur.vo.QuakeEventReportVO;
import nms.quakeoccur.vo.SelfEventListVO;
import nms.quakeoccur.vo.WaveDataMainVO;
import nms.util.ExcelFnc;
import nms.util.Execute;
import nms.util.Execute.ExecResult;
import nms.util.ShellCmdReading;
import nms.util.controller.UtilController;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.StationVO;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.ibatis.annotations.Param;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFCreationHelper;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import edu.emory.mathcs.backport.java.util.Collections;

@Controller
@RequestMapping("/quakeoccur/quakeinfo")
public class QuakeInfoContorller {
	private static final Logger logger = LoggerFactory.getLogger(QuakeInfoContorller.class);
	@Autowired
	QuakeInfoService quakeInfoService;
	
	@RequestMapping("/list")
	public String quakeInfoListView(ModelMap model) throws Exception
	{	
		
		List<StationVO> list = (List<StationVO>) UtilController.STATION_MAP.get("stationNames");
		List<StationVO> new_list = new ArrayList<>();
		String sTmp = "";
		for(StationVO o : list)
		{
			StationVO n = new StationVO();
			if(!sTmp.equals(o.getSta_tmp1())){
				sTmp = o.getSta_tmp1();
				n.setSta_tmp3(o.getSta_tmp3());
			}else{
				n.setSta_tmp3("sub");
			}
			n.setObs_id(o.getObs_id());
			n.setObs_name(o.getObs_name());
			n.setObs_kind(o.getSta_tmp1());
			n.setSta_tmp1(getChangeWord(o.getSta_tmp1()));
			new_list.add(n);
		}
		
		model.addAttribute("stationInfo",new_list);
		return "/quakeoccur/quakeinfo";
	}
	/**
	 * 자체 이벤트 보고서
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/popup/report")
	public String quakeInfoReport(ModelMap model, @Param("summary")String summary,@Param("no")String no,@Param("type")String type) throws Exception
	{	
		String replaceWord = getReplaceWord(type);
		SelfEventListVO eventReportData = quakeInfoService.getSelfReportData(replaceWord, no);
//		List<QuakeEventReportVO> selfReportDataAll = quakeInfoService.getSelfReportDataAll(replaceWord, type);
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeReportDataAll(replaceWord, type);
		
		String epochTime = eventReportData.getEpoch_time();
//		String delayTime = eventReportData.getDelay_time();
		String delayTime = "120";
		String fullDate = eventReportData.getFull_date();
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];
		
		//실서버 업로드시 해제
		
		
		for(QuakeEventReportVO s : quakeReportDataAll)
		{	
			try {
				String net = s.getNet();
//			ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_"+s.getSen_id()+"_20170622.mma",0);
//				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+s.getSen_id()+"_"+year+month+day+".mma",0);
				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+s.getSen_id(),0);
				List<String> lines = result.getLines();
				s = ShellCmdReading.shellCmd(lines,s);
				if(s.getObs_name().equals(eventReportData.getOrg())){
					eventReportData.setZ(s.getMax_g());
				}
			} catch (Exception e) {
				// TODO: handle exception
				System.out.println(e.toString());
			}
		}
		
		
		Map<String, String> maxValueNStep = maxValueNStep(eventReportData.getZ(),eventReportData.getN(),eventReportData.getE());
//		eventReportData.setZ(maxValueNStep.get("maxValue"));
		eventReportData.setN(maxValueNStep.get("step"));
		//파형 도식 관련 테스트 순서 ->
		/**
		 * 1. 데이터 획득 실행시 json데이터를 가져오는 형태(line 나눠지는지 아닌지)
		 * 2. Gson을 통해 vo에 데이터를 넣을 수 있는지.
		 * 3. 데이터 적용
		 */
		String date = eventReportData.getTimestamp().replaceAll(":", "").replaceAll("-","").replaceAll(" ", "");
		model.addAttribute("mainData",eventReportData);
		model.addAttribute("dataList",quakeReportDataAll);
		model.addAttribute("org_type",type);
		model.addAttribute("viewTap",summary);
		
		model.addAttribute("org_type",type);
		model.addAttribute("req_date",date.substring(0,date.length()-2));
		model.addAttribute("req_id",date.substring(0,date.length()-2));
		model.addAttribute("viewTap",summary);
		
		return "/quakeoccur/popup/quakeReport";
		
	}
	
	public Map<String,String> maxValueNStep(String z, String n, String e) throws Exception
	{
		Map<String, String> rMap = new HashMap<String, String>();
		float max = 0;  
        BigDecimal bd = null;
		if(Float.parseFloat(z) > max){
			max = Float.parseFloat(z);
		}
		if(Float.parseFloat(n) > max){
			max = Float.parseFloat(n);
		}
		if(Float.parseFloat(e) > max){
			max = Float.parseFloat(e);
		}		
		bd = new BigDecimal(max);
		rMap.put("maxValue", ""+bd.setScale(7,BigDecimal.ROUND_DOWN));
		
		String step = "";
		if(max > 0.2){
			step = "3단계";
		}else if(max > 0.01){
			step = "2단계";
		}else{
			step = "1단계";
		}
		rMap.put("step", step);
		return rMap;
	}
	
	@RequestMapping(value = "/getManualExcel.do", method = RequestMethod.POST)
	public void getManualExcel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		ExcelFnc excel = new ExcelFnc();
		String folder = request.getSession().getServletContext().getRealPath("/excel");
		String fileName = folder+File.separator+"manualReport.xls";
		excel.copyExcel(fileName, folder+File.separator+request.getParameter("men_info")+".xls");
		
		File excelFile = new File(folder+File.separator+request.getParameter("men_info")+".xls");
		HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
		HSSFSheet sheetAt = wb.getSheetAt(0);
		HSSFSheet sheetAt2 = wb.getSheetAt(1);
		HSSFSheet sheetAt3 = wb.getSheetAt(2);
		
		if(request.getParameter("summary").equals("n")){
			byte[] img1 = Base64.decodeBase64(request.getParameter("imgData").replaceAll("data:image/png;base64,", ""));
			byte[] img2 = Base64.decodeBase64(request.getParameter("imgData2").replaceAll("data:image/png;base64,", ""));
			excel.setImage(wb, sheetAt2, 2, 13, 4, 100, img1);
			excel.setImage(wb, sheetAt3, 2, 13, 4, 45, img2);
		}
		String replaceWord = getReplaceWord(request.getParameter("type"));
		System.out.println(replaceWord+","+ request.getParameter("no"));
		SelfEventListVO eventReportData = quakeInfoService.getSelfReportData(replaceWord, request.getParameter("no"));
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeReportDataAll(replaceWord, request.getParameter("type"));
		
		
		HSSFCellStyle cellStyle = null;
		HSSFCell valueCell = null;
		if(request.getParameter("summary").equals("n")){
			cellStyle = sheetAt2.getRow(1).getCell(11).getCellStyle();
			valueCell = sheetAt2.getRow(1).createCell(11);
			valueCell.setCellValue("보고자 : "+request.getParameter("men_info"));
			valueCell.setCellStyle(cellStyle);
		}
		cellStyle = sheetAt.getRow(1).getCell(7).getCellStyle();
		valueCell = sheetAt.getRow(1).createCell(7);
		valueCell.setCellValue("보고자 : "+request.getParameter("men_info"));
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(8).getCell(4).getCellStyle();
		valueCell = sheetAt.getRow(8).createCell(4);
		valueCell.setCellValue(eventReportData.getTmp2());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(5).getCell(2).getCellStyle();
		valueCell = sheetAt.getRow(5).createCell(2);
		valueCell.setCellValue(eventReportData.getTimestamp());
		valueCell.setCellStyle(cellStyle);

		cellStyle = sheetAt.getRow(5).getCell(4).getCellStyle();
		valueCell = sheetAt.getRow(5).createCell(4);
		valueCell.setCellValue(eventReportData.getOrg());
		valueCell.setCellStyle(cellStyle);
		
		Map<String, String> maxValueNStep = maxValueNStep(eventReportData.getZ(),eventReportData.getN(),eventReportData.getE());
		cellStyle = sheetAt.getRow(5).getCell(6).getCellStyle();
		valueCell = sheetAt.getRow(5).createCell(6);
		valueCell.setCellValue(maxValueNStep.get("maxValue"));
		valueCell.setCellStyle(cellStyle);

		cellStyle = sheetAt.getRow(5).getCell(7).getCellStyle();
		valueCell = sheetAt.getRow(5).createCell(7);
		valueCell.setCellValue(maxValueNStep.get("step"));
		valueCell.setCellStyle(cellStyle);
		
		String epochTime = eventReportData.getEpoch_time();
//		String delayTime = eventReportData.getDelay_time();
		String delayTime = "120";
		String fullDate = eventReportData.getFull_date();
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];
		
		//실서버 업로드시 해제
		
		int row = 8;
		int col = 0;
		for(QuakeEventReportVO s : quakeReportDataAll)
		{	
			row++;
			col = 2;
			try {
				String net = s.getNet();
//			ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_"+s.getSen_id()+"_20170622.mma",0);
//				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+s.getSen_id()+"_"+year+month+day+".mma",0);
				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+s.getSen_id(),0);
				List<String> lines = result.getLines();
				s = ShellCmdReading.shellCmd(lines,s);
				
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(s.getObs_name());
				valueCell.setCellStyle(cellStyle);
				
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(s.getMax_time());
				valueCell.setCellStyle(cellStyle);
				
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(s.getMax_g());
				valueCell.setCellStyle(cellStyle);
				
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(s.getMax_z());
				valueCell.setCellStyle(cellStyle);
				
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(s.getMax_n());
				valueCell.setCellStyle(cellStyle);
			
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(s.getMax_e());
				valueCell.setCellStyle(cellStyle);
			} catch (Exception e) {
				// TODO: handle exception
				System.out.println(e.toString());
			}
		}
		
		
		//파형 도식 관련 테스트 순서 ->
		
		
		FileOutputStream fileOut = new FileOutputStream(excelFile);
        wb.write(fileOut);
        fileOut.close();
		
//		System.out.println(folder+File.separator+imgName1+".jpg");
		long saveTime = System.currentTimeMillis();
		long currTime = 0;
		while( currTime - saveTime < 500){
		    currTime = System.currentTimeMillis();
		}
		System.out.println(request.getParameter("men_info"));
		response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename="+URLEncoder.encode(request.getParameter("men_info"),"UTF-8")+".xls");
        IOUtils.copy(new ByteArrayInputStream(Files.readAllBytes(Paths.get(folder+File.separator+request.getParameter("men_info")+".xls"))), response.getOutputStream());
        response.flushBuffer();
      
        excelFile.delete();
		
	}	
	
	/**
	 * 지진이벤트 보고서
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/popup/reportWave")
	public String quakeWaveReport(ModelMap model, @Param("summary")String summary,@Param("no")String no,@Param("type")String type) throws Exception
	{	
		String replaceWord = getReplaceWord(type);
		QuakeEventReportVO quakeReportData = quakeInfoService.getQuakeReportData(no);
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeReportDataAll(replaceWord, type);
		List<QuakeEventReportVO> quakeReportHistoryData = quakeInfoService.getQuakeReportHistoryData("10",quakeReportData.getDate(),quakeReportData.getTime());
		double lat = quakeReportData.getLat();
		double lon = quakeReportData.getLon();
		
		String epochTime = quakeReportData.getEpoch_time();
//		String delayTime = quakeReportData.getDelay_time();
		String delayTime = "120";
		String fullDate = quakeReportData.getFull_date();
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];
		File imgCheck = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no+".jpg");
		try{
			if(!imgCheck.isFile()){
				ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no,1);
			}
		}catch(Exception e){
			
		}
		for(QuakeEventReportVO q : quakeReportDataAll)
		{
			double lat2 = q.getLat();
			double lon2 = q.getLon();
			q.setKmeter(""+distance(lat2, lon2, lat, lon));
			//실서버 업로드시 제거
			String net = q.getNet();
//			ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_"+q.getSen_id()+"_20170622.mma",0);
			try {
				System.out.println(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id());
//				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma",0);
				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id(),0);
				List<String> lines = result.getLines();
				q = ShellCmdReading.shellCmd(lines,q);
				int req = Integer.parseInt(quakeReportData.getReq_id());
				if(req >= 2017260 && req <= 2017285 && type.equals("NC")){
					BigDecimal bd;
					bd = new BigDecimal(Float.parseFloat(q.getMax_z())/9.81);
					q.setMax_z(((""+bd).length()>9?(""+bd).substring(0,9):(""+bd)));
					bd = new BigDecimal(Float.parseFloat(q.getMax_n())/9.81);
					q.setMax_n(((""+bd).length()>9?(""+bd).substring(0,9):(""+bd)));
					bd = new BigDecimal(Float.parseFloat(q.getMax_e())/9.81);
					q.setMax_e(((""+bd).length()>9?(""+bd).substring(0,9):(""+bd)));
				}
			} catch (Exception e) {
				// TODO: handle exception
				logger.debug("wave Popup error  : "+e.toString());
			}
			
//			System.out.println(shellCmd);
		}
		
		
		quakeReportData.setKmeter(""+distance(35.49, 129.15, lat, lon));
		String date = quakeReportData.getReq_date().replaceAll(":", "").replaceAll("-","").replaceAll(" ", "");
		model.addAttribute("dataList",quakeReportDataAll);
		model.addAttribute("mainData",quakeReportData);
		model.addAttribute("historyList",quakeReportHistoryData);
		model.addAttribute("org_type",type);
		model.addAttribute("req_date",date.substring(0,date.length()-2));
		model.addAttribute("req_id",quakeReportData.getReq_id());
		model.addAttribute("viewTap",summary);
		
		
		return "/quakeoccur/popup/quakeWaveReport";
	}	
	/*
	 * 지진 요약 엑셀 다운로드
	 * */
	//지진엑셀
	@RequestMapping(value = "/getQuakeExcel.do", method = RequestMethod.POST)
	public void getQuakeExcel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		ExcelFnc excel = new ExcelFnc();
		String folder = request.getSession().getServletContext().getRealPath("/excel");
		String fileName = folder+File.separator+"quakeReport.xls";
		excel.copyExcel(fileName, folder+File.separator+request.getParameter("men_info")+".xls");
		
		File excelFile = new File(folder+File.separator+request.getParameter("men_info")+".xls");
		HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
		
		String type = request.getParameter("type");
		File curveImg = new File(File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+request.getParameter("no")+File.separator+type+File.separator+"imgTT"+File.separator+type+"_distance_time_graph.png");
		byte[] img8 = null;
		byte[] img3 = null;
		byte[] img4 = null;
		byte[] img5 = null;
		byte[] img6 = null;
		
		if(curveImg.isFile()){
			img8 = FileUtils.readFileToByteArray(curveImg);
		}
		
//		byte[] img1 = Base64.decodeBase64(request.getParameter("imgData").replaceAll("data:image/png;base64,", ""));
//		byte[] img2 = Base64.decodeBase64(request.getParameter("imgData2").replaceAll("data:image/png;base64,", ""));
		byte[] img7 = Base64.decodeBase64(request.getParameter("imgData7").replaceAll("data:image/png;base64,", ""));
		HSSFSheet sheetAt = wb.getSheetAt(0);
		HSSFSheet sheetAt2 = wb.getSheetAt(1);
		HSSFSheet sheetAt3 = wb.getSheetAt(2);
		HSSFSheet sheetAt4 = wb.getSheetAt(3);
		HSSFSheet sheetAt5 = wb.getSheetAt(4);
		HSSFSheet sheetAt6 = wb.getSheetAt(5);
		
		QuakeEventReportVO quakeReportData = quakeInfoService.getQuakeReportData(request.getParameter("no"));
		double lat = quakeReportData.getLat();
		double lon = quakeReportData.getLon();
		System.out.println(":::::::::::::::::::::::::::::::::::::::"+type+"::::::::::::::::::::::::::::::::::");
		if(type.equals("NC")){
			System.out.println("원전");
//			img3 = Base64.decodeBase64(request.getParameter("imgData3").replaceAll("data:image/png;base64,", ""));
//			img4 = Base64.decodeBase64(request.getParameter("imgData4").replaceAll("data:image/png;base64,", ""));
//			img5 = Base64.decodeBase64(request.getParameter("imgData5").replaceAll("data:image/png;base64,", ""));
//			img6 = Base64.decodeBase64(request.getParameter("imgData6").replaceAll("data:image/png;base64,", ""));
//			excel.setImage(wb, sheetAt2, 2, 5, 10, 16, img3);//
//			excel.setImage(wb, sheetAt2, 2, 12, 18, 36, img4);
//			excel.setImage(wb, sheetAt3, 2, 5, 10, 16, img5);//
//			excel.setImage(wb, sheetAt3, 2, 12, 18, 36, img6);
			if(curveImg.isFile()){
				excel.setImage(wb, sheetAt6, 2, 13, 4, 45, img8);
			}
//			excel.setImage(wb, sheetAt, 2, 5, 10, 17, img1);
//			excel.setImage(wb, sheetAt, 2, 12, 18, 36, img2);
			excel.setImage(wb, sheetAt5, 2, 7, 12, 32, img7);
			File imgCheck = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+request.getParameter("no")+".jpg");
			try{
				if(!imgCheck.isFile()){
					ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+request.getParameter("no"),1);
				}
			}catch(Exception e){
				System.out.println("에러체크");
			}
			byte[] mapImg = FileUtils.readFileToByteArray(new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+request.getParameter("no")+".jpg"));
			excel.setImage(wb, sheetAt, 2, 5, 10, 17, mapImg);
			excel.setImage(wb, sheetAt2, 2, 5, 10, 16, mapImg);
			excel.setImage(wb, sheetAt3, 2, 5, 10, 16, mapImg);
		}else{
//			excel.setImage(wb, sheetAt4, 2, 12, 24, 42, img2);
			excel.setImage(wb, sheetAt5, 2, 8, 12, 32, img7);
			if(curveImg.isFile()){
				excel.setImage(wb, sheetAt6, 2, 13, 4, 45, img8);
			}

		}


		
		HSSFCellStyle cellStyle = null;
		HSSFCell valueCell = null;
		
		
		for(int i=0;i<6;i++){
			if(i!=4){
				HSSFSheet sheet = wb.getSheetAt(i);
				cellStyle = sheet.getRow(1).getCell(11).getCellStyle();
				valueCell = sheet.getRow(1).createCell(11);
				valueCell.setCellValue("보고자 : "+request.getParameter("men_info"));
				valueCell.setCellStyle(cellStyle);
			
//				if(i==5){
//					cellStyle = sheet.getRow(2).getCell(13).getCellStyle();
//					valueCell = sheet.getRow(2).createCell(13);
//					valueCell.setCellValue(quakeReportData.getReq_starttime()+" - "+quakeReportData.getReq_endtime()+ " 규모"+quakeReportData.getMag());
//					valueCell.setCellStyle(cellStyle);		
//				}
//			}else{
//				HSSFSheet sheet = wb.getSheetAt(i);
//				cellStyle = sheet.getRow(1).getCell(7).getCellStyle();
//				valueCell = sheet.getRow(1).createCell(7);
//				valueCell.setCellValue("보고자 : "+request.getParameter("men_info"));
//				valueCell.setCellStyle(cellStyle);
			}
		}
		for(int i=0;i<4;i++){
			HSSFSheet sheet = wb.getSheetAt(i);
			cellStyle = sheet.getRow(6).getCell(2).getCellStyle();
			valueCell = sheet.getRow(6).createCell(2);
			valueCell.setCellValue(quakeReportData.getDate());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(6).getCell(4).getCellStyle();
			valueCell = sheet.getRow(6).createCell(4);
			valueCell.setCellValue(quakeReportData.getTime());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(6).getCell(7).getCellStyle();
			valueCell = sheet.getRow(6).createCell(7);
			valueCell.setCellValue(quakeReportData.getLat());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(7).getCell(7).getCellStyle();
			valueCell = sheet.getRow(7).createCell(7);
			valueCell.setCellValue(quakeReportData.getArea());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(6).getCell(9).getCellStyle();
			valueCell = sheet.getRow(6).createCell(9);
			valueCell.setCellValue(quakeReportData.getLon());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(6).getCell(11).getCellStyle();
			valueCell = sheet.getRow(6).createCell(11);
			valueCell.setCellValue(quakeReportData.getMag());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(9).getCell(5).getCellStyle();
			valueCell = sheet.getRow(9).createCell(5);
			valueCell.setCellValue("("+quakeReportData.getTimearea()+")");
			valueCell.setCellStyle(cellStyle);		
		
		}
		
		
		String replaceWord = getReplaceWord(request.getParameter("type"));
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeReportDataAll(replaceWord, request.getParameter("type"));
		

		
		String epochTime = quakeReportData.getEpoch_time();
		String delayTime = quakeReportData.getDelay_time();
//		String delayTime = "120";
		String fullDate = quakeReportData.getFull_date();
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];
		int row = 11;
		int col = 5;
		int imgRow = 20;
		int imgCol = 7;
		
		int graRow = 20;
		int graCol = 2;
		
		int ncRow = 0;
		if(!type.equals("NC")){
			col = 2;
		}
		String swc = "";
		boolean nNCFlag = true;
		for(QuakeEventReportVO q : quakeReportDataAll)// 12 5
		{	
			row++;
			HSSFSheet sheet = null;
			
			col = (type.equals("NC")?5:2);
			if(!type.equals("NC")){
				sheet = wb.getSheetAt(3);
				if(nNCFlag){
					graRow = 25;
					graCol = 2;
					nNCFlag =!nNCFlag;
				}
			}else{
				if(q.getObs_id().equals("KA")||q.getObs_id().equals("KB")||q.getObs_id().equals("KC")||q.getObs_id().equals("KD")||q.getObs_id().equals("KE")){
					sheet =  wb.getSheetAt(0);
					swc = "gr";
					ncRow = 1;
				}else if(q.getObs_id().equals("WA")||q.getObs_id().equals("WB")||q.getObs_id().equals("WC")||q.getObs_id().equals("WD")){
					if(swc.equals("gr")){
						row = 12;
						
						imgRow = 19;
						imgCol = 7;
						graRow = 19;
						graCol = 2;
					}
					sheet =  wb.getSheetAt(1);
					swc = "ws";
					ncRow = 0;
				}else{
					if(swc.equals("ws")){
						row = 12;
						
						imgRow = 19;
						imgCol = 7;
						graRow = 19;
						graCol = 2;
					}
					swc = "yu";
					ncRow = 0;
					sheet =  wb.getSheetAt(2);
				}
			}
			double lat2 = q.getLat();
			double lon2 = q.getLon();
			q.setKmeter(""+distance(lat2, lon2, lat, lon));
			//실서버 업로드시 제거
			
			cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
			valueCell = sheet.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getObs_name());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
			valueCell = sheet.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getObs_id());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
			valueCell = sheet.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getAddress());
			valueCell.setCellStyle(cellStyle);
			
			if(!type.equals("NC")){col+=2;}
			cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
			valueCell = sheet.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getKmeter());
			valueCell.setCellStyle(cellStyle);
			
			if(!type.equals("NC")){col++;}
			
			String net = q.getNet();
			try {
				System.out.println("체크");
//				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma",0);
				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id(),0);
				System.out.println("체크"+result.getLines().size());
				if(result.getLines().size()>1){
					System.out.println("사이즈 1 이상");
					List<String> lines = result.getLines();
					
					q = ShellCmdReading.shellCmd(lines,q);
				}
				System.out.println("체크3");
				int req = Integer.parseInt(quakeReportData.getReq_id());
				if(req >= 2017260 && req <= 2017285 && type.equals("NC")){
					BigDecimal bd;
					bd = new BigDecimal(Float.parseFloat(q.getMax_z())/9.81);
					q.setMax_z(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
					bd = new BigDecimal(Float.parseFloat(q.getMax_n())/9.81);
					q.setMax_n(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
					bd = new BigDecimal(Float.parseFloat(q.getMax_e())/9.81);
					q.setMax_e(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
				}
				
				cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
				valueCell = sheet.getRow(row).createCell(col++);
				valueCell.setCellValue(q.getMax_z());
				valueCell.setCellStyle(cellStyle);

				cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
				valueCell = sheet.getRow(row).createCell(col++);
				valueCell.setCellValue(q.getMax_n());
				valueCell.setCellStyle(cellStyle);

				cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
				valueCell = sheet.getRow(row).createCell(col++);
				valueCell.setCellValue(q.getMax_e());
				valueCell.setCellStyle(cellStyle);
				
				/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::: 여기부터 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
				if(type.equals("NC")){
					String fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+quakeReportData.getReq_id()+File.separator;
					
					String m2j = File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json ";
					String date = quakeReportData.getReq_date().replaceAll(":", "").replaceAll("-","").replaceAll(" ", "");
					String fPathEtn = "*.mseed";
					
					q = getGraphData(q,m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,"NC","g1");
					byte[] tempImg = Files.readAllBytes(Paths.get(fPath+"NC"+File.separator+"imgSP"+File.separator+q.getSen_id()+"_response_spectrum.png"));
					//아마도 스펙트럼 이미지
					int iCol = (imgCol==7 ? 3 : 2);
					excel.setImage(wb, sheet, imgCol, imgCol+iCol, imgRow, imgRow+6, tempImg);
					
					System.out.println(":::::::::::::::::::::::::::::::"+q.getObs_id()+":::::::::::::::::::::::::::::::::::::::::::");
					try{
						int nCol = (graCol==2 || graCol==10 ? 2 : 3);
						if(q.getAc100_z().indexOf("error") < 0 ){
					        String string = q.getAc100_z().split("values")[1];
					        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
					        String[] split = substring.split(",");
					        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
							excel.drawDayChart(wb, sheet, split, graRow, graRow+2, graCol, graCol+nCol);
						}
						graRow+=2;//9
						if(q.getAc100_n().indexOf("error") < 0 ){
					        String string = q.getAc100_n().split("values")[1];
					        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
					        String[] split = substring.split(",");
					        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
							excel.drawDayChart(wb, sheet, split, graRow, graRow+2, graCol, graCol+nCol);
						}
						graRow+=2; // 14
						if(q.getAc100_e().indexOf("error") < 0 ){
					        String string = q.getAc100_e().split("values")[1];
					        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
					        String[] split = substring.split(",");
					        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
							excel.drawDayChart(wb, sheet, split, graRow, graRow+2, graCol, graCol+nCol);
						}	
						System.out.println("row : "+(23+ncRow)+"/"+ncRow);
						if(graRow==(23+ncRow) && graCol == 2){
							graRow = 19+ncRow;
							graCol = 4;
							imgCol = 10;
						}else if(graRow==(23+ncRow) && graCol ==4){
							graRow = 26+ncRow;;
							graCol = 2;
							imgCol = 7;
							imgRow = 26+ncRow;
						}else if(graRow==(30+ncRow) && graCol == 2){
							graRow = 26+ncRow;;
							graCol = 4;
							imgCol = 10;
						}else{
							graRow = 34;
							graCol = 2;
							imgCol = 7;
							imgRow = 34;
						}
					}catch(Exception e){
						logger.debug("Error1"+e.toString());
					}
					
		
//					cellStyle = sheetAt.getRow(imgRow-1).getCell(imgCol).getCellStyle();
//					valueCell = sheetAt.getRow(imgRow-1).createCell(imgCol);
//					valueCell.setCellValue(q.getSen_id());
//					valueCell.setCellStyle(cellStyle);	
					
//					excel.setImage(wb, sheetAt, imgCol, imgCol+5, imgRow, imgRow+4, tempImg);
//					if(imgRow == 24 && imgCol == 7){
//						imgRow = 19;
//						imgCol = 2;
//					}else if(imgCol== 2){
//						imgCol = 7;
//					}else{
//						imgRow = 24;
//						imgCol = 2;
//					}

				}else{//원전 외의 그래프용
					String fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+quakeReportData.getReq_id()+File.separator;
					String m2j = File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json ";
					String fPathEtn = "*.mseed";
					
					q = getGraphData(q,m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,"NC","g1");
					//아마도 스펙트럼 이미지

					System.out.println(":::::::::::::::::::::::::::::::"+q.getObs_id()+":::::::::::::::::::::::::::::::::::::::::::");
					try{
						
						cellStyle = sheet.getRow(graRow-1).getCell(graCol).getCellStyle();
						valueCell = sheet.getRow(graRow-1).createCell(graCol);
						valueCell.setCellValue(q.getObs_id());
						valueCell.setCellStyle(cellStyle);
						
						int nCol = (graCol==2 || graCol==10 ? 2 : 3);
						if(q.getAc100_z().indexOf("error") < 0 ){
					        String string = q.getAc100_z().split("values")[1];
					        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
					        String[] split = substring.split(",");
					        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
							excel.drawDayChart(wb, sheet, split, graRow, graRow+2, graCol, graCol+nCol);
						}
						graRow+=2;//9
						if(q.getAc100_n().indexOf("error") < 0 ){
					        String string = q.getAc100_n().split("values")[1];
					        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
					        String[] split = substring.split(",");
					        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
							excel.drawDayChart(wb, sheet, split, graRow, graRow+2, graCol, graCol+nCol);
						}
						graRow+=2; // 14
						if(q.getAc100_e().indexOf("error") < 0 ){
					        String string = q.getAc100_e().split("values")[1];
					        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
					        String[] split = substring.split(",");
					        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
							excel.drawDayChart(wb, sheet, split, graRow, graRow+2, graCol, graCol+nCol);
						}	
						
						if(graRow==29 && graCol == 2){
							graRow = 25;
							graCol = 4;
						}else if(graRow==29 && graCol == 4){
							graRow = 25;
							graCol = 7;
						}else if(graRow==29 && graCol == 7){
							graRow = 25;
							graCol = 10;
						}else if(graRow==29 && graCol == 10){
							graRow = 32;
							graCol = 2;
						}else if(graRow==36 && graCol == 2){
							graRow = 32;
							graCol = 4;
						}else if(graRow==36 && graCol == 4){
							graRow = 32;
							graCol = 7;
						}else if(graRow==36 && graCol == 7){
							graRow = 32;
							graCol = 10;
						}
					}catch(Exception e){
						logger.debug("Error1"+e.toString());
					}
				}
				/*::::::::::::::::::::::::::::::::::::::::::   여기까지 쭈우우우욱    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
				
			} catch (Exception e) {
				// TODO: handle exception
			}
			
		}
		row = 5;
		col = 2;
		List<QuakeEventReportVO> quakeReportHistoryData = quakeInfoService.getQuakeReportHistoryData("5",quakeReportData.getDate(),quakeReportData.getTime());
		for(QuakeEventReportVO qe : quakeReportHistoryData)
		{
			col = 2;
			cellStyle = sheetAt5.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt5.getRow(row).createCell(col++);
			valueCell.setCellValue(qe.getDate()+" "+qe.getTime());
			valueCell.setCellStyle(cellStyle);

			cellStyle = sheetAt5.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt5.getRow(row).createCell(col++);
			valueCell.setCellValue(qe.getLat());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt5.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt5.getRow(row).createCell(col++);
			valueCell.setCellValue(qe.getLon());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt5.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt5.getRow(row).createCell(col++);
			valueCell.setCellValue(qe.getArea());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt5.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt5.getRow(row).createCell(col++);
			valueCell.setCellValue(qe.getMag());
			valueCell.setCellStyle(cellStyle);
			row++;
		}

		if(type.equals("NC")){
			wb.removeSheetAt(3);
		}else{
			wb.removeSheetAt(0);
			wb.removeSheetAt(0);
			wb.removeSheetAt(0);
		}
		
		FileOutputStream fileOut = new FileOutputStream(excelFile);
        wb.write(fileOut);
        fileOut.close();
		
		long saveTime = System.currentTimeMillis();
		long currTime = 0;
		while( currTime - saveTime < 500){
		    currTime = System.currentTimeMillis();
		}
		System.out.println(request.getParameter("men_info"));
		response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename="+URLEncoder.encode(request.getParameter("men_info"),"UTF-8")+".xls");
        IOUtils.copy(new ByteArrayInputStream(Files.readAllBytes(Paths.get(folder+File.separator+request.getParameter("men_info")+".xls"))), response.getOutputStream());
        response.flushBuffer();
      
        excelFile.delete();
		
	}	
	
	/**
	 * 지진이벤트 보고서
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/popup/reportWave/summary")
	public String quakeWaveReportSummary(ModelMap model, @Param("summary")String summary,@Param("no")String no,@Param("type")String type) throws Exception
	{	
		String replaceWord = getReplaceWord(type);
		System.out.println(no+"/"+type);
		QuakeEventReportVO quakeReportData = quakeInfoService.getQuakeReportData(no);
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeSummaryReportDataAll(replaceWord, type);
		String typeNo = "";
		if(type.equals("NC")){
			typeNo="5";
		}else{
			typeNo="13";
		}
		List<QuakeEventReportVO> quakeReportHistoryData = quakeInfoService.getQuakeReportHistoryData(typeNo,quakeReportData.getDate(),quakeReportData.getTime());
		
		
		double lat = quakeReportData.getLat();
		double lon = quakeReportData.getLon();
		
		File imgCheck = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no+".jpg");
		try{
			if(!imgCheck.isFile()){
				ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no,1);
			}
		}catch(Exception e){
			
		}
		
		String epochTime = quakeReportData.getEpoch_time();
//		String delayTime = quakeReportData.getDelay_time();
		String delayTime = "120";
		String fullDate = quakeReportData.getFull_date();
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];
		
			for(QuakeEventReportVO q : quakeReportDataAll)
			{
				double lat2 = q.getLat();
				double lon2 = q.getLon();
				q.setKmeter(""+distance(lat2, lon2, lat, lon));
				//실서버 업로드시 제거
				String net = q.getNet();
//			ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_"+q.getSen_id()+"_20170622.mma",0);
				try {
//					ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma",0);
					ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id(),0);
					List<String> lines = result.getLines();
					
					q = ShellCmdReading.shellCmd(lines,q);
					int req = Integer.parseInt(quakeReportData.getReq_id());
					if(req >= 2017260 && req <= 2017285 && type.equals("NC")){
						BigDecimal bd;
						bd = new BigDecimal(Float.parseFloat(q.getMax_z())/9.81);
						q.setMax_z(((""+bd).length()>9?(""+bd).substring(0,9):(""+bd)));
						bd = new BigDecimal(Float.parseFloat(q.getMax_n())/9.81);
						q.setMax_n(((""+bd).length()>9?(""+bd).substring(0,9):(""+bd)));
						bd = new BigDecimal(Float.parseFloat(q.getMax_e())/9.81);
						q.setMax_e(((""+bd).length()>9?(""+bd).substring(0,9):(""+bd)));
					}
				} catch (Exception e) {
					// TODO: handle exception
				}
				
//			System.out.println(shellCmd);
			}
		
		
		quakeReportData.setKmeter(""+distance(35.49, 129.15, lat, lon));
		String date = quakeReportData.getReq_date().replaceAll(":", "").replaceAll("-","").replaceAll(" ", "");
		model.addAttribute("dataList",quakeReportDataAll);
		model.addAttribute("mainData",quakeReportData);
		model.addAttribute("historyList",quakeReportHistoryData);
		model.addAttribute("org_type",type);
		model.addAttribute("req_date",date.substring(0,date.length()-2));
		model.addAttribute("req_id",quakeReportData.getReq_id());
		model.addAttribute("viewTap",summary);
		
		return "/quakeoccur/popup/quakeWaveSummaryReport";
	}	
	/*
	 * 지진 요약 엑셀 다운로드
	 * */
	
	@RequestMapping(value = "/getSimpleQuakeExcel.do", method = RequestMethod.POST)
	public void getSimpleQuakeExcel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		ExcelFnc excel = new ExcelFnc();
//		excel.insertValue();
		String folder = request.getSession().getServletContext().getRealPath("/excel");
		String fileName = "";
		String type = request.getParameter("type");
		String no = request.getParameter("no");
		QuakeEventReportVO quakeReportData = quakeInfoService.getQuakeReportData(no);
		double lat = quakeReportData.getLat();
		double lon = quakeReportData.getLon();
		if(type.equals("NC")){
			fileName = folder+File.separator+"quakeSimple.xls";
		}else{
			fileName = folder+File.separator+"quakeSimple_HP.xls";
		}
		excel.copyExcel(fileName, folder+File.separator+request.getParameter("men_info")+".xls");
		
		File imgCheck = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no+".jpg");
		try{
			if(!imgCheck.isFile()){
				ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no,1);
			}
		}catch(Exception e){
			System.out.println("imgError");
		}
		File img = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no+".jpg");
//		byte[] img1 = Base64.decodeBase64(request.getParameter("imgData").replaceAll("data:image/png;base64,", ""));
		byte[] img1 = FileUtils.readFileToByteArray(img);
		
		
//		System.out.println(folder+File.separator+request.getParameter("men_info")+".xls");
		File excelFile = new File(folder+File.separator+request.getParameter("men_info")+".xls");
		HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
		HSSFSheet sheetAt = wb.getSheetAt(0);
		
		if(request.getParameter("type").equals("NC")){
			byte[] img2 = Base64.decodeBase64(request.getParameter("imgData2").replaceAll("data:image/png;base64,", ""));
			excel.setImage(wb, sheetAt, 2, 5, 10, 16, img1);
			excel.setImage(wb, sheetAt, 2, 12, 18, 28, img2);
		}else{
			excel.setImage(wb, sheetAt, 2, 5, 10, 20, img1);

		}
		
		HSSFCellStyle cellStyle = null;
		HSSFCell valueCell = null;
		
		cellStyle = sheetAt.getRow(1).getCell(11).getCellStyle();
		valueCell = sheetAt.getRow(1).createCell(11);
		valueCell.setCellValue("보고자 : "+request.getParameter("men_info"));
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(9).getCell(5).getCellStyle();
		valueCell = sheetAt.getRow(9).createCell(5);
		valueCell.setCellValue("("+quakeReportData.getTimearea()+")");
		valueCell.setCellStyle(cellStyle);	
		
		cellStyle = sheetAt.getRow(6).getCell(2).getCellStyle();
		valueCell = sheetAt.getRow(6).createCell(2);
		valueCell.setCellValue(quakeReportData.getDate());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(6).getCell(4).getCellStyle();
		valueCell = sheetAt.getRow(6).createCell(4);
		valueCell.setCellValue(quakeReportData.getTime());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(6).getCell(7).getCellStyle();
		valueCell = sheetAt.getRow(6).createCell(7);
		valueCell.setCellValue(quakeReportData.getLat());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(7).getCell(7).getCellStyle();
		valueCell = sheetAt.getRow(7).createCell(7);
		valueCell.setCellValue(quakeReportData.getArea());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(6).getCell(9).getCellStyle();
		valueCell = sheetAt.getRow(6).createCell(9);
		valueCell.setCellValue(quakeReportData.getLon());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(6).getCell(11).getCellStyle();
		valueCell = sheetAt.getRow(6).createCell(11);
		valueCell.setCellValue(quakeReportData.getMag());
		valueCell.setCellStyle(cellStyle);
		
		cellStyle = sheetAt.getRow(9).getCell(5).getCellStyle();
		valueCell = sheetAt.getRow(9).createCell(5);
		valueCell.setCellValue("("+quakeReportData.getTimearea()+")");
		valueCell.setCellStyle(cellStyle);		
		
		String replaceWord = getReplaceWord(request.getParameter("type"));
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeSummaryReportDataAll(replaceWord, request.getParameter("type"));
		
		
		List<QuakeEventReportVO> quakeReportHistoryData = quakeInfoService.getQuakeReportHistoryData("5",quakeReportData.getDate(),quakeReportData.getTime());
		
		
//		double lat = quakeReportData.getLat();
//		double lon = quakeReportData.getLon();
		
		String epochTime = quakeReportData.getEpoch_time();
//		String delayTime = quakeReportData.getDelay_time();
		String delayTime = "120";
		String fullDate = quakeReportData.getFull_date();
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];

		int row = 11;
		int col = 5;
		for(QuakeEventReportVO q : quakeReportDataAll)// 12 5
		{	
			row++;
			System.out.println(row);
			col = 5;
			double lat2 = q.getLat();
			double lon2 = q.getLon();
			q.setKmeter(""+distance(lat2, lon2, lat, lon));
			//실서버 업로드시 제거
			
			cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getObs_name());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getObs_id());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getAddress());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(col++);
			valueCell.setCellValue(q.getKmeter());
			valueCell.setCellStyle(cellStyle);
			
			String net = q.getNet();
			try {
//				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma",0);
				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id(),0);
				List<String> lines = result.getLines();
				
				q = ShellCmdReading.shellCmd(lines,q);
				
				int req = Integer.parseInt(quakeReportData.getReq_id());
				if(req >= 2017260 && req <= 2017285 && request.getParameter("type").equals("NC")){
					BigDecimal bd;
					bd = new BigDecimal(Float.parseFloat(q.getMax_z())/9.81);
					q.setMax_z(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
					bd = new BigDecimal(Float.parseFloat(q.getMax_n())/9.81);
					q.setMax_n(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
					bd = new BigDecimal(Float.parseFloat(q.getMax_e())/9.81);
					q.setMax_e(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
				}
				
				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(q.getMax_z());
				valueCell.setCellStyle(cellStyle);

				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(q.getMax_n());
				valueCell.setCellStyle(cellStyle);

				cellStyle = sheetAt.getRow(row).getCell(col).getCellStyle();
				valueCell = sheetAt.getRow(row).createCell(col++);
				valueCell.setCellValue(q.getMax_e());
				valueCell.setCellStyle(cellStyle);
				
			} catch (Exception e) {
				// TODO: handle exception
			}
			
		}
		cellStyle = sheetAt.getRow(6).getCell(11).getCellStyle();
		valueCell = sheetAt.getRow(6).createCell(11);
		valueCell.setCellValue(quakeReportData.getMag());
		valueCell.setCellStyle(cellStyle);
		if(request.getParameter("type").equals("NC")){
			row = 30;
		}else{
			row = 22;
		}
		for(QuakeEventReportVO q : quakeReportHistoryData) // 31 
		{
			row++;
			cellStyle = sheetAt.getRow(row).getCell(2).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(2);
			valueCell.setCellValue(q.getDate()+" "+q.getTime());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(5).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(5);
			valueCell.setCellValue(q.getLat());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(6).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(6);
			valueCell.setCellValue(q.getLon());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(7).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(7);
			valueCell.setCellValue(q.getArea());
			valueCell.setCellStyle(cellStyle);
			
			cellStyle = sheetAt.getRow(row).getCell(11).getCellStyle();
			valueCell = sheetAt.getRow(row).createCell(11);
			valueCell.setCellValue(q.getMag());
			valueCell.setCellStyle(cellStyle);
		}

		
        FileOutputStream fileOut = new FileOutputStream(excelFile);
        wb.write(fileOut);
        fileOut.close();
		
//		System.out.println(folder+File.separator+imgName1+".jpg");
		long saveTime = System.currentTimeMillis();
		long currTime = 0;
		while( currTime - saveTime < 500){
		    currTime = System.currentTimeMillis();
		}
		System.out.println(request.getParameter("men_info"));
		response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename="+URLEncoder.encode(request.getParameter("men_info"),"UTF-8")+".xls");
        IOUtils.copy(new ByteArrayInputStream(Files.readAllBytes(Paths.get(folder+File.separator+request.getParameter("men_info")+".xls"))), response.getOutputStream());
        response.flushBuffer();
      
        excelFile.delete();
		
	}
	
	@RequestMapping("/getQuakePopupData.ws")
	public @ResponseBody ResponseDataListVO getQuakePopupData(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String type = sch_data.get("type").toString();
		String org_type = sch_data.get("org_type").toString();
		String pop_type = sch_data.get("pop_type").toString();
		
		String time_data = sch_data.get("time_data").toString();
		String path1 = sch_data.get("path1").toString();
		
		double lat = Double.parseDouble(sch_data.get("lat").toString());
		double lon = Double.parseDouble(sch_data.get("lon").toString());
		
		List<QuakeEventReportVO> ReportDataAll = quakeInfoService.getQuakeReportDataAll(getReplaceWord(org_type), org_type);
		System.out.println(type);
		
		String m2j = File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json ";
		
		
		if(type.equals("g2")){
			//지진 발생지로부터 관측소 거리 측정. 
			for(QuakeEventReportVO q : ReportDataAll)
			{	
				q.setKmeter(""+distance(lat, lon, q.getLat(), q.getLon()));
			}
			
//			Collections.sort(ReportDataAll, new Comparator<QuakeEventReportVO>() {
//				@Override
//				public int compare(QuakeEventReportVO obj1, QuakeEventReportVO obj2) {
//					// TODO Auto-generated method stub
//					return (Integer.parseInt(obj1.getKmeter()) < Integer.parseInt(obj2.getKmeter())) ? -1: (Integer.parseInt(obj1.getKmeter()) > Integer.parseInt(obj2.getKmeter())) ? 1:0 ;
//				}
//				
//			});
		}
		
		
		String fPath = "";
		String fPathEtn = "";
		if(pop_type.equals("wave")){
			fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+path1+File.separator;
//			fPathEtn = time_data+".mseed";
			fPathEtn = "*.mseed";
		}else if(pop_type.equals("self")){
			fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"event"+File.separator+path1+File.separator;
			fPathEtn = time_data+".mseed";			
		}else{
			fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"segment"+File.separator+org_type+File.separator+path1+File.separator;
			fPathEtn = time_data+".mseed";			
		}
		
		for(QuakeEventReportVO q : ReportDataAll)
		{	
			if(pop_type.equals("wave")){
				q = getGraphData(q,m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,org_type,type);
				logger.info(m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"__"+fPathEtn);
				q.setImage_path(fPath+org_type+File.separator+"imgSP"+File.separator+q.getSen_id()+"_response_spectrum.png");
			}else if(pop_type.equals("self")){
				q = getGraphData(q,m2j+fPath+org_type+File.separator+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,org_type,type);
				q.setImage_path(fPath+org_type+File.separator+"imgSP"+File.separator+q.getSen_id()+"_response_spectrum.png");
			}else{
				q = getGraphData(q,m2j+fPath+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,org_type,type);
				q.setImage_path(fPath+"imgSP"+File.separator+q.getSen_id()+"_response_spectrum.png");
			}
		}

		/**
		 * 관측소 리스트를 받아옴.(org type에 따라)
		 * 받아온 관측소 코드로 각각의 데이터를 받음
		 * type에 따라 진앙거리순 재정렬
		 */
		
		datasets.setData(ReportDataAll);
		
		return datasets;
	}
	
	@RequestMapping("/getQuakeSimplePopupData.ws")
	public @ResponseBody ResponseDataListVO getQuakeSimplePopupData(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
//		String type = sch_data.get("type").toString();
//		String org_type = sch_data.get("org_type").toString();
		
		String time_data = sch_data.get("time_data").toString();
		String path1 = sch_data.get("path1").toString();
		
		
		List<QuakeEventReportVO> ReportDataAll = quakeInfoService.getQuakeSummaryReportDataAll(getReplaceWord("NC"), "NC");
		
		String m2j = File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json ";
		
		String fPath = "";
		String fPathEtn = "";
		
		fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+path1+File.separator;
//		fPathEtn = time_data+".mseed";
		fPathEtn = "*.mseed";
		
		for(QuakeEventReportVO q : ReportDataAll)
		{	
			try{
				System.out.println(m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"_"+","+"_"+fPathEtn);
				q = getGraphData(q,m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,"NC","g1");
				q.setImage_path(fPath+"NC"+File.separator+"imgSP"+File.separator+q.getSen_id()+"_response_spectrum.png");
			}catch(Exception e){
				System.out.println("error");
			}
		}
		
		datasets.setData(ReportDataAll);
		
		return datasets;
	}	
	
	@RequestMapping("/createManualData.ws")
	public @ResponseBody ResponseDataListVO createManualData(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String time = sch_data.get("time").toString();
		String org = sch_data.get("org").toString();
		String uTime = addTime(time, -540, "yyyy/MM/dd,HH:mm:ss");
		String aTime = addTime(time, 0, "yyyyMMddHHmmss");
		String rTxt = "OK";
		String realTime = realTime();
		String lat = sch_data.get("lat").toString();
		String lon = sch_data.get("lon").toString();
		
		try{
			System.out.println(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+org+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"manual");
			ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+org+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"manual",0);
		}catch(Exception e){
			logger.debug("::::::::::::::::: error Manual :::::::::::::::::");
		}
		
		try {
//			File.separator
			System.out.println(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"heesong"+File.separator+"bin"+File.separator+"script"+File.separator+"hs_mseed2sac_v3.sh "+uTime+" 210 M "+aTime+" "+org);
			ExecResult execCmd = Execute.execCmd(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"heesong"+File.separator+"bin"+File.separator+"script"+File.separator+"hs_mseed2sac_v3.sh "+uTime+" 210 M "+aTime+" "+org, 0);
			
			//수동
//			System.out.println(execCmd.getLines().get(0));
		} catch (Exception e) {
			// TODO: handle exception
			logger.debug("::::::::::::::::: error Manual2 :::::::::::::::::");
			rTxt = "Not Ok";
		}
		datasets.setResultCode(realTime);
		datasets.setResultDesc(rTxt);
		
		return datasets;
	}
	public QuakeEventReportVO getGraphData(QuakeEventReportVO q,String fPath,String bPath,String org,String type) throws Exception{
		
		try{
//			File[] files = listFile.listFiles();
			int cnt = q.getCnt();
			if(type.equals("g1")){
				if(org.equals("NC") || org.equals("CJ")){
					q.setAc100_z(putStr(Execute.execCmd(fPath+"BGZ"+bPath, 0).getLines()));
					q.setAc100_n(putStr(Execute.execCmd(fPath+"BGN"+bPath, 0).getLines()));
					q.setAc100_e(putStr(Execute.execCmd(fPath+"BGE"+bPath, 0).getLines()));
					q.setSp100_z(putStr(Execute.execCmd(fPath+"HGZ"+bPath, 0).getLines()));
					q.setSp100_n(putStr(Execute.execCmd(fPath+"HGN"+bPath, 0).getLines()));
					q.setSp100_e(putStr(Execute.execCmd(fPath+"HGE"+bPath, 0).getLines()));
				}else{
					//HGZ,N,E
					//HPZ,Y,X
					//WP는 G를 제외한 센서 가운데 D PP 는 P
					fPath = fPath.substring(0,fPath.length()-2);
					String stationCode = "P";
					if(org.equals("WP")){
						stationCode = "D";
					}
					logger.info("path : "+fPath+"G_HGZ"+bPath);
					q.setG_z(putStr(Execute.execCmd(fPath+"G_HGZ"+bPath, 0).getLines()));
					q.setG_n(putStr(Execute.execCmd(fPath+"G_HGN"+bPath, 0).getLines()));
					q.setG_e(putStr(Execute.execCmd(fPath+"G_HGE"+bPath, 0).getLines()));
					q.setB_z(putStr(Execute.execCmd(fPath+"B_H"+stationCode+"Z"+bPath, 0).getLines()));
					q.setB_n(putStr(Execute.execCmd(fPath+"B_H"+stationCode+"Y"+bPath, 0).getLines()));
					q.setB_e(putStr(Execute.execCmd(fPath+"B_H"+stationCode+"X"+bPath, 0).getLines()));			
					//HPY,X
//					if(cnt > 2){
						q.setM_n(putStr(Execute.execCmd(fPath+"M_H"+stationCode+"Y"+bPath, 0).getLines()));
						q.setM_e(putStr(Execute.execCmd(fPath+"M_H"+stationCode+"X"+bPath, 0).getLines()));
//					}
//					if (cnt > 3){
						q.setR_n(putStr(Execute.execCmd(fPath+"R_H"+stationCode+"Y"+bPath, 0).getLines()));
						q.setR_e(putStr(Execute.execCmd(fPath+"R_H"+stationCode+"X"+bPath, 0).getLines()));
//					}
					//HPX,Y
				}
			}else{
				q.setG_z(putStr(Execute.execCmd(fPath+"HGN"+bPath, 0).getLines()));
			}
		}catch(Exception e){
			
		}
		return q;
	}

	@RequestMapping(value = "/getExcel.do", method = RequestMethod.POST)
	public void getExcel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
        try {
//        	String imgData = sch_data.get("imgData").toString();
            String imgData = request.getParameter("imgData");
            String imgData2 = request.getParameter("imgData2");
            
            imgData = imgData.replaceAll("data:image/png;base64,", "");
            imgData2 = imgData2.replaceAll("data:image/png;base64,", "");
            byte[] file = Base64.decodeBase64(imgData);
            byte[] file3 = Base64.decodeBase64(imgData2);
//            File file2 = new File("D:"+File.separator+"excel"+File.separator+"test_copy.xls");
            Path path = Paths.get("D:"+File.separator+"excel"+File.separator+"test_copy.xls");
            byte[] file2 = Files.readAllBytes(path);
            
            ByteArrayInputStream is = new ByteArrayInputStream(file);
            ByteArrayInputStream is2 = new ByteArrayInputStream(file2);
            ByteArrayInputStream is3 = new ByteArrayInputStream(file3);
            
            FileOutputStream outputStream = new FileOutputStream("D:"+File.separator+"excel"+File.separator+"image.jpg");
            IOUtils.copy(is,outputStream);
            IOUtils.closeQuietly(is);
            IOUtils.closeQuietly(outputStream);
            
            FileOutputStream outputStream2 = new FileOutputStream("D:"+File.separator+"excel"+File.separator+"image2.jpg");
            IOUtils.copy(is3,outputStream2);
            IOUtils.closeQuietly(is3);
            IOUtils.closeQuietly(outputStream2);
            
//            response.setContentType("image/png");
//            response.setHeader("Content-Disposition", "attachment; filename=test.png");
 
//            IOUtils.copy(is, response.getOutputStream());
//            response.flushBuffer();
            
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=down.xls");
            IOUtils.copy(is2, response.getOutputStream());
            response.flushBuffer();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
//			model.addAttribute("fileName", "임시.xls");
//			model.addAttribute("type", type);
//			model.addAttribute("sta_type", sta_type);
//			model.addAttribute("ncTable", ncTable);
//			model.addAttribute("wpTable", wpTable);
//			model.addAttribute("ppTable", ppTable);
//			model.addAttribute("chartDay", chartDay);
//			model.addAttribute("chartMonth", chartMonth);
//		return "exportExcelReport";
//        return "success";
	}
	
	public static String addTime(String date,int min,String dFormat) throws ParseException{
		Calendar cal = Calendar.getInstance();
		DateFormat ddf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		DateFormat df = new SimpleDateFormat(dFormat);
		Date parse2 = ddf.parse(date);

		cal.setTime(parse2);
		cal.add(Calendar.MINUTE, min);
		
		String format = df.format(cal.getTime());
		return format;
	}
	public String putStr(List<String> s ){
		String rTxt = "";
		for(int i =0; i<s.size();i++){
			rTxt += s.get(i);
		}
		return rTxt;
	}
	public String realTime(){
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		String format = df.format(date);
		return format;
	}
	public String getReplaceWord(String type){
		String rWord = null;
		if(type.equals("NC") || type.equals("CJ")){
			rWord="원자력발전소";
		}else if(type.equals("PP")){
			rWord="양수발전소";
		}else if(type.equals("WP")){
			rWord="댐";
		}
		return rWord;
	}
	public String getChangeWord(String type)
	{
		String rWord = "";
		if(type.equals("NC")){
			rWord = "원전";
		}else if(type.equals("PP")){
			rWord = "양수";
		}else if(type.equals("WP")){
			rWord = "수력";
		}
		return rWord;
	}
	
	@RequestMapping("/getQuakeEventList.ws")
	public @ResponseBody ResponseDataListVO getQuakeEventList(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String date = sch_data.get("date").toString();
		String date2 = sch_data.get("date2").toString();
		String obs_kind = sch_data.get("obs_kind").toString();
		String sta_type = sch_data.get("sta_type").toString();
		String page = (String) sch_data.get("page").toString();
		
		
		List<List<Object>> results = quakeInfoService.getQuakeEventList(date,date2, obs_kind, sta_type, page);
		
		if(results != null && results.size() != 0)
		{
			List<QuakeEventListVO> list = getDataset(results, 0);
			
			datasets.setData(list);
			datasets.setTotalDataCount((String) results.get(1).get(0).toString());
		}
		
		return datasets;
	}
	@RequestMapping("/getQuakeEventSubList.ws")
	public @ResponseBody ResponseDataListVO getQuakeEventSubList(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String req_id = sch_data.get("req_id").toString();
		String obs_kind = sch_data.get("obs_kind").toString();
		String sta_type = sch_data.get("sta_type").toString();
		
		
		List<QuakeEventListVO> quakeEventSubList = quakeInfoService.getQuakeEventSubList(req_id, obs_kind, sta_type);
		
		if(quakeEventSubList != null && quakeEventSubList.size() != 0)
		{
			datasets.setData(quakeEventSubList);
		}
		
		return datasets;
	}	
		
	@RequestMapping("/getTestData.ws")
	public @ResponseBody ResponseDataListVO getTestData(@RequestBody String a, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		ArrayList<String> list = new ArrayList<>();
//		int[] dd = {9316, 11312, 11483, 9382, 9142, 11310, 11314, 9293, 9191, 10943, 11410, 9531, 8870, 10846, 11482, 9436, 8890, 10751, 11398, 9438, 8551, 10559, 11041, 9164, 8477, 10228, 11175, 9221, 8381, 10336, 11125, 9025, 8256, 10295, 10877, 8979, 8019, 9860, 10785, 8861, 8036, 9783, 10780, 8913, 7965, 9611, 10402, 9006, 7785, 9302, 10552, 8755, 7599, 9386, 10745, 8933, 7476, 9290, 10488, 8873, 7700, 9126, 10408, 8941, 7515, 8744, 10367, 9106, 7626, 9101, 10208, 9219, 7793, 8502, 10336, 9240, 7575, 8825, 10536, 9468, 7705, 8724, 10689, 9688, 7585, 8662, 10537, 9539, 7775, 8634, 10375, 9462, 7546, 8420, 10325, 9313, 7496, 8267, 10066, 9420, 7521, 8375, 10440, 9809, 7777, 8529, 10583, 9692, 7820, 8390, 10133, 9829, 7882, 8164, 10226, 9935, 7960, 8324, 10501, 10169, 8128, 8533, 10562, 10369, 8290, 8526, 10459, 10430, 8704, 8603, 10619, 10486, 8532, 8519, 10382, 10651, 8302, 8324, 10614, 10689, 8846, 8611, 10606, 10652, 8681, 8661, 10695, 10822, 8862, 8693, 10556, 10962, 8945, 8527, 10542, 11088, 9064, 8448, 10567, 11028, 9014, 8599, 10608, 11237, 9283, 8449, 10475, 11165, 9305, 8492, 10071, 11190, 9202, 8232, 10197, 11153, 9435, 8333, 10190, 11035, 9413, 8558, 9856, 10903, 9353, 8136, 9917, 11196, 9524, 8222, 9744, 11142, 9608, 8471, 10046, 11346, 9960, 8513, 10125, 11296, 9846, 8529, 9773, 11416, 9831, 8351, 9727, 11142, 9966, 8248, 9699, 11327, 9837, 8517, 9791, 11275, 10008, 8279, 9616, 11270, 10065, 8444, 9516, 11249, 10244, 8405, 9353, 11362, 10514, 8569, 9504, 11334, 10378, 8505, 9615, 11596, 10617, 8700, 9349, 11287, 10563, 8510, 9173, 11266, 10742, 8687, 9239, 11308, 10934, 8815, 9228, 11392, 10890, 8994, 9414, 11292, 11031, 8917, 9165, 11294, 11039, 8969, 9242, 11099, 10892, 9058, 9120, 11317, 11046, 8894, 9242, 11140, 11259, 9359, 9132, 11148, 11292, 9230, 8880, 10898, 11097, 9147, 8829, 10833, 11470, 9255, 8951, 11037, 11289, 9539, 9057, 11053, 11559, 9348, 8913, 11072, 11649, 9645, 9133, 10991, 11710, 9604, 8627, 11080, 11470, 9516, 8972, 10582, 11635, 9666, 8928, 10744, 11760, 10088, 8936, 10975, 11876, 10031, 9081, 10692, 11817, 10407, 9141, 10645, 12008, 10403, 9285, 10862, 12077, 10347, 8860, 10626, 11898, 10294, 9031, 10487, 11994, 10379, 9007, 10603, 11812, 10572, 9044, 10279, 11910, 10436, 8959, 10255, 11888, 10732, 9100, 10292, 11772, 10737, 9077, 9976, 11661, 10766, 9065, 10147, 11756, 10398, 8884, 9628, 11302, 10661, 8693, 9654, 11363, 10561, 8765, 9468, 11492, 10678, 8609, 9197, 11291, 10611, 8608, 9292, 11031, 10575, 8766, 9092, 11040, 10446, 8313, 9031, 10889, 10404, 8723, 8974, 10943, 10577, 8405, 8800, 10742, 10367, 8580, 8739, 10491, 10276, 8344, 8514, 10486, 10390, 8277, 8335, 10402, 10286, 8370, 8339, 10169, 10539, 8589, 8233, 10433, 10586, 8461, 8480, 10483, 10644, 8586, 8114, 10364, 10721, 8557, 8124, 10001, 10615, 8576, 7979, 9944, 10559, 8528, 7863, 9989, 10449, 8665, 8042, 9709, 10599, 8833, 8058, 9967, 10741, 8769, 8124, 9990, 10652, 8803, 7891, 9722, 10767, 9207, 8123, 9913, 11069, 9274, 8372, 9989, 11023, 9429, 8230, 9939, 11020, 9456, 8318, 9638, 11019, 9375, 8198, 9733, 10854, 9884, 8367, 9782, 11510, 9929, 8362, 9699, 11117, 9826, 8508, 9786, 11278, 10128, 8446, 9667, 11517, 10147, 8473, 9617, 11097, 10457, 8796, 9508, 11514, 10592, 8789, 9834, 11443, 10375, 8698, 9638, 11487, 10617, 8869, 9811, 11540, 10877, 8985, 9783, 11769, 11038, 9239, 9968, 11868, 10922, 9112, 9885, 11632, 11157, 9296, 9854, 11882, 11255, 9315, 9804, 11630, 11283, 9392, 9700, 11466, 11170, 9286, 9553, 11593, 11199, 9068, 9383, 11538, 11341, 9190, 9270, 11271, 11177, 9256, 9118, 11049, 11371, 9368, 9074, 11055, 11356, 9262, 9030, 11049, 11211, 9275, 8729, 10739, 11258, 9149, 8735, 10737, 11197, 9129, 8638, 10472, 10844, 9044, 8419, 10180, 10892, 9147, 8421, 10143, 10905, 9011, 8093, 10060, 10739, 8763, 7911, 9679, 10561, 8699, 7791, 9379, 10478, 8718, 7433, 9489, 10545, 8509, 7523, 9288, 10223, 8433, 7375, 9202, 10159, 8466, 7484, 9016, 10225, 8574, 7277, 8897, 10027, 8401, 7128, 8728, 10086, 8560, 7318, 8629, 9879, 8638, 7245, 8693, 10262, 8852, 7309, 8581, 10130, 8926, 7354, 8733, 10300, 8868, 7379, 8652, 10195, 9055, 7401, 8270, 9943, 9254, 7479, 8443, 10370, 9536, 7593, 8365, 10381, 9443, 7702, 8539, 10277, 9631, 7831, 8529, 10365, 9909, 8081, 8752, 10751, 9986, 8133, 8558, 10412, 10121, 8253, 8805, 10754, 10333, 8216, 8625, 10847, 10680, 8623, 8945, 11188, 10730, 8995, 9330, 11075, 11040, 8888, 9084, 11189, 11073, 9033, 9102, 11459, 11266, 9058, 9164, 11242, 11430, 9509, 9527, 11405, 11616, 9816, 9367, 11478, 11895, 9819, 9660, 11604, 12012, 10064, 9503, 11553, 12196, 10256, 9664, 11808, 12314, 10480, 10133, 11714, 12316, 10669, 9986, 11885, 12752, 10866, 10177, 12146, 12954, 11251, 10386, 12145, 13038, 11206, 10110, 12113, 13247, 11280, 10430, 12076, 13095, 11430, 10115, 11864, 13137, 11407, 10096, 11747, 13046, 11486, 10209, 11624, 12847, 11358, 10060, 11593, 12819, 11597, 10179, 11188, 12953, 11602, 10025, 11418, 12771, 11528, 10066, 11401, 12833, 11391, 9805, 10975, 12567, 11331, 9396, 10515, 12258, 10988, 9329, 10534, 12182, 10927, 9251, 10265, 11903, 10897, 9014, 10007, 11848, 10971, 9099, 9758, 11502, 10856, 8936, 9451, 11525, 10817, 8703, 9499, 11456, 10659, 8773, 9289, 11209, 10740, 8597};
//		for(int i=0;i<6;i++){
//			list.add(dd);
//		}
//		datasets.setData(list);
		
//		ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json "+File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+"2017213"+File.separator+"KA"+File.separator+"KN_KAG_HGZ_20170626171040.mseed", 0);
//		List<String> lines = result.getLines();
//		System.out.println(lines.size());
		//실서버 업로드시 해제
		for(int i=0;i<6;i++)
		{	
			String bab = "/opt/KISStool/bin/mseed2json /data/HSGEO/remoteseg/2017213/KA/KN_KAG_HGZ_20170626171040.mseed";
//			ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_BSB_20170622.mma",0);
			String strs = "su - sysop -c";
			String arg2 = File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json";
			String arg1 = File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+"2017213"+File.separator+"KA"+File.separator+"KN_KAG_HGZ_20170626171040.mseed";
			String result2 = Execute.execCommand(strs,arg2,arg1);
//			List<String> lines = result.getLines();
//			list.add("a"+i);
			list.add(result2);
//			s = ShellCmdReading.shellCmd(lines,s);
		}
				
		datasets.setData(list);
		
				
		return datasets;
	}	
	@RequestMapping("/getTestData2.ws")
	public @ResponseBody ResponseDataListVO getTestData2(@RequestBody String a, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		ArrayList<String> list = new ArrayList<>();
//		int[] dd = {9316, 11312, 11483, 9382, 9142, 11310, 11314, 9293, 9191, 10943, 11410, 9531, 8870, 10846, 11482, 9436, 8890, 10751, 11398, 9438, 8551, 10559, 11041, 9164, 8477, 10228, 11175, 9221, 8381, 10336, 11125, 9025, 8256, 10295, 10877, 8979, 8019, 9860, 10785, 8861, 8036, 9783, 10780, 8913, 7965, 9611, 10402, 9006, 7785, 9302, 10552, 8755, 7599, 9386, 10745, 8933, 7476, 9290, 10488, 8873, 7700, 9126, 10408, 8941, 7515, 8744, 10367, 9106, 7626, 9101, 10208, 9219, 7793, 8502, 10336, 9240, 7575, 8825, 10536, 9468, 7705, 8724, 10689, 9688, 7585, 8662, 10537, 9539, 7775, 8634, 10375, 9462, 7546, 8420, 10325, 9313, 7496, 8267, 10066, 9420, 7521, 8375, 10440, 9809, 7777, 8529, 10583, 9692, 7820, 8390, 10133, 9829, 7882, 8164, 10226, 9935, 7960, 8324, 10501, 10169, 8128, 8533, 10562, 10369, 8290, 8526, 10459, 10430, 8704, 8603, 10619, 10486, 8532, 8519, 10382, 10651, 8302, 8324, 10614, 10689, 8846, 8611, 10606, 10652, 8681, 8661, 10695, 10822, 8862, 8693, 10556, 10962, 8945, 8527, 10542, 11088, 9064, 8448, 10567, 11028, 9014, 8599, 10608, 11237, 9283, 8449, 10475, 11165, 9305, 8492, 10071, 11190, 9202, 8232, 10197, 11153, 9435, 8333, 10190, 11035, 9413, 8558, 9856, 10903, 9353, 8136, 9917, 11196, 9524, 8222, 9744, 11142, 9608, 8471, 10046, 11346, 9960, 8513, 10125, 11296, 9846, 8529, 9773, 11416, 9831, 8351, 9727, 11142, 9966, 8248, 9699, 11327, 9837, 8517, 9791, 11275, 10008, 8279, 9616, 11270, 10065, 8444, 9516, 11249, 10244, 8405, 9353, 11362, 10514, 8569, 9504, 11334, 10378, 8505, 9615, 11596, 10617, 8700, 9349, 11287, 10563, 8510, 9173, 11266, 10742, 8687, 9239, 11308, 10934, 8815, 9228, 11392, 10890, 8994, 9414, 11292, 11031, 8917, 9165, 11294, 11039, 8969, 9242, 11099, 10892, 9058, 9120, 11317, 11046, 8894, 9242, 11140, 11259, 9359, 9132, 11148, 11292, 9230, 8880, 10898, 11097, 9147, 8829, 10833, 11470, 9255, 8951, 11037, 11289, 9539, 9057, 11053, 11559, 9348, 8913, 11072, 11649, 9645, 9133, 10991, 11710, 9604, 8627, 11080, 11470, 9516, 8972, 10582, 11635, 9666, 8928, 10744, 11760, 10088, 8936, 10975, 11876, 10031, 9081, 10692, 11817, 10407, 9141, 10645, 12008, 10403, 9285, 10862, 12077, 10347, 8860, 10626, 11898, 10294, 9031, 10487, 11994, 10379, 9007, 10603, 11812, 10572, 9044, 10279, 11910, 10436, 8959, 10255, 11888, 10732, 9100, 10292, 11772, 10737, 9077, 9976, 11661, 10766, 9065, 10147, 11756, 10398, 8884, 9628, 11302, 10661, 8693, 9654, 11363, 10561, 8765, 9468, 11492, 10678, 8609, 9197, 11291, 10611, 8608, 9292, 11031, 10575, 8766, 9092, 11040, 10446, 8313, 9031, 10889, 10404, 8723, 8974, 10943, 10577, 8405, 8800, 10742, 10367, 8580, 8739, 10491, 10276, 8344, 8514, 10486, 10390, 8277, 8335, 10402, 10286, 8370, 8339, 10169, 10539, 8589, 8233, 10433, 10586, 8461, 8480, 10483, 10644, 8586, 8114, 10364, 10721, 8557, 8124, 10001, 10615, 8576, 7979, 9944, 10559, 8528, 7863, 9989, 10449, 8665, 8042, 9709, 10599, 8833, 8058, 9967, 10741, 8769, 8124, 9990, 10652, 8803, 7891, 9722, 10767, 9207, 8123, 9913, 11069, 9274, 8372, 9989, 11023, 9429, 8230, 9939, 11020, 9456, 8318, 9638, 11019, 9375, 8198, 9733, 10854, 9884, 8367, 9782, 11510, 9929, 8362, 9699, 11117, 9826, 8508, 9786, 11278, 10128, 8446, 9667, 11517, 10147, 8473, 9617, 11097, 10457, 8796, 9508, 11514, 10592, 8789, 9834, 11443, 10375, 8698, 9638, 11487, 10617, 8869, 9811, 11540, 10877, 8985, 9783, 11769, 11038, 9239, 9968, 11868, 10922, 9112, 9885, 11632, 11157, 9296, 9854, 11882, 11255, 9315, 9804, 11630, 11283, 9392, 9700, 11466, 11170, 9286, 9553, 11593, 11199, 9068, 9383, 11538, 11341, 9190, 9270, 11271, 11177, 9256, 9118, 11049, 11371, 9368, 9074, 11055, 11356, 9262, 9030, 11049, 11211, 9275, 8729, 10739, 11258, 9149, 8735, 10737, 11197, 9129, 8638, 10472, 10844, 9044, 8419, 10180, 10892, 9147, 8421, 10143, 10905, 9011, 8093, 10060, 10739, 8763, 7911, 9679, 10561, 8699, 7791, 9379, 10478, 8718, 7433, 9489, 10545, 8509, 7523, 9288, 10223, 8433, 7375, 9202, 10159, 8466, 7484, 9016, 10225, 8574, 7277, 8897, 10027, 8401, 7128, 8728, 10086, 8560, 7318, 8629, 9879, 8638, 7245, 8693, 10262, 8852, 7309, 8581, 10130, 8926, 7354, 8733, 10300, 8868, 7379, 8652, 10195, 9055, 7401, 8270, 9943, 9254, 7479, 8443, 10370, 9536, 7593, 8365, 10381, 9443, 7702, 8539, 10277, 9631, 7831, 8529, 10365, 9909, 8081, 8752, 10751, 9986, 8133, 8558, 10412, 10121, 8253, 8805, 10754, 10333, 8216, 8625, 10847, 10680, 8623, 8945, 11188, 10730, 8995, 9330, 11075, 11040, 8888, 9084, 11189, 11073, 9033, 9102, 11459, 11266, 9058, 9164, 11242, 11430, 9509, 9527, 11405, 11616, 9816, 9367, 11478, 11895, 9819, 9660, 11604, 12012, 10064, 9503, 11553, 12196, 10256, 9664, 11808, 12314, 10480, 10133, 11714, 12316, 10669, 9986, 11885, 12752, 10866, 10177, 12146, 12954, 11251, 10386, 12145, 13038, 11206, 10110, 12113, 13247, 11280, 10430, 12076, 13095, 11430, 10115, 11864, 13137, 11407, 10096, 11747, 13046, 11486, 10209, 11624, 12847, 11358, 10060, 11593, 12819, 11597, 10179, 11188, 12953, 11602, 10025, 11418, 12771, 11528, 10066, 11401, 12833, 11391, 9805, 10975, 12567, 11331, 9396, 10515, 12258, 10988, 9329, 10534, 12182, 10927, 9251, 10265, 11903, 10897, 9014, 10007, 11848, 10971, 9099, 9758, 11502, 10856, 8936, 9451, 11525, 10817, 8703, 9499, 11456, 10659, 8773, 9289, 11209, 10740, 8597};
//		for(int i=0;i<6;i++){
//			list.add(dd);
//		}
//		datasets.setData(list);
		/*
		 * 1. 관측소 리스트를 받음(NC&CJ/PP&WP)
		 * 2. 관측소 타입에 따라 자유장(가속도/속도) / 자유장,하부,상부의 각 센터 데이터(JSON String 2라인이므로 통합)를 VO에 String으로 저장
		 * 3. VO에 넣어 페이지로 리턴하고 해당 페이지에서 각 메뉴에 맞게 데이터를 입력하여 그래프 출력.
		 *  -> 이후 지진, 자체, 수동 각 이벤트별 기능에 맞게 수정
		 */
		Gson gson = new Gson();
		ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json "+File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+"2017213"+File.separator+"KA"+File.separator+"KN_KAG_HGZ_20170626171040.mseed", 0);
		List<String> lines = result.getLines();
		String jsonTxt = "";
		for(int x = 0 ; x < lines.size() ; x ++){
			jsonTxt += lines.get(x);
		}
		List<WaveDataMainVO> dataVO = new ArrayList<WaveDataMainVO>(Arrays.asList(gson.fromJson(jsonTxt, WaveDataMainVO[].class)));
		System.out.println(lines.size());
		//실서버 업로드시 해제
		list.add(""+lines.size());
		datasets.setData(dataVO);
		
				
		return datasets;
	}		
	@RequestMapping("/getSelfEventList.ws")
	public @ResponseBody ResponseDataListVO getSelfEventList(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{
		ResponseDataListVO datasets = new ResponseDataListVO();
		String date = sch_data.get("date").toString();
		String date2 = sch_data.get("date2").toString();
		String obs_kind = sch_data.get("obs_kind").toString();
		String sta_type = sch_data.get("sta_type").toString();
		String page = (String) sch_data.get("page").toString();
		
		
		
		List<List<Object>> results = quakeInfoService.getSelfEventList(date,date2, obs_kind, sta_type, page);
		
		if(results != null && results.size() != 0)
		{
			List<SelfEventListVO> list = getDataset(results, 0);
			
			datasets.setData(list);
			datasets.setTotalDataCount((String) results.get(1).get(0).toString());
		}
		
		return datasets;
	}
	@RequestMapping("/getWaveReportData.ws")
	public @ResponseBody ResponseDataListVO getWaveReportData(@RequestBody Map<String, String> sch_data, HttpServletRequest request)throws Exception
	{	
		ResponseDataListVO datasets = new ResponseDataListVO();
		
		return datasets;
	}

	
	/**
	 *
	 * <pre>
	 * 1. 媛쒖슂 : result ���щ윭媛��쇰븣 �ъ슜
	 * 2. 泥섎━�댁슜 : result ���щ윭媛��쇰븣 �ъ슜
	 * </pre>
	 *
	 * @Author	: User
	 * @Date	: 2015. 6. 9.
	 * @Method Name : getDataset
	 * @param datasets
	 * @param index
	 * @return
	 */
	protected <T> List<T> getDataset(List<List<Object>> datasets, int index)  throws Exception{
		return (List<T>) datasets.get(index);
	}
	
    /**
     * 두 지점간의 거리 계산
     *
     * @param lat1 지점 1 위도
     * @param lon1 지점 1 경도
     * @param lat2 지점 2 위도
     * @param lon2 지점 2 경도
     * @param unit 거리 표출단위
     * @return
     */
    private int distance(double lat1, double lon1, double lat2, double lon2) {
        int R = 6371;//km
        
        double dLat = deg2rad(lat2-lat1);
        double dLon = deg2rad(lon2-lon1);
        
        double a = Math.sin(dLat/2)*Math.sin(dLat/2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
        Math.sin(dLon/2) * Math.sin(dLon/2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        double d = R * c;
        
        return (int) Math.floor(d);
    }
     
 
    // This function converts decimal degrees to radians
    private static double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }
     
    // This function converts radians to decimal degrees
    private static double rad2deg(double rad) {
        return (rad * 180 / Math.PI);
    }

}
