package nms.util.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;

import nms.board.mapper.NoticeMapper;
import nms.util.mapper.FileMapper;
import nms.util.vo.FileVO;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * 파일 업로드를 처리하는 Service
 * @author 박병규
 * @since 2016.10.20
 * @version 1.0
 * @see
 * 
 * <pre>
 * << 개정이력(Modification Information) >>
 *   

 * </pre>
 */
@Repository(value = "fileService")
public class FileService {
	@Resource(name = "fileMapper")
	private FileMapper fileMapper;
	
	/**
	 * 게시판 및 자료실 업로드
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public boolean fileUpload(MultipartHttpServletRequest mRequest,String Key) {

		boolean isSuccess = false;
		mRequest.getSession().getServletContext().getRealPath("/file/");
//		String uploadPath = "/file/";
		String uploadPath = mRequest.getSession().getServletContext().getRealPath(File.separator+"file"+File.separator);
		String test = mRequest.getContextPath()+File.separator+"file"+File.separator;
		System.out.println(uploadPath);
//		System.out.println(test);
		File dir = new File(uploadPath);

		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		
		Iterator<String> iter = mRequest.getFileNames();
		while(iter.hasNext()) {
			String uploadFileName = iter.next();
			MultipartFile mFile = mRequest.getFile(uploadFileName);
			String originalFileName = mFile.getOriginalFilename();
			String fileType = originalFileName.substring(originalFileName.lastIndexOf("."),originalFileName.length());
			System.out.println(fileType);
			UUID uuid = UUID.randomUUID();
			String saveFileName = ""+uuid;
//			System.out.println(uploadFileName);
//			System.out.println(saveFileName);
			
			if(saveFileName != null && !saveFileName.equals("")) {
				if(new File(uploadPath + saveFileName).exists()) {
					saveFileName = saveFileName + "_" + System.currentTimeMillis();
				}
				try {
					mFile.transferTo(new File(uploadPath +File.separator+ saveFileName+fileType));
					isSuccess = true;				
				} catch (IllegalStateException e) {
					e.printStackTrace();
					isSuccess = false;
				} catch (IOException e) {
					e.printStackTrace();
					isSuccess = false;
				}
			} // if end
			System.out.println(uploadPath +File.separator+ saveFileName);
			System.out.println(originalFileName);
			try {
				fileMapper.insertFile(Key, uploadPath +File.separator+ saveFileName+fileType,saveFileName+fileType, originalFileName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} // while end
		return isSuccess;
	} // fileUpload end
	
	/**
	 * 게시판 및 자료실 업로드
	 */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public boolean imgFileUpload(MultipartHttpServletRequest mRequest,String type,String no) {

		boolean isSuccess = false;
//		mRequest.getSession().getServletContext().getRealPath("/images/observatory");
//		String uploadPath = "/file/";
		String uploadPath = mRequest.getSession().getServletContext().getRealPath(File.separator+"images"+File.separator+"observatory"+File.separator);
		String test = mRequest.getContextPath()+File.separator+"file"+File.separator;
		System.out.println(uploadPath);
//		System.out.println(test);
		File dir = new File(uploadPath);

		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		
		Iterator<String> iter = mRequest.getFileNames();
		while(iter.hasNext()) {
			String uploadFileName = iter.next();
			MultipartFile mFile = mRequest.getFile(uploadFileName);
			String originalFileName = mFile.getOriginalFilename();
			String fileType = originalFileName.substring(originalFileName.lastIndexOf("."),originalFileName.length());
			
//			System.out.println(fileType);
			
			String saveFileName = type+no+"_"+uploadFileName;
			System.out.println(uploadFileName+fileType);
			
			if(saveFileName != null && !saveFileName.equals("")) {
				if(new File(uploadPath + saveFileName).exists()) {
					saveFileName = saveFileName + "_" + System.currentTimeMillis();
				}
				try {
					mFile.transferTo(new File(uploadPath +File.separator+ saveFileName+fileType));
					isSuccess = true;				
				} catch (IllegalStateException e) {
					e.printStackTrace();
					isSuccess = false;
				} catch (IOException e) {
					e.printStackTrace();
					isSuccess = false;
				}
			} // if end
			try {
				if(type.equals("sta")){
					fileMapper.updateStationImg(uploadFileName, saveFileName+fileType, no);
				}else if (type.equals("sen")){
					fileMapper.updateSensorImg(uploadFileName, saveFileName+fileType, no);
				}else{
					fileMapper.updateRecorderImg(uploadFileName, saveFileName+fileType, no);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println(uploadPath +File.separator+ saveFileName);
			System.out.println(originalFileName);
			
			try {
//				fileMapper.insertFile(Key, uploadPath +File.separator+ saveFileName+fileType,saveFileName+fileType, originalFileName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} // while end
		return isSuccess;
	} // fileUpload end
	
	
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteFile(String f_no) throws Exception
	{
		FileVO selectFileInfo = fileMapper.selectFileInfo(f_no);
		File file = new File(selectFileInfo.getF_path());
		
		if(file.isFile()){
			file.delete();
		}
		
		
		return fileMapper.deleteFile(f_no);
	}
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Exception.class})
	public void deleteFiles(String m_key) throws Exception
	{
		List<FileVO> selectFileInfoList = fileMapper.selectFileInfoList(m_key);
		for(FileVO f : selectFileInfoList)
		{
			File file = new File(f.getF_path());
			if(file.isFile()){
				file.delete();
			}
			fileMapper.deleteFile(f.getF_no());
		}
	}
	
	public String sWrite(String name, String charset, String content,String[] command) throws Exception {
		System.out.printf("%s 파일 쓰기. (%s) %n", name, charset);
		
		FileOutputStream fileHandle = new FileOutputStream(name);
		OutputStreamWriter streamHandle = new OutputStreamWriter( fileHandle, charset);
		streamHandle.write(content);
		streamHandle.close();
		fileHandle.close();
		
		//프로세스 빌더 command로 보내도록
		
		ProcessBuilder builder = new ProcessBuilder(command);
        Process process = builder.start();
        printStream(process);
        
		return "a";
		
	}
	
    public void printStream(Process process)
            throws IOException, InterruptedException {
    	process.waitFor();
	    try (InputStream psout = process.getInputStream()) {
	        copy(psout, System.out);
	    }
    }
    public void copy(InputStream input, OutputStream output) throws IOException {
        byte[] buffer = new byte[1024];
        int n = 0;
        while ((n = input.read(buffer)) != -1) {
            output.write(buffer, 0, n);
        }
    }
}
