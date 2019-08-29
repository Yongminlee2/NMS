<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/log/popup/id" />
	<title>한국수력원자력::모니터링 소프트웨어</title>
	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
/* 		td{ */
/* 			width: 100px; */
/* 		} */
		.popup-info-container div{
			display:none;
		}
		form input,select{
			border: 0px;
			height:100%;
			width:100%;
			text-align: center;
			color:#72716f;
			font-family: Calibri, sans-serif;
		}
		form .shot-select{
			width:20%;
		}
		
		ul.tabs {
		    margin: 0;
		    padding: 0;
		    float: left;
		    list-style: none;
		    height: 32px;
		    border-bottom: 1px solid #eee;
		    border-left: 1px solid #eee;
		    width: 100%;
		    font-family:"dotum";
		    font-size:12px;
		}
		ul.tabs li {
		    float: left;
		    text-align:center;
		    cursor: pointer;
		    width:82px;
		    height: 31px;
		    line-height: 31px;
		    border: 1px solid #eee;
		    border-left: none;
		    font-weight: bold;
		    background: #ffffff;
		    overflow: hidden;
		    position: relative;
		    color:black;
		}
		ul.tabs li.active {
		    background: #ff9b6f;
		    border-bottom: 1px solid #FFFFFF;
/* 		    color:darkred; */
		}
	 	.modal_img{
	 		width: 150px;
	 		height: 150px;
/* 	 		position: absolute; */
	/*  		border: 1px solid; */
	/*  		border-color: rgb(212,212,212); */
	 		left:50%;
/* 	 		margin-top : 20px; */
	 		margin-left:-75px;
	 		background: url('/NMS/img/dodo1.png') no-repeat;
	 		border-radius : 15px;
	 		display: block;
	 	}		

	</style>
	<script>
		var observatoryImgObj = new Image();
		var fileObj = "";
		$(document).ready(function(){
			$(".popup-info-container div:first").show();
			$("body").css("overflow","hidden");
// 			modyFormdata()
		});
		/*
			table : 데이터 추가되는 테이블의 tbody
		*/
		function fnAddDataRow(table)
		{
			
			var tr = $("#"+table).children("tr").eq(1);
			var tdCnt = tr.children("td").length;
			var append = "<tr mody='new'>";
			append += "<td type='input' chk='true'><input type='hidden' name='l_no' value='0'></td>";
			append += "<td type='input' chk='true'><input type='text' name='l_type'></td>";
			append += "<td type='input' chk='true'><input type='text' name='l_name'></td>";
			append += "<td style='width:40px;'><a href='#'><img src=\"<c:url value='/img/btt_dele.png'/>\" onclick=\"fnDeleteSubList('0',this)\"></a></td>";
			
			append += "</tr>";
			$("#"+table).append(append);
		}

		/*
			form : 데이터 추가를 하려는 form의 ID
			recorder, sensor의 
		*/
		
		function fnSaveSubAttribute(form)
		{
			if(!validationCheck(form)){
				return false;
			}
			var jsonStr = formSerializeToJsonStr("log-id-table","table");
			url = "${pageContext.request.contextPath}/system/log/insertLogId.ws";
			
		    $.ajax({
		          url: url,
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jsonStr,
		          success : function(data){
		        	console.log(data.resultDesc);
			      	console.log("doit"+data);
			      	if(data.resultDesc=="success")
			      	{
			      		alert("완료되었습니다.");
			      		window.opener.document.location.reload();
			      		window.location.reload(true);
		          	}
		          }
		           
        	});
		}
		
		function fnDeleteSubList(idx,obj)
		{
			url = "${pageContext.request.contextPath}/system/log/deleteLogId.ws";
			if(confirm("삭제하시겠습니까?")){
				if($(obj).parent().parent().attr("mody")!="new" && idx != "0")
				{
				    $.ajax({
				          url: url,
				          type: "POST",
				          dataType: 'json',
				          contentType: "application/json; charset=utf-8",
				          data: idx,
				          success : function(data){
				        	  	console.log(data);
				        	  	console.log(data.resultDesc);
						      	if(data.resultDesc=="success")
						      	{
						      		alert("삭제완료되었습니다.");
						      		window.opener.document.location.reload();
						      		window.location.reload(true);
					          	}
				          } 
		        	});
					
				}
				$(obj).parent().parent().parent().remove();
			}
		}
		function fnChangeValue(obj){
			$(obj).parent().parent().attr("mody","mody");
		}
	</script>
</head>
<body style="overflow:hidden;">
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="popup-tap-wrap">
		<div class="popup-info-container">
			  <section class="pop_body">
<%-- 			     <h2>${stationInfo.obs_name } 관측소</h2> --%>
	<!-- 				            표2 -->
			 <span style="float:right;margin-right:26px;"><a href="#"><img src="<c:url value="/img/btt_hadd.png"/>" onclick="fnAddDataRow('log-id-table')" alt="목록"></a> <a href="#"  onclick="fnSaveSubAttribute('log-id-table')"><img src="<c:url value="/img/btt_save.png"/>" alt="목록"></a></span>
             <article class="pop_table" style="overflow:auto;max-height:511px;min-height:411px;">
				<form id="log-id-form">
	             
	              <table>
	                <thead>
	                  <tr>
	                    <th colspan="4">LOG ID 목록</th>
	                  </tr>
	                </thead>
	                <tbody id="log-id-table">
	                   <tr chk="no">
	                   	<th></th>
	                    <th>Log ID Code</th>
	                    <th>Log ID Name</th>
	                    <th></th>
	                  </tr>
	                  <c:forEach items="${idList }" var="il">
		              	<tr>
		              		<td type="input" chk="true"><input type="hidden" name="l_no" value="${il.l_no }"></td>
		                    <td type="input" chk="true"><input onKeyup="fnChangeValue(this)" type="text" name="l_type" value="${il.l_type }"></td>
							<td type="input" chk="true"><input onKeyup="fnChangeValue(this)" type="text" name="l_name" value="${il.l_name }"></td>
							<td child="delete" style="width:40px;"><a href="#"><img src="<c:url value="/img/btt_dele.png"/>" onclick="fnDeleteSubList('${il.l_no}',this)" alt="목록"></a></td>
	                	</tr>
	                  </c:forEach>
	                </tbody>
	              </table>
			   </form>
	            </article>
<%-- 	            <tag:paging url="${pageName }" firstPage="${pagingInfo.firstPage }" endPage="${pagingInfo.endPage }" lastPage="${pagingInfo.totalLastPage }" curPage="${pagingInfo.currentPage }" totalCnt="${pagingInfo.totalCnt }"/> --%>
			    </section>
		</div>		
	</div>
</body>
</html>
