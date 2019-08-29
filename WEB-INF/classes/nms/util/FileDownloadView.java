package nms.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

/**
 * 파일 다운로드를 위한 View 클래스
 * @author 박용성
 * @since 2014.06.20
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2014.06.20  박용성          최초 생성
 *
 * </pre>
 */
public class FileDownloadView extends AbstractView {

	/**
	 * 파일 다운로드 뷰 생성자
	 */
	public FileDownloadView() {
		setContentType("applicaiton/download;charset=utf-8");
	}

	/**
	 * renderMergedOutputModel
	 */
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception
	{
		File file = (File) model.get("downloadFile");

		response.setContentType(getContentType());
		response.setContentLength((int) file.length());
		
		String fileName = java.net.URLEncoder.encode(file.getName(), "utf-8")
				.replaceAll("\\+", "%20")
                .replaceAll("\\%21", "!")
                .replaceAll("\\%27", "'")
                .replaceAll("\\%28", "(")
                .replaceAll("\\%29", ")")
                .replaceAll("\\%7E", "~");
		
		response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");

		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;

		try
		{
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (fis != null)
			{
				try
				{
					fis.close();
				}
				catch (Exception e2) {}
			}
		}
		
		out.flush();
	}
}
