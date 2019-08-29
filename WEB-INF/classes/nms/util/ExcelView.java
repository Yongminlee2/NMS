package nms.util;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
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
public class ExcelView extends AbstractExcelView{

	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HSSFSheet excelSheet = workbook.createSheet("excel");
		// excelSheet.setDefaultColumnWidth(30);

		setExcelHeader(workbook, excelSheet, (List<String>) model.get("header"));

		setExcelRows(workbook, excelSheet, (List<String>) model.get("dataFields"), (List<Object>) model.get("dataList"));

		for(int i = 0; i < ((List<String>) model.get("dataFields")).size() + 1; i++)
		{
			excelSheet.autoSizeColumn(i);
			excelSheet.setColumnWidth(i, (excelSheet.getColumnWidth(i)) + 2000);
		}

		// excelSheet.addMergedRegion(new CellRangeAddress(firstRow, lastRow, firstCol, lastCol));

		String fileName = java.net.URLEncoder.encode((String) model.get("fileName"), "utf-8");

		response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
	}

	/**
	 * 데이타 헤더 생성
	 * @param workbook
	 * @param excelSheet
	 * @param header
	 */
	public void setExcelHeader(HSSFWorkbook workbook, HSSFSheet excelSheet, List<String> header) {
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

		HSSFRow excelHeader = excelSheet.createRow(0);
		excelHeader.setHeight((short) 400);

		excelHeader.createCell(0).setCellValue("No");

		excelHeader.getCell(0).setCellStyle(style);

		for(int i = 0; i < header.size(); i++)
		{
			excelHeader.createCell(i + 1).setCellValue(header.get(i));
			excelHeader.getCell(i + 1).setCellStyle(style);
		}
	}

	/**
	 * 데이타 행 생성
	 * @param excelSheet
	 * @param dataFields
	 * @param dataList
	 * @throws NoSuchFieldException
	 * @throws SecurityException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 */
	public void setExcelRows(HSSFWorkbook workbook, HSSFSheet excelSheet, List<String> dataFields, List<Object> dataList) throws SecurityException, IllegalArgumentException, IllegalAccessException
	{
		int record = 1;

		for (Object object :  dataList)
		{
			HSSFRow excelRow = excelSheet.createRow(record++);

			excelRow.createCell(0).setCellValue(String.valueOf(record - 1));

			Class<?> newClass = object.getClass();

			for(int i = 0; i < dataFields.size(); i++)
			{
				try
				{
					Field field = newClass.getDeclaredField(dataFields.get(i).replace("N_", ""));
					field.setAccessible(true);

					Object value = field.get(object);

					Cell cell = excelRow.createCell(i + 1);
					
					if(dataFields.get(i).indexOf("N_") == 0)
					{
						try {
							cell.setCellValue(Double.parseDouble(((String)value)));
							cell.setCellType(Cell.CELL_TYPE_NUMERIC);
						} catch (NullPointerException e) {
							cell.setCellValue((String)value);
						} catch (NumberFormatException e) {
							cell.setCellValue((String)value);
						}
						/*
						CellStyle style = workbook.createCellStyle();
						style.setDataFormat(workbook.createDataFormat().getFormat("0.0"));
						cell.setCellStyle(style);
						*/
					}
					else
					{
						cell.setCellValue((String)value);
					}
				}
				catch(NoSuchFieldException e)
				{
					System.out.println(e.toString());
				}
			}
		}
	}
}
