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
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/log/list" />
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}//system/log" />
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
		.ui-datepicker-calendar tr{
			height: 26px;
		}
		tr{
			height:38px;
		}
		input{
			width:190px;
		}
	</style>
	<script>
		$(document).ready(function(){
			$("input[type='checkbox']").each(function(i,v){
				if($(this).attr("val")=="Y"){
					$(this).attr("checked",true);
				}
			});
// 			$("input[name='startDate']").val('${pagingInfo.stDate }');
// 			$("input[name='endDate']").val('${pagingInfo.enDate }');
			
			fnSetDatePickerAndToDate($("input[name='startDate']"), -1);
			fnSetDatePickerAndToDate($("input[name='endDate']"), 0);
			
			$("select[name='searchKeyword']").val('${searchKeyword}').prop("selected",true);
			$("select[name='searchKeyword2']").val('${searchKeyword2}').prop("selected",true);
		});
		
		function fnTest(){
			alert(accessAuth);
		}
		function fnOpenPopup(page)
		{
			var url = "${pageContext.request.contextPath}//system/log/popup/"+page;
			fnOpenPop(url,450,530,"");
		}
	</script>
</head>
<body>
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">로그 관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템 관리</li>
	       <li class="addNow">로그 관리</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->
	       <form id="searchForm" name="searchForm" action="${pageName }" method="post">
	       <input type="hidden" name="page" value="${pagingInfo.currentPage }">
	       <article class="selectbox_long">
	           <ul  style="width:1430px;">
	             <li>로그유형
	               <select name= "searchKeyword" style="width:190px;">
						<option value ="" selected>===전체===</option>
						<c:forEach items="${typeList}" var="tl" varStatus="idx">
							<option value="${tl.l_type }">${tl.l_name }</option>
						</c:forEach>
					</select>
	             </li>
	             <li>프로세스ID
	               <select name= "searchKeyword2"style="width:190px;">
						<option value ="" selected>===전체===</option>
						<c:forEach items="${idList}" var="il" varStatus="idx">
							<option value="${il.l_type }">${il.l_name }</option>
						</c:forEach>
					</select>
	             </li>
	             <li><input id="stDate" name="startDate" value="" style="width:190px;"></li>
	             <li><input id="enDate" name="endDate" value="" style="width:190px;"></li>
	             <li class="btt_filecomplt"><a href="javascript:searchForm.submit();">자료확인</a></li>
	           </ul>
	       </article>
	       </form>
	       <!--표-->
	       <article class="s_table2">
	         <p class="f20">검색자료 <span class="fOrange">총 ${pagingInfo.totalCnt }건</span></p>
             <p class="f14">
             	<span onclick="fnOpenPopup('id')"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_logtype.png"/>" alt=""></a></span>
             	<span onclick="fnOpenPopup('type')"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_idcontrol.png"/>" alt=""></a></span> 
             </p>
             <div style="min-height:535px;">
	            	             <table>
	               <caption>관측소 목록</caption>
	               <colgroup>
	                           <col style="width:5%" />
	                           <col style="width:25%" />
	                           <col style="width:10%" />
	                           <col style="width:10%" />
	                           <col style="width:50%" />
	               </colgroup>
	               <thead>
	                 <tr>
	                   <th>순번</th>
	                   <th>로그유형</th>
	                   <th>발행시각</th>
	                   <th>사용자 및 시스템 ID</th>
	                   <th>내용</th>
	                 </tr>
	               </thead>
	               <tbody id="accessInfoTable">
	               <c:if test="${totalCnt < 1 }">
	               		<tr>
	               			<td colspan="5">검색된 자료가 없습니다.</td>
	               		</tr>
	               </c:if>	
					<c:forEach items="${logList}" var="ll" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr class="bg_gray2">
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr>
						</c:if>
							<td>${ll.l_no }</td>
							<td>${ll.l_type }</td>
							<td>${ll.l_date }</td>
							<td>${ll.l_log_id }</td>
							<td>${ll.l_text }</td>
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
