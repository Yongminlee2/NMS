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
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/user/list" />
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}//system/access" />
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
		tr{
			height:38px;
		}
	</style>
	<script>
		$(document).ready(function(){
			$("input[type='checkbox']").each(function(i,v){
				if($(this).attr("val")=="Y"){
					$(this).attr("checked",true);
				}
			});
		});
		
		function fnModyAccessInfo(){
			var sendData = "[";
			$("#accessInfoTable tr").each(function(i,v){
				if($(this).attr("mody")=="mody"){
					sendData += "{\"maincategory\":\"a\",\"subcategory\":\""+$(this).children("td[name='subcategory']").html()+"\",";
					$(this).children("td[type='chk']").each(function(i,v){
						var obj  = $(this).children("input[type='checkbox']");
						sendData += "\""+obj.attr("name")+"\":\""+obj.attr("val")+"\",";
					});
					sendData = sendData.substring(0,sendData.length-1);
					sendData += "},";
				}
			});
			sendData = sendData.substring(0,sendData.length-1);
			sendData += "]";
			console.log(sendData);
			if(sendData=="]"){
				alert("수정된 사항이 없습니다.");
				return false;
			}
			 $.ajax({
		          url: "${pageName2}/modyAccess.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: sendData,
		          success : function(data){
		          	if(data.resultDesc == "success"){
		          		alert("수정되었습니다.");
		          		window.location.reload(true);
		          	}else{
		          		alert("작업이 실패하였습니다.");
		          	}
		          } 
       		});
			
		}
		function fnChangeValue(obj){
			$(obj).parent().parent().attr("mody","mody");
			if($(obj).attr("val")=="Y"){
				$(obj).attr("val","N");
			}else{
				$(obj).attr("val","Y");
			}
		}
	</script>
</head>
<body>
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">접속권한 관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템관리</li>
	       <li class="addNow">접속권한 관리</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->

	       <!--표-->
	       <article class="s_table2">
             <p class="f14"> <span onclick="fnModyAccessInfo()"><a href="#" ><img style="width:98px;" src="<c:url value="/img/btt_note_save.png"/>" alt="저장"></a></span></p>
             <div style="min-height:535px;">
	            	             <table>
	               <caption>관측소 목록</caption>
	               <colgroup>
	                           <col style="width:15%" />
	                           <col style="width:15%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	                           <col style="width:8%" />
	               </colgroup>
	               <thead>
	                 <tr style="">
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" colspan="2">구분</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" colspan="2">관리자</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" colspan="2">사용자</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" colspan="2">뷰어</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" colspan="2">외부인</th>
	                 </tr>	               
	                 <tr>
	                   <th style="background:none;background-color:#d8e8f5;">메뉴</th>
	                   <th style="background:none;background-color:#d8e8f5;">서브메뉴</th>
	                   <th style="background:none;background-color:#d8e8f5;">접속</th>
	                   <th style="background:none;background-color:#d8e8f5;">입력/수정</th>
	                   <th style="background:none;background-color:#d8e8f5;">접속</th>
	                   <th style="background:none;background-color:#d8e8f5;">입력/수정</th>
	                   <th style="background:none;background-color:#d8e8f5;">접속</th>
	                   <th style="background:none;background-color:#d8e8f5;">입력/수정</th>
	                   <th style="background:none;background-color:#d8e8f5;">접속</th>
	                   <th style="background:none;background-color:#d8e8f5;">입력/수정</th>
	                 </tr>
	               </thead>
	               <tbody id="accessInfoTable">
					<c:forEach items="${accessInfo}" var="ac" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr class="bg_gray2">
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr>
						</c:if>
							<td>${ac.maincategory }</td>
							<td name="subcategory">${ac.subcategory }</td>
							<td type="chk"><input name="s1" val="${ac.s1}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="m1" val="${ac.m1}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="s2" val="${ac.s2}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="m2" val="${ac.m2}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="s3" val="${ac.s3}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="m3" val="${ac.m3}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="s4" val="${ac.s4}" onclick="fnChangeValue(this)" type="checkbox"></td>
							<td type="chk"><input name="m4" val="${ac.m4}" onclick="fnChangeValue(this)" type="checkbox"></td>
						</tr>
					</c:forEach>
	               </tbody>
	             </table>
             </div>
          </article>
	    </section>
	    
	</div>
</body>
</html>
