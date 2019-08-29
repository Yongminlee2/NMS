package nms.util;

import java.awt.Color;
import java.awt.Paint;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nms.inforeceived.vo.DataCollRateListVO;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.springframework.web.servlet.view.document.AbstractExcelView;

/**
 * 리스트를 엑셀로 저장하는 클래스
 * @author 박용성
 * @since 2015.04.07
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *       수정일          수정자                수정내용
 *  --------------   ---------    ---------------------------
 *    2015.04.07       박용성         최초 생성
 *
 * </pre>
 */
public class ExcelViewDataCollRate extends AbstractExcelView{

	private static final Shape circle = new Ellipse2D.Double(-3, -3, 6, 6);
	private static final int N = 600;
	 
	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		if("R".equals(model.get("type")) || "M".equals(model.get("type"))){
			HSSFSheet sheet = workbook.createSheet("수집률");
			
			List<DataCollRateListVO> ncTable = (List<DataCollRateListVO>) model.get("ncTable");
			List<DataCollRateListVO> wpTable = (List<DataCollRateListVO>) model.get("wpTable");
			List<DataCollRateListVO> ppTable = (List<DataCollRateListVO>) model.get("ppTable");
			
			int rows = drawTable(workbook, sheet, ncTable, wpTable, ppTable, model.get("type").toString());
			
			if(!model.get("chartSta").equals("")){
				String chartSta = model.get("chartSta").toString();
				List<DataCollRateListVO> chartData = new ArrayList<DataCollRateListVO>();
				String gubun = "";
				for (DataCollRateListVO data : ncTable) {
					if(data.getStation().equals(chartSta)){
						chartData.add(data);
						gubun = "NC";
					}
					
				}
				
				for (DataCollRateListVO data : wpTable) {
					if(data.getStation().equals(chartSta)){
						chartData.add(data);
						gubun = "WP";
					}
				}
				
				for (DataCollRateListVO data : ppTable) {
					if(data.getStation().equals(chartSta)){
						chartData.add(data);
						gubun = "PP";
					}
				}
				
				if("R".equals(model.get("type"))){
					drawDayChart(rows, workbook, sheet, chartData, gubun);
				}else{
					drawMonthChart(rows, workbook, sheet, chartData, gubun);
				}
			}
			
			//rows = drawDayChart(rows, workbook, sheet, (List<DataCollRateListVO>) model.get("chartDay"));
			//drawMonthChart(rows, workbook, sheet, (List<DataCollRateListVO>) model.get("chartMonth"));
		}
		else{
			HSSFSheet sheet = workbook.createSheet("누수율");
			drawDayChart(workbook, sheet, (List<DataCollRateListVO>) model.get("chartDay"));
		}
		
		String fileName = java.net.URLEncoder.encode((String) model.get("fileName"), "utf-8");

