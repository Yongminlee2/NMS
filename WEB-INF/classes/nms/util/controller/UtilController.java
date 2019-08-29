package nms.util.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nms.quakeoccur.service.QuakeInfoService;
import nms.quakeoccur.vo.MailVO;
import nms.quakeoccur.vo.QuakeEventReportVO;
import nms.quakeoccur.vo.SelfEventListVO;
import nms.system.service.AccessService;
import nms.system.service.UserService;
import nms.system.vo.AccessVO;
import nms.system.vo.UserInfoVO;
import nms.util.ExcelFnc;
import nms.util.Execute;
import nms.util.Execute.ExecResult;
import nms.util.ShellCmdReading;
import nms.util.service.UtilService;
import nms.util.vo.CodeVO;
import nms.util.vo.ResponseDataListVO;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
/**
 * �먯＜ �ъ슜�섎뒗 �뺣낫�ㅼ쓽 �몄텧���ъ슜�섎뒗 Controller �대옒��
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
@Controller
public class UtilController {
	private static final Logger logger = LoggerFactory.getLogger(UtilController.class);
	public static HashMap<String, List<?> > CODE_MAP;
	public static HashMap<String, List<?> > STATION_MAP;
	public static List<AccessVO> ACCESS_MAP;
	
	@Resource(name = "userService")
	private UserService userService;
	@Resource(name = "utilService")
	private UtilService utilService;
	@Resource(name = "accessService")
	private AccessService accessService;
	@Autowired
	QuakeInfoService quakeInfoService;
	
	@PostConstruct
	public void PostConstruct() throws Exception
	{
		CODE_MAP = setCodeMap();
		STATION_MAP = setStationMap();
		ACCESS_MAP = setPageAccessInfo();
		utilService.setStationSensorTable();
	}
	
	/*
	 * 일반 관측소 정보 셋팅
	 * */
	public HashMap<String, List<?>> setStationMap() throws Exception
	{
		logger.info("Create Station Data Station Map!!");
		
		STATION_MAP = new HashMap<>();
		STATION_MAP.put("stationInfo", utilService.getStationInfo());
		STATION_MAP.put("stationofsensor", utilService.getStationOfSensorInfo());
		STATION_MAP.put("stationofsensor2", utilService.getStationOfSensorInfo2());
		STATION_MAP.put("stationNames", utilService.getStationNames());
		
		return STATION_MAP;
		 
	}
	
	public List<AccessVO> setPageAccessInfo() throws Exception
	{
		logger.info("Create Access Info Map !!");
		ACCESS_MAP = null ;
		ACCESS_MAP = accessService.getAccessList();
		
		return ACCESS_MAP;
	}
	
	/*
	 * 코드 정보 셋팅
	 * */
	public HashMap<String, List<?>> setCodeMap() throws Exception
	{
		CODE_MAP = new HashMap<>();
		logger.info("Create Code Data Code Map!!");
		String mainCode = "";
		
		List<CodeVO> codeInfoList = utilService.getCodeInfoList();
		
		List<CodeVO> codeGroup = new ArrayList<CodeVO>();
		int index = 0;
		for (CodeVO codeVO : codeInfoList) {
			
			if(mainCode.equals(codeVO.getMainCode()))
			{
				codeGroup.add(codeVO);
				
				if(codeInfoList.size() -1 == index)
				{
					CODE_MAP.put(mainCode, codeGroup);
				}
			}
			else
			{
				
				CODE_MAP.put(mainCode, codeGroup);
				codeGroup = new ArrayList<CodeVO>();
				codeGroup.add(codeVO);
				
			}
			
			mainCode = codeVO.getMainCode();
			index ++;
		}
		
		return CODE_MAP;
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
    private static double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }
     
    // This function converts radians to decimal degrees
    private static double rad2deg(double rad) {
        return (rad * 180 / Math.PI);
    }
	@RequestMapping(value = "/getTest.do", method = RequestMethod.POST)
	public String getTest(@RequestBody String json, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		Gson gson = new Gson();
		json = URLDecoder.decode(json,"utf-8");
		json = json.split("}")[0]+"}";
		
		MailVO mail = gson.fromJson(json,MailVO.class);
		
		String type = mail.getSiteType();
		String no = mail.getDbKey();
		String flag = mail.getFromEvent();
		
		userService.sendMail(no, "testtest",(flag.equals("NEMA")?"K":"H"));
		return "abc";
		
	}
  
	@RequestMapping(value = "/getMailSendTest.do", method = RequestMethod.POST)
	public String getMailSendTest(@RequestBody String json,HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		ExcelFnc excel = new ExcelFnc();
		
//		Gson gson = new Gson();
//		json = URLDecoder.decode(json,"utf-8");
//		json = json.split("}")[0]+"}";
//		MailVO mail = gson.fromJson(json,MailVO.class);
		/**
		 * 엑셀 제작. 
		 */
		System.out.println("진입확인"+json);
		String ret =  "ok";
		try{
			excel.sendMailNoFile(json);
		} catch(Exception e){
			System.out.println("Controller Mail Send Error");
			ret = "fail";
		}
		
		long saveTime = System.currentTimeMillis();
		long currTime = 0;
		while( currTime - saveTime < 5000){
			currTime = System.currentTimeMillis();
		}
		
		return ret;
	}
	
	@RequestMapping(value = "/getMailSend.do", method = RequestMethod.POST)
	public String getMailSend(@RequestBody String json, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		ExcelFnc excel = new ExcelFnc();
		Gson gson = new Gson();
		String folder = request.getSession().getServletContext().getRealPath("/excel");
		System.out.println(json);
		json = URLDecoder.decode(json,"utf-8");
		json = json.split("}")[0]+"}";
		File excelFile = null;
//		userService.getUserList(searchVO)
		MailVO mail = gson.fromJson(json,MailVO.class);
		String type = mail.getSiteType();
		String no = mail.getDbKey();
		String flag = mail.getFromEvent();
		List<UserInfoVO> sendMailMember = userService.sendMailMember(type);
		logger.info("sendMemberCount : "+sendMailMember.size());

		if(sendMailMember.size() > 0){
			for(UserInfoVO u : sendMailMember)
			{
				logger.info("sendMember : "+u.getEmail());
			}
		}
		
		String mailName = (type.equals("NC")?"원전":(type.equals("WP")?"수력":"양수"));
		
		if(sendMailMember.size() > 0){
			if(flag.equals("NEMA")){
				String fileName = "";
		
				if(type.equals("NC")){
					fileName = folder+File.separator+"quakeSimple.xls";
				}else{
					fileName = folder+File.separator+"quakeSimple_HP.xls";
				}
				
				
				
				QuakeEventReportVO quakeReportData = quakeInfoService.getQuakeReportData(no);
				
				mailName = "지진_"+quakeReportData.getReq_id()+"_"+quakeReportData.getFull_date()+"_"+"규모"+quakeReportData.getMag();
				excel.copyExcel(fileName, folder+File.separator+mailName+".xls");	
				
				String replaceWord = getReplaceWord(type);
				List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeSummaryReportDataAll(replaceWord, type);
				List<QuakeEventReportVO> quakeReportHistoryData = quakeInfoService.getQuakeReportHistoryData("5",quakeReportData.getDate(),quakeReportData.getTime());
				
				double lat = quakeReportData.getLat();
				double lon = quakeReportData.getLon();
				
//				try{
//	//				ExecResult result2 = Execute.execCmd("python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"test",1);
//					ExecResult result2 = Execute.execCmd("python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+no,1);
//				}catch(Exception e){
//					
//				}
				
				System.out.println("going...");
				byte[] img1 = null;
				File imgCheck = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no+".jpg");
				try{
					if(!imgCheck.isFile()){
//						/usr/local/anaconda2/bin/
						ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no,1);
					}
				}catch(Exception e){
					System.out.println("지도 이미지 에러");
					
				}
				img1 = Files.readAllBytes(Paths.get(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+type+"_"+no+".jpg"));
				System.out.println(folder+File.separator+mailName+".xls");
				System.out.println("구간 체크 1");
				
				excelFile = new File(folder+File.separator+mailName+".xls");
				HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
				HSSFSheet sheetAt = wb.getSheetAt(0);
				
				System.out.println("구간 체크 1 - 2");
				//def_KHNP.jpg
				
				/*이미지 파일 생성시 img1에 데이터를 못받는 경우 기본 이미지로 들어가도록함.*/
				if(img1 == null){
					System.out.println("Defult Image");
					img1 = Files.readAllBytes(Paths.get(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"def_KHNP.jpg"));
					System.out.println(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"def_KHNP.jpg");
				}
				
				if(type.equals("NC")){
					excel.setImage(wb, sheetAt, 2, 5, 10, 16, img1);
					
				}else{
					excel.setImage(wb, sheetAt, 2, 5, 10, 20, img1);
				}
				
				System.out.println("구간 체크 1 - 3");
				
				System.out.println("구간 체크 2");
				
				HSSFCellStyle cellStyle = null;
				HSSFCell valueCell = null;
				
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
				
		
				
				System.out.println("구간 체크 3");
				String epochTime = quakeReportData.getEpoch_time();
				String delayTime = quakeReportData.getDelay_time();
				String fullDate = quakeReportData.getFull_date();
				String year = fullDate.split("-")[0];
				String month =fullDate.split("-")[1];
				String day = fullDate.split("-")[2];
		
				int row = 11;
				int col = 5;
				int imgRow = 19;
				int imgCol = 2;
				
				int graRow = 4;
				int graCol = 14;
				
				for(QuakeEventReportVO q : quakeReportDataAll)// 12 5
				{	
					System.out.println("구간 체크 루프");
					row++;
					System.out.println(row);
					col = 5;
					double lat2 = q.getLat();
					double lon2 = q.getLon();
					q.setKmeter(""+distance(lat2, lon2, lat, lon));
					//실서버 업로드시 제거
					logger.debug("::::::::::::::::::::::::::::::::::::::::::::: Join Check ::::::::::::::::::::::::::::: ");
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
						logger.info(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma");
//						ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma",0);
						ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id(),0);
	//					ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_KAG_"+year+month+day+".mma",0);
						List<String> lines = result.getLines();
						
						q = ShellCmdReading.shellCmd(lines,q);
						
						logger.debug("check data ::::::::::::::::::::::::::::: "+q.getMax_z());
	
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
						logger.debug("check data2 ::::::::::::::::::::::::::::: "+q.getMax_n());
						if(type.equals("NC")){
							String fPath = File.separator+"data"+File.separator+"HSGEO"+File.separator+"remoteseg"+File.separator+quakeReportData.getReq_id()+File.separator;
							
							String m2j = File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"mseed2json ";
							String date = quakeReportData.getReq_date().replaceAll(":", "").replaceAll("-","").replaceAll(" ", "");
	//						String fPathEtn = date.substring(0,date.length()-2)+".mseed";
							String fPathEtn = "*.mseed";
							
	//						q = getGraphData(q,m2j+fPath+"KA"+File.separator+q.getNet()+"_KAG_","_"+fPathEtn,"NC","g1");
							q = getGraphData(q,m2j+fPath+q.getObs_id()+File.separator+q.getNet()+"_"+q.getSen_id()+"_","_"+fPathEtn,"NC","g1");
							byte[] tempImg = Files.readAllBytes(Paths.get(fPath+"NC"+File.separator+"imgSP"+File.separator+q.getSen_id()+"_response_spectrum.png"));
	//						byte[] tempImg = Files.readAllBytes(Paths.get(fPath+"NC"+File.separator+"imgSP"+File.separator+"KAG_response_spectrum.png"));
							
							try{
								if(q.getAc100_z().indexOf("error") < 0 ){
							        String string = q.getAc100_z().split("values")[1];
							        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
							        String[] split = substring.split(",");
							        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
									excel.drawDayChart(wb, sheetAt, split, graRow, graRow+5, graCol, graCol+7);
								}
								graRow+=5;//9
								if(q.getAc100_n().indexOf("error") < 0 ){
							        String string = q.getAc100_n().split("values")[1];
							        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
							        String[] split = substring.split(",");
							        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
									excel.drawDayChart(wb, sheetAt, split, graRow, graRow+5, graCol, graCol+7);
								}
								graRow+=5; // 14
								if(q.getAc100_e().indexOf("error") < 0 ){
							        String string = q.getAc100_e().split("values")[1];
							        String substring = string.substring(3,string.length()-5).replaceAll(" ","");
							        String[] split = substring.split(",");
							        logger.debug("row & col ::::::::::::::::::::: "+graRow+" :::::::::::::::::::::::::::::::"+graCol);
									excel.drawDayChart(wb, sheetAt, split, graRow, graRow+5, graCol, graCol+7);
								}	
								
								if(graRow==14 && graCol == 14){
									graRow = 4;
									graCol = 22;
								}else if(graRow==14 && graCol ==22){
									graRow = 20;
									graCol = 14;
								}else if(graRow==30 && graCol == 14){
									graRow = 20;
									graCol = 22;
								}
							}catch(Exception e){
								logger.debug("Error1"+e.toString());
							}
							
				
							cellStyle = sheetAt.getRow(imgRow-1).getCell(imgCol).getCellStyle();
							valueCell = sheetAt.getRow(imgRow-1).createCell(imgCol);
							valueCell.setCellValue(q.getSen_id());
							valueCell.setCellStyle(cellStyle);	
							
							excel.setImage(wb, sheetAt, imgCol, imgCol+5, imgRow, imgRow+4, tempImg);
							if(imgRow == 24 && imgCol == 7){
								imgRow = 19;
								imgCol = 2;
							}else if(imgCol== 2){
								imgCol = 7;
							}else{
								imgRow = 24;
								imgCol = 2;
							}
	
						}
						
					} catch (Exception e) {
						// TODO: handle exception
						logger.debug("Error"+e.toString());
					}
					
				}
				
				System.out.println("구간 체크 5");
				cellStyle = sheetAt.getRow(6).getCell(11).getCellStyle();
				valueCell = sheetAt.getRow(6).createCell(11);
				valueCell.setCellValue(quakeReportData.getMag());
				valueCell.setCellStyle(cellStyle);
				
				
				if(type.equals("NC")){
					row = 31;
				}else{
					row = 23;
				}
				
				System.out.println("size : "+quakeReportHistoryData.size());
				int cntr = 1;
				for(QuakeEventReportVO q : quakeReportHistoryData) // 31 
				{
					if(cntr < 5){
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
					row++;
					cntr++;
					}
				}
		        FileOutputStream fileOut = new FileOutputStream(excelFile);
		        wb.write(fileOut);
		        fileOut.close();
			}else{
				String replaceWord = getReplaceWord(type);
				SelfEventListVO eventReportData = quakeInfoService.getSelfReportData(replaceWord, no);
				mailName = "자체_"+no+"_"+eventReportData.getFull_date();
				String fileName = folder+File.separator+"manualReport.xls";
				excel.copyExcel(fileName, folder+File.separator+mailName+".xls");
				excelFile = new File(folder+File.separator+mailName+".xls");
				
				HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
				HSSFSheet sheetAt = wb.getSheetAt(0);
				
				System.out.println(replaceWord+","+ no);
				List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeReportDataAll(replaceWord, type);
				
				
				HSSFCellStyle cellStyle = null;
				HSSFCell valueCell = null;
	
				
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
				String delayTime = eventReportData.getDelay_time();
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
	//				ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_"+s.getSen_id()+"_20170622.mma",0);
//						ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+s.getSen_id()+"_"+year+month+day+".mma",0);
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
				
		        FileOutputStream fileOut = new FileOutputStream(excelFile);
		        wb.write(fileOut);
		        fileOut.close();
			}
			
			
			
			/**
			 * 엑셀 제작. 
			 */
			
			int cnt = 1;
