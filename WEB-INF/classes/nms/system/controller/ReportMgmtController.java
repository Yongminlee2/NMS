package nms.system.controller;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import nms.board.vo.BoardVO;
import nms.sec.AccessUserInfoManager;
import nms.system.service.ObservatoryService;
import nms.system.service.RecorderService;
import nms.system.service.ReportMgmtService;
import nms.system.service.SensorService;
import nms.system.vo.InitReportMainVO;
import nms.system.vo.InitReportRecorderVO;
import nms.system.vo.InitReportSensorVO;
import nms.system.vo.MaintenanceReportVO;
import nms.system.vo.ObservatoryVO;
import nms.system.vo.RecorderVO;
import nms.system.vo.ReportMgmtVO;
import nms.system.vo.ReturnDataVO;
import nms.system.vo.SensorVO;
import nms.system.vo.StationInfoVO;
import nms.util.DateSetting;
import nms.util.controller.UtilController;
import nms.util.service.FileService;
import nms.util.vo.ResponseDataListVO;
import nms.util.vo.SearchDataVO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/system/report")
public class ReportMgmtController {
	private static final Logger logger = LoggerFactory.getLogger(ObservatoryController.class);
	
	@Resource(name = "observatoryService")
	private ObservatoryService observatoryService;
	
	@Resource(name = "sensorService")
	private SensorService sensorService;
	
	@Resource(name = "recorderService")
	private RecorderService recorderService;	
	
	@Resource(name = "reportMgmtService")
	private ReportMgmtService reportMgmtService;	
	@Resource(name = "fileService")
	private FileService fileService;
	
	@RequestMapping(value = "/list")
	public String list(Model model,HttpServletRequest request) throws Exception{
		logger.info("Join Info List!");
		SearchDataVO search = new SearchDataVO();
//		
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
		
		if(request.getParameter("startDate")==null)
		{
			search.setStartDate(DateSetting.getbeforeDate(730));
			search.setEndDate(DateSetting.getbeforeDate(0));
			
		}else{
			search.setStartDate(request.getParameter("startDate"));
			search.setEndDate(request.getParameter("endDate"));
		}
		
		model.addAttribute("codeMap", UtilController.STATION_MAP);
		List<ReportMgmtVO> reportList = reportMgmtService.getReportList(search);
		System.out.println(reportList.get(0).getObs_kind());
		int totalCnt = reportMgmtService.getReportListTotalCnt(search);
		System.out.println("totalCnt  : "+totalCnt);
		if(reportList.size()>1){
			reportList.get(0).setTotalCnt(totalCnt);
			reportList.get(0).setCurrentPage(page);
			reportList.get(0).setStDate(search.getStartDate());
			reportList.get(0).setEnDate(search.getEndDate());
			model.addAttribute("pagingInfo",reportList.get(0));
		}else{
			model.addAttribute("pagingInfo",new ReportMgmtVO());
		}
//		System.out.println(infoList.get(0).getBoard_title());
//		System.out.println(totalCnt);
//		
		model.addAttribute("reportList", reportList);
		model.addAttribute("totalCnt",totalCnt);
		
		return "/system/reportMgmt/list";
	}
	
