package nms.quakeoccur.controller;

import java.io.File;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import nms.quakeoccur.service.ManualAnalysisService;
import nms.quakeoccur.service.QuakeInfoService;
import nms.quakeoccur.vo.QuakeEventReportVO;
import nms.quakeoccur.vo.SelfEventListVO;
import nms.quakeoccur.vo.ManualPopupVO;
import nms.util.Execute;
import nms.util.ShellCmdReading;
import nms.util.Execute.*;

import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/quakeoccur/manualanalysis")
public class ManualAnalysisController {
	private static final Logger logger = LoggerFactory.getLogger(ManualAnalysisController.class);
	@Autowired
	ManualAnalysisService manualAnalysisService;
	
	@Autowired
	QuakeInfoService quakeInfoService;
	
	@RequestMapping("/list")
	public String manualAnalysisListView(ModelMap model) throws Exception
	{
		return "/quakeoccur/manualanalysis";
	}
	
	@RequestMapping(value="/popup/report",method = RequestMethod.POST)
	public String quakeInfoReport(ModelMap model,ManualPopupVO dataVO) throws Exception
	{	
		logger.info("Join to /popup/report/");
		logger.debug("test");
		System.out.println("self"+dataVO.getArea());
		if(dataVO.getTime().length() < 19){
			dataVO.setTime("2017-07-01 06:10:40");
		}
		String type = dataVO.getOrg();
		String replaceWord = getReplaceWord(type);
		double lat = Double.parseDouble(dataVO.getLat());
		double lon = Double.parseDouble(dataVO.getLon());
		
		List<QuakeEventReportVO> quakeReportDataAll = quakeInfoService.getQuakeReportDataAll(replaceWord, type);
		String epochTime = ""+(Integer.parseInt(parseEpoch(dataVO.getTime()))-30);
		String delayTime = "120";
		String fullDate = dataVO.getTime().substring(0,10);
		String year = fullDate.split("-")[0];
		String month =fullDate.split("-")[1];
		String day = fullDate.split("-")[2];
		
		//실서버 업로드시 해제
			for(QuakeEventReportVO q : quakeReportDataAll)
			{	
				String net = q.getNet();
				double lat2 = q.getLat();
				double lon2 = q.getLon();
				q.setKmeter(""+distance(lat2, lon2, lat, lon));
				try {
	//			ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s 1498137443 -d 10 "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"06"+File.separator+"22"+File.separator+"KN_"+s.getSen_id()+"_20170622.mma",0);
//					ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"data"+File.separator+"KISStool"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+"_"+q.getSen_id()+"_"+year+month+day+".mma",0);
					ExecResult result = Execute.execCmd(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+epochTime+" -d "+delayTime+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+year+File.separator+month+File.separator+day+File.separator+net+q.getSen_id(),0);
					List<String> lines = result.getLines();
					q = ShellCmdReading.shellCmd(lines,q);
					if(Integer.parseInt(fullDate.replaceAll("-", "")) < 20171116){
						BigDecimal bd;
						bd = new BigDecimal(Float.parseFloat(q.getMax_z())/9.81);
						q.setMax_z(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
						bd = new BigDecimal(Float.parseFloat(q.getMax_n())/9.81);
						q.setMax_n(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
						bd = new BigDecimal(Float.parseFloat(q.getMax_e())/9.81);
						q.setMax_e(((""+bd).length()>8?(""+bd).substring(0,8):(""+bd)));
					}
				} catch (Exception e) {
					// TODO: handle exception
					System.out.println(e.toString());
				}
			}
		//*/
		String date = dataVO.getTime().replaceAll(":", "").replaceAll("-","").replaceAll(" ", "");
		System.out.println(date);
		Map<String,String> dataMap = new HashMap<String, String>();
		dataMap.put("date", fullDate);
		dataMap.put("time", dataVO.getTime().substring(11,dataVO.getTime().length()));
		dataMap.put("lat", dataVO.getLat());
		dataMap.put("lon", dataVO.getLon());
		dataMap.put("area", dataVO.getArea());
		dataMap.put("mag", dataVO.getMag());
		dataMap.put("realTime", dataVO.getRealtime());
		dataMap.put("timeArea",dataVO.getTime().substring(11,dataVO.getTime().length())+"~"+addTime(dataVO.getTime(),2,"yyyy-MM-dd HH:mm:ss").substring(11,dataVO.getTime().length()));
		dataMap.put("etc",dataVO.getEtc());
		dataMap.put("comment",dataVO.getComment());
		dataMap.put("uInfo",dataVO.getUser_info());
		
		
		model.addAttribute("dataList",quakeReportDataAll);
		model.addAttribute("mainData",dataMap);
		model.addAttribute("historyList",quakeInfoService.getQuakeReportHistoryData("10",fullDate,dataMap.get("time").toString()));
		model.addAttribute("org_type",type);
		
		model.addAttribute("req_date",date.substring(0,date.length()));
		model.addAttribute("req_id",date.substring(0,date.length()));
		
		return "/quakeoccur/popup/quakeReportManual";
	}
	
	public static String parseEpoch(String date) throws ParseException{
	   long epoch = 0;

       DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
       Date datenew = df.parse(date);
       epoch = datenew.getTime();

       System.out.println(epoch);
       String rEpoch = ""+epoch;
       return rEpoch.substring(0,rEpoch.length()-3);
	}
	public String addTime(String date,int min,String dFormat) throws ParseException{
		Calendar cal = Calendar.getInstance();
		DateFormat df = new SimpleDateFormat(dFormat);
		Date parse = df.parse(date);
		cal.setTime(parse);
		cal.add(Calendar.MINUTE, min);
		
		String format = df.format(cal.getTime());
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
