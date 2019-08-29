package nms.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.google.gson.Gson;

import nms.quakeoccur.vo.QuakeEventReportVO;
import nms.quakeoccur.vo.WaveDataMainVO;

public class ShellCmdReading {
	Gson gson = new Gson();
	public static QuakeEventReportVO shellCmd(List<String> lines,QuakeEventReportVO vo) throws Exception {
		
		
		String max_g="0";
		String max_z="0";
		String max_n="0";
		String max_e="0";
		String max_time;
		String max_z_time = "";
		String max_n_time = "";
		String max_e_time = "";
		
		//4 : 코드 , 5 : 시간 22~26 zne2d3d
		int forCnt = 1;
		for (String line:lines) {
			String[] split = line.replaceAll("  ", " ").replaceAll("  "," ").split(" ");
			String thisTime = "";
			String this_g = "";
//			System.out.println("data : "+forCnt++);
//			for(int i=0;i<split.length;i++){
			for(int i=20;i<23;i++){
					
				if(!split[i].equals("")){
//					if(i==4){
					thisTime=split[4];
					if(i==20){
						this_g = split[i];
						if(Double.parseDouble(max_z)<Double.parseDouble(split[i])){
							max_z = split[i];
							max_z_time = thisTime;
							System.out.println("z : "+split[i]);
						}
					}else if(i==21){
						if(Double.parseDouble(max_n)<Double.parseDouble(split[i])){
							max_n = split[i];
							max_n_time = thisTime;
							System.out.println("n : "+split[i]);
						}
					}else if(i==22){
						if(Double.parseDouble(max_e)<Double.parseDouble(split[i])){
							max_e = split[i];
							max_e_time = thisTime;
							System.out.println("e : "+split[i]);
						}
					}
				}
			}
		}
		
		max_g = max_z;
		max_time = max_z_time;
		
		if(Double.parseDouble(max_n)>=Double.parseDouble(max_g)){
			max_g = max_n;
			max_time = max_n_time;
		}
		
		if(Double.parseDouble(max_e)>=Double.parseDouble(max_g)){
			max_g = max_e;
			max_time = max_e_time;
		}
		System.out.println("안쪽:"+vo.getObs_id());

//		max_z = ""+(Double.parseDouble(max_z)*1000);
//		max_n = ""+(Double.parseDouble(max_n)*1000);
//		max_e = ""+(Double.parseDouble(max_e)*1000);
		try {
			BigDecimal bd;
			int lenInt = 9;
//			System.out.println(vo.getObs_id()+" ::::::::::::::::::::::::::::::::::::");
			
			bd = new BigDecimal(Double.parseDouble(max_g)/980);
			lenInt = ((""+bd).length()>9?9:(""+bd).length());
			bd.setScale(7,BigDecimal.ROUND_DOWN);
			vo.setMax_g((""+bd).substring(0,lenInt));
//			vo.setMax_g(""+bd.setScale(7,BigDecimal.ROUND_DOWN));
			System.out.println("max_g"+bd);
			bd = new BigDecimal(Double.parseDouble(max_z)/980);
			lenInt = ((""+bd).length()>9?9:(""+bd).length());
			bd.setScale(7,BigDecimal.ROUND_DOWN);
			vo.setMax_z((""+bd).substring(0,lenInt));
//			vo.setMax_z(""+bd.setScale(7,BigDecimal.ROUND_DOWN));
			System.out.println("max_z"+bd);
			bd = new BigDecimal(Double.parseDouble(max_n)/980);
			lenInt = ((""+bd).length()>9?9:(""+bd).length());
			bd.setScale(7,BigDecimal.ROUND_DOWN);
			vo.setMax_n((""+bd).substring(0,lenInt));
//			vo.setMax_n(""+bd.setScale(7,BigDecimal.ROUND_DOWN));
			System.out.println("max_n"+bd);
			bd = new BigDecimal(Double.parseDouble(max_e)/980);
			lenInt = ((""+bd).length()>9?9:(""+bd).length());
			bd.setScale(7,BigDecimal.ROUND_DOWN);
			vo.setMax_e((""+bd).substring(0,lenInt));
//			vo.setMax_e(""+bd.setScale(7,BigDecimal.ROUND_DOWN));
			System.out.println("max_e"+bd);
			Date tt = new Date(Long.parseLong(max_time)*1000);
			SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String format = simple.format(tt);
			System.out.println("가공중 : "+format);
			vo.setMax_time(format);
			
//			
//			System.out.println("z"+vo.getMax_z());
//			System.out.println("n"+vo.getMax_n());
//			System.out.println("e"+vo.getMax_e());
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.toString());
		}
		
		return vo;
	}
	
	public WaveDataMainVO getDataForJson(List<String> lines){
		
		return new WaveDataMainVO();
	}

}
