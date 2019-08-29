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
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	
	<script src="<c:url value="/js/css/modernizr.js"/>"></script>
	<script src="<c:url value="/js/css/common.js"/>"></script>
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/report/list" />
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}//system/report" />
	
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
		.ui-datepicker-calendar tr{
			height: 26px;
		}
		tr{
			height:44px;
		}
		.modal{
			z-index:999;
			position:absolute;
			border:1px solid;
			width:500px;
			height:400px;
			top:25%;
			left:37%; 
			border-radius:12px; 
			background-color: white;
			display:none;
		}
		.modal-head{
		    background-color: #d8e8f5;
		    border-top-left-radius: 12px;
		    border-top-right-radius: 12px;
		    padding: 9px;
		    height: 18px;
		    text-align: center;
		    font-size: 16px;
		    font-weight: bold;
		}
		.modal-background{
			position: absolute;
			top:0px;height:200%;
			left:0px;width:200%;
			background-color: black;
			z-index:998;
			display: none;
			opacity:0.4;
		}		
		.background{
			display:none;
			width:100%;
			height:100%;
			position: absolute;
		    background-color: black;
		    left: 0;
		    top: 0;
		    opacity: 0.4;
		    z-index: 999;
		}
	</style>
	<script>
		$(document).ready(function(){
			$("input[name='startDate']").val('${pagingInfo.stDate }');
// 			$("input[name='endDate']").val('${pagingInfo.enDate }');
// 			fnSetDatePickerAndToDate($("input[name='startDate']"), -1);
			fnSetDatePickerAndToDate($("input[name='endDate']"), 0);
		});
		
		function fnDetailPopup(no,type){
			var url = "";
			var width = 1100;
			var height = 900;
// 			alert(staNo);
			if(type=="RPT_02"){
				url = "${pageContext.request.contextPath}//system/report/popupMgmt";
				height = 690;
			}else if(type=="RPT_03"){
				url = "${pageContext.request.contextPath}//system/report/popupInit";
				width = 1600;
				height = 800;
			}else if(type=="RPT_04"){
				url = "${pageContext.request.contextPath}//system/report/popupMtn";
				width = 1115;
				height = 860;
			}
			
			fnOpenPop(url,width,height,"l_no="+no);
		}
		
		function fnShowModal(){
			
			$("#report-modal").show();
			$("#modal-background").show();
		}
		function fnModalClose(){
			$("#modal-background").hide();
			$("#report-modal").hide();
		}
		function fnInsertReport(){
			var sendData = $("select[name='sta_no']").val()+"&"+$("select[name='l_type']").val();
			var type = $("select[name='l_type']").val();
// 			alert(type);
			/*
				return 값으로 입력된 idx값을 받아오도록 한다.
				그 값을 리턴
			*/
			$.ajax({
		          url: "${pageName2}/insertReport.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: sendData,
		          success : function(data){
		          	if(data.resultDesc == "success"){
		          		alert("완료되었습니다.");
		          		window.location.reload(true);
//						fnModalClose();
//						fnDetailPopup(data.data,type);
						
		          	}else{
		          		alert("작업이 실패하였습니다.");
		          	}
		          } 
	    	});
			
			
			
		}
		
		function fnTest(a,b){
// 			alert(a+"/"+b);
			
		}
		
		function fnSendReport(l_no,type){
			event.stopPropagation();
// 			alert(type);
// 			fnOpenPop("a",500,500,"l_no="+no);
// 			fnOpenPopForReport("a",500,500,"l_no="+no);
			//RPT타입에 따라 데이터를 받아온 뒤 각 타입에 맞는 데이터를 보내어 가공, 전송.
			//보고서는 최초 작성시 저장 기능만 제공
			//이후에 오픈시는 열람만 가능.
			$.ajax({
		          url: "${pageName2}/getReportData.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: l_no+"&"+type,
		          success : function(data){
		          	if(data.resultDesc == "success"){
		          		console.log(data);
		          		alert("전송이 완료되었습니다.");
		          		location.href = location.href;
		          	}else{
		          		alert("작업이 실패하였습니다.");
		          	}
		          } 
	    	});
		}
		function createSendInitData(obj){
			var initData = "";
			
			return initData;
		}
		function createSendMgmtData(obj){
			var mgmtData = "";
			
			return mgmtData;
		}
		function createSendMtnData(obj){
			var mtnData = "";
			
			return mtnData;
		}		
	</script>
</head>
<body>
<!-- 	<button>추가</button> -->
<!-- 	<div class="page-pallet-baseinfo-list"> -->
<%-- 		<c:forEach items="${stationList}" var="st"> --%>
<%-- 			<div onclick="fnDetailStationInfo('${st.sta_no}')">${st.obs_id }${st.obs_name }</div> --%>
<%-- 		</c:forEach> --%>
<!-- 	</div> -->
<div class="background"></div>
	<input name="popupSaveFlag" type="hidden">
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">보고서 관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템관리</li>
	       <li class="addNow">보고서 관리</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->
	       <form id="searchForm" name="searchForm" action="${pageName }" method="post">
	        <input type="hidden" name="page" value="${pagingInfo.currentPage }">
	       <article class="selectbox_long">
	           <ul>
	             <li>점검일자
					 <input id="" name="startDate" value="">
	             </li>
	             <li><input id="" name="endDate" value=""></li>
	             <li class="btt_filecomplt"><a href="javascript:searchForm.submit();">자료확인</a></li>
