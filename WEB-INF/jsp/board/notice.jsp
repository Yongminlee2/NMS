<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		
    <link href="<c:url value="/css/base.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/contrl.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />
    
	<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.form.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	
	<script src="<c:url value="/js/css/modernizr.js"/>"></script>
	<script src="<c:url value="/js/css/common.js"/>"></script>
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}/board/notice/list" />
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}/board/notice" />
	
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
		.test-btn{
		    position: absolute;
		    top: 141px;
		    z-index: 999;
		}
		.delBtn{
			margin-left:4px;
			color:red;
			cursor: pointer;
		}
		#upload-area input{
	 		width:180px;
	 		padding-bottom:6px;
	 	}
	 	#add-file{
		    display: inline;
		    font-weight: bold;
		    font-size: 19px;	 	
		    cursor: pointer;
	 	}		
	</style>
	<script>
		var boardNo="";
		$(document).ready(function(){
			$("input[name='searchKeyword']").val('${searchKeyword}');
// 			$("input[name='startDate']").val('${pagingInfo.stDate }');
// 			$("input[name='endDate']").val('${pagingInfo.enDate }');
			
			fnSetDatePickerAndToDate($("input[name='startDate']"), -1);
			fnSetDatePickerAndToDate($("input[name='endDate']"), 0);
		});
		
		function fnDetailBoard(no){
			boardNo = no;
			$.ajax({
				url: "${pageName2 }/view.ws",
				type: "POST",
				data: no,
				success : function(data){
					if(data.resultDesc=="success"){
						var obj = data.data;
						var files = data.data2;
						console.log(obj);
						console.log(files);
						$("#con_title").html(obj.board_title);
						$("#con_user").html(obj.user_nm+"("+obj.user_id+")");
						$("#con_dt").html(obj.board_dt);
						$("#contents").html(obj.board_content);
						for(var i=0;i<files.length;i++)
						{
							$("#download").append("<a key='"+files[i].f_name+"' href='${pageContext.request.contextPath}/file/"+files[i].f_name+"' download='"+files[i].f_realname+"' >"+files[i].f_realname+"</a><span key='"+files[i].f_name+"' class='update delBtn' onclick=\"fnDeleteFile('"+files[i].f_no+"',this)\">x</span>&nbsp;&nbsp;");	
						}
						
						fnSettingBoard("normal");
						fnHideAllConteiner();
						$(".notice-view").show();
					}
				} 
			}); 
		}
		function fnCallInsertNotice(){
			fnSettingBoard("insert");
			fnHideAllConteiner();
			$(".notice-view").show();
			$("#upload-area").children("input").each(function(i,v){
				if($(this).attr("name")!="uploadFile"){
					$(this).remove();
				}
			});
			$("input[name='uploadFile']").val("");
		}
		function fnHideAllConteiner(){
			$(".notice-list").hide();
			$(".notice-view").hide();
// 			$(".notice-insert").hide();
		}
		function fnReturnList(){
			fnHideAllConteiner();
			$(".notice-list").show();
			$("#download").html("");
		}
		function fnSettingBoard(type){
			$("#con_title").attr("contenteditable",true);
			$("#contents").attr("contenteditable",true);
			$("#notice-btn1").off("click");
			$("#notice-btn2").off("click");
			$(".insert").hide();
			$(".update").hide();
			
			if(type=="insert"){
				$("#con_title").html("");
				$("#contents").html("");
				$(".update").show();
				$("#notice-btn1").attr("src","<c:url value='/img/btt_note_save.png'/>");
				$("#notice-btn1").on("click",function(){
					if(confirm("입력하시겠습니까?")){
						$.ajax({
							url: "${pageName2}/insert.ws",
							type: "POST",
						    dataType: 'json',
						    contentType: "application/json; charset=utf-8",
		 					data: "{\"board_title\":\""+$("#con_title").html()+"\",\"board_content\":\""+$("#contents").html()+"\"}",
// 							data: formData,
							success : function(data){
								if(data.resultDesc=="success"){
									$("#notice-form").ajaxSubmit({
										success : function(data) {
											if(data=="success"){
												alert("입력이 완료되었습니다.");	
												window.location.reload();
											}
										},
										error : function(error) {
											alert("요청 처리 중 오류가 발생하였습니다.");
										}
									});
								}else{
									alert("게시물을 입력하지 못하였습니다.");
								}
							} 
						}); 

					}
				});
				$("#notice-btn2").attr("src","<c:url value='/img/btt_note_cancle.png'/>");
				$("#notice-btn2").on("click",function(){
					if(confirm("취소하시겠습니까?")){
						fnReturnList();
					}
				});				
			}else if(type=="mody"){
				$("#notice-btn1").attr("src","<c:url value='/img/btt_note_modify.png'/>");
				$(".update").show();
				$("#notice-btn1").on("click",function(){
					if(confirm("수정하시겠습니까?")){
						$.ajax({
							url: "${pageName2}/update.ws",
							type: "POST",
					        dataType: 'json',
					        contentType: "application/json; charset=utf-8",
							data: "{\"no\":\""+boardNo+"\",\"board_title\":\""+$("#con_title").html()+"\",\"board_content\":\""+$("#contents").html()+"\"}",
							success : function(data){
								if(data.resultDesc=="success"){
									$("#notice-form").ajaxSubmit({
										success : function(data) {
											if(data=="success"){
												alert("수정이 완료되었습니다.");	
												window.location.reload();
											}
										},
										error : function(error) {
											alert("요청 처리 중 오류가 발생하였습니다.");
										}
									});
									
								}else{
									alert("게시물을 입력하지 못하였습니다.");
								}
							} 
						}); 
					}
				});
				$("#notice-btn2").attr("src","<c:url value='/img/btt_note_delt.png'/>");
				$("#notice-btn2").on("click",function(){
					if(confirm("취소하시겠습니까?")){
						fnSettingBoard("normal");
						$(".temp-file").remove();
					}
				});						
			}else{
				$("#con_title").attr("contenteditable",false);
				$("#contents").attr("contenteditable",false);
				
				$(".insert").show();
				$("#notice-btn1").attr("src","<c:url value='/img/btt_note_modify.png'/>");
				$("#notice-btn1").on("click",function(){
					if(confirm("수정하시겠습니까?")){
						fnSettingBoard("mody");
					}
				});
				$("#notice-btn2").attr("src","<c:url value='/img/btt_note_delt.png'/>");
				$("#notice-btn2").on("click",function(){
					if(confirm("삭제하시겠습니까?")){
						$.ajax({
							url: "${pageName2}/delete.ws",
							type: "POST",
					        dataType: 'json',
					        contentType: "application/json; charset=utf-8",
							data: boardNo,
							success : function(data){
								if(data.resultDesc=="success"){
									alert("삭제되었습니다.");
									window.location.reload();
								}else{
									alert("삭제에 실패하였습니다.");
								}
							} 
						}); 
					}
				});		
			}
		}
	function addFile(obj){
		var dt = new Date();
		if(($("#upload-area input[type='file']").size()+$("#upload-area a").size())>=5){
			alert("더이상 추가하실 수 없습니다.");
			return false;
		}
		$(obj).before("<input name='"+dt.getTime()+"' type='file' class='temp-file'>");
	}
	function fnDeleteFile(f_no,obj){
		if(confirm("삭제하시겠습니까? 삭제된 파일은 복원되지 않습니다.")){

			$.ajax({
				url: "${pageName2}/deleteFile.ws",
				type: "POST",
		        dataType: 'json',
		        contentType: "application/json; charset=utf-8",
				data: f_no,
				success : function(data){
					if(data.resultDesc=="success"){						
						$("a[key='"+$(obj).attr("key")+"']").remove();
						$(obj).remove();
					}else{
						alert("삭제에 실패하였습니다.");
					}
				} 
			}); 
		}
	}
	</script>
