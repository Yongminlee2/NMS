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
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/observatory/history" />
	
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
		.ui-datepicker-calendar tr{
			height: 26px;
		}
		tr{
			height:44px;
		}
	</style>
	<script>
		$(document).ready(function(){
			var first_day_of_year;
			var q_date = new Date();
			first_day_of_year = q_date.getFullYear();
			fnSetDatePickerAndToDate($("input[name='startDate']"), -365);
			fnSetDatePickerAndToDate($("input[name='endDate']"), 0);
			
		});
		
		function fnDetailStationHistoryInfo(staNo,type){
// 			alert(staNo);
			var sendType = "";
			if(type=="관측소"){
				sendType="sta";
			}else if (type=="센서"){
				sendType="sen";
			}else{
				sendType="rec";
			}
			var url = "${pageContext.request.contextPath}//system/observatory/history/popup";
			fnOpenPop(url,1100,700,"sh_no="+staNo+"&type="+sendType);
		}
		function fnGoStationPage(){
			location.replace("${pageContext.request.contextPath}//system/observatory/list");  
		}
		
		
		
	</script>
</head>
<body>
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">관측소관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템관리</li>
	       <li class="addNow">이력정보</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->
	       <form id="searchForm" name="searchForm" action="${pageName }" method="post">
	        <input type="hidden" name="page" value="${pagingInfo.currentPage }">
	       <article class="selectbox_long">
	           <ul>
	             <li>구분
	               <select name= "select" onchange="fnGoStationPage()">
						   <option value ="" selected>이력 정보</option>
						   <option>관측소 정보</option >
					</select>
	             </li>
	             <li>등록일
					 <input id="" name="startDate" value="">
	             </li>
	             <li><input id="" name="endDate" value=""></li>
	             <li class="btt_filecomplt"><a href="javascript:searchForm.submit();">자료확인</a></li>
	           </ul>
	       </article>
	       </form>
	       <!--표-->
	       <article class="s_table2">
             <p class="f20">검색자료 <span class="fOrange">총 ${pagingInfo.totalCnt } 건</span></p>
<%--              <p class="f14"> <span onclick="fnDetailStationHistoryInfo('new')"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_add.png"/>" alt="추가"></a></span></p> --%>
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
	                   <th>구분</th>
	                   <th>관측소 구분</th>
	                   <th>관측소 명</th>
	                   <th>관측소 코드명</th>
	                   <th>점검내용</th>
	                   <th>작성자</th>
	                   <th>작성일</th>
	                 </tr>
	               </thead>
	               <tbody>
	               <c:if test="${totalCnt < 1 }">
	               		<tr>
	               			<td colspan="8">검색된 자료가 없습니다.</td>
	               		</tr>
	               </c:if>
					<c:forEach items="${stationHistoryList}" var="st" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr onclick="fnDetailStationHistoryInfo('${st.sh_no}','${st.obs_desc}')" class="bg_gray2">
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr onclick="fnDetailStationHistoryInfo('${st.sh_no}','${st.obs_desc}')">
						</c:if>
							<td>${st.sh_no }</td>
							<td>${st.obs_desc }</td>
							<td>${st.obs_kind }</td>
							<td>${st.obs_name.replace('원자력발전소','') }</td>
							<td>${st.obs_id }</td>
							<td>${st.sta_tmp2 }</td>
							<td>${st.user_id }</td>
							<td>${st.regdate.replace('.0','') }</td>
						</tr>
					</c:forEach>
	               </tbody>
	             </table>
             </div>
			<tag:paging url="${pageName }" firstPage="${pagingInfo.firstPage }" endPage="${pagingInfo.endPage }" lastPage="${pagingInfo.totalLastPage }" curPage="${pagingInfo.currentPage }" totalCnt="${totalCnt }"/>
          </article>
	    </section>
	    
	</div>
</body>
</html>