<!-- 	             <li class="btt_filecomplt"><a href="">신규</a></li> -->
	           </ul>
	       </article>
	       </form>
	       <!--표-->
	       <article class="s_table2">
             <p class="f20">검색자료 <span class="fOrange">총 ${pagingInfo.totalCnt }건</span></p>
             <p class="f14"> <span onclick="fnShowModal()"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_add.png"/>" alt="점검"></a></span></p>
             <div style="min-height:535px;">
	             <table>
	               <caption>관측소 목록</caption>
	               <colgroup>
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:10%" />
	                           <col style="width:8%" />
	                           <col style="width:12%" />
	                           <col style="width:12%" />
	                           <col style="width:10%" />
	                           <col style="width:10%" />
	                           <col style="width:10%" />
	               </colgroup>
	               <thead>
	                 <tr>
	                   <th>번호</th>
	                   <th>점검일자</th>
	                   <th>관측소구분</th>
	                   <th>보고서구분</th>
	                   <th>관측소명</th>
	                   <th>전송 내역</th>
	                   <th>결과 내역</th>
	                   <th>전송</th>
	                   <th>열람</th>
	                 </tr>
	               </thead>
	               <tbody>
	               <c:if test="${totalCnt < 1 }">
	               		<tr>
	               			<td colspan="7">검색된 자료가 없습니다.</td>
	               		</tr>
	               </c:if>
					<c:forEach items="${reportList}" var="rp" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr class="bg_gray2">
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr>
						</c:if>
							<td>${rp.l_idx }</td>
							<td>${rp.l_date }</td>
							<td>${rp.obs_kind }</td>
							<td>${rp.l_type_desc }</td>
							<td>${rp.obs_name.replace('원자력발전소','') }</td>
							<td>${rp.l_send }</td>
							<td>${rp.l_status }</td>
							<td onclick="fnSendReport('${rp.l_no}','${rp.l_type}')">
								<c:if test="${rp.ls eq 5 }">
									[ 전  송 ]
								</c:if>
								<c:if test="${rp.ls ne 5 }">
									[ 재 전 송 ]
								</c:if>
							</td>
							<td onclick="fnDetailPopup('${rp.l_no}','${rp.l_type}')">[ 보 기 ]</td>
						</tr>
					</c:forEach>
	               </tbody>
	             </table>
             </div>
			<tag:paging url="${pageName }" firstPage="${pagingInfo.firstPage }" endPage="${pagingInfo.endPage }" lastPage="${pagingInfo.totalLastPage }" curPage="${pagingInfo.currentPage }" totalCnt="${totalCnt }"/>
          </article>
	    </section>
	    
	</div>
	
	<div id="report-modal" class="modal" style="" >
<!-- 	<div class="modal" style="position:absolute; border:1px solid;width:500px;height:600px;top:17%;left:36%; border-radius:12px; background-color: white;" > -->
		<div class="modal-head">보고서 생성</div>
		<div class="modal-body">
			<form id="memberForm">
				<article class="pop_table">
					<table>
						<tbody>	
							<tr>
								<th>관측소</th>
								<td>
									<select name="sta_no">
										<c:forEach items="${codeMap.stationInfo }" var="cm">
												<option value="${cm.sta_no }">${cm.obs_name }</option>
										</c:forEach>
									</select>
								</td>
							</tr>	
							<tr>
								<th>보고서 타입</th>
								<td>
									<select name="l_type">
										<option value="RPT_02">관리대장</option>
										<option value="RPT_03">초기점검</option>
										<option value="RPT_04">정기점검</option>
									</select>
								</td>
							</tr>																																										
						</tbody>
					</table>
					<br><br>
					<table>
		                <colgroup>
                            <col style="width:15%" />
                            <col style="width:58%" />
                            <col style="width:27%" />
		                </colgroup>					
		                <tbody>
		                	<tr style="text-align: center;">
		                    	<th>구분</th>
		                    	<th>내용</th>
		                    	<th>주기</th>
		                	</tr>
		                	<tr>
		                		<td style="font-size:10px;">관리 대장</td>
		                		<td style="font-size:10px;">관측소 및 지진계측기 정보가 담긴 관리 대장 보고서를 작성</td>
		                		<td style="font-size:10px;">지진계측기 설치 시</td>
		                	</tr>
		                	<tr>
		                		<td style="font-size:10px;">초기 점검</td>
		                		<td style="font-size:10px;">관측소 및 지진계측기가 초기 설치 시 해당 정보가 담긴 초기점검 보고서를 작성</td>
		                		<td style="font-size:10px;">지진계측기 설치 시</td>
		                	</tr>
		                	<tr>
		                		<td style="font-size:10px;">정기 점검</td>
		                		<td style="font-size:10px;">관측소 및 지진계측기 설치 후 정기적으로 점검한 정보가 담긴 정기점검보고서를 작성</td>
		                		<td style="font-size:10px;">정기 점검 후 <br>(6개월 마다)</td>
		                	</tr>	                		                	
		                </tbody>
					</table>
				</article>
			</form>
		</div>
		<div class="modal-footer">
			<article class="pop_table">
				<a href="#"><img src="<c:url value="/img/btt_add.png"/>" onclick="fnInsertReport()"></a>
				<a href="#"><img style="width:109px;"src="<c:url value="/img/btt_note_cancle.png"/>" onclick="fnModalClose()"></a>
			</article>
		</div>
	</div>	
<div id="modal-background" class="modal-background"></div>	
</body>
</html>
