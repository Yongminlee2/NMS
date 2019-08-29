package nms.util;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;


import nms.quakeoccur.vo.WaveDataMainVO;
import nms.quakeoccur.vo.WaveDataSubVO;
import nms.system.vo.RecorderVO;
import nms.util.Execute.ExecResult;

import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFCreationHelper;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.SigarException;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.google.gson.Gson;

public class Test {
	String hello;
    public static void main(String[] args) throws UnsupportedEncodingException, SigarException, ParseException {
		File imgCheck = new File(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"a"+".jpg");
		byte[] img1 = null;
		double a = 0.0000001;
		System.out.println(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"a");
		System.out.println(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+"NC"+" "+"1"+" "+"2"+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"?");
		BigDecimal bd = new BigDecimal((0.00001521*100)/980);
		
		System.out.println(a);
		System.out.println(bd.setScale(7,BigDecimal.ROUND_DOWN));
		System.out.println(bd.toString());
		
		System.out.println(File.separator+"opt"+File.separator+"KISStool"+File.separator+"bin"+File.separator+"readQscd -s "+"1"+" -d "+"2"+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"QSCD"+File.separator+"2017"+File.separator+"12"+File.separator+"30"+File.separator+"KA"+"KAG");
		try{
			if(!imgCheck.isFile()){
//				/usr/local/anaconda2/bin/
				
//				System.out.println(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+no);
//				ExecResult result2 = Execute.execCmd(File.separator+"usr"+File.separator+"local"+File.separator+"anaconda2"+File.separator+"bin"+File.separator+"python2.7 "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+"KHNP_map.py "+type+" "+lat+" "+lon+" "+File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+no,1);
				System.out.println("이미지 생성 완료");
//				img1 = Files.readAllBytes(Paths.get(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"mkOriginArea"+File.separator+no+".jpg"));
			}
		}catch(Exception e){
			System.out.println("지도 이미지 에러");
			
		};
//    	SimpleDateFormat dateFormat = new SimpleDateFormat("YYYYMMdd");
//    	for(int i=0;i<6;i++){
//    		System.out.println(i);
//    	}
//    	String a = "0.009580";
//    	String dt = "2017-11-15 16:00:14";
//    	int c = Integer.parseInt(dt.substring(0,10).replaceAll("-", ""));
//    	
//    	System.out.println(c);
//    	if(c < 20171116){
//    		System.out.println("up");
//    	}else{
//    		System.out.println("low");
//    	}
//    	System.out.println(Float.parseFloat(a)/9.81);
//    	double d =9;
//    	double dd = Math.round((d/980)*1000000)/1000000.0;
//    	System.out.println(dd);
//    	System.out.println(dd*980);
//    	String year = "2017";
//    	String month = "10";
//    	String day = "11";
//
//    	System.out.println(File.separator+"var"+File.separator+"www"+File.separator+"html"+File.separator+"heesong"+File.separator+"bin"+File.separator+"script"+File.separator+"hs_mseed2sac_v3.sh "+"2017/10/21,16:00:00"+" 210 M "+"20171021160000"+" "+"NC");
//    	
//    	
//    	String line = "0x598FF6B7 0x00 0x3F KNKBG 1507703527  -0.019752  -0.003449  -0.008779  -0.019113   0.001567  -0.006580  -0.010629  -0.001876  -0.005940   0.010974   0.005330   0.012533   0.008147   0.004689   0.004064   0.010974   0.012533   0.004689   0.013382   0.017306   0.006271   0.006267   0.006252   0.008852   0.000000 0x00 0x00 ";
//    	
//    	String[] split = line.replaceAll("  ", " ").replaceAll("  "," ").split(" ");
//    	
//    	for(int i=0;i<split.length;i++){
//    		System.out.println(i+" : "+split[i]);
//    	}
//    	
//		BigDecimal bd;
//		bd = new BigDecimal(0.012533/980);
//		System.out.println((""+bd).substring(0,8));
//		
//		
//		Date tt = new Date(1507703527*1000);
//		SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//		String format = simple.format(tt);
//		System.out.println("가공중 : "+format);
		
		
//		SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
//		Date currentTime = new Date ();
//		String mTime = mSimpleDateFormat.format ( currentTime );
//		System.out.println(mTime);
//    	Gson gson = new Gson();
//        String txt = "%7B+%22receiverMail%22%3A%22heojeongpil%40hsgeo.co.kr%22+%7D=";
//        String decode = URLDecoder.decode(txt,"utf-8");
//        System.out.println(decode.split("}")[0]+"}");
//        nms.quakeoccur.vo.MailVO mail = gson.fromJson(decode,nms.quakeoccur.vo.MailVO.class);
//        System.out.println(mail.getReceiverMail());
//        BigDecimal bd = new BigDecimal(Float.parseFloat("0.000023"));
//        System.out.println(bd.setScale(6,BigDecimal.ROUND_CEILING));
        
//        System.out.println(File.separator+"usr"+File.separator+"local"+File.separator+"map_image"+File.separator+".jpg");
//        
//    	File dir = new File("d:\\excel");
//    	FileFilter fileFilter = new WildcardFileFilter("image*");
//    	File[] files = dir.listFiles(fileFilter);
//    	for (int i = 0; i < files.length; i++) {
//    	   System.out.println(files[i]);
//    	}
//        Sigar sigar = new Sigar(); //1. sigar객체 생성

//        CpuPerc cpu = sigar.getCpuPerc(); //2. 전체 cpu에 대한 사용량
//        CpuPerc[] cpus = sigar.getCpuPercList(); //3. 각 cpu에 대한 사용량
//        Mem mem = sigar.getMem();
        
        
//        System.out.println("Free Memory : "+(float)Math.round(mem.getFreePercent()*10)/10);
//        System.out.println("Used Memory : "+(float)Math.round(mem.getUsedPercent()*10)/10);
        
        //4. cpu사용량 출력
//        System.out.println("Total cpu----");
//        String a = ""+CpuPerc.format(cpu.getCombined());
//        System.out.println("Used Cpu : "+a.replace("%", "")); // 사용중
//        System.out.println(listFiles[0].getName());
//        System.out.println(test.getName());
//        System.out.println(test.isFile());
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
    
	public static String putStr(List<String> s ){
		String rTxt = "";
		System.out.println(s.size());
		for(int i = 0; i<s.size();i++){
			System.out.println(i + " / " +s.get(i));
			rTxt += s.get(i);
		}
		return rTxt;
	}
	public static String realTime(){
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd,HH:mm:ss");
		Date date = new Date();
		System.out.println(date);
		String format = df.format(date);
		return format;
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
    public static int[] solution(int[][] v) {
        
        int xS = 0;
        int yS = 0;
        System.out.println("vlength : "+v.length);
        for(int i=0;i<v.length;i++){
            for(int x = 0 ; x < v.length; x ++)
            {
                if(v[i][0]==v[x][0] && x != i){
                    x = v.length+1;
                }else if((x+1) == v.length){
                    xS = v[i][0];
                }
            }
            
            for(int y = 0 ; y < v.length; y ++)
            {
                if(v[i][1]==v[y][1] && y != i){
                    y = v.length+1;
                }else if((y+1) == v.length){
                    yS = v[i][1];
                }
            }
        }
        int[] answer = {xS,yS};
        
        return answer;
    }
}
