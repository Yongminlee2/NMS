package nms.util;

import java.util.Calendar;

public class DateSetting {
	
	public static final String getbeforeDate(int day){
		Calendar cal = Calendar.getInstance();
		cal.add(cal.DATE, day*-1);
		return cal.get ( cal.YEAR )+"-"+((cal.get ( cal.MONTH )+1)<10?"0"+(cal.get ( cal.MONTH )+1):(cal.get ( cal.MONTH )+1))+"-"+((cal.get ( cal.DATE )+0) < 10 ? "0"+(cal.get ( cal.DATE )+0) : cal.get ( cal.DATE ));
		
	}
}