//			logger.info("Start cnt : "+cnt);
//			for(UserInfoVO user : sendMailMember){
//			String[] mails = {"kplee@hsgeo.co.kr","tjpark@dodo1.co.kr"};
			int fSize = sendMailMember.size();
			logger.info("sendMemberCount : "+fSize);
			
			for(int i = 0; i < fSize;i++){
				logger.info("cnt : "+i);
				logger.info("sendMemberTotalCount : "+fSize);
				excel.sendMail(sendMailMember.get(i).getEmail(), folder+File.separator+mailName+".xls",mailName+".xls",type);
//				excel.sendMail(mails[i], folder+File.separator+mailName+"통보.xls",mailName+"통보.xls");
				long saveTime = System.currentTimeMillis();
				long currTime = 0;
				while( currTime - saveTime < 3000){
					currTime = System.currentTimeMillis();
				}
//				logger.info("no : "+no+" , id : "+ user.getId() + " , key" +flag);
				logger.info("no : "+no+" , id : "+ sendMailMember.get(i).getEmail() + " , key" +flag);
				
				userService.sendMail(no, sendMailMember.get(i).getId(),(flag.equals("NEMA")?"K":"H"));
				
				logger.info("cnt : "+i);
				logger.info("sendMemberTotalCount-end : "+fSize);
			}
			
			long saveTime = System.currentTimeMillis();
			long currTime = 0;
			while( currTime - saveTime < 3000){
				currTime = System.currentTimeMillis();
			}
			
			excelFile.delete();
			return "success";
		}else {
			System.out.println("Send member not found");
			return "no send member";
		}
		
	}
	
	/**
	 * 회원 정보를 입력 또는 수정한다.
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main/InsertMember.ws")
	public @ResponseBody ResponseDataListVO InsertMember(@RequestBody UserInfoVO userVO, HttpServletRequest request) throws Exception{
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnValue = "success";
		userVO.setPw(BCrypt.hashpw(userVO.getPw(), BCrypt.gensalt()));
		userVO.setType("new");
		userVO.setTmp2((userVO.getTmp2().equals("on")?"y":"n"));
		userVO.setTmp3((userVO.getTmp3().equals("on")?"y":"n"));
		System.out.println("Insert Member Main");
		try {
			userService.InsertMember(userVO);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnValue = "fail";
		}
		responseVO.setResultDesc(returnValue);
//		System.out.println(ac.get(0).getM1());
//		for(AccessVO a : accessVO)
//		{
//			System.out.println(a.getM1());
//		}
		return responseVO;
	}
	public String putStr(List<String> s ){
		String rTxt = "";
		for(int i =0; i<s.size();i++){
			rTxt += s.get(i);
		}
		return rTxt;
	}
	public QuakeEventReportVO getGraphData(QuakeEventReportVO q,String fPath,String bPath,String org,String type) throws Exception{
		try{
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
					q.setG_z(putStr(Execute.execCmd(fPath+"G_HGZ"+bPath, 0).getLines()));
					q.setG_n(putStr(Execute.execCmd(fPath+"G_HGN"+bPath, 0).getLines()));
					q.setG_e(putStr(Execute.execCmd(fPath+"G_HGE"+bPath, 0).getLines()));
					q.setB_z(putStr(Execute.execCmd(fPath+"B_H"+stationCode+"Z"+bPath, 0).getLines()));
					q.setB_n(putStr(Execute.execCmd(fPath+"B_H"+stationCode+"Y"+bPath, 0).getLines()));
					q.setB_e(putStr(Execute.execCmd(fPath+"B_H"+stationCode+"X"+bPath, 0).getLines()));			
					//HPY,X
					if(cnt > 2){
						q.setM_n(putStr(Execute.execCmd(fPath+"M_H"+stationCode+"Y"+bPath, 0).getLines()));
						q.setM_e(putStr(Execute.execCmd(fPath+"M_H"+stationCode+"X"+bPath, 0).getLines()));
					}
					if (cnt > 3){
						q.setR_n(putStr(Execute.execCmd(fPath+"R_H"+stationCode+"Y"+bPath, 0).getLines()));
						q.setR_e(putStr(Execute.execCmd(fPath+"R_H"+stationCode+"X"+bPath, 0).getLines()));
					}
					//HPX,Y
				}
			}else{
				q.setG_z(putStr(Execute.execCmd(fPath+"HGZ"+bPath, 0).getLines()));
			}
		}catch(Exception e){
			
		}
		return q;
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
		rMap.put("maxValue", ""+bd.setScale(6,BigDecimal.ROUND_CEILING));
		
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
}
