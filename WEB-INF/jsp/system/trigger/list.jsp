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
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/trigger/list" />
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}//system/trigger" />
	
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
		tr{
			height:44px;
		}
		#trgBody input{
			width:70%;
			text-align:center;
 			border:none;
		}
		.bg_gray2 input{
			background-color:#e1e1e1;
		}
	</style>
	<script>
		$(document).ready(function(){
			$("select[name='searchKeyword']").val('${searchKeyword}').prop("selected",true);
		});
		
		function fnModyTriggerInfo(){
			var sendData = "[";
			$("#trgBody tr").each(function(i,v){
				if($(this).attr("mody")=="mody"){
					sendData += "{";
					$(this).children("td[chk='true']").each(function(i,v){
						var obj  = "";
						if($(this).attr("type")=="input"){
							obj  = $(this).children("input");
// 							alert(obj.val());
							sendData += "\""+obj.attr("name")+"\":\""+obj.val()+"\",";
						}else{
							obj = $(this);
							sendData += "\""+obj.attr("name")+"\":\""+obj.html()+"\",";
						}
					});
					sendData = sendData.substring(0,sendData.length-1);
					sendData += "},";
				}
			});
			sendData = sendData.substring(0,sendData.length-1);
			sendData += "]";
			
			console.log(sendData);
			//저장시 변경된 데이터가 없는경우 sendData = ]
			if(sendData=="]"){
				alert("변경된 데이터가 존재하지 않습니다.");
				return false;
			}
// 			console.log(sendData);
// 			return false;
			$.ajax({
	          url: "${pageName2}/modyTrigger.ws",
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
		}
		function fnChangeDec(obj){
			$(".tr_detection").val($(obj).val());
			$("#trgBody").children("tr").eq(0).attr("mody","mody");
		}
	</script>
</head>
<body>
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">트리거 관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템관리</li>
	       <li class="addNow">트리거 관리</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->
	       <form id="searchForm" name="searchForm" action="${pageName }" method="post">
	        <input type="hidden" name="page" value="${pagingInfo.currentPage }">
	       <article class="selectbox_long">
	           <ul>
	             <li>관측소 구분
	               <select name= "searchKeyword">
						   <option value ="">===전체===</option>
						   <option value="NF">원전부지</option >
						   <option value="WP">수력발전</option >
						   <option value="PP">양수발전</option >
					</select>
	             </li>
	             <li class="btt_filecomplt"><a href="javascript:searchForm.submit();">자료확인</a></li>
	           </ul>
	       </article>
	       </form>
	       <!--표-->
	       <article class="s_table2">
	         <p class="f20">검색자료 <span class="fOrange">총 ${totalCnt } 건</span></p>
             <p class="f14"> <span onclick="fnModyTriggerInfo()"><a href="#" ><img style="width:98px;" src="<c:url value="/img/btt_note_save.png"/>" alt="저장"></a></span></p>
             <div style="min-height:535px;">
             	 <table>
           	 		<colgroup>
	                    <col style="width:70%" />
	                    <col style="width:30%" />
                    </colgroup>
             	 	<tbody>
             	 		<tr>
             	 			<th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;">감지 관측소 수</th><td style="border-top: 2px solid #3DB7CC;"><input type="text" style="width: 100%;height:44px;border:none;text-align: center;" onchange="fnChangeDec(this)" value="${triggerData.tr_detection }"/></td>
             	 		</tr>
             	 	</tbody>
             	 </table>
	             <table>
	               <caption>관측소 목록</caption>
	               <colgroup>
	                           <col style="width:5%" />
	                           <col style="width:5%" />
	                           <col style="width:20%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	                           <col style="width:7%" />
	               </colgroup>	               
	               <thead>
	                 <tr style="">
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" rowspan="2">번호</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" rowspan="2">관측소코드</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" rowspan="2">관측소명</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" >1단계</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" >2단계</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" >3단계</th>
<!-- 	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" rowspan="2">성분값</th> -->
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;display:none;" rowspan="2">관측소 수</th>
	                   <th style="background:none;border-top: 2px solid #3DB7CC;background-color:#d8e8f5;" rowspan="2">모니터링 테이블</th>
	                 </tr>	               
	                 <tr>
	                   <th style="background:none;background-color:#d8e8f5;">PGA 임계값</th>
<!-- 	                   <th style="background:none;background-color:#d8e8f5;">CAV 임계값</th> -->
	                   <th style="background:none;background-color:#d8e8f5;">PGA 임계값</th>
<!-- 	                   <th style="background:none;background-color:#d8e8f5;">CAV 임계값</th> -->
	                   <th style="background:none;background-color:#d8e8f5;">PGA 임계값</th>
<!-- 	                   <th style="background:none;background-color:#d8e8f5;">CAV 임계값</th> -->
	                 </tr>
	               </thead>
	               <tbody id="trgBody">
	               <c:if test="${totalCnt < 1 }">
	               		<tr>
	               			<td colspan="12">검색된 자료가 없습니다.</td>
	               		</tr>
	               </c:if>	               
					<c:forEach items="${triggerList}" var="tr" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr class="bg_gray2">
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr>
						</c:if>
		                   <td type="td" chk="true" name="tr_no">${tr.tr_no }</td>
		                   <td type="" chk="false">${tr.tr_sta }</td>
		                   <td chk="false">${tr.obs_name.replace('원자력발전소','') }</td>
		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_pga_1" value="${tr.tr_pga_1 }"     /> </td>
<%-- 		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_cav_1" value="${tr.tr_cav_1 }"     /> </td> --%>
		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_pga_2" value="${tr.tr_pga_2 }"     /> </td>
<%-- 		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_cav_2" value="${tr.tr_cav_2 }"     /> </td> --%>
		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_pga_3" value="${tr.tr_pga_3 }"     /> </td>
<%-- 		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_cav_3" value="${tr.tr_cav_3 }"     /> </td> --%>
<%-- 		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_chan" value="${tr.tr_chan }"      /></td> --%>
		                   <td type="input" chk="true" style="display: none;"><input onKeyup="fnChangeValue(this)" class="tr_detection" name="tr_detection" value="${tr.tr_detection }" /></td>
		                   <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" name="tr_sta_table" value="${tr.tr_sta_table }" /></td>
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