</head>
<body>
	<div id="wrap" class="notice-list">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">공지사항</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>알림마당</li>
	       <li class="addNow">공지사항</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->
	       <form id="searchForm" name="searchForm" action="${pageName }" method="post">
	        <input type="hidden" name="page" value="${pagingInfo.currentPage }">
	       <article class="selectbox_long">
	           <ul>
	             <li>제목 <input type="text" id="" name="searchKeyword"></li>
	             <li>작성일자
					 <input id="" name="startDate" value="">
	             </li>
	             <li><input id="" name="endDate" value=""></li>	             
	             <li class="btt_filecomplt"><a href="javascript:searchForm.submit();">자료확인</a></li>
	           </ul>
	       </article>
	       </form>
	       <!--표-->
	       <article class="s_table2">
             <p class="f20">검색자료 <span class="fOrange">총 ${totalCnt }건</span></p>
             <p class="f14"> <span onclick="fnCallInsertNotice()"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_add.png"/>" alt="추가"></a></span></p>
             <div style="min-height:535px;">
	             <table>
	               <caption>관측소 목록</caption>
	               <colgroup>
	                           <col style="width:5%" />
	                           <col style="width:60%" />
	                           <col style="width:10%" />
	                           <col style="width:25%" />
	               </colgroup>
	               <thead>
	                 <tr>
	                   <th>번호</th>
	                   <th>제목</th>
	                   <th>작성자</th>
	                   <th>날짜</th>
	                 </tr>
	               </thead>
	               <tbody>
	               <c:if test="${totalCnt < 1 }">
	               		<tr style="height:44px;">
	               			<td colspan="4">검색된 자료가 없습니다.</td>
	               		</tr>
	               </c:if>		               
					<c:forEach items="${noticeList}" var="notice" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr  style="height:44px;" onclick="fnDetailBoard('${notice.no}')" class="bg_gray2">
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr  style="height:44px;" onclick="fnDetailBoard('${notice.no}')">
						</c:if>
							<td>${notice.no }</td>
							<td>${notice.board_title }</td>
							<td>${notice.user_id }</td>
							<td>${notice.board_dt }</td>
						</tr>
					</c:forEach>
	               </tbody>
	             </table>
             </div>
			<tag:paging url="${pageName }" firstPage="${pagingInfo.firstPage }" endPage="${pagingInfo.endPage }" lastPage="${pagingInfo.totalLastPage }" curPage="${pagingInfo.currentPage }" totalCnt="${totalCnt }"/>
          </article>
	    </section>
	    
	</div>
	<div id="wrap"  class="notice-view" style="display: none;">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">공지사항</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>알림마당</li>
	       <li class="addNow">공지사항</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
          <article id="con_view" class="board">
          	<form id="notice-form" action="${pageName2 }/fileUpload.ws" method="post" enctype="multipart/form-data">
          	<table>
          		<tr><td>
	               <ul>
	                 <li class="bTit">타이틀</li>
	                 <li class="binput" style="margin-right:0px;"><div style="padding-left:5px;text-align:left;" id="con_title"></div></li>
	                 <li class="insert bTit">작성자</li>
	                 <li  style="text-align:left;" id="con_user" class="insert"></li>
	                 <li class="insert bTit">작성일</li>
	                 <li  style="text-align:left;" id="con_dt" class="insert"></li>
	               </ul>
               </td></tr>
          		<tr style="background-color:#e4f0fa;border-bottom: 2px solid white;">
          			<td id="upload-area">
	          			<span id="download" class="download" style="padding-left:10px;"></span><br>
	          			<input  class="update" name="uploadFile" id="file" type="file"><span class="update" id="add-file" onclick="addFile(this)">+</span>
          			</td>
          		</tr>               
               <tr><td>
               <div id="contents" class="bWright" style="width:1437px;min-height: 300px;max-width:1440px;">abcd deeasd <br> aasd <br> asda <br> asdas </div>
               </td></tr>
