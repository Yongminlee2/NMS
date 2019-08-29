package nms.util;

import java.awt.Color;
import java.awt.Paint;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import nms.inforeceived.vo.DataCollRateListVO;
import nms.util.controller.UtilController;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFCreationHelper;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.Plot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

public class ExcelFnc {
	private static final Logger logger = LoggerFactory.getLogger(ExcelFnc.class);
	private static final Shape circle = new Ellipse2D.Double(-3, -3, 6, 6);
	private static final int N = 600;
//	public void setImage(HSSFWorkbook wb, HSSFSheet sheetAt, int col1, int col2, int row1, int row2,String imgPath) throws IOException
	public void setImage(HSSFWorkbook wb, HSSFSheet sheetAt, int col1, int col2, int row1, int row2,byte[] bytes) throws IOException
	{
//		FileInputStream inputStream = new FileInputStream(imgPath);
//        byte[] bytes = IOUtils.toByteArray(inputStream);
        int pictureIdx = wb.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
//        inputStream.close();
        
        HSSFCreationHelper helper = wb.getCreationHelper();
        HSSFClientAnchor anchor = helper.createClientAnchor();
            // 이미지를 출력할 CELL 위치 선정
        anchor.setAnchor((short)col1, row1, 0, 0,(short) col2, row2, 0, 0);
        // 이미지 그리기
        HSSFPatriarch patriarch=sheetAt.createDrawingPatriarch();
        patriarch.createPicture(anchor,pictureIdx);
        // 이미지 사이즈 비율 설정
        System.out.println("img insert");
	}
	public void copyExcel(String origin, String copy)
	{
		try{
			FileInputStream inputStream = new FileInputStream(origin);
	    	FileOutputStream outputStream = new FileOutputStream(copy);
	    	
	    	FileChannel fcin =  inputStream.getChannel();
	    	FileChannel fcout = outputStream.getChannel();
	    	  
	    	long size = fcin.size();
	    	fcin.transferTo(0, size, fcout);
	    	  
	    	fcout.close();
	    	fcin.close();
	    	  
	    	outputStream.close();
	    	inputStream.close();
		}catch(IOException e){
			
		}
	}
	