	/**
	 * 관리대장 상세 팝업을 호출한다.
	 * @param model
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popupMgmt")
	public String popupMgmt(Model model,@ModelAttribute("l_no")String l_no) throws Exception{
//		System.out.println(l_no);
//		System.out.println("sta_no : "+sta_no);
		SearchDataVO search = new SearchDataVO();
		search.setSearchKeyword(l_no);
		
		ObservatoryVO observatoryVO = (ObservatoryVO) observatoryService.getStationMngInfoList(search).get(0);
		List<SensorVO> sensorList = sensorService.getSensorMngList(l_no);
		List<RecorderVO> recorderList = recorderService.getRecorderMngList(l_no);
		
//			if(history.equals("y")){
//				stationHistoryList = observatoryService.getStationHistoryList(sta_no);
//			}else{
//				stationHistoryList = observatoryService.getStationHistoryList(obs_id);
//				
//			}
		
		model.addAttribute("status","mody");
		
		model.addAttribute("stationInfo",observatoryVO);
//			model.addAttribute("stationHistory",stationHistoryList);
		
		model.addAttribute("senCnt", sensorList.size());
		model.addAttribute("sensorList",sensorList);
		model.addAttribute("recCnt", recorderList.size());
		model.addAttribute("recorderList",recorderList);
		
		return "/system/reportMgmt/popup/MgmtPopup";
	}
	
	
	
	/**
	 * 초기점검보고서 상세 팝업을 호출한다.
	 * @param model
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popupInit")
	public String popupInit(Model model,@ModelAttribute("l_no")String l_no) throws Exception{
//		System.out.println(l_no);
		model.addAttribute("reportMain",reportMgmtService.getReport_a(l_no));
		List<InitReportSensorVO> report_b = reportMgmtService.getReport_b(l_no);
		List<InitReportRecorderVO> report_c = reportMgmtService.getReport_c(l_no);
		model.addAttribute("sen_cnt",report_b.size());
		model.addAttribute("rec_cnt",report_c.size());
		for(int i=1;i<=5;i++)
		{	
//			System.out.println(i);
			if(i<=report_b.size()){
				model.addAttribute("sen_"+i,report_b.get(i-1));
			}else{
				model.addAttribute("sen_"+i,new InitReportSensorVO());
			}
		}
		for(int i=1;i<=3;i++)
		{	
//			System.out.println(i);
			if(i<=report_c.size()){
				model.addAttribute("rec_"+i,report_c.get(i-1));
			}else{
				model.addAttribute("rec_"+i,new InitReportRecorderVO());
			}
		}
		return "/system/reportMgmt/popup/InitPopup";
	}
	
//	@RequestMapping(value = "/getInitData.ws")
//	public @ResponseBody String SendInitReportData(@RequestBody String l_no) throws Exception{
////		System.out.println(l_no);
//		try {
//			
//		} catch (Exception e) {
//			// TODO: handle exception
//		}
//		String sendData = "";
//		InitReportMainVO report_a = reportMgmtService.getReport_a(l_no);
//		List<InitReportSensorVO> report_b = reportMgmtService.getReport_b(l_no);
//		List<InitReportRecorderVO> report_c = reportMgmtService.getReport_c(l_no);
//		
//
//		sendData  = "rpt_date :"+""+" \n";
//		sendData += "net :"+""+" \n";
//		sendData += "obs_id :"+""+" \n";
//		sendData += "obs_name :"+""+" \n";
//		sendData += "contractdate :"+""+" \n";
//		sendData += "completedate :"+""+" \n";
//		sendData += "price_contract :"+""+" \n";
//		sendData += "price_sw :"+""+" \n";
//		sendData += "price_hw :"+""+" \n";
//		sendData += "opendate :"+""+" \n";
//		sendData += "offdate :"+""+" \n";
//		sendData += "area :"+""+" \n";
//		sendData += "address :"+""+" \n";
//		sendData += "obs_kind :"+""+" \n";
//		sendData += "position :"+""+" \n";
//		sendData += "lon :"+""+" \n";
//		sendData += "lat :"+""+" \n";
//		sendData += "altitude :"+""+" \n";
//		sendData += "ground_ht :"+""+" \n";
//		sendData += "uground_ht :"+""+" \n";
//		sendData += "base :"+""+" \n";
//		sendData += "str_cd :"+""+" \n";
//		sendData += "seis_cd :"+""+" \n";
//		sendData += "ground :"+""+" \n";
//		sendData += "hole :"+""+" \n";
//		sendData += "seis_ds  :"+""+" \n";
//		sendData += "design_acc :"+""+" \n";
//		sendData += "threshold_acc :"+""+" \n";
//		sendData += "build_floor :"+""+" \n";
//		sendData += "eq_area :"+""+" \n";
//		sendData += "hole_map :"+""+" \n";
//		sendData += "charge :"+""+" \n";
//		sendData += "contact :"+""+" \n";
//		sendData += "sen_count :"+""+" \n";
//
//		
//		sen_map.put("sensors", report_b);
//		rec_map.put("recorders",report_c);
//		
//		reVO.setDatas(sen_map);
//		reVO.setDatas2(rec_map);
//		
//		
//		return reVO;
//	}	
	
	/**
	 * 정기점검보고서 상세 팝업을 호출한다.
	 * @param model
	 * @param sta_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popupMtn")
	public String popupMtn(Model model,@ModelAttribute("l_no")String l_no) throws Exception{
//		System.out.println(l_no);
		MaintenanceReportVO maintenanceReport = reportMgmtService.getMaintenanceReport(l_no);
//		MaintenanceReportVO maintenanceReport = reportMgmtService.getMaintenanceReport("1");
		if(maintenanceReport==null){
			model.addAttribute("report",new MaintenanceReportVO());
		}else{
			model.addAttribute("report",maintenanceReport);
		}
		return "/system/reportMgmt/popup/MtnPopup";
	}
	
	@RequestMapping(value = "/insertReport.ws")
	public @ResponseBody ResponseDataListVO insertReport(@RequestBody String str, HttpServletRequest request) throws Exception{
		String[] strs = str.split("&");
		ResponseDataListVO responseVO = new ResponseDataListVO();
		String returnVal = "success";
		System.out.println(strs.toString());
		try {
			int insertReport = reportMgmtService.insertReport(strs[1],AccessUserInfoManager.getUserID(),strs[0]);
			System.out.println(insertReport);
			int[] rInt = {insertReport};
			responseVO.setData(rInt);
		} catch (Exception e) {
//			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		responseVO.setResultDesc(returnVal);
		return responseVO;
	}
	
	@RequestMapping(value = "/sensorInsert.ws")
	public @ResponseBody ResponseDataListVO insertSensor(@RequestBody String jsonStr, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		ResponseDataListVO responseVO = new ResponseDataListVO();
		System.out.println(jsonStr);
		try {
			sensorService.insertReportSensor(jsonStr);
			responseVO.setResultDesc("success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			responseVO.setResultDesc("fail");

		}
		return responseVO;
	}	
	@RequestMapping(value = "/sensorDelete.ws")
	public @ResponseBody ResponseDataListVO deleteSensor(@RequestBody String sen_no, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		int deleteSensor = sensorService.deleteReportSensor(sen_no);
		ResponseDataListVO responseVO = new ResponseDataListVO();
		
//		responseVO.setResultDesc("success");
		return responseVO;
	}	
	@RequestMapping(value = "/recorderInsert.ws")
	public @ResponseBody ResponseDataListVO insertRecorder(@RequestBody String jsonStr, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		ResponseDataListVO responseVO = new ResponseDataListVO();
		System.out.println(jsonStr);
		try {
			recorderService.insertReportRecorder(jsonStr);
			responseVO.setResultDesc("success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			responseVO.setResultDesc("fail");

		}
		return responseVO;
	}
	
	@RequestMapping(value = "/recorderDelete.ws")
	public @ResponseBody ResponseDataListVO deleteRecorder(@RequestBody String rec_no, HttpServletRequest request) throws Exception{
//		System.out.println(recVO.get(0).getObs_id());
		ResponseDataListVO responseVO = new ResponseDataListVO();
		try {
			int dR = recorderService.deleteReportRecorder(rec_no);
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
	
	@RequestMapping(value = "/update.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO updateObseratory(@RequestBody ObservatoryVO obVO, HttpServletRequest request) throws Exception
	{	
		System.out.println("station");
		System.out.println(obVO.getSta_no());
		String returnVal = "success";
		try {
			observatoryService.updateReportStation(obVO);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		
		return responseVO;
	}
	
	@RequestMapping(value = "/updateMaintenance.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO updateMaintenance(@RequestBody MaintenanceReportVO mtVO, HttpServletRequest request) throws Exception
	{	
		System.out.println("maintenance");
//		System.out.println(mtVO.getRpt_no());
		
		String returnVal = "success";
		try {
			reportMgmtService.updateMaintenance(mtVO);
//			reportMgmtService.deleteNUpdateReport("RPT04","UPDATE",mtVO.getRpt_rno()); // 수정시 전송으로 변경
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		
		
		
		return responseVO;
	}
	
	
	
	@RequestMapping(value = "/getReportData.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO getReportData(@RequestBody String data, HttpServletRequest request) throws Exception
	{	
		ResponseDataListVO responseVO = new ResponseDataListVO();
		
		
		String[] datas = data.split("&");//0 : l_no, 1 : type		
		String[] command = null;
		String saveTxt = null;
		String path = null;
		
		logger.info("getReportData");
		System.out.println("get Report Data List " + datas[1]);
		
		
		String returnVal = "success";
		String code = "";
		String fileName = "";
		
		try {
			Properties properties = new Properties();
            properties.load(new FileInputStream(new File(request.getRealPath("/WEB-INF/classes/props/report.properties"))));
            String sendRp = File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"heesong"+File.separator+"bin"+File.separator+"send_event_report";
            String txtPath = request.getRealPath("/report")+File.separator;
//			reportMgmtService.updateInit(itVO);
			if(datas[1].equals("RPT_02")){ // 관리대장
				SearchDataVO search = new SearchDataVO();
				search.setSearchKeyword(datas[0]);
				ObservatoryVO station = observatoryService.getStationMngInfoList(search).get(0);
				List<SensorVO> sensorList = sensorService.getSensorMngList(datas[0]);
				List<RecorderVO> recorderList = recorderService.getRecorderMngList(datas[0]);
				
				station.setSensors(sensorList);
				station.setRecorders(recorderList);
				responseVO.setData(station);
				fileName = datas[1].replace("_", "")+"_"+station.getNet()+"_"+station.getObs_id()+"_"+DateSetting.getbeforeDate(0).replaceAll("-", "");
				path = request.getSession().getServletContext().getRealPath(File.separator+"report"+File.separator+fileName+".txt");
				command = new String[] {sendRp,"-h",properties.getProperty("report.IP"),"-p",properties.getProperty("report.Port"),"-t","2","-c",""+Integer.parseInt(datas[1].replace("RPT_","")),"-f",txtPath+fileName+".txt","-k",""+datas[0]};
				
				saveTxt = createReport(datas[1],station);
					
				code = "관리대장";
			}else if(datas[1].equals("RPT_03")){ //초기점검
				InitReportMainVO report_a = reportMgmtService.getReport_a(datas[0]);
				List<InitReportSensorVO> report_b = reportMgmtService.getReport_b(datas[0]);
				List<InitReportRecorderVO> report_c = reportMgmtService.getReport_c(datas[0]);
				report_a.setSensors(report_b);
				report_a.setRecorders(report_c);

//				fileName = datas[1].replace("_", "")+"_"+report_a.getNet()+"_"+report_a.getObs_id()+"_"+DateSetting.getbeforeDate(0).replaceAll("-", "");
				fileName = datas[1].replace("_", "")+"_"+report_a.getNet()+"_"+report_a.getObs_id()+"_"+report_a.getRpt_date().replaceAll("-", "");
				path = request.getSession().getServletContext().getRealPath(File.separator+"report"+File.separator+fileName+".txt");
				command = new String[] {sendRp,"-h",properties.getProperty("report.IP"),"-p",properties.getProperty("report.Port"),"-t","2","-c",""+Integer.parseInt(datas[1].replace("RPT_","")),"-f",txtPath+fileName+".txt","-k",""+datas[0]};
				
				saveTxt = createReport(datas[1],report_a);
				
				code = "초기점검";
			}else if(datas[1].equals("RPT_04")){ //정기점검
				MaintenanceReportVO maintenanceReport = reportMgmtService.getMaintenanceReport(datas[0]);
				System.out.println(maintenanceReport.getQ1_1());
				responseVO.setData(maintenanceReport);
				
				
//				fileName = datas[1].replace("_", "")+"_"+maintenanceReport.getNet()+"_"+maintenanceReport.getObs_id()+"_"+DateSetting.getbeforeDate(0).replaceAll("-", "");
				fileName = datas[1].replace("_", "")+"_"+maintenanceReport.getNet()+"_"+maintenanceReport.getObs_id()+"_"+maintenanceReport.getRpt_date().replaceAll("-", "");
				path = request.getSession().getServletContext().getRealPath(File.separator+"report"+File.separator+fileName+".txt");
				command = new String[] {sendRp,"-h",properties.getProperty("report.IP"),"-p",properties.getProperty("report.Port"),"-t","2","-c",""+Integer.parseInt(datas[1].replace("RPT_","")),"-f",txtPath+fileName+".txt","-k",""+datas[0]};
				
				saveTxt = createReport(datas[1],maintenanceReport);
				
				code = "정기점검";
			}
			String tmp = "";
			for(String s : command)
			{
				tmp += s+" ";
			}
//			System.out.println(tmp);
			logger.debug("::::::::::::::::::::::::::::: Command - "+tmp+" ::::::::::::::::::::::::::::::::::::::::::::");
			logger.debug("::::::::::::::::::::::::::::: FailPath - "+fileName+" ::::::::::::::::::::::::::::::::::::::::::::");
//			System.out.println(split[2]);
//			System.out.println(saveTxt);
			String sWrite = fileService.sWrite(path, "CP949", saveTxt,command);
			reportMgmtService.updateSendTime(datas[0]);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		responseVO.setResultDesc(returnVal);
		responseVO.setResultCode(code);
		
		
		return responseVO;
	}
	
	private String createReport(String type,Object data)
	{	
		String saveTxt = "";
		int sCnt = 1;
		int rCnt = 1;
		
		if (type.equals("RPT_02")){
			ObservatoryVO dataVO =  (ObservatoryVO) data;
			System.out.println("a");
			saveTxt += "rpt_date : "+DateSetting.getbeforeDate(0)+"\n";
			saveTxt += "net : "+dataVO.getNet()+"\n";
			saveTxt += "obs_id : "+dataVO.getObs_id()+"\n";
			saveTxt += "obs_name : "+dataVO.getObs_name()+"\n";
			saveTxt += "contractdate : "+dataVO.getContractdate()+"\n";
			saveTxt += "completedate : "+dataVO.getCompletedate()+"\n";
			saveTxt += "price_contract : "+dataVO.getPrice_contract()+"\n";
			saveTxt += "price_sw : "+dataVO.getPrice_sw()+"\n";
			saveTxt += "price_hw : "+dataVO.getPrice_hw()+"\n";
			saveTxt += "opendate : "+dataVO.getOpendate()+"\n";
			saveTxt += "offdate : "+dataVO.getOffdate()+"\n";
			saveTxt += "area : "+dataVO.getArea()+"\n";
			saveTxt += "address : "+dataVO.getAddress()+"\n";
			saveTxt += "obs_kind : "+dataVO.getObs_kind()+"\n";
			saveTxt += "position : "+dataVO.getPosition()+"\n";
			saveTxt += "lon : "+dataVO.getLon()+"\n";
			saveTxt += "lat : "+dataVO.getLat()+"\n";
			System.out.println("b");
			saveTxt += "altitude : "+dataVO.getAltitude()+"\n";
			saveTxt += "ground_ht : "+dataVO.getGround_ht()+"\n";
			saveTxt += "uground_ht : "+dataVO.getUground_ht()+"\n";
			saveTxt += "base : "+dataVO.getBase()+"\n";
			saveTxt += "str_cd : "+dataVO.getStr_cd()+"\n";
			saveTxt += "seis_cd : "+dataVO.getSeis_cd()+"\n";
			saveTxt += "ground : "+dataVO.getGround()+"\n";
			saveTxt += "hole : "+dataVO.getHole()+"\n";
			saveTxt += "seis_ds : "+dataVO.getSeis_ds()+"\n";
			saveTxt += "design_acc : "+dataVO.getDesign_acc()+"\n";
			saveTxt += "threshold_acc : "+dataVO.getThreshold_acc()+"\n";
			saveTxt += "build_floor : "+dataVO.getBuild_floor()+"\n";
			saveTxt += "eq_area : "+dataVO.getEq_area()+"\n";
			saveTxt += "hole_map : "+dataVO.getHole_map()+"\n";
			saveTxt += "charge : "+dataVO.getCharge()+"\n";
			saveTxt += "contact : "+dataVO.getContact()+"\n";
			saveTxt += "sen_count : "+dataVO.getSensors().size()+"\n";
			System.out.println("c");
			for(SensorVO sen : dataVO.getSensors())
			{
				saveTxt += "sen("+sCnt+")_id : KN_"+sen.getSen_id()+"\n";
				saveTxt += "sen("+sCnt+")_company : "+sen.getSen_company()+"\n";
				saveTxt += "sen("+sCnt+")_model : "+sen.getSen_model()+"\n";
				saveTxt += "sen("+sCnt+")_serial_no : "+sen.getSen_serial()+"\n";
				saveTxt += "sen("+sCnt+")_kind : "+sen.getSen_kind()+"\n";
				saveTxt += "sen("+sCnt+")_gubun : "+sen.getSen_gubun()+"\n";
				saveTxt += "sen("+sCnt+")_position : "+sen.getSen_position()+"\n";
				saveTxt += "sen("+sCnt+")_channel : "+sen.getSen_channel()+"\n";
				saveTxt += "sen("+sCnt+")_lon : "+sen.getSen_lon()+"\n";
				saveTxt += "sen("+sCnt+")_lat : "+sen.getSen_lat()+"\n";
				saveTxt += "sen("+sCnt+")_z_response : "+sen.getSen_z_resp()+"\n";
				saveTxt += "sen("+sCnt+")_n_response : "+sen.getSen_n_resp()+"\n";
				saveTxt += "sen("+sCnt+")_e_response : "+sen.getSen_e_resp()+"\n";
				saveTxt += "sen("+sCnt+")_z_sensitivity : "+sen.getSen_z_sens()+"\n";
				saveTxt += "sen("+sCnt+")_n_sensitivity : "+sen.getSen_n_sens()+"\n";
				saveTxt += "sen("+sCnt+")_e_sensitivity : "+sen.getSen_e_sens()+"\n";
				saveTxt += "sen("+sCnt+")_rec_id : "+sen.getSen_rec_id()+"\n";
				sCnt++;
			}
			
			saveTxt += "rec_count : "+dataVO.getRecorders().size()+"\n";
			
			for(RecorderVO rec : dataVO.getRecorders())
			{
				saveTxt += "rec("+rCnt+")_id : KN_"+rec.getRec_id()+"\n";
				saveTxt += "rec("+rCnt+")_company : "+rec.getRec_company()+"\n";
				saveTxt += "rec("+rCnt+")_model : "+rec.getRec_model()+"\n";
				saveTxt += "rec("+rCnt+")_serial_no : "+rec.getRec_serial()+"\n";
				saveTxt += "rec("+rCnt+")_warranty : "+rec.getWarrenty()+"\n";
				saveTxt += "rec("+rCnt+")_wformat : "+rec.getWformat()+"\n";
				saveTxt += "rec("+rCnt+")_protocol : "+rec.getProtocol()+"\n";
				rCnt++;
			}
			
		}else if (type.equals("RPT_03")){
			InitReportMainVO dataVO = (InitReportMainVO)data;
//			saveTxt += "rpt_date : "+DateSetting.getbeforeDate(0)+"\n";
			saveTxt += "rpt_date : "+dataVO.getRpt_date()+"\n";
			saveTxt += "net : "+dataVO.getNet()+"\n";
			saveTxt += "obs_id : "+dataVO.getObs_id()+"\n";
			saveTxt += "f_sen_id : "+dataVO.getF_sen_id()+"\n";
			saveTxt += "f_q1 : "+dataVO.getF_q1()+"\n";
			saveTxt += "f_q2_1 : "+dataVO.getF_q2_1()+"\n";
			saveTxt += "f_q2_2 : "+dataVO.getF_q2_2()+"\n";
			saveTxt += "f_q3_1 : "+dataVO.getF_q3_1()+"\n";
			saveTxt += "f_q3_2 : "+dataVO.getF_q3_2()+"\n";
			if(dataVO.getSensors().size()>0){
				saveTxt += "s_sen_count : "+dataVO.getSensors().size()+"\n";
			}
			
			for(InitReportSensorVO sen : dataVO.getSensors())
			{
				saveTxt += "s("+sCnt+")_sen_id : "+sen.getS_sen_id()+"\n";
				saveTxt += "s("+sCnt+")_q1_1 : "+sen.getS_q1_1()+"\n";
				saveTxt += "s("+sCnt+")_q1_2 : "+sen.getS_q1_2()+"\n";
				saveTxt += "s("+sCnt+")_q1_3 : "+sen.getS_q1_3()+"\n";
				saveTxt += "s("+sCnt+")_q1_4 : "+sen.getS_q1_4()+"\n";
				saveTxt += "s("+sCnt+")_q1_5 : "+sen.getS_q1_5()+"\n";
				saveTxt += "s("+sCnt+")_q1_6 : "+sen.getS_q1_6()+"\n";
				saveTxt += "s("+sCnt+")_q2_1 : "+sen.getS_q2_1()+"\n";
				saveTxt += "s("+sCnt+")_q2_2 : "+sen.getS_q2_2()+"\n";
				saveTxt += "s("+sCnt+")_q3_1 : "+sen.getS_q3_1()+"\n";
				saveTxt += "s("+sCnt+")_q3_2 : "+sen.getS_q3_2()+"\n";
				sCnt++;
			}
			
			saveTxt += "r_rec_count : "+dataVO.getRecorders().size()+"\n";
			for(InitReportRecorderVO rec : dataVO.getRecorders())
			{
				saveTxt += "r("+rCnt+")_rec_id : "+rec.getR_sen_id()+"\n";
				saveTxt += "r("+rCnt+")_q1_1 : "+rec.getR_q1_1()+"\n";
				saveTxt += "r("+rCnt+")_q1_2 : "+rec.getR_q1_2()+"\n";
				saveTxt += "r("+rCnt+")_q2_1 : "+rec.getR_q2_1()+"\n";
				saveTxt += "r("+rCnt+")_q2_2 : "+rec.getR_q2_2()+"\n";
				saveTxt += "r("+rCnt+")_q3_1 : "+rec.getR_q3_1()+"\n";
				saveTxt += "r("+rCnt+")_q3_2 : "+rec.getR_q3_2()+"\n";
				saveTxt += "r("+rCnt+")_q4_1 : "+rec.getR_q4_1()+"\n";
				saveTxt += "r("+rCnt+")_q4_2 : "+rec.getR_q4_2()+"\n";
				saveTxt += "r("+rCnt+")_q4_3 : "+rec.getR_q4_3()+"\n";
				saveTxt += "r("+rCnt+")_q5_1 : "+rec.getR_q5_1()+"\n";
				saveTxt += "r("+rCnt+")_q5_2 : "+rec.getR_q5_2()+"\n";
				saveTxt += "r("+rCnt+")_q5_3 : "+rec.getR_q5_3()+"\n";
				saveTxt += "r("+rCnt+")_q6_1 : "+rec.getR_q6_1()+"\n";
				saveTxt += "r("+rCnt+")_q6_2 : "+rec.getR_q6_2()+"\n";
				saveTxt += "r("+rCnt+")_q7 : "+rec.getR_q7()+"\n";
				saveTxt += "r("+rCnt+")_q8 : "+rec.getR_q8()+"\n";
				
				rCnt++;
			}
			
			saveTxt += "r_q9_1 : "+dataVO.getR_q9_1()+"\n";
			saveTxt += "r_q9_2 : "+dataVO.getR_q9_2()+"\n";
			saveTxt += "r_q9_3 : "+dataVO.getR_q9_3()+"\n";
			saveTxt += "r_q9_4 : "+dataVO.getR_q9_4()+"\n";
			saveTxt += "r_q9_5 : "+dataVO.getR_q9_5()+"\n";
			saveTxt += "r_q9_6 : "+dataVO.getR_q9_6()+"\n";
			saveTxt += "r_q9_7 : "+dataVO.getR_q9_7()+"\n";
			saveTxt += "r_q10_1 : "+dataVO.getR_q10_1()+"\n";
			saveTxt += "r_q10_2 : "+dataVO.getR_q10_2()+"\n";
			saveTxt += "r_q10_3 : "+dataVO.getR_q10_3()+"\n";
			saveTxt += "r_q10_4 : "+dataVO.getR_q10_4()+"\n";
			saveTxt += "r_q11_1 : "+dataVO.getR_q11_1()+"\n";
			saveTxt += "r_q11_2 : "+dataVO.getR_q11_2()+"\n";
			saveTxt += "r_q11_3 : "+dataVO.getR_q11_3()+"\n";
			saveTxt += "r_q11_4 : "+dataVO.getR_q11_4()+"\n";
			saveTxt += "r_q12_1 : "+dataVO.getR_q12_1()+"\n";
			saveTxt += "r_q12_2 : "+dataVO.getR_q12_2()+"\n";
			saveTxt += "bigo : "+dataVO.getBigo()+"\n";
			saveTxt += "result : "+dataVO.getResult()+"\n";
			saveTxt += "user_dept : "+dataVO.getUser_dept()+"\n";
			saveTxt += "user_duty : "+dataVO.getUser_duty()+"\n";
			saveTxt += "user_name : "+dataVO.getUser_name()+"\n";
			saveTxt += "user_tel : "+dataVO.getUser_tel()+"\n";
			
		}else if (type.equals("RPT_04")){
			MaintenanceReportVO dataVO = (MaintenanceReportVO)data;
//			saveTxt += "rpt_date : "+DateSetting.getbeforeDate(0)+"\n";
			saveTxt += "rpt_date : "+dataVO.getRpt_date()+"\n";
			saveTxt += "net : "+dataVO.getNet()+"\n";
			saveTxt += "obs_id : "+dataVO.getObs_id()+"\n";
			saveTxt += "q1_1 : "+dataVO.getQ1_1()+"\n";
			saveTxt += "q1_2 : "+dataVO.getQ1_2()+"\n";
			saveTxt += "q1_3 : "+dataVO.getQ1_3()+"\n";
			saveTxt += "q1_4 : "+dataVO.getQ1_4()+"\n";
			saveTxt += "q2_1 : "+dataVO.getQ2_1()+"\n";
			saveTxt += "q2_2 : "+dataVO.getQ2_2()+"\n";
			saveTxt += "q2_3 : "+dataVO.getQ2_3()+"\n";
			saveTxt += "q2_4 : "+dataVO.getQ2_4()+"\n";			
			saveTxt += "q3_1 : "+dataVO.getQ3_1()+"\n";
			saveTxt += "q3_2 : "+dataVO.getQ3_2()+"\n";
			saveTxt += "q4_1 : "+dataVO.getQ4_1()+"\n";
			saveTxt += "q4_2 : "+dataVO.getQ4_2()+"\n";
			saveTxt += "q4_3 : "+dataVO.getQ4_3()+"\n";
			saveTxt += "bigo : "+dataVO.getBigo()+"\n";
			saveTxt += "result : "+dataVO.getResult()+"\n";
			saveTxt += "user_dept : "+dataVO.getUser_dept()+"\n";
			saveTxt += "user_duty : "+dataVO.getUser_duty()+"\n";
			saveTxt += "user_name : "+dataVO.getUser_name()+"\n";
			saveTxt += "user_tel : "+dataVO.getUser_tel()+"\n";			
			System.out.println("RPT_04");
		}else{
			saveTxt = "fail";
		}
		
		return saveTxt;
	}
	@RequestMapping(value = "/updateInit.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO updateInit(@RequestBody InitReportMainVO itVO, HttpServletRequest request) throws Exception
	{	
		System.out.println("init");
		System.out.println(itVO.getRpt_no());
		System.out.println(itVO.getSensors().get(0).getRpt_sno());
		System.out.println(itVO.getRecorders().get(0).getRpt_rno());
		System.out.println(itVO.getRpt_date());
		
		String returnVal = "success";
		try {
			reportMgmtService.updateInit(itVO);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		
		return responseVO;
	}
	
	@RequestMapping(value = "/sendReport.ws", method = RequestMethod.POST)
	public @ResponseBody ResponseDataListVO sendReport(@RequestBody String str, HttpServletRequest request) throws Exception
	{	
		
//		getServletContext().getRealPath("/");
		
		System.out.println("send report");
		String[] split = str.split("&");
		String returnVal = "success";
		String path = request.getSession().getServletContext().getRealPath(File.separator+"report"+File.separator+split[1]+".txt");
		//split[0] = key l_no
		//split[1] = type RPT
		//split[2] = content text
		
		//IP, PORT properties로 옮길것.
		//전송 데이터를 가공, popup페이지로 들어가지 않고 처리할 수 있는 방법
		System.out.println("send_event_report"+"-h"+"10.184.172.67"+"-p"+"3000"+"-t"+"2"+"-c"+""+Integer.parseInt(split[1].split("_")[0].replace("RPT",""))+"-f"+split[1]+".txt"+"-k"+split[0]);
		String[] command = new String[] {"send_event_report","-h","10.184.172.67","-p","3000","-t","2","-c",""+Integer.parseInt(split[1].split("_")[0].replace("RPT","")),"-f",split[1]+".txt","-k",split[0]};
		
		System.out.println(command.toString());
		try {
//			System.out.println(split[0]);
//			System.out.println(split[1]);
//			System.out.println(split[2]);
			String sWrite = fileService.sWrite(path, "CP949", split[2],command);
			reportMgmtService.updateSendTime(split[0]);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
			returnVal = "fail";
		}
		ResponseDataListVO responseVO = new ResponseDataListVO();
		responseVO.setResultDesc(returnVal);
		
		return responseVO;
	}
}