<!--                <textarea contenteditable="true" name="message" class="bWright" rows="30"></textarea> -->
				<tr><td>
               <ul class="boardBtt">
               
                 <li class="fLeft" style="margin-left:0px;"><a href="#"><img class="insert" src="<c:url value="/img/btt_note_list.png"/>" onclick="fnReturnList()" alt="목록"></a></li>
                 <li class="fRight">
                   <p style="padding-left:160px;"><a href="#"><img id="notice-btn1" src="<c:url value="/img/btt_note_save.png"/>" alt="목록"></a></p>
<%--                    <p style="padding-left:160px;"><input type="image" value="submit" name="submit" src="<c:url value="/img/btt_note_save.png" />" style="height:43px;"></p> --%>
                   <p style="padding-left: 30px;"><a href="#"><img id="notice-btn2" src="<c:url value="/img/btt_note_cancle.png"/>" alt="목록"></a></p>
                 </li>
               </ul>
               </td></tr>
              </table>
             </form>
           </article>
	   </section>
	    
	</div>
		
	<div id="wrap"  class="notice-insert" style="display: none;">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">공지사항</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>알림마당</li>
	       <li class="addNow">공지사항</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	   		
          <article id="con_view" class="board">
          	<table>
          		<tr><td>
	               <ul>
	                 <li class="bTit">타이틀</li>
	                 <li class="binput" id="con_title"></li>
	                 <li class="bTit">작성자</li>
	                 <li id="con_user"></li>
	                 <li class="bTit">작성일</li>
	                 <li id="con_dt"></li>
	               </ul>
               </td></tr>
               <tr><td>
               <div id="contents" class="bWright" style="width:99%;max-width:1440px;">abcd deeasd <br> aasd <br> asda <br> asdas </div>
               </td></tr>
<!--                <textarea contenteditable="true" name="message" class="bWright" rows="30"></textarea> -->
				<tr><td>
               <ul class="boardBtt">
               
                 <li class="fLeft" style="margin-left:0px;"><a href="#"><img src="<c:url value="/img/btt_note_list.png"/>" onclick="fnReturnList()" alt="목록"></a></li>
                 <li class="fRight">
<%--                    <p><a href=""><img src="<c:url value="/img/btt_note_save.png"/>" alt="목록"></a></p> --%>
<%--                    <p><a href=""><img src="<c:url value="/img/btt_note_cancle.png"/>" alt="목록"></a></p> --%>
                 </li>
               </ul>
               </td></tr>
              </table>
           </article>
	   </section>
	    
	</div>		
</body>
</html>
