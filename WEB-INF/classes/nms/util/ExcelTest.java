package nms.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;

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
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFCreationHelper;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;

public class ExcelTest {
	public static void main(String[] args) throws Exception {
		    
        try {
        	ExcelFnc fnc = new ExcelFnc();
            // 엑셀파일
			FileInputStream inputStream = new FileInputStream("D:"+File.separator+"excel"+File.separator+"sample.xls");
	    	FileOutputStream outputStream = new FileOutputStream("D:"+File.separator+"excel"+File.separator+"test_copy.xls");
	    	
	    	FileChannel fcin =  inputStream.getChannel();
	    	FileChannel fcout = outputStream.getChannel();
	    	  
	    	long size = fcin.size();
	    	fcin.transferTo(0, size, fcout);
	    	  
	    	fcout.close();
	    	fcin.close();
	    	  
	    	outputStream.close();
	    	inputStream.close();
        	
            File file = new File("D:"+File.separator+"excel"+File.separator+"test_copy.xls");
 
            // 엑셀 파일 오픈
//            XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(file));
            HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(file));
            
            Cell cell = null;
            HSSFSheet sheetAt = wb.getSheetAt(0);
            HSSFSheet cloneSheet = wb.cloneSheet(0);
            JFreeChart lineChart = ChartFactory.createLineChart(
                    "1",
                    "Years","Number of Schools",
                    createDataset(),
                    PlotOrientation.VERTICAL,
                    true,true,false);
            
//            sheetAt.getRow(7).createCell(3).setCellValue("보고자 : 두두원 박태진(010-2818-7645)");
    		int width=1460; /* 가로 */
    		int height=450; /* 세로 */
    		ByteArrayOutputStream baos = new ByteArrayOutputStream();
    		ChartUtilities.writeChartAsPNG(baos,lineChart,width,height);

    		int my_picture_id = wb.addPicture(baos.toByteArray(), wb.PICTURE_TYPE_PNG);
    		baos.close();
    		
    		HSSFClientAnchor anchor = new HSSFClientAnchor();
    		int col1=1,row1=1; // 엑셀 12열, 2번째 칸에서 그림이 그려진다.
    		anchor.setAnchor((short)col1, row1, 0, 0,(short) 23, 22, 0, 0);
    		anchor.setAnchorType(2);
    		HSSFPatriarch patriarch=sheetAt.createDrawingPatriarch();
    		patriarch.createPicture(anchor,my_picture_id);
    		
//    		String[] a = {"-36545","-36545","-36545","-36545","-36545"};
//    		fnc.drawDayChart(wb, sheetAt,a , 1, 20, 1, 12);
            HSSFCellStyle cellStyle = sheetAt.getRow(1).getCell(11).getCellStyle();
            HSSFCell valueCell = sheetAt.getRow(1).createCell(11);
            valueCell.setCellValue("보고자 : 두두원 박태진(010-2818-7645)");
            valueCell.setCellStyle(cellStyle);
            setImage(wb,sheetAt,2,5,10,16,"D:"+File.separator+"excel"+File.separator+"test.jpg");
            setImage(wb,sheetAt,2,12,18,28,"D:"+File.separator+"excel"+File.separator+"test.jpg");
            
            // 엑셀 파일 저장
            FileOutputStream fileOut = new FileOutputStream(file);
            
            wb.write(fileOut);
            fileOut.close();
            System.out.println("끝");
        } catch (FileNotFoundException fe) {
            System.out.println("FileNotFoundException >> " + fe.toString());
        } catch (IOException ie) {
            System.out.println("IOException >> " + ie.toString());
        }

	}
   private static DefaultCategoryDataset createDataset( ) {
	      DefaultCategoryDataset dataset = new DefaultCategoryDataset( );
	      dataset.addValue( 15 , "schools" , "1" );
	      dataset.addValue( 30 , "schools2" , "1" );
	      dataset.addValue( 30 , "schools" , "2" );
	      dataset.addValue( 60 , "schools2" , "2" );
	      dataset.addValue( 60 , "schools" ,  "3" );
	      dataset.addValue( 120 , "schools2" ,  "3" );
	      dataset.addValue( 120 , "schools" , "4" );
	      dataset.addValue( 240 , "schools2" , "4" );
	      
	      dataset.addValue( 240 , "schools" , "5" );
	      dataset.addValue( 280 , "schools2" , "5" );
	      dataset.addValue( 300 , "schools" , "6" );
	      dataset.addValue( 450 , "schools2" , "6" );
	      return dataset;
	}
	public static void setImage(HSSFWorkbook wb, HSSFSheet sheetAt, int col1, int col2, int row1, int row2,String imgPath) throws IOException
	{
		FileInputStream inputStream = new FileInputStream(imgPath);
        byte[] bytes = IOUtils.toByteArray(inputStream);
        int pictureIdx = wb.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
        inputStream.close();
        
        HSSFCreationHelper helper = wb.getCreationHelper();
        HSSFClientAnchor anchor = helper.createClientAnchor();
//            HSSFClientAnchor anchor =  new HSSFClientAnchor();
//            HSSFClientAnchor anchor =  helper.createClientAnchor();
            // 이미지를 출력할 CELL 위치 선정
        anchor.setAnchor((short)col1, row1, 0, 0,(short) col2, row2, 0, 0);
//            anchor.setAnchorType(2);
//        anchor.setCol1(1);
//        anchor.setRow1(6); //row
//        anchor.setCol2(3); //    col1   col2
//        anchor.setRow2(8); //row row1   row2 
        // 이미지 그리기
//            XSSFPicture pict = drawing.createPicture(anchor, pictureIdx);
//            XSSFPicture pict = drawing.createPicture(anchor, pictureIdx);
//            HSSFPatriarch patriarch=sheetAt.createDrawingPatriarch();
        HSSFPatriarch patriarch=sheetAt.createDrawingPatriarch();
        patriarch.createPicture(anchor,pictureIdx);
        // 이미지 사이즈 비율 설정
            
	}
}
