<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
    
    <link href="<c:url value="/css/base.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/common.css"/>" rel="stylesheet" type="text/css" />
	<!-- 1. 기타로 조회시 생각 -->
	<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	
	<script src="<c:url value="/js/css/common.js"/>"></script>
	<title>한국수력원자력::모니터링 소프트웨어</title>
	<style>
		.page2{
			display: none;
		}
	</style>
	<script>
		var senCnt='${sen_cnt}';
		var recCnt='${rec_cnt}';
		$(document).ready(function(){
			var date = '${reportMain.rpt_date}';
			
			if(date!=""){
				$("#yyyy").val(date.substring(0,4));
				$("#mm").val(date.substring(5,7));
				$("#dd").val(date.substring(8,10));
			}
			$("input[name='sen'][value='${sen_cnt}']").attr("checked",true);
			$("input[name='rec'][value='${rec_cnt}']").attr("checked",true);
			
			fnSettingRadioButton();
			
			$("input[name='sen'],input[name='rec']").on('change',function(){
				var idx = $(this).val();
				var sch = 0;
				if($(this).attr("name")=="sen"){
					sch = 5;
					senCnt = idx;
				}else{
					sch = 3;
					recCnt = idx;
				}
				for(var i = sch ; i > idx ; i--){
// 					alert($(this).attr("name")+i);
					$("."+$(this).attr("name")+i).attr("use","nok");
					$("."+$(this).attr("name")+i).parent().addClass("bgray");
					$("."+$(this).attr("name")+i).attr("disabled","disabled");
				}
				for(var j = 1 ; j <= idx ; j++){
					
					$("."+$(this).attr("name")+j).attr("use","ok");
					$("."+$(this).attr("name")+j).parent().removeClass("bgray");
					$("."+$(this).attr("name")+j).removeAttr("disabled");
				}
			});
			
			$("input[type='radio']").each(function(i,v){
				if($(this).attr("multi")=="true" && $(this).attr("val")!=""){
					var name = this.name;
					var value = $(this).attr("val");
					$("input[name='"+name+"'][value='"+value+"']").attr("checked",true);
				}
			});
		});
		function fnSettingRadioButton(){
			var idx = "${sen_cnt}";
			for(var i = 5 ; i > idx ; i--){
//					alert($(this).attr("name")+i);
				$(".sen"+i).attr("use","nok");
				$(".sen"+i).parent().addClass("bgray");
				$(".sen"+i).attr("disabled","disabled");
				$(".sen"+i).attr("checked",false);
			}
			var idx2 = "${rec_cnt}";
			for(var i = 3 ; i > idx2 ; i--){
//					alert($(this).attr("name")+i);
				$(".rec"+i).attr("use","nok");
				$(".rec"+i).parent().addClass("bgray");
				$(".rec"+i).attr("disabled","disabled");
				$(".rec"+i).attr("checked",false);
			}

		}
		function fnAllSensorDisable(){
			var idx = 0;
			$("input[name='sen']").attr("checked",false);
			for(var i = 5 ; i > idx ; i--){
//				alert($(this).attr("name")+i);
			$(".sen"+i).attr("use","nok");
			$(".sen"+i).attr("checked",false);
			$(".sen"+i).parent().addClass("bgray");
			$(".sen"+i).attr("disabled","disabled");
			}
		}
		function getToday(){
			var d = new Date();
			var tday = d.getFullYear()+"-"+getFormattedPartTime(d.getMonth()+1)+"-"+getFormattedPartTime(d.getDate());
			return tday;
		}
		
		function fnSendData(flag){
			
			var txt = "rpt_data : "+$("#yyyy").val()+"-"+$("#mm").val()+"-"+$("#dd").val()+"\n";
			var jsonStr = "{\"rpt_no\":\""+$("#rpt_no").val()+"\",";
			var sen="s(0)";
			var rec="r(0)";
			txt +="net : "+$("#net-ipt").val()+"\n";
			txt +="obs_id : "+$("#obs-ipt").val()+"\n";
			
			jsonStr += "\"obs_id\":\""+$("#obs-ipt").val()+"\",";
			jsonStr += "\"net\":\""+$("#net-ipt").val()+"\",";
			var arr = [];
			var arr2 = [];
			var arr3 = [];
			var arr4 = [];
// 			alert(typeof a == $("input[name='q1_3']:checked").val());
			$("#1st input[type='radio']").each(function(i,v){
				  var myname= this.name;
				  if( $.inArray( myname, arr ) < 0 ){
				     arr.push(myname);
				  }
			});
			$("#2nd input[type='radio']").not("#2nd input[use='nok']").each(function(i,v){
				  var myname= this.name;
				  if( $.inArray( myname, arr2 ) < 0 ){
					  arr2.push(myname);
				  }
			});
			for(var i=1;i<6;i++){
				arr2.push("s("+i+")_sno");
			}
// 			console.log(arr2);	
			$("#3rd input[type='radio']").not("#3rd input[use='nok']").each(function(i,v){
				  var myname= this.name;
				  if( $.inArray( myname, arr3 ) < 0 ){
					  arr3.push(myname);
				  }
			});
			for(var i=1;i<4;i++){
				arr3.push("r("+i+")_rno");
			}
			$("#4th input[type='radio']").each(function(i,v){
				  var myname= this.name.replace("9","09");
				  if( $.inArray( myname, arr4 ) < 0 ){
					  arr4.push(myname);
				  }
			});			
			
			arr2.sort();arr3.sort();arr4.sort();
			/*
			console.log(arr); // 1,4 번 = report_a
			console.log(arr2); // report_b
			console.log(arr3); // report_c
			console.log(arr4); // 1,4 번 = report_a
			*/

			for(var i = 0 ; i < arr.length ; i++)
			{
				txt +=arr[i]+" : "+$("input[name='"+arr[i]+"']:checked").val()+"\n";	
				jsonStr += "\""+arr[i]+"\":\""+$("input[name='"+arr[i]+"']:checked").val()+"\",";

			}
			
			/*sensor*/
			txt += "s_sen_count : "+senCnt+"\n";
			jsonStr += "\"sensors\":[";
			for(var i = 0 ; i < arr2.length ; i++)
			{	
// 				if(i>0){
// 					jsonStr +=",";
// 				}
				if(sen != arr2[i].split("_")[0]){
					if(sen!="s(0)"){
						jsonStr=jsonStr.substring(0,jsonStr.lastIndexOf(","))+"},{";
					}else{
						jsonStr += "{";
					}
					sen = arr2[i].split("_")[0];
				}
				jsonStr += "\"s_cnt\":\""+senCnt+"\",";
				
				if(arr2[i].indexOf("sno")==-1){
					txt +=arr2[i]+" : "+$("input[name='"+arr2[i]+"']:checked").val()+"\n";
					jsonStr += "\""+"s_"+arr2[i].substring(5,arr2[i].length)+"\":\""+$("input[name='"+arr2[i]+"']:checked").val()+"\""; 
				}else{
// 					txt +=arr2[i]+" : "+$("input[name='"+arr2[i]+"']").val()+"\n";
					jsonStr += "\""+"rpt_"+arr2[i].substring(5,arr2[i].length)+"\":\""+$("input[name='"+arr2[i]+"']").val()+"\",";
					console.log($("input[name='"+arr2[i]+"']").attr("disabled"));
					
					var ipt = $("input[name='"+arr2[i]+"']").val();
					var dab = $("input[name='"+arr2[i]+"']").attr("disabled");
					
					if(ipt=="" && typeof dab == "undefined"){
						jsonStr +="\"type\":\"insert\"";
					}else if(ipt== "" && dab == "disabled"){
						jsonStr +="\"type\":\"none\"";
					}else if (ipt!= "" && typeof dab == "undefined"){
						jsonStr +="\"type\":\"update\"";
					}else if(ipt!="" && dab == "disabled"){
						jsonStr +="\"type\":\"delete\"";
					}
					
				}
				if((i+1) < arr2.length){
					jsonStr +=",";
				}
				
			}
			jsonStr +="}],";
			/*recorder*/
			
			txt += "r_rec_count : "+recCnt+"\n";
			jsonStr += "\"recorders\":[";
			for(var i = 0 ; i < arr3.length ; i++)
			{	
				if(rec != arr3[i].split("_")[0]){
					if(rec!="r(0)"){
						jsonStr=jsonStr.substring(0,jsonStr.lastIndexOf(","))+"},{";
					}else{
						jsonStr += "{";
					}
					rec = arr3[i].split("_")[0];
				}
				jsonStr += "\"r_cnt\":\""+recCnt+"\",";
				
				if(arr3[i].indexOf("rno")==-1){
					txt +=arr3[i]+" : "+$("input[name='"+arr3[i]+"']:checked").val()+"\n";
					jsonStr += "\""+"r_"+arr3[i].substring(5,arr3[i].length)+"\":\""+$("input[name='"+arr3[i]+"']:checked").val()+"\""; 
				}else{
// 					txt +=arr3[i]+" : "+$("input[name='"+arr3[i]+"']").val()+"\n";
					jsonStr += "\""+"rpt_"+arr3[i].substring(5,arr3[i].length)+"\":\""+$("input[name='"+arr3[i]+"']").val()+"\",";
					
					var ipt = $("input[name='"+arr3[i]+"']").val();
					var dab = $("input[name='"+arr3[i]+"']").attr("disabled");
					
					if(ipt=="" && typeof dab == "undefined"){
						jsonStr +="\"type\":\"insert\"";
					}else if(ipt== "" && dab == "disabled"){
						jsonStr +="\"type\":\"none\"";
					}else if (ipt!= "" && typeof dab == "undefined"){
						jsonStr +="\"type\":\"update\"";
					}else if(ipt!="" && dab == "disabled"){
						jsonStr +="\"type\":\"delete\"";
					}
				}
				
				if((i+1) < arr3.length){
					jsonStr +=",";
				}
			}
			jsonStr +="}],";
			for(var i = 0 ; i < arr4.length ; i++)
			{
				txt +=arr4[i].replace("09","9")+" : "+$("input[name='"+arr4[i].replace("09","9")+"']:checked").val()+"\n";
				jsonStr += "\""+arr4[i].replace("09","9")+"\":\""+$("input[name='"+arr4[i].replace("09","9")+"']:checked").val()+"\",";
			}
			
			console.log(txt);
			
			
			txt += "bigo : "+$("input[name='bigo']").val()+"\n";
			txt += "result : "+$("input[name='result']").val()+"\n";
			txt += "user_dept : "+$("input[name='user_dept']").val()+"\n";
			txt += "user_duty : "+$("input[name='user_duty']").val()+"\n";
			txt += "user_name : "+$("input[name='user_name']").val()+"\n";
			txt += "user_tel : "+$("input[name='user_tel']").val()+"\n";
			
			jsonStr+="\"bigo\":\""+$("input[name='bigo']").val()+"\",";
			jsonStr+="\"result\":\""+$("input[name='result']").val()+"\",";
			jsonStr+="\"user_dept\":\""+$("input[name='user_dept']").val()+"\",";
			jsonStr+="\"user_duty\":\""+$("input[name='user_duty']").val()+"\",";
			jsonStr+="\"user_name\":\""+$("input[name='user_name']").val()+"\",";
			jsonStr+="\"user_tel\":\""+$("input[name='user_tel']").val()+"\",";
			jsonStr += "\"rpt_date\":\""+$("#yyyy").val()+"-"+$("#mm").val()+"-"+$("#dd").val()+"\"}";
// 			alert(jsonStr);
			jsonStr = jsonStr.replace(/undefined/gi,"");
// 			alert(txt);
//			alert($("#obs-ipt").val());
			var txtName = "RPT03_"+$("#net-ipt").val()+"_"+$("#obs-ipt").val()+"_"+getToday().replace("-","").replace("-","");
// 			return false;
			if(flag=="t"){
				if(confirm("전송하시겠습니까?")){
					saveAndSnedReport(jsonStr,txtName,txt);
				}else{
					onlySaveReport(jsonStr);
				}
			}else{
				onlySaveReport(jsonStr);
// 				onlySendReport(txtName,txt);
			}

		}
		function onlySendReport(tName,text){
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/sendReport.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: "${l_no}&"+tName+"&"+text,
		          success : function(data){
		        	  if(data.resultDesc=="success")
				      	{
				      		alert("전송이 완료되었습니다.");
			          	}else{
			          		alert("전송에 실패하였습니다.");
			          	}
		          }
			});
		}
		function onlySaveReport(jStr){
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/updateInit.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jStr,
		          success : function(data){
		        	if(data.resultDesc=="success")
			      	{
			      		alert("저장이 완료되었습니다.");
		        		opener.parent.location.reload();
		        		window.close();
			      		
		          	}else{
		          		alert("저장에 실패하였습니다.");
		          	}
		          }
			});
		}
		function saveAndSnedReport(jStr,tName,text){
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/updateInit.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jStr,
		          success : function(data){
		        	if(data.resultDesc=="success")
			      	{
		        		alert("저장이 완료되었습니다.");
		        		opener.parent.location.reload();
		        		window.close();
		    			/*
		        		$.ajax({
		  		          url: "${pageContext.request.contextPath}/system/report/sendReport.ws",
		  		          type: "POST",
		  		          dataType: 'json',
		  		          contentType: "application/json; charset=utf-8",
		  		          data: "${l_no}&"+tName+"&"+text,
		  		          success : function(data){
		  		        	  if(data.resultDesc=="success")
		  				      	{
		  				      		alert("전송 및 저장이 완료되었습니다.");
		  			          	}else{
		  			          		alert("전송에 실패하였습니다.");
		  			          	}
		  		          }
		  				});
		    			*/
		          	}else{
		          		alert("전송에 실패하였습니다.");
		          	} 
		          }
			});
		}
		function fnNext(){
			$(".page1").hide();
			$(".page2").show();
		}
		function fnPrev(){
			$(".page2").hide();
			$(".page1").show();
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<input type="hidden" id="net-ipt" value="${reportMain.net }">
<input type="hidden" id="obs-ipt" value="${reportMain.obs_id }">
<input type="hidden" id="rpt_no" value="${reportMain.rpt_no }">
<div id="pop_wrap" style="width:100%;">
  <section class="pop_topTit2">
    <h1 style="width:86%;">${report.obs_name } 지진가속도계측기 초기점검 보고서</h1>
    <ul class="pop_top_btt">
    <c:if test="${reportMain.l_status eq '6' or reportMain.l_status eq '5'}">
      <li class="" onclick="fnSendData('f')"><a href="#" ><img src="<c:url value="/img/btt_save.png"/>" alt="전송" /></a></li>
<%--       <li class="" onclick="fnSendData('t')"><a href="#"><img src="<c:url value="/img/btt_save.png"/>" alt="전송"></a></li> --%>
    </c:if>  
      <li class="page1" onclick="fnNext()"><a href="#"><img src="<c:url value="/img/btt_pop_nxt.png"/>" alt="다음" /></a></li>    
      <li class="page2" onclick="fnPrev()"><a href="#"><img src="<c:url value="/img/btt_pop_prv.png"/>" alt="이전" /></a></li>
    </ul>
  </section>
	<form id="initForm">
  <section class="pop_body">
<!--표 1-->
      <article class="page1 pop_table_report">
       <table>
         <caption>관측소 기본 정보</caption>
         <colgroup>
                     <col style="width:7%" />
                     <col style="width:10%" />
                     <col style="width:30%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
         </colgroup>
         <thead>
         
           <tr>
             <th rowspan="2">구분</th>
             <th colspan="2">점검내용</th>
             <th rowspan="2">적합</th>
             <th rowspan="2">부적합</th>
           </tr>
            <tr>
             <th>항목</th>
             <th>상세내용</th>
           </tr>
         </thead>
         <tbody id="1st">
            <tr>
             <td rowspan="5">자유장 지진 가속도<input name="f_sen_id" type="hidden" value="${reportMain.f_sen_id }"></td>
             <td>가속도계 성분</td>
             <td class="tleft">연직 1성분, 수평 2성분</td>
             <td><input name="f_q1"  value="Y" type="radio" multi="true" val="${reportMain.f_q1}" checked="checked"></td>
             <td><input name="f_q1"  value="N" type="radio" multi="true" val="${reportMain.f_q1}"></td>
           </tr>
           <tr>
             <td rowspan="2">주파수 영역</td>
             <td class="tleft">최소 주파수 0.1Hz 이내 최대 주파수 50Hz 이상</td>
             <td><input name="f_q2_1" value="Y" type="radio" multi="true" val="${reportMain.f_q2_1}"checked="checked"></td>
             <td><input name="f_q2_1" value="N" type="radio" multi="true" val="${reportMain.f_q2_1}"></td>
           </tr>
           <tr>
             <td class="tleft">0.1Hz~50Hz까지 평활 주파수 대역 유지</td>
             <td><input name="f_q2_2"  value="Y" type="radio" multi="true" val="${reportMain.f_q2_2}"checked="checked"></td>
             <td><input name="f_q2_2"  value="N" type="radio" multi="true" val="${reportMain.f_q2_2}"></td>
           </tr>
           <tr>
             <td rowspan="2">동적 범위</td>
             <td class="tleft">기존 설치 : 90 dB 이상</td>
             <td><input name="f_q3_1"  value="Y" type="radio" multi="true" val="${reportMain.f_q3_1}"checked="checked"></td>
             <td><input name="f_q3_1"  value="N" type="radio" multi="true" val="${reportMain.f_q3_1}"></td>
           </tr>
           <tr>
             <td class="tleft">신규 설치 : 120dB 이상</td>
             <td><input name="f_q3_2"  value="Y" type="radio" multi="true" val="${reportMain.f_q3_2}"checked="checked"></td>
             <td><input name="f_q3_2"  value="N" type="radio" multi="true" val="${reportMain.f_q3_2}"></td>
           </tr>
         </tbody>
       </table>
     </article>
      <!--표 2-->
      <article class="page1 pop_table_report2">
       <table>
         <caption>관측소 기본 정보</caption>
         <colgroup>
                     <col style="width:15%" />
                     <col style="width:25%" />
         </colgroup>
         <thead>
         
           <tr>
             <th colspan="2">작성 보고서 정보</th>
           </tr>
         </thead>
         <tbody>
            <tr>
             <th>기관/계측소 코드</th>
             <td><input type="text" class="short" value="${reportMain.net }"> / <input type="text" class="midd" value="${reportMain.obs_id }"></td>
           </tr>
            <tr>
             <th>점검일자</th>
             <td><input id="yyyy" type="text" class="short2"> 년 <input id="mm"type="text" class="short"> 월 <input id="dd" type="text" class="short"> 일</td>
           </tr>
            <tr>
             <th>담당부서</th>
             <td><input name="user_dept" type="text" value="${reportMain.user_dept }"></td>
           </tr>
            <tr>
             <th>직책</th>
             <td><input name="user_duty" type="text" value="${reportMain.user_duty }"></td>
           </tr>
            <tr>
             <th>성명</th>
             <td><input name="user_name" type="text" value="${reportMain.user_name }"></td>
           </tr>
            <tr>
             <th>연락처</th>
             <td><input name="user_tel" type="text" value="${reportMain.user_tel }"></td>
           </tr>
         </tbody>
       </table>
     </article>
     
     <!--표 3-->
      <article class="page1 pop_table_report3">
       <table>
         <caption>관측소 기본 정보</caption>
         <colgroup>
                     <col style="width:7%" />
                     <col style="width:10%" />
                     <col style="width:30%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
         </colgroup>
         <thead>
         
           <tr>
             <th rowspan="2">구분</th>
             <th colspan="2">점검내용<span onclick="fnAllSensorDisable()" style="float: right;padding:7px;border:1px solid;margin-right:5px;background-color:#4375DB;cursor:pointer;">센서 제거</span></th>
             <th colspan="2"><input name="sen" type="radio" value="1" style="width:auto;">센서1(T)</th>
             <th colspan="2"><input name="sen" type="radio" value="2" style="width:auto;">센서2(V)</th>
             <th colspan="2"><input name="sen" type="radio" value="3" style="width:auto;">센서3</th>
             <th colspan="2"><input name="sen" type="radio" value="4" style="width:auto;">센서4</th>
             <th colspan="2"><input name="sen" type="radio" value="5" style="width:auto;">센서5</th>
           </tr>
            <tr>
             <th>항목</th>
             <th>상세내용</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
           </tr>
         </thead>
         <tbody id="2nd">
            <tr>
             <td rowspan="10">시설물 지진 가속도
             <span style="display: none;"><input type="hidden" class="sen1" name="s(1)_sno" value=${sen_1.rpt_sno }></span>
             <span style="display: none;"><input type="hidden" class="sen2" name="s(2)_sno" value=${sen_2.rpt_sno }></span>
             <span style="display: none;"><input type="hidden" class="sen3" name="s(3)_sno" value=${sen_3.rpt_sno }></span>
             <span style="display: none;"><input type="hidden" class="sen4" name="s(4)_sno" value=${sen_4.rpt_sno }></span>
             <span style="display: none;"><input type="hidden" class="sen5" name="s(5)_sno" value=${sen_5.rpt_sno }></span>
             </td>
             <td rowspan="6">가속도계 성분</td>
             <td class="tleft">수평 1성분(단방향)</td>
             <td><input class="sen1" name="s(1)_q1_1" value="Y" type="radio" multi="true" val="${sen_1.s_q1_1}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q1_1" value="N" type="radio" multi="true" val="${sen_1.s_q1_1}"></td>
             <td><input class="sen2" name="s(2)_q1_1" value="Y" type="radio" multi="true" val="${sen_2.s_q1_1}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q1_1" value="N" type="radio" multi="true" val="${sen_2.s_q1_1}"></td>
             <td><input class="sen3" name="s(3)_q1_1" value="Y" type="radio" multi="true" val="${sen_3.s_q1_1}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q1_1" value="N" type="radio" multi="true" val="${sen_3.s_q1_1}"></td>
             <td><input class="sen4" name="s(4)_q1_1" value="Y" type="radio" multi="true" val="${sen_4.s_q1_1}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q1_1" value="N" type="radio" multi="true" val="${sen_4.s_q1_1}"></td>
             <td><input class="sen5" name="s(5)_q1_1" value="Y" type="radio" multi="true" val="${sen_5.s_q1_1}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q1_1" value="N" type="radio" multi="true" val="${sen_5.s_q1_1}"></td>
           </tr>
           <tr>
             <td class="tleft">수평 2성분</td>
             <td><input class="sen1" name="s(1)_q1_2" value="Y" type="radio" multi="true" val="${sen_1.s_q1_2}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q1_2" value="N" type="radio" multi="true" val="${sen_1.s_q1_2}"></td>                 
             <td><input class="sen2" name="s(2)_q1_2" value="Y" type="radio" multi="true" val="${sen_2.s_q1_2}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q1_2" value="N" type="radio" multi="true" val="${sen_2.s_q1_2}"></td>                 
             <td><input class="sen3" name="s(3)_q1_2" value="Y" type="radio" multi="true" val="${sen_3.s_q1_2}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q1_2" value="N" type="radio" multi="true" val="${sen_3.s_q1_2}"></td>                 
             <td><input class="sen4" name="s(4)_q1_2" value="Y" type="radio" multi="true" val="${sen_4.s_q1_2}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q1_2" value="N" type="radio" multi="true" val="${sen_4.s_q1_2}"></td>                 
             <td><input class="sen5" name="s(5)_q1_2" value="Y" type="radio" multi="true" val="${sen_5.s_q1_2}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q1_2" value="N" type="radio" multi="true" val="${sen_5.s_q1_2}"></td>                 
           </tr>
           <tr>
             <td class="tleft">연직 1성분, 수평 2성분</td>
             <td><input class="sen1" name="s(1)_q1_3" value="Y" type="radio" multi="true" val="${sen_1.s_q1_3}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q1_3" value="N" type="radio" multi="true" val="${sen_1.s_q1_3}"></td>                 
             <td><input class="sen2" name="s(2)_q1_3" value="Y" type="radio" multi="true" val="${sen_2.s_q1_3}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q1_3" value="N" type="radio" multi="true" val="${sen_2.s_q1_3}"></td>                 
             <td><input class="sen3" name="s(3)_q1_3" value="Y" type="radio" multi="true" val="${sen_3.s_q1_3}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q1_3" value="N" type="radio" multi="true" val="${sen_3.s_q1_3}"></td>                 
             <td><input class="sen4" name="s(4)_q1_3" value="Y" type="radio" multi="true" val="${sen_4.s_q1_3}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q1_3" value="N" type="radio" multi="true" val="${sen_4.s_q1_3}"></td>                 
             <td><input class="sen5" name="s(5)_q1_3" value="Y" type="radio" multi="true" val="${sen_5.s_q1_3}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q1_3" value="N" type="radio" multi="true" val="${sen_5.s_q1_3}"></td>                 
           </tr>
           <tr>
             <td class="tleft">연직 1성분, 수평 1성분</td>
             <td><input class="sen1" name="s(1)_q1_4" value="Y" type="radio" multi="true" val="${sen_1.s_q1_4}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q1_4" value="N" type="radio" multi="true" val="${sen_1.s_q1_4}"></td>                 
             <td><input class="sen2" name="s(2)_q1_4" value="Y" type="radio" multi="true" val="${sen_2.s_q1_4}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q1_4" value="N" type="radio" multi="true" val="${sen_2.s_q1_4}"></td>                 
             <td><input class="sen3" name="s(3)_q1_4" value="Y" type="radio" multi="true" val="${sen_3.s_q1_4}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q1_4" value="N" type="radio" multi="true" val="${sen_3.s_q1_4}"></td>                 
             <td><input class="sen4" name="s(4)_q1_4" value="Y" type="radio" multi="true" val="${sen_4.s_q1_4}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q1_4" value="N" type="radio" multi="true" val="${sen_4.s_q1_4}"></td>                 
             <td><input class="sen5" name="s(5)_q1_4" value="Y" type="radio" multi="true" val="${sen_5.s_q1_4}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q1_4" value="N" type="radio" multi="true" val="${sen_5.s_q1_4}"></td>                 
           </tr>
           <tr>
             <td class="tleft">연직 1성분</td>
             <td><input class="sen1" name="s(1)_q1_5" value="Y" type="radio" multi="true" val="${sen_1.s_q1_5}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q1_5" value="N" type="radio" multi="true" val="${sen_1.s_q1_5}"></td>                 
             <td><input class="sen2" name="s(2)_q1_5" value="Y" type="radio" multi="true" val="${sen_2.s_q1_5}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q1_5" value="N" type="radio" multi="true" val="${sen_2.s_q1_5}"></td>                 
             <td><input class="sen3" name="s(3)_q1_5" value="Y" type="radio" multi="true" val="${sen_3.s_q1_5}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q1_5" value="N" type="radio" multi="true" val="${sen_3.s_q1_5}"></td>                 
             <td><input class="sen4" name="s(4)_q1_5" value="Y" type="radio" multi="true" val="${sen_4.s_q1_5}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q1_5" value="N" type="radio" multi="true" val="${sen_4.s_q1_5}"></td>                 
             <td><input class="sen5" name="s(5)_q1_5" value="Y" type="radio" multi="true" val="${sen_5.s_q1_5}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q1_5" value="N" type="radio" multi="true" val="${sen_5.s_q1_5}"></td>                 
           </tr>
           <tr>
             <td class="tleft">수평 1성분(장방향)</td>
             <td><input class="sen1" name="s(1)_q1_6" value="Y" type="radio" multi="true" val="${sen_1.s_q1_6}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q1_6" value="N" type="radio" multi="true" val="${sen_1.s_q1_6}"></td>                 
             <td><input class="sen2" name="s(2)_q1_6" value="Y" type="radio" multi="true" val="${sen_2.s_q1_6}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q1_6" value="N" type="radio" multi="true" val="${sen_2.s_q1_6}"></td>                 
             <td><input class="sen3" name="s(3)_q1_6" value="Y" type="radio" multi="true" val="${sen_3.s_q1_6}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q1_6" value="N" type="radio" multi="true" val="${sen_3.s_q1_6}"></td>                 
             <td><input class="sen4" name="s(4)_q1_6" value="Y" type="radio" multi="true" val="${sen_4.s_q1_6}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q1_6" value="N" type="radio" multi="true" val="${sen_4.s_q1_6}"></td>                 
             <td><input class="sen5" name="s(5)_q1_6" value="Y" type="radio" multi="true" val="${sen_5.s_q1_6}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q1_6" value="N" type="radio" multi="true" val="${sen_5.s_q1_6}"></td>                 
           </tr>                                 
           <tr>
             <td rowspan="2">주파수 영역</td>
             <td class="tleft">최소 주파수 0.1Hz 이내 최대 주파수 50Hz 이상</td>
             <td><input class="sen1" name="s(1)_q2_1" value="Y" type="radio" multi="true" val="${sen_1.s_q2_1}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q2_1" value="N" type="radio" multi="true" val="${sen_1.s_q2_1}"></td>                 
             <td><input class="sen2" name="s(2)_q2_1" value="Y" type="radio" multi="true" val="${sen_2.s_q2_1}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q2_1" value="N" type="radio" multi="true" val="${sen_2.s_q2_1}"></td>                 
             <td><input class="sen3" name="s(3)_q2_1" value="Y" type="radio" multi="true" val="${sen_3.s_q2_1}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q2_1" value="N" type="radio" multi="true" val="${sen_3.s_q2_1}"></td>                 
             <td><input class="sen4" name="s(4)_q2_1" value="Y" type="radio" multi="true" val="${sen_4.s_q2_1}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q2_1" value="N" type="radio" multi="true" val="${sen_4.s_q2_1}"></td>                 
             <td><input class="sen5" name="s(5)_q2_1" value="Y" type="radio" multi="true" val="${sen_5.s_q2_1}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q2_1" value="N" type="radio" multi="true" val="${sen_5.s_q2_1}"></td>                 
           </tr>
           <tr>
             <td class="tleft">0.1Hz~50Hz까지 평활 주파수 대역 유지</td>
             <td><input class="sen1" name="s(1)_q2_2" value="Y" type="radio" multi="true" val="${sen_1.s_q2_2}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q2_2" value="N" type="radio" multi="true" val="${sen_1.s_q2_2}"></td>                 
             <td><input class="sen2" name="s(2)_q2_2" value="Y" type="radio" multi="true" val="${sen_2.s_q2_2}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q2_2" value="N" type="radio" multi="true" val="${sen_2.s_q2_2}"></td>                 
             <td><input class="sen3" name="s(3)_q2_2" value="Y" type="radio" multi="true" val="${sen_3.s_q2_2}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q2_2" value="N" type="radio" multi="true" val="${sen_3.s_q2_2}"></td>                 
             <td><input class="sen4" name="s(4)_q2_2" value="Y" type="radio" multi="true" val="${sen_4.s_q2_2}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q2_2" value="N" type="radio" multi="true" val="${sen_4.s_q2_2}"></td>                 
             <td><input class="sen5" name="s(5)_q2_2" value="Y" type="radio" multi="true" val="${sen_5.s_q2_2}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q2_2" value="N" type="radio" multi="true" val="${sen_5.s_q2_2}"></td>                 
           </tr>
           <tr>
             <td rowspan="2">동적 범위</td>
             <td class="tleft">기존 설치 : 90dB 이상</td>
             <td><input class="sen1" name="s(1)_q3_1" value="Y" type="radio" multi="true" val="${sen_1.s_q3_1}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q3_1" value="N" type="radio" multi="true" val="${sen_1.s_q3_1}"></td>                 
             <td><input class="sen2" name="s(2)_q3_1" value="Y" type="radio" multi="true" val="${sen_2.s_q3_1}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q3_1" value="N" type="radio" multi="true" val="${sen_2.s_q3_1}"></td>                 
             <td><input class="sen3" name="s(3)_q3_1" value="Y" type="radio" multi="true" val="${sen_3.s_q3_1}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q3_1" value="N" type="radio" multi="true" val="${sen_3.s_q3_1}"></td>                 
             <td><input class="sen4" name="s(4)_q3_1" value="Y" type="radio" multi="true" val="${sen_4.s_q3_1}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q3_1" value="N" type="radio" multi="true" val="${sen_4.s_q3_1}"></td>                 
             <td><input class="sen5" name="s(5)_q3_1" value="Y" type="radio" multi="true" val="${sen_5.s_q3_1}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q3_1" value="N" type="radio" multi="true" val="${sen_5.s_q3_1}"></td>                 
           </tr>
           <tr>
             <td class="tleft">신규 설치 : 120dB 이상</td>
             <td><input class="sen1" name="s(1)_q3_2" value="Y" type="radio" multi="true" val="${sen_1.s_q3_2}"checked="checked"></td>
             <td><input class="sen1" name="s(1)_q3_2" value="N" type="radio" multi="true" val="${sen_1.s_q3_2}"></td>                 
             <td><input class="sen2" name="s(2)_q3_2" value="Y" type="radio" multi="true" val="${sen_2.s_q3_2}"checked="checked"></td>
             <td><input class="sen2" name="s(2)_q3_2" value="N" type="radio" multi="true" val="${sen_2.s_q3_2}"></td>                 
             <td><input class="sen3" name="s(3)_q3_2" value="Y" type="radio" multi="true" val="${sen_3.s_q3_2}"checked="checked"></td>
             <td><input class="sen3" name="s(3)_q3_2" value="N" type="radio" multi="true" val="${sen_3.s_q3_2}"></td>                 
             <td><input class="sen4" name="s(4)_q3_2" value="Y" type="radio" multi="true" val="${sen_4.s_q3_2}"checked="checked"></td>
             <td><input class="sen4" name="s(4)_q3_2" value="N" type="radio" multi="true" val="${sen_4.s_q3_2}"></td>                 
             <td><input class="sen5" name="s(5)_q3_2" value="Y" type="radio" multi="true" val="${sen_5.s_q3_2}"checked="checked"></td>
             <td><input class="sen5" name="s(5)_q3_2" value="N" type="radio" multi="true" val="${sen_5.s_q3_2}"></td>                 
           </tr>
         </tbody>
       </table>
     </article>
     
     <!--  -->
     
<!--      class="bgray" -->
      <!--표 1-->
      <article class="page2 pop_table_report3">
       <table style="width:100%;">
         <caption>지진가속도계측기 초기점검보고서</caption>
         <colgroup>
                     <col style="width:7%" />
                     <col style="width:25%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:7%" />
                     <col style="width:25%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
         </colgroup>
         <thead>
         
           <tr>
             <th>구분</th>
             <th>기록계</th>
             <th colspan="8">점검 내용</th>
             <th colspan="2"><input name="rec" value="1" type="radio"><br>기록계1</th>
             <th colspan="2"><input name="rec" value="2" type="radio"><br>기록계2</th>
             <th colspan="2"><input name="rec" value="3" type="radio"><br>기록계3</th>
           </tr>
            <tr>
             <th>항목</th>
             <th>상세내용</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
             <th>항목</th>
             <th>상세내용</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
             <th>적합</th>
             <th>부적합</th>
           </tr>
         </thead>
         <tbody id="3rd">
            <tr>
             <th rowspan="2">동적 범위
             <span style="display:none"><input class="rec1" type="hidden" name="r(1)_rno" value=${rec_1.rpt_rno }></span>
             <span style="display:none"><input class="rec2" type="hidden" name="r(2)_rno" value=${rec_2.rpt_rno }></span>
             <span style="display:none"><input class="rec3" type="hidden" name="r(3)_rno" value=${rec_3.rpt_rno }></span>
             </th>
             <td class="tleft">기존설치 : 90dB 이상</td>
             <td><input class="rec1" type="radio" name="r(1)_q1_1" value="Y" type="radio" multi="true" val="${rec_1.r_q1_1}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q1_1" value="N" type="radio" multi="true" val="${rec_1.r_q1_1}"></td>
             <td><input class="rec2" type="radio" name="r(2)_q1_1" value="Y" type="radio" multi="true" val="${rec_2.r_q1_1}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q1_1" value="N" type="radio" multi="true" val="${rec_2.r_q1_1}"></td>
             <td><input class="rec3" type="radio" name="r(3)_q1_1" value="Y" type="radio" multi="true" val="${rec_3.r_q1_1}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q1_1" value="N" type="radio" multi="true" val="${rec_3.r_q1_1}"></td>
             <th>자료취득 횟수</th>
             <td class="tleft">MMA/S</td>
             <td><input class="rec1" type="radio" name="r(1)_q4_3" value="Y" type="radio" multi="true" val="${rec_1.r_q4_3}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q4_3" value="N" type="radio" multi="true" val="${rec_1.r_q4_3}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q4_3" value="Y" type="radio" multi="true" val="${rec_2.r_q4_3}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q4_3" value="N" type="radio" multi="true" val="${rec_2.r_q4_3}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q4_3" value="Y" type="radio" multi="true" val="${rec_3.r_q4_3}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q4_3" value="N" type="radio" multi="true" val="${rec_3.r_q4_3}"></td>                 
           </tr>
           <tr>
             <td class="tleft">신규설치 : 120dB 이상</td>
             <td><input class="rec1" type="radio" name="r(1)_q1_2" value="Y" type="radio" multi="true" val="${rec_1.r_q1_2}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q1_2" value="N" type="radio" multi="true" val="${rec_1.r_q1_2}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q1_2" value="Y" type="radio" multi="true" val="${rec_2.r_q1_2}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q1_2" value="N" type="radio" multi="true" val="${rec_2.r_q1_2}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q1_2" value="Y" type="radio" multi="true" val="${rec_3.r_q1_2}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q1_2" value="N" type="radio" multi="true" val="${rec_3.r_q1_2}"></td>                 
             <th rowspan="3">기록형식 및 저장</th>
             <td class="tleft">100회/초 저장 및 전송</td>
             <td><input class="rec1" type="radio" name="r(1)_q5_1" value="Y" type="radio" multi="true" val="${rec_1.r_q5_1}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q5_1" value="N" type="radio" multi="true" val="${rec_1.r_q5_1}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q5_1" value="Y" type="radio" multi="true" val="${rec_2.r_q5_1}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q5_1" value="N" type="radio" multi="true" val="${rec_2.r_q5_1}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q5_1" value="Y" type="radio" multi="true" val="${rec_3.r_q5_1}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q5_1" value="N" type="radio" multi="true" val="${rec_3.r_q5_1}"></td>                 
           </tr>
           <tr>
             <th rowspan="2">채널수</th>
             <td class="tleft">자유장 : 3채널 이상</td>
             <td><input class="rec1" type="radio" name="r(1)_q2_1" value="Y" type="radio" multi="true" val="${rec_1.r_q2_1}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q2_1" value="N" type="radio" multi="true" val="${rec_1.r_q2_1}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q2_1" value="Y" type="radio" multi="true" val="${rec_2.r_q2_1}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q2_1" value="N" type="radio" multi="true" val="${rec_2.r_q2_1}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q2_1" value="Y" type="radio" multi="true" val="${rec_3.r_q2_1}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q2_1" value="N" type="radio" multi="true" val="${rec_3.r_q2_1}"></td>                 
             <td class="tleft">20회/초 저장 및 전송</td>
             <td><input class="rec1" type="radio" name="r(1)_q5_2" value="Y" type="radio" multi="true" val="${rec_1.r_q5_2}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q5_2" value="N" type="radio" multi="true" val="${rec_1.r_q5_2}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q5_2" value="Y" type="radio" multi="true" val="${rec_2.r_q5_2}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q5_2" value="N" type="radio" multi="true" val="${rec_2.r_q5_2}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q5_2" value="Y" type="radio" multi="true" val="${rec_3.r_q5_2}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q5_2" value="N" type="radio" multi="true" val="${rec_3.r_q5_2}"></td>                 
           </tr>
           <tr>
             <td class="tleft">시설물 : 3채널 이상 및 확장 가능성 확인</td>
             <td><input class="rec1" type="radio" name="r(1)_q2_2" value="Y" type="radio" multi="true" val="${rec_1.r_q2_2}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q2_2" value="N" type="radio" multi="true" val="${rec_1.r_q2_2}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q2_2" value="Y" type="radio" multi="true" val="${rec_2.r_q2_2}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q2_2" value="N" type="radio" multi="true" val="${rec_2.r_q2_2}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q2_2" value="Y" type="radio" multi="true" val="${rec_3.r_q2_2}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q2_2" value="N" type="radio" multi="true" val="${rec_3.r_q2_2}"></td>                 
             <td class="tleft">MMA/S</td>
             <td><input class="rec1" type="radio" name="r(1)_q5_3" value="Y" type="radio" multi="true" val="${rec_1.r_q5_3}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q5_3" value="N" type="radio" multi="true" val="${rec_1.r_q5_3}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q5_3" value="Y" type="radio" multi="true" val="${rec_2.r_q5_3}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q5_3" value="N" type="radio" multi="true" val="${rec_2.r_q5_3}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q5_3" value="Y" type="radio" multi="true" val="${rec_3.r_q5_3}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q5_3" value="N" type="radio" multi="true" val="${rec_3.r_q5_3}"></td>                 
           </tr>
           <tr>
             <th rowspan="2">트리거 방법</th>
             <td class="tleft">STA/LTA 방법 또는 threshole 이용</td>
             <td><input class="rec1" type="radio" name="r(1)_q3_1" value="Y" type="radio" multi="true" val="${rec_1.r_q3_1}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q3_1" value="N" type="radio" multi="true" val="${rec_1.r_q3_1}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q3_1" value="Y" type="radio" multi="true" val="${rec_2.r_q3_1}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q3_1" value="N" type="radio" multi="true" val="${rec_2.r_q3_1}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q3_1" value="Y" type="radio" multi="true" val="${rec_3.r_q3_1}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q3_1" value="N" type="radio" multi="true" val="${rec_3.r_q3_1}"></td>                 
             <th rowspan="2">자료기록</th>
             <td class="tleft">트리거 전 30초</td>
             <td><input class="rec1" type="radio" name="r(1)_q6_1" value="Y" type="radio" multi="true" val="${rec_1.r_q6_1}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q6_1" value="N" type="radio" multi="true" val="${rec_1.r_q6_1}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q6_1" value="Y" type="radio" multi="true" val="${rec_2.r_q6_1}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q6_1" value="N" type="radio" multi="true" val="${rec_2.r_q6_1}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q6_1" value="Y" type="radio" multi="true" val="${rec_3.r_q6_1}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q6_1" value="N" type="radio" multi="true" val="${rec_3.r_q6_1}"></td>                 
           </tr>
           <tr>
             <td class="tleft">트리거 수준 변경 기능 확인</td>
             <td><input class="rec1" type="radio" name="r(1)_q3_2" value="Y" type="radio" multi="true" val="${rec_1.r_q3_2}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q3_2" value="N" type="radio" multi="true" val="${rec_1.r_q3_2}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q3_2" value="Y" type="radio" multi="true" val="${rec_2.r_q3_2}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q3_2" value="N" type="radio" multi="true" val="${rec_2.r_q3_2}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q3_2" value="Y" type="radio" multi="true" val="${rec_3.r_q3_2}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q3_2" value="N" type="radio" multi="true" val="${rec_3.r_q3_2}"></td>                 
             <td class="tleft">트리거 후 60초</td>
             <td><input class="rec1" type="radio" name="r(1)_q6_2" value="Y" type="radio" multi="true" val="${rec_1.r_q6_2}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q6_2" value="N" type="radio" multi="true" val="${rec_1.r_q6_2}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q6_2" value="Y" type="radio" multi="true" val="${rec_2.r_q6_2}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q6_2" value="N" type="radio" multi="true" val="${rec_2.r_q6_2}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q6_2" value="Y" type="radio" multi="true" val="${rec_3.r_q6_2}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q6_2" value="N" type="radio" multi="true" val="${rec_3.r_q6_2}"></td>                 
           </tr>
           <tr>
             <th rowspan="2">자료취득 회수</th>
             <td class="tleft">100회/초 저장 및 전송</td>
             <td><input class="rec1" type="radio" name="r(1)_q4_1" value="Y" type="radio" multi="true" val="${rec_1.r_q4_1}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q4_1" value="N" type="radio" multi="true" val="${rec_1.r_q4_1}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q4_1" value="Y" type="radio" multi="true" val="${rec_2.r_q4_1}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q4_1" value="N" type="radio" multi="true" val="${rec_2.r_q4_1}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q4_1" value="Y" type="radio" multi="true" val="${rec_3.r_q4_1}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q4_1" value="N" type="radio" multi="true" val="${rec_3.r_q4_1}"></td>                 
             <th>최대시각 오차</th>
             <td class="tleft">0.005초 이내</td>
             <td><input class="rec1" type="radio" name="r(1)_q7" value="Y" type="radio" multi="true" val="${rec_1.r_q7}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q7" value="N" type="radio" multi="true" val="${rec_1.r_q7}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q7" value="Y" type="radio" multi="true" val="${rec_2.r_q7}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q7" value="N" type="radio" multi="true" val="${rec_2.r_q7}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q7" value="Y" type="radio" multi="true" val="${rec_3.r_q7}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q7" value="N" type="radio" multi="true" val="${rec_3.r_q7}"></td>                 
           </tr>
           <tr>
             <td class="tleft">20회/초 저장 및 전송</td>
             <td><input class="rec1" type="radio" name="r(1)_q4_2" value="Y" type="radio" multi="true" val="${rec_1.r_q4_2}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q4_2" value="N" type="radio" multi="true" val="${rec_1.r_q4_2}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q4_2" value="Y" type="radio" multi="true" val="${rec_2.r_q4_2}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q4_2" value="N" type="radio" multi="true" val="${rec_2.r_q4_2}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q4_2" value="Y" type="radio" multi="true" val="${rec_3.r_q4_2}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q4_2" value="N" type="radio" multi="true" val="${rec_3.r_q4_2}"></td>                 
             <th>자료전송방법</th>
             <td class="tleft">TCP/IP 통신</td>
             <td><input class="rec1" type="radio" name="r(1)_q8" value="Y" type="radio" multi="true" val="${rec_1.r_q8}"checked="checked"></td>
             <td><input class="rec1" type="radio" name="r(1)_q8" value="N" type="radio" multi="true" val="${rec_1.r_q8}"></td>                 
             <td><input class="rec2" type="radio" name="r(2)_q8" value="Y" type="radio" multi="true" val="${rec_2.r_q8}"checked="checked"></td>
             <td><input class="rec2" type="radio" name="r(2)_q8" value="N" type="radio" multi="true" val="${rec_2.r_q8}"></td>                 
             <td><input class="rec3" type="radio" name="r(3)_q8" value="Y" type="radio" multi="true" val="${rec_3.r_q8}"checked="checked"></td>
             <td><input class="rec3" type="radio" name="r(3)_q8" value="N" type="radio" multi="true" val="${rec_3.r_q8}"></td>                 
           </tr>
         </tbody>
       </table>
     </article>
     
     <!--표 1-->
      <article class="page2 pop_table_report3">
       <table>
         <caption>지진가속도계측기 초기점검보고서2</caption>
         <colgroup>
                     <col style="width:7%" />
                     <col style="width:37%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
                     <col style="width:7%" />
                     <col style="width:37%" />
                     <col style="width:3%" />
                     <col style="width:3%" />
         </colgroup>
         <thead>
         
           <tr>
             <th>구분</th>
             <th>상세내용</th>
             <th>적합</th>
             <th>부적합</th>
             <th>구분</th>
             <th>상세내용</th>
             <th>적합</th>
             <th>부적합</th>
           </tr>
         </thead>
         <tbody id="4th">
            <tr>
             <th rowspan="7">지진 가속도계 설치 위치</th>
             <td class="tleft">기록의 횟수, 점검 및 교체가 용이하며 접근성이 좋을 것</td>
             <td><input type="radio" name="r_q9_1" value="Y" type="radio" multi="true" val="${reportMain.r_q9_1}"checked="checked"></td>
             <td><input type="radio" name="r_q9_1" value="N" type="radio" multi="true" val="${reportMain.r_q9_1}"></td>
             <th rowspan="2">설치 상태</th>
             <td class="tleft">자유장, 지진가속도계 센서의 수평방향은 동서방향과 남북방향이 되도록 설치</td>
             <td><input type="radio" name="r_q10_3" value="Y" type="radio" multi="true" val="${reportMain.r_q10_3}"checked="checked"></td>
             <td><input type="radio" name="r_q10_3" value="N" type="radio" multi="true" val="${reportMain.r_q10_3}"></td>
           </tr>
            <tr>
             <td class="tleft">지진 발생 시 낙하물에 의한 손상 우려가 없는 안전한 장소</td>
             <td><input type="radio" name="r_q9_2" value="Y" type="radio" multi="true" val="${reportMain.r_q9_2}"checked="checked"></td>
             <td><input type="radio" name="r_q9_2" value="N" type="radio" multi="true" val="${reportMain.r_q9_2}"></td>
             <td class="tleft">모든 시설물 지진가속도계가 동일한 좌표축을 유지</td>
             <td><input type="radio" name="r_q10_4" value="Y" type="radio" multi="true" val="${reportMain.r_q10_4}"checked="checked"></td>
             <td><input type="radio" name="r_q10_4" value="N" type="radio" multi="true" val="${reportMain.r_q10_4}"></td>
           </tr>
            <tr>
             <td class="tleft">실외에 설치되었을 경우 계측기의 정상 작동 온도 범위 유지</td>
             <td><input type="radio" name="r_q9_3" value="Y" type="radio" multi="true" val="${reportMain.r_q9_3}"checked="checked"></td>
             <td><input type="radio" name="r_q9_3" value="N" type="radio" multi="true" val="${reportMain.r_q9_3}"></td>
             <th rowspan="4">전원부</th>
             <td class="tleft">접지 루프가 형성되지 않도록 지진가속도계측기를 접지</td>
             <td><input type="radio" name="r_q11_1" value="Y" type="radio" multi="true" val="${reportMain.r_q11_1}"checked="checked"></td>
             <td><input type="radio" name="r_q11_1" value="N" type="radio" multi="true" val="${reportMain.r_q11_1}"></td>
           </tr>
            <tr>
             <td class="tleft">실내에 설치되었을 경우 진동이 크게 발생하는 지역 회피</td>
             <td><input type="radio" name="r_q9_4" value="Y" type="radio" multi="true" val="${reportMain.r_q9_4}"checked="checked"></td>
             <td><input type="radio" name="r_q9_4" value="N" type="radio" multi="true" val="${reportMain.r_q9_4}"></td>
             <td class="tleft">외부입력 전선에 서지보호장치 설치</td>
             <td><input type="radio" name="r_q11_2" value="Y" type="radio" multi="true" val="${reportMain.r_q11_2}"checked="checked"></td>
             <td><input type="radio" name="r_q11_2" value="N" type="radio" multi="true" val="${reportMain.r_q11_2}"></td>
           </tr>
            <tr>
             <td class="tleft">방폭지역 및 강한 전자장 발생지역 회피</td>
             <td><input type="radio" name="r_q9_5" value="Y" type="radio" multi="true" val="${reportMain.r_q9_5}"checked="checked"></td>
             <td><input type="radio" name="r_q9_5" value="N" type="radio" multi="true" val="${reportMain.r_q9_5}"></td>
             <td class="tleft">연결상태 및 전원공급 정상 상태 확인</td>
             <td><input type="radio" name="r_q11_3" value="Y" type="radio" multi="true" val="${reportMain.r_q11_3}"checked="checked"></td>
             <td><input type="radio" name="r_q11_3" value="N" type="radio" multi="true" val="${reportMain.r_q11_3}"></td>
           </tr>
            <tr>
             <td class="tleft">큰 전류가 발생하는 장소의 경우 실드케이블 사용</td>
             <td><input type="radio" name="r_q9_6" value="Y" type="radio" multi="true" val="${reportMain.r_q9_6}"checked="checked"></td>
             <td><input type="radio" name="r_q9_6" value="N" type="radio" multi="true" val="${reportMain.r_q9_6}"></td>
             <td class="tleft">비상전원공급장치 설치</td>
             <td><input type="radio" name="r_q11_4" value="Y" type="radio" multi="true" val="${reportMain.r_q11_4}"checked="checked"></td>
             <td><input type="radio" name="r_q11_4" value="N" type="radio" multi="true" val="${reportMain.r_q11_4}"></td>
           </tr>
            <tr>
             <td class="tleft">주변 시설물들과의 상호작용에 의한 영향이 없어야 함</td>
             <td><input type="radio" name="r_q9_7" value="Y" type="radio" multi="true" val="${reportMain.r_q9_7}"checked="checked"></td>
             <td><input type="radio" name="r_q9_7" value="N" type="radio" multi="true" val="${reportMain.r_q9_7}"></td>
             <th rowspan="2">계측 데이터</th>
             <td class="tleft">국민안전처의 지진가속도계측 통합관리시스템과 연계구동</td>
             <td><input type="radio" name="r_q12_1" value="Y" type="radio" multi="true" val="${reportMain.r_q12_1}"checked="checked"></td>
             <td><input type="radio" name="r_q12_1" value="N" type="radio" multi="true" val="${reportMain.r_q12_1}"></td>
           </tr>
           
            <tr>
             <th rowspan="2">설치상태</th>
             <td class="tleft">지반 또는 시설물의 바닥에 견고히 고정</td>
             <td><input type="radio" name="r_q10_1" value="Y" type="radio" multi="true" val="${reportMain.r_q10_1}"checked="checked"></td>
             <td><input type="radio" name="r_q10_1" value="N" type="radio" multi="true" val="${reportMain.r_q10_1}"></td>
             <td class="tleft">국민안전처의 지진가속도계측 통합관리시스템의 데이터베이스에 정상적으로 등록</td>
             <td><input type="radio" name="r_q12_2" value="Y" type="radio" multi="true" val="${reportMain.r_q12_2}"checked="checked"></td>
             <td><input type="radio" name="r_q12_2" value="N" type="radio" multi="true" val="${reportMain.r_q12_2}"></td>
           </tr>
           <tr>
             <td class="tleft">기후변화, 전가지 및 낙뢰영향 방지등의 보호장치</td>
             <td><input type="radio" name="r_q10_2" value="Y" type="radio" multi="true" val="${reportMain.r_q10_2}"checked="checked"></td>
             <td><input type="radio" name="r_q10_2" value="N" type="radio" multi="true" val="${reportMain.r_q10_2}"></td>
             <td colspan="2"></td>
             <td colspan="2" ></td>
           </tr>
           
           <tr>
             <th>점검결과</th>
             <td colspan="3"><input type="text" name="bigo"></td>
             <th>처리결과</th>
             <td colspan="3"><input type="text" name="result"></td>
           </tr>
         </tbody>
       </table>
     </article>
    </section>
   </form>
</div>
</body>
</html>
