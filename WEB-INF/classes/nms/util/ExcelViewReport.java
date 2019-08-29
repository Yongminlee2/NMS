package nms.util;

import java.awt.Color;
import java.awt.Paint;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nms.inforeceived.vo.DataCollRateListVO;
import nms.quakeoccur.vo.QuakeEventReportVO;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
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
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
public class ExcelViewReport extends AbstractExcelView{

	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HSSFCellStyle s1 = workbook.createCellStyle();
		s1.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
		
		HSSFCellStyle s2 = workbook.createCellStyle();
		s2.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
		
		HSSFSheet excelSheet = workbook.createSheet("excel");
		HSSFRow excelHeader = excelSheet.createRow(0);
		HSSFCell createCell = excelHeader.createCell(0);
		createCell.setCellValue("No");
		createCell.setCellStyle(s1);createCell.setCellStyle(s2);
		
		System.out.println("엑셀뷰");
		
//		setImage(workbook,excelSheet,1,3,6,10,"d:"+File.separator+"excel"+File.separator+"test.jpg");
//		setImage(workbook,excelSheet,1,3,1,5,"d:"+File.separator+"excel"+File.separator+"test.jpg");
		drawLine("Left",workbook,excelSheet,1,5,1);
		drawLine("Top",workbook,excelSheet,1,4,1);
		drawLine("Bottom",workbook,excelSheet,1,4,4);
		drawLine("Right",workbook,excelSheet,1,5,3);
		
		
		HashMap<String, String> map = new HashMap<>();
		map.put("date", "2017-06-20");
		map.put("time", "11:02:37");
		map.put("lat", "35.85");
		map.put("lng", "129.08");
		map.put("address", "경북 경주시 서쪽 12km 지역");
		map.put("mag", "3.2");
		
		List<QuakeEventReportVO> quekes = new ArrayList();
		String[] a = {"고리","월성","한울","한빛"};
		String[] b = {"KAG","월성","한울","한빛"};
		String[] c = {"인재개발원","월성","한울","한빛"};
		String[] d = {"55","월성","한울","한빛"};
		String[] e = {"0.000374","월성","한울","한빛"};
		String[] f = {"0.000495","월성","한울","한빛"};
		String[] g = {"0.000661","월성","한울","한빛"};
		for(int i=0;i<4;i++){
			QuakeEventReportVO q = new QuakeEventReportVO();
			q.setOrg(a[i]); q.setObs_id(b[i]); q.setAddress(c[i]);
			q.setKmeter(d[i]);q.setAc100_z(e[i]);q.setAc100_n(f[i]);q.setAc100_e(g[i]);
		}
//		createSummaryQuakeExcel(workbook,excelSheet,map,quekes,quekes);
		String fileName = java.net.URLEncoder.encode((String) model.get("fileName"), "utf-8");
		
		

											//행			  열			병합여부(0병합 1놉) 범위
//		sheet. addMergedRegion (new Region(( int) 0 , ( short )0 , ( int) 1, (short )0 )); //번호
		response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
	}
	
	public void setImage(HSSFWorkbook workbook, HSSFSheet excelSheet, int col1, int col2, int row1, int row2,String imgPath) throws IOException
	{
		FileInputStream inputStream = new FileInputStream(imgPath);
        byte[] bytes = IOUtils.toByteArray(inputStream);
        int pictureIdx = workbook.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
        inputStream.close();
        
        HSSFClientAnchor anchor = new HSSFClientAnchor();

		// API참조할 것.
		anchor.setAnchor((short)col1, row1, 0, 0,(short) col2, row2, 0, 0);
		// 그림이 1,11 에서 18,28까지 그러진다.

		anchor.setAnchorType(2);
		// Creating HSSFPatriarch object
		HSSFPatriarch patriarch=excelSheet.createDrawingPatriarch();

		//Creating picture with anchor and index information
		patriarch.createPicture(anchor,pictureIdx);
	}
	
	public void createSummaryQuakeExcel(HSSFWorkbook workbook, HSSFSheet excelSheet, Map<String,String> datas, List<QuakeEventReportVO> quekes, List<QuakeEventReportVO> quekes2) throws IOException
	{
		HSSFRow createRow = null;
		createRow = excelSheet.createRow(0);
		createRow.createCell(1).setCellValue("지진관측 보고서");
		
		createRow = excelSheet.createRow(1);
		createRow.createCell(1).setCellValue("1. 개요");
		createRow.createCell(4).setCellValue("(KST : Korean Standard Time)");
		
		createRow = excelSheet.createRow(2);
		createRow.createCell(1).setCellValue("발생 시각 (KST)");
		createRow.createCell(3).setCellValue("진앙 위치");
		createRow.createCell(5).setCellValue("규모");
		
		createRow = excelSheet.createRow(3);
		createRow.createCell(1).setCellValue("년 월 일");
		createRow.createCell(2).setCellValue("시 각");
		createRow.createCell(3).setCellValue("위 도");
		createRow.createCell(4).setCellValue("경 도");
		
		createRow = excelSheet.createRow(4);
		createRow.createCell(1).setCellValue(datas.get("date"));
		createRow.createCell(2).setCellValue(datas.get("time"));
		createRow.createCell(3).setCellValue(datas.get("lat"));
		createRow.createCell(4).setCellValue(datas.get("lng"));
		createRow.createCell(5).setCellValue(datas.get("mag"));
		
		createRow = excelSheet.createRow(5);
		createRow.createCell(3).setCellValue(datas.get("address"));
		
		createRow = excelSheet.createRow(7);
		createRow.createCell(1).setCellValue("2. 지진관측소 관측값");
		createRow.createCell(3).setCellValue("(1g=980cm/sec=980gal,SSE=0.2g,OBE=0.1g, 00:00:00~00:00:00");
		
		setImage(workbook,excelSheet,1,4,8,13,"d:"+File.separator+"excel"+File.separator+"test.jpg");
		createRow = excelSheet.createRow(8);
		createRow.createCell(5).setCellValue("2. 지진관측소 관측값");
		
//		int i = 0;
//		for(QuakeEventReportVO q : quekes){//4
//			createRow = excelSheet.createRow(8+i);
//		}
	}
	
	public void drawLine(String type,HSSFWorkbook workbook,HSSFSheet excelSheet,int stNum, int enNum, int row)
	{
		HSSFCellStyle ccs1 = workbook.createCellStyle();
		HSSFCellStyle ccs2 = workbook.createCellStyle();
		if(type.equals("Top")){
			ccs1.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			System.out.println("top");
		}else if(type.equals("Left")){
			ccs2.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			System.out.println("left");
		}else if(type.equals("Right")){
			ccs2.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			System.out.println("right");
		}else{
			ccs1.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			System.out.println("bottom");
		}
		
		if(type.equals("Top") || type.equals("Bottom"))
		{
			HSSFRow rowNum = excelSheet.createRow(row);
			for(int i= stNum; i < enNum; i ++)
			{
				HSSFCell createCell = rowNum.createCell(i);
				createCell.setCellStyle(ccs1);
			}
			
		}else{
			for(int i = stNum; i < enNum ; i++)
			{
				HSSFRow rowNum = excelSheet.createRow(i);
				HSSFCell createCell = rowNum.createCell(row);
				createCell.setCellStyle(ccs2);
			}
		}
		
	}

}