	public void sendMail(String receiverMail, String filePath,String fileName,String type){
		logger.info(":::::::::::::::::: Mail Send Start ::::::::::::::::::");
		String smtp_addr ="127.0.0.1";
        String sender_addr ="admin@127.0.0.1";
        String sender_nm  = "관리자";
//        String receiver = receiverMail ;
//        String mailName = (type.equals("NC")?"원전":(type.equals("WP")?"수력":"양수"));
//        String subject = mailName+" 지진 발생 보고서";
//        String content = mailName+" 지진 발생 보고서" ;
        
        String mailName = fileName.substring(0,fileName.length()-4);
        String subject = mailName;
        String content = mailName+" 지진 발생 보고서" ;
        try
        {
            // 기본적인 메소드를 선언한다.
            Properties props = new Properties();
            
            props.put("mail.smtp.host",smtp_addr);
            props.put("mail.smtp.port","27");
            Session session = Session.getDefaultInstance(props,null);
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(sender_addr,sender_nm, "euc-kr"));

            InternetAddress[] tos = InternetAddress.parse(receiverMail);
            message.setRecipients(Message.RecipientType.TO, tos);
            message.setSubject(subject, "euc-kr");
            
            // 내용 붙여 넣기
            MimeBodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(content, "euc-kr");
            
            // 파일 붙여 넣기
            MimeBodyPart messageBodyPartFile = new MimeBodyPart();
            File sendFile = new File(filePath);
            DataSource source = new FileDataSource(sendFile);
            messageBodyPartFile.setDataHandler(new DataHandler(source));
            messageBodyPartFile.setFileName(fileName);
            
            // 내용과 파일 붙이기
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            multipart.addBodyPart(messageBodyPartFile);
            
            // 전송 준비
            message.setSentDate(new java.util.Date());
            message.setContent(multipart);

            // 전송
            Transport transport = session.getTransport("smtp");
            Transport.send(message);
            transport.close();
//            sendFile.delete();
    		logger.info(":::::::::::::::::: Mail Send End ::::::::::::::::::");

        }
        catch(Exception e)  {
               e.printStackTrace();
               logger.debug("Mail Send Error : "+e.toString());
        }
	}
	
	public void sendMailNoFile(String receiverMail){
		logger.info(":::::::::::::::::: Mail Send Start ::::::::::::::::::");
		String smtp_addr ="127.0.0.1";
        String sender_addr ="admin@127.0.0.1";
        String sender_nm  = "관리자";
//        String receiver = receiverMail ;
        String subject = "이메일 테스트";
        String content = "지진 발생 보고서 이메일 테스트" ;
        try
        {
            // 기본적인 메소드를 선언한다.
            Properties props = new Properties();
            
            props.put("mail.smtp.host",smtp_addr);
            props.put("mail.smtp.port","27");
            Session session = Session.getDefaultInstance(props,null);
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(sender_addr,sender_nm, "euc-kr"));

            InternetAddress[] tos = InternetAddress.parse(receiverMail);
            message.setRecipients(Message.RecipientType.TO, tos);
            message.setSubject(subject, "euc-kr");
            
            // 내용 붙여 넣기
            MimeBodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText(content, "euc-kr");
            
            // 파일 붙여 넣기
//            MimeBodyPart messageBodyPartFile = new MimeBodyPart();
//            File sendFile = new File(filePath);
//            DataSource source = new FileDataSource(sendFile);
//            messageBodyPartFile.setDataHandler(new DataHandler(source));
//            messageBodyPartFile.setFileName(fileName);
            
            // 내용과 파일 붙이기
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
//            multipart.addBodyPart(messageBodyPartFile);
            
            // 전송 준비
            message.setSentDate(new java.util.Date());
            message.setContent(multipart);

            // 전송
            Transport transport = session.getTransport("smtp");
            Transport.send(message);
            transport.close();
//            sendFile.delete();
            logger.info(":::::::::::::::::: Mail Send End ::::::::::::::::::");
        }
        catch(Exception e)  {
               e.printStackTrace();
               logger.debug("Mail Send Error : "+e.toString());
        }
	}
	/**
	 * 시트에 데이터를 입력한 후 스타일을 동일하게 적용한다. 
	 * @param sheet
	 * @param row
	 * @param col
	 * @param value
	 * @throws Exception
	 */
	public void insertSheetDataNCopyStyle(HSSFSheet sheet,int row, int col, String value) throws Exception{
		HSSFCellStyle cellStyle = null;
		HSSFCell valueCell = null;
		
//		cellStyle = sheet.getRow(row).getCell(col).getCellStyle();
		valueCell = sheet.getRow(row).createCell(col);
		valueCell.setCellValue(value);
//		valueCell.setCellStyle(cellStyle);
	}
	
	public void drawDayChart(HSSFWorkbook workbook, HSSFSheet sheet, String[] dataList, int row, int row2, int col, int col2) throws Exception{
		DefaultCategoryDataset dataset = new DefaultCategoryDataset(); 
		logger.info("draw Chart");

		int c = 0;
		int min = 99999990;
		int max = -99999990;
		logger.debug("::::::::::::::::::::::::::::::::::::::::: start data set  ::::::::::::::::::::::::::::::::::::::::::: ");
//		logger.debug("::::::::::::::::::::::::::::::::::::::::: col : "+col+"  ::::::::::::::::::::::::::::::::::::::::::: ");
//		logger.debug("::::::::::::::::::::::::::::::::::::::::: col2 : "+col2+"  ::::::::::::::::::::::::::::::::::::::::::: ");
//		logger.debug("::::::::::::::::::::::::::::::::::::::::: row : "+row+"  ::::::::::::::::::::::::::::::::::::::::::: ");
//		logger.debug("::::::::::::::::::::::::::::::::::::::::: row2 : "+row2+"  ::::::::::::::::::::::::::::::::::::::::::: ");
		for (String data : dataList) {
//			logger.debug(data);
			c ++;
			int parseInt = Integer.parseInt(data);
			if(parseInt > max){
				max = parseInt;
			}
			if(parseInt < min){
				min = parseInt;
			}
			dataset.addValue(parseInt, "c", ""+c);
		}
//		logger.debug("::::::::::::::::::::::::::::::::::::::::: cnt : "+c);
		JFreeChart createLineChart = ChartFactory.createLineChart("", "", "", dataset,  PlotOrientation.VERTICAL, false, false, false);
		CategoryPlot plot = createLineChart.getCategoryPlot();
		
		plot.setDrawSharedDomainAxis(false);
		ValueAxis rangeAxis = plot.getRangeAxis();
//		logger.debug("::::::::::::::::::::::::::::::::::::::::: min & max : "+min+" , "+max+" ::::::::::::::::::::::::::::::::::::::::::::::::::::");
		rangeAxis.setRange(min, max);
		
		
		int width=1460; /* 가로 */
		int height=450; /* 세로 */

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ChartUtilities.writeChartAsPNG(baos,createLineChart,width,height);

		int my_picture_id = workbook.addPicture(baos.toByteArray(), workbook.PICTURE_TYPE_PNG);
		baos.close();
		/* 앵커라고 엑셀 어디에 박아놓을지 결정하는 것. */
		HSSFClientAnchor anchor = new HSSFClientAnchor();
//		int col1=1,row1=1; // 엑셀 12열, 2번째 칸에서 그림이 그려진다.

		// API참조할 것.
		anchor.setAnchor((short)col, row, 0, 0,(short) col2, row2, 0, 0);
		// 그림이 1,11 에서 18,28까지 그러진다.

		anchor.setAnchorType(2);
		// Creating HSSFPatriarch object
		HSSFPatriarch patriarch=sheet.createDrawingPatriarch();

		//Creating picture with anchor and index information
		patriarch.createPicture(anchor,my_picture_id);
		/* Graph 만들기. Finish.*/
		logger.debug("::::::::::::::::::::::::::::::::::::::::: Draw End ::::::::::::::::::::::::::::::::::::::::::::::::::::");
	}
	
}