		response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
	}
	
	private void drawDayChart(HSSFWorkbook workbook, HSSFSheet sheet, List<DataCollRateListVO> dataList) throws Exception{
		DefaultCategoryDataset Data = new DefaultCategoryDataset();
		XYSeriesCollection dataset = new XYSeriesCollection();
		int c = 0;
		for (DataCollRateListVO data : dataList) {
			int start_h = Integer.parseInt(data.getTmp1());
			int start_m = Integer.parseInt(data.getTmp2());
			int end_h = Integer.parseInt(data.getTmp3());
			int end_m = Integer.parseInt(data.getTmp4());
			
			if((start_h == end_h) && (start_m == end_m)){
				XYSeries series1 = new XYSeries("");
				c ++;
				//Data.addValue(start_h , "" , start_m+"");
				series1.add(start_m, start_h);
				dataset.addSeries(series1);
			}else if((start_h == end_h) && (start_m != end_m)){
				XYSeries series1 = new XYSeries("");
				c ++;
				series1.add(start_m, start_h);
				series1.add(end_m, end_h);
				//Data.addValue(start_h , "" , start_m+"");
				//Data.addValue(end_h , "" , end_m+"");
				dataset.addSeries(series1);
			}else if((start_h != end_h) && (start_m != end_m)){
				XYSeries series1 = new XYSeries("");
				c ++;
				series1.add(start_m, start_h);
				series1.add(60, start_h);
				dataset.addSeries(series1);
				/*Data.addValue(start_h , "" , start_m+"");
				Data.addValue(start_h , "" , 60+"");*/
				
				for(int i = start_h + 1; i < end_h; i ++){
					XYSeries series2 = new XYSeries("");
					c ++;
					series2.add(0, i);
					series2.add(60, i);
					dataset.addSeries(series2);
					/*Data.addValue(i , "" , 0+"");
					Data.addValue(i , "" , 60+"");*/
				}
				XYSeries series3 = new XYSeries("");
				c ++;
				series3.add(0, end_h);
				series3.add(end_m, end_h);
				dataset.addSeries(series3);
				/*Data.addValue(end_h , "" , 0+"");
				Data.addValue(end_h , "" , end_m+"");*/
			}
		}
		
		String chartTitle = "누수율";
		String xAxisLabel = "분";
		String yAxisLabel = "시";
		
		JFreeChart lineChartObject=ChartFactory.createXYLineChart(chartTitle, xAxisLabel, yAxisLabel, dataset, PlotOrientation.VERTICAL,true,true,false);
		
		XYPlot plot = lineChartObject.getXYPlot();
		MyRenderer renderer = new MyRenderer(true, true, N);
		plot.setRenderer(renderer);
		for(int i = 0; i < c; i ++ ){
			renderer.setSeriesShape(i, circle);
			renderer.setSeriesShapesVisible(i, true);
			renderer.setSeriesPaint(i, Color.red);
		}
		int width=1460; /* 가로 */
		int height=450; /* 세로 */

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ChartUtilities.writeChartAsPNG(baos,lineChartObject,width,height);

		int my_picture_id = workbook.addPicture(baos.toByteArray(), workbook.PICTURE_TYPE_PNG);
		baos.close();
		/* 앵커라고 엑셀 어디에 박아놓을지 결정하는 것. */
		HSSFClientAnchor anchor = new HSSFClientAnchor();
		int col1=1,row1=1; // 엑셀 12열, 2번째 칸에서 그림이 그려진다.

		// API참조할 것.
		anchor.setAnchor((short)col1, row1, 0, 0,(short) 23, 22, 0, 0);
		// 그림이 1,11 에서 18,28까지 그러진다.

		anchor.setAnchorType(2);
		// Creating HSSFPatriarch object
		HSSFPatriarch patriarch=sheet.createDrawingPatriarch();

		//Creating picture with anchor and index information
		patriarch.createPicture(anchor,my_picture_id);
		/* Graph 만들기. Finish.*/
	}
	
	private int drawTable(HSSFWorkbook workbook, HSSFSheet sheet, List<DataCollRateListVO> ncList, List<DataCollRateListVO> wpList, List<DataCollRateListVO> ppList, String type) throws Exception{
		CellStyle style = workbook.createCellStyle();
		Font font = workbook.createFont();
		// font.setFontName("Arial");
		style.setFillForegroundColor(HSSFColor.GREY_40_PERCENT.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setColor(HSSFColor.WHITE.index);
		// font.setFontName("맑은 고딕");
		style.setFont(font);
		
		CellStyle styleRed = workbook.createCellStyle();
		Font fontRed = workbook.createFont();
		styleRed.setFillForegroundColor(HSSFColor.RED.index);
		styleRed.setFillPattern(CellStyle.SOLID_FOREGROUND);
		styleRed.setAlignment(CellStyle.ALIGN_CENTER);
		styleRed.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		fontRed.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		fontRed.setColor(HSSFColor.WHITE.index);
		// font.setFontName("맑은 고딕");
		styleRed.setFont(fontRed);
		
		CellStyle styleBlue = workbook.createCellStyle();
		Font fontBlue = workbook.createFont();
		styleBlue.setFillForegroundColor(HSSFColor.BLUE.index);
		styleBlue.setFillPattern(CellStyle.SOLID_FOREGROUND);
		styleBlue.setAlignment(CellStyle.ALIGN_CENTER);
		styleBlue.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		fontBlue.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		fontBlue.setColor(HSSFColor.WHITE.index);
		// font.setFontName("맑은 고딕");
		styleBlue.setFont(fontBlue);
		
		
		int firstRow = 0;
		
		int obsCellS = 1;
		int obsCellE = 2;
		int channelCellS = 1;
		int channelCellE = 1;
		int valueCnt = 1;
		
		int dayHeaderX = 0;
		int dayHeaderY = 1;
		
		int obsHeaderX = 0;
		int obsHeaderY = 0;
		
		int channelHeader = 1;
		
		if(ncList.size() != 0){
			HSSFRow row1 = sheet.createRow(firstRow++);
			HSSFRow row2 = sheet.createRow(firstRow++);
			HSSFRow row3 = sheet.createRow(firstRow);
			HSSFRow row4 = null;
			
			String checkDate = "";
			
			for(int i = 0; i < ncList.size(); i ++ ){
				
				if(!checkDate.equals(ncList.get(i).getDate())){
					checkDate = ncList.get(i).getDate();
					row3 = sheet.createRow(firstRow++);
					row3.createCell(0).setCellValue (checkDate);
					row3.getCell(0).setCellStyle(style);
					valueCnt = 1;
					obsCellS = 1;
					obsCellE = 2;
					channelCellS = 1;
					channelCellE = 1;
				}

				row1.createCell(0).setCellValue("날짜");
				row1.getCell(0).setCellStyle(style);
				sheet. addMergedRegion (new Region(( int) dayHeaderX , ( short )0 , ( int) dayHeaderY, (short )0 )); //날짜
				sheet. addMergedRegion (new Region(( int) obsHeaderX , ( short )obsCellS , ( int) obsHeaderY, (short )obsCellE )); //관측소
				
				row1.createCell(obsCellS).setCellValue(ncList.get(i).getObs_name().replace("원자력발전소", "원전"));
				row1.getCell(obsCellS).setCellStyle(style);
				obsCellS = obsCellS +2;
				obsCellE = obsCellE +2;
				
				sheet. addMergedRegion (new Region(( int) channelHeader , ( short )channelCellS , ( int) channelHeader, (short )channelCellE )); //가속도
				
				row2.createCell( channelCellS). setCellValue ("가속도");
				row2.getCell(channelCellS).setCellStyle(style);
				channelCellS = channelCellS + 1;
				channelCellE = channelCellE + 1;
				
				sheet. addMergedRegion (new Region(( int) channelHeader , ( short )channelCellS , ( int) channelHeader, (short )channelCellE )); //속도
				
				row2.createCell(channelCellS).setCellValue ("속도");
				row2.getCell(channelCellS).setCellStyle(style);
				channelCellS = channelCellS + 1;
				channelCellE = channelCellE + 1;
				
				
				
				if("R".equals(type)){
					String least1 = fnLeast(ncList.get(i).getHgz(), ncList.get(i).getHge(), ncList.get(i).getHgn());
					String least2 = fnLeast(ncList.get(i).getHhz(), ncList.get(i).getHhe(), ncList.get(i).getHhn());
					
					if(least1.equals("Z")){
						row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHgz() + "(" + least1 + ")");
						double value = Double.parseDouble(ncList.get(i).getHgz());
						if(value <= 95){
							row3.getCell(valueCnt-1).setCellStyle(styleBlue);
						}
						
						if(value <= 90){
							row3.getCell(valueCnt-1).setCellStyle(styleRed);
						}
						
						/*row4.createCell(valueCnt).setCellValue(ncList.get(i).getHgz());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGZ"));
						row3.getCell(valueCnt-1).setCellStyle(style);*/
					}else if(least1.equals("E")){
						row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHge() + "(" + least1 + ")");
						double value = Double.parseDouble(ncList.get(i).getHge());
						if(value <= 95){
							row3.getCell(valueCnt-1).setCellStyle(styleBlue);
						}
						
						if(value <= 90){
							row3.getCell(valueCnt-1).setCellStyle(styleRed);
						}
						
						/*row4.createCell(valueCnt).setCellValue(ncList.get(i).getHge());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGE"));
						row3.getCell(valueCnt-1).setCellStyle(style);*/
					}else{
						row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHgn() + "(" + least1 + ")");
						double value = Double.parseDouble(ncList.get(i).getHgn());
						if(value <= 95){
							row3.getCell(valueCnt-1).setCellStyle(styleBlue);
						}
						
						if(value <= 90){
							row3.getCell(valueCnt-1).setCellStyle(styleRed);
						}
						/*row4.createCell(valueCnt).setCellValue(ncList.get(i).getHgn());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGN"));
						row3.getCell(valueCnt-1).setCellStyle(style);*/
					}
					
					if(least2.equals("Z")){
						row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHhz() + "(" + least2 + ")");
						double value = Double.parseDouble(ncList.get(i).getHhz());
						if(value <= 95){
							row3.getCell(valueCnt-1).setCellStyle(styleBlue);
						}
						
						if(value <= 90){
							row3.getCell(valueCnt-1).setCellStyle(styleRed);
						}
						/*row4.createCell(valueCnt).setCellValue(ncList.get(i).getHhz());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHZ"));
						row3.getCell(valueCnt-1).setCellStyle(style);*/
					}else if(least2.equals("E")){
						row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHhe() + "(" + least2 + ")");
						double value = Double.parseDouble(ncList.get(i).getHhe());
						if(value <= 95){
							row3.getCell(valueCnt-1).setCellStyle(styleBlue);
						}
						
						if(value <= 90){
							row3.getCell(valueCnt-1).setCellStyle(styleRed);
						}
						/*row4.createCell(valueCnt).setCellValue(ncList.get(i).getHhe());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHE"));
						row3.getCell(valueCnt-1).setCellStyle(style);*/
					}else{
						row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHhn() + "(" + least2 + ")");
						double value = Double.parseDouble(ncList.get(i).getHhn());
						if(value <= 95){
							row3.getCell(valueCnt-1).setCellStyle(styleBlue);
						}
						
						if(value <= 90){
							row3.getCell(valueCnt-1).setCellStyle(styleRed);
						}
						/*row4.createCell(valueCnt).setCellValue(ncList.get(i).getHhn());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHN"));
						row3.getCell(valueCnt-1).setCellStyle(style);*/
					}
				}else{
					row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHgz());
					
					double value = Double.parseDouble(ncList.get(i).getHgz());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
					row3.createCell(valueCnt++).setCellValue(ncList.get(i).getHhz());
					value = Double.parseDouble(ncList.get(i).getHhz());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}
				
				
			}
			
			firstRow = firstRow + 2;
		}
		
		if(wpList.size() != 0){
			dayHeaderX = firstRow;
			dayHeaderY = firstRow + 1;
			channelHeader = firstRow +1;
			obsHeaderX = firstRow;
			obsHeaderY = firstRow;
			
			HSSFRow row1 = sheet.createRow(firstRow++);
			HSSFRow row2 = sheet.createRow(firstRow++);
			HSSFRow row3 = sheet.createRow(firstRow);
			HSSFRow row4 = null;
			
			String checkDate = "";
			
			for(int i = 0; i < wpList.size(); i ++ ){
				
				if(!checkDate.equals(wpList.get(i).getDate())){
					checkDate = wpList.get(i).getDate();
					row3 = sheet.createRow(firstRow++);
					row3.createCell(0).setCellValue (checkDate);
					row3.getCell(0).setCellStyle(style);
					valueCnt = 1;
					obsCellS = 1;
					obsCellE = 1;
					channelCellS = 1;
					channelCellE = 1;
				}

				row1.createCell(0).setCellValue("날짜");
				row1.getCell(0).setCellStyle(style);
				sheet.addMergedRegion (new Region(( int) dayHeaderX , ( short )0 , ( int) dayHeaderY, (short )0 )); //날짜
				sheet.addMergedRegion (new Region(( int) obsHeaderX , ( short )obsCellS , ( int) obsHeaderY, (short )obsCellE )); //관측소
				
				row1.createCell(obsCellS).setCellValue(wpList.get(i).getObs_name());
				row1.getCell(obsCellS).setCellStyle(style);
				obsCellS = obsCellS +1;
				obsCellE = obsCellE +1;
				
				sheet. addMergedRegion (new Region(( int) channelHeader , ( short )channelCellS , ( int) channelHeader, (short )channelCellE )); //가속도
				
				row2.createCell(channelCellS).setCellValue ("가속도");
				row2.getCell(channelCellS).setCellStyle(style);
				channelCellS = channelCellS + 1;
				channelCellE = channelCellE + 1;
				
				/*sheet. addMergedRegion (new Region(( int) channelHeader , ( short )channelCellS , ( int) channelHeader, (short )channelCellE )); //속도
				
				row2. createCell(channelCellS). setCellValue ("속도");
				row2.getCell(channelCellS).setCellStyle(style);
				channelCellS = channelCellS + 3;
				channelCellE = channelCellE + 3;*/
				
				String sensorLoc = wpList.get(i).getStation().substring(2, 3);
				if("M".equals(sensorLoc) || "R".equals(sensorLoc)){
					row3.createCell(valueCnt++).setCellValue(wpList.get(i).getHdy());
					double value = Double.parseDouble(wpList.get(i).getHdy());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}else if("B".equals(sensorLoc)){
					row3.createCell(valueCnt++).setCellValue(wpList.get(i).getHdz());
					double value = Double.parseDouble(wpList.get(i).getHdz());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}else{
					row3.createCell(valueCnt++).setCellValue(wpList.get(i).getHgz());
					double value = Double.parseDouble(wpList.get(i).getHgz());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}
				
				/*if("R".equals(type)){
					
					String least1 = fnLeast(wpList.get(i).getHgz(), wpList.get(i).getHge(), wpList.get(i).getHgn());
					if(least1.equals("Z")){
						row4.createCell(valueCnt).setCellValue(wpList.get(i).getHgz());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGZ"));
						row3.getCell(valueCnt-1).setCellStyle(style);
					}else if(least1.equals("E")){
						row3.createCell(valueCnt++).setCellValue(wpList.get(i).getHge() + "(" + least1 + ")");
						row4.createCell(valueCnt).setCellValue(wpList.get(i).getHge());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGE"));
						row3.getCell(valueCnt-1).setCellStyle(style);
					}else{
						row3.createCell(valueCnt++).setCellValue(wpList.get(i).getHgn() + "(" + least1 + ")");
						row4.createCell(valueCnt).setCellValue(wpList.get(i).getHgn());
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGN"));
						row3.getCell(valueCnt-1).setCellStyle(style);
					}
				}else{
					row3.createCell(valueCnt++).setCellValue(wpList.get(i).getHgz());
				}*/
				/*
				row4.createCell(valueCnt).setCellValue(wpList.get(i).getHhz());
				row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHZ"));
				row3.getCell(valueCnt-1).setCellStyle(style);
				row4.createCell(valueCnt).setCellValue(wpList.get(i).getHhe());
				row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHE"));
				row3.getCell(valueCnt-1).setCellStyle(style);
				row4.createCell(valueCnt).setCellValue(wpList.get(i).getHhn());
				row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHN"));
				row3.getCell(valueCnt-1).setCellStyle(style);*/
				
			}
			
			firstRow = firstRow + 2;
		}
		
		if(ppList.size() != 0){
			dayHeaderX = firstRow;
			dayHeaderY = firstRow + 1;
			channelHeader = firstRow +1;
			obsHeaderX = firstRow;
			obsHeaderY = firstRow;
			
			HSSFRow row1 = sheet.createRow(firstRow++);
			HSSFRow row2 = sheet.createRow(firstRow++);
			HSSFRow row3 = sheet.createRow(firstRow);
			HSSFRow row4 = null;
			
			String checkDate = "";
			
			for(int i = 0; i < ppList.size(); i ++ ){
				
				if(!checkDate.equals(ppList.get(i).getDate())){
					checkDate = ppList.get(i).getDate();
					row3 = sheet.createRow(firstRow++);
					row3.createCell(0).setCellValue (checkDate);
					row3.getCell(0).setCellStyle(style);
					valueCnt = 1;
					obsCellS = 1;
					obsCellE = 1;
					channelCellS = 1;
					channelCellE = 1;
				}

				row1.createCell(0).setCellValue("날짜");
				row1.getCell(0).setCellStyle(style);
				sheet. addMergedRegion (new Region(( int) dayHeaderX , ( short )0 , ( int) dayHeaderY, (short )0 )); //날짜
				sheet. addMergedRegion (new Region(( int) obsHeaderX , ( short )obsCellS , ( int) obsHeaderY, (short )obsCellE )); //관측소
				
				row1. createCell( obsCellS). setCellValue (ppList.get(i).getObs_name().replace("발전소", ""));
				sheet.setColumnWidth(obsCellS, (sheet.getColumnWidth(obsCellS))+768 );  // 윗줄만으로는 컬럼의 width
				row1.getCell(obsCellS).setCellStyle(style);
				obsCellS = obsCellS +1;
				obsCellE = obsCellE +1;
				
				sheet. addMergedRegion (new Region(( int) channelHeader , ( short )channelCellS , ( int) channelHeader, (short )channelCellE )); //가속도
				
				row2. createCell( channelCellS). setCellValue ("가속도");
				row2.getCell(channelCellS).setCellStyle(style);
				channelCellS = channelCellS + 1;
				channelCellE = channelCellE + 1;
				
				/*sheet. addMergedRegion (new Region(( int) channelHeader , ( short )channelCellS , ( int) channelHeader, (short )channelCellE )); //속도
				
				row2.createCell(channelCellS).setCellValue ("속도");
				row2.getCell(channelCellS).setCellStyle(style);
				channelCellS = channelCellS + 3;
				channelCellE = channelCellE + 3;*/
				
				String sensorLoc = ppList.get(i).getStation().substring(2, 3);
				if("M".equals(sensorLoc)){
					row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHpy());
					double value = Double.parseDouble(ppList.get(i).getHpy());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}else if("B".equals(sensorLoc)){
					row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHpz());
					double value = Double.parseDouble(ppList.get(i).getHpz());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}else{
					row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHgz());
					double value = Double.parseDouble(ppList.get(i).getHgz());
					if(value <= 95){
						row3.getCell(valueCnt-1).setCellStyle(styleBlue);
					}
					
					if(value <= 90){
						row3.getCell(valueCnt-1).setCellStyle(styleRed);
					}
				}
				
				/*if("R".equals(type)){
					String least1 = fnLeast(ppList.get(i).getHgz(), ppList.get(i).getHge(), ppList.get(i).getHgn());
					
					if(least1.equals("Z")){
						row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHgz() + "(" + least1 + ")");
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGZ"));
						row3.getCell(valueCnt-1).setCellStyle(style);
					}else if(least1.equals("E")){
						row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHge() + "(" + least1 + ")");
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGE"));
						row3.getCell(valueCnt-1).setCellStyle(style);
					}else{
						row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHgn() + "(" + least1 + ")");
						row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HGN"));
						row3.getCell(valueCnt-1).setCellStyle(style);
					}
				}else{
					row3.createCell(valueCnt++).setCellValue(ppList.get(i).getHgz());
				}*/
				
				
				/*
				row4.createCell(valueCnt).setCellValue(ppList.get(i).getHhz());
				row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHZ"));
				row3.getCell(valueCnt-1).setCellStyle(style);
				row4.createCell(valueCnt).setCellValue(ppList.get(i).getHhe());
				row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHE"));
				row3.getCell(valueCnt-1).setCellStyle(style);
				row4.createCell(valueCnt).setCellValue(ppList.get(i).getHhn());
				row3.createCell(valueCnt++).setCellValue(new HSSFRichTextString("HHN"));
				row3.getCell(valueCnt-1).setCellStyle(style);*/
				
			}
			firstRow = firstRow + 2;
		}
		
		return firstRow;
	}
	
	private int drawDayChart(int rows, HSSFWorkbook workbook, HSSFSheet sheet, List<DataCollRateListVO> dataList, String gubun) throws Exception{
		DefaultCategoryDataset Data = new DefaultCategoryDataset();
		String obsName = dataList.get(0).getObs_name();
		for (DataCollRateListVO data : dataList) {
			
			String least1 = fnLeast(data.getHgz(), data.getHge(), data.getHgn());
			if(least1.equals("Z")){
				Data.addValue(Double.parseDouble(data.getHgz()) , "가속도" , data.getDate());
			}else if(least1.equals("E")){
				Data.addValue(Double.parseDouble(data.getHge()) , "가속도" , data.getDate());
			}else{
				Data.addValue(Double.parseDouble(data.getHgn()) , "가속도" , data.getDate());
			}
			
			if(gubun.equals("NC")){
				String least2 = fnLeast(data.getHhz(), data.getHhe(), data.getHhn());
				if(least2.equals("Z")){
					Data.addValue(Double.parseDouble(data.getHhz()) , "속도" , data.getDate());
				}else if(least2.equals("E")){
					Data.addValue(Double.parseDouble(data.getHhe()) , "속도" , data.getDate());
				}else{
					Data.addValue(Double.parseDouble(data.getHhn()) , "속도" , data.getDate());
				}
			}
		}
		JFreeChart lineChartObject=ChartFactory.createLineChart(obsName+"수집률 그래프(일일)","","",Data,PlotOrientation.VERTICAL,true,true,false);
		
		//CategoryPlot plot = (CategoryPlot)lineChartObject.getPlot();
		//CategoryAxis xAxis = (CategoryAxis)plot.getDomainAxis();
		//xAxis.setCategoryLabelPositions(CategoryLabelPositions.);
		
		int width=1460; /* 가로 */
		int height=450; /* 세로 */

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ChartUtilities.writeChartAsPNG(baos,lineChartObject,width,height);

		int my_picture_id = workbook.addPicture(baos.toByteArray(), workbook.PICTURE_TYPE_PNG);
		baos.close();
		/* 앵커라고 엑셀 어디에 박아놓을지 결정하는 것. */
		HSSFClientAnchor anchor = new HSSFClientAnchor();
		int col1=1,row1=rows; // 엑셀 12열, 2번째 칸에서 그림이 그려진다.

		// API참조할 것.
		anchor.setAnchor((short)col1, row1, 0, 0,(short) 23, rows + 21, 0, 0);
		// 그림이 1,11 에서 18,28까지 그러진다.

		anchor.setAnchorType(2);
		// Creating HSSFPatriarch object
		HSSFPatriarch patriarch=sheet.createDrawingPatriarch();

		//Creating picture with anchor and index information
		patriarch.createPicture(anchor,my_picture_id);
		/* Graph 만들기. Finish.*/
		
		return rows + 21;
		
	}
	
	private void drawMonthChart(int rows, HSSFWorkbook workbook, HSSFSheet sheet, List<DataCollRateListVO> dataList, String gubun) throws Exception{
		DefaultCategoryDataset Data = new DefaultCategoryDataset();
		String obsName = dataList.get(0).getObs_name();
		for (DataCollRateListVO data : dataList) {
			Data.addValue(Double.parseDouble(data.getHgz()) , "가속도"  , data.getDate());
			
			if(gubun.equals("NC")){
				Data.addValue(Double.parseDouble(data.getHhz()) , "속도" , data.getDate());
			}
		}
		
		JFreeChart lineChartObject=ChartFactory.createLineChart(obsName+"수집률 그래프(월별)","","",Data,PlotOrientation.VERTICAL,true,true,false);
		
		/*CategoryPlot plot = (CategoryPlot)lineChartObject.getPlot();
		CategoryAxis xAxis = (CategoryAxis)plot.getDomainAxis();
		xAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);*/
		
		int width=1460; /* 가로 */
		int height=450; /* 세로 */

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ChartUtilities.writeChartAsPNG(baos,lineChartObject,width,height);

		int my_picture_id = workbook.addPicture(baos.toByteArray(), workbook.PICTURE_TYPE_PNG);
		baos.close();
		/* 앵커라고 엑셀 어디에 박아놓을지 결정하는 것. */
		HSSFClientAnchor anchor = new HSSFClientAnchor();
		int col1=1,row1=rows + 2; // 엑셀 12열, 2번째 칸에서 그림이 그려진다.

		// API참조할 것.
		anchor.setAnchor((short)col1, row1, 0, 0,(short) 23, rows + 21, 0, 0);
		// 그림이 1,11 에서 18,28까지 그러진다.

		anchor.setAnchorType(2);
		// Creating HSSFPatriarch object
		HSSFPatriarch patriarch=sheet.createDrawingPatriarch();

		//Creating picture with anchor and index information
		patriarch.createPicture(anchor,my_picture_id);
		/* Graph 만들기. Finish.*/
	}
	
	private String fnLeast(String as, String bs, String cs){
		double a = Double.parseDouble(as);
		double b = Double.parseDouble(bs);
		double c = Double.parseDouble(cs);
		
		if(a > b){
			if(b > c){
				return "N";
			}else{
				return "E";
			}
		}else{
			if(a > c){
				return "N";
			}else{
				return "Z";
			}
		}
	}
	
	private static class MyRenderer extends XYLineAndShapeRenderer {

		private List<Color> clut;

		public MyRenderer(boolean lines, boolean shapes, int n) {
			super(lines, shapes);
			clut = new ArrayList<Color>(n);
			for (int i = 0; i < n; i++) {
				clut.add(Color.getHSBColor((float) i / n, 1, 1));
			}
		}

		@Override
		public Paint getItemFillPaint(int row, int column) {
			return clut.get(column);
		}
	}
	
	/*function fnLeast(a,b,c){
		if(a > b){
			if(b > c){
				return "N";
			}else{
				return "E";
			}
		}else{
			if(a > c){
				return "N";
			}else{
				return "Z";
			}
		}
	}*/
	
	
}
