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
		var inFlag = false;
		$(document).ready(function(){
			$(".popup-info-container div:first").show();
// 			modyFormdata()

			$("#recorder-table,#sensor-table").children("tr").each(function(){
				if($(this).attr("chk")!="no"){
					$(this).children("td").each(function(){
// 						console.log($(this).html());
						$(this).children().attr("onChange","modyFormdata(this)");
						
// 						$(this).children().on('change',modyFormdata($(this)));
// 						console.log($(this).children().val());
					});
				}
			});
			
			/* 탭 이벤트 */
		    $("ul.tabs li").click(function () {
		        $("ul.tabs li").removeClass("active").css("color", "#333");
		        //$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
		        $(this).addClass("active");//.css("color", "darkred");
		        $(".tab-contrainer").hide();
		        var activeTab = $(this).attr("rel");
		        $("#" + activeTab).fadeIn();
		    });
		    /* 탭 이벤트 종료 */

		});
		

		function fnSaveStationInfo(){
			var jsonStr = formSerializeToJsonStr($("#station-form").serialize()+"&status=${status}","one");
		    $.ajax({
		          url: "${pageContext.request.contextPath}/system/report/update.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jsonStr,
		          success : function(data){
		          	if(data.resultDesc=="success"){
		          		console.log("s");
		          		return true;
		          	}else{
		          		return false;
		          	}
		          } 
            });
		}
		/*
			table : 데이터 추가되는 테이블의 tbody
		*/
		function fnAddDataRow(table)
		{
			if($("#"+table).children("tr").size()==1){
				document.location.reload();
			}else if((table=="sensor-table"?($("#"+table).children("tr").size()>5?true:false):($("#"+table).children("tr").size()>3?true:false))){
				alert("너무 많은 값이 입력되었습니다.");
				return false;
			}
			var tr = $("#"+table).children("tr").eq(1);
			var tdCnt = tr.children("td").length;
			var append = "<tr>";
			for(var i=0;i<tdCnt;i++)
			{
				child = tr.children("td").eq(i).children().size();
				if(tr.children("td").eq(i).attr("child")=="none"){
					append+="<td child='none'></td>";
				}else if(tr.children("td").eq(i).attr("child")=="delete"){
					console.log(tr.children("td").eq(i).html());
					append+="<td child='delete'>"+tr.children("td").eq(i).html().replace("data","list")+"</td>";
				}else{
					
					append += "<td>";
					for(var j=0;j<child;j++)
					{
					append +="<input vaild='"+tr.children("td").eq(i).children("input").eq(j-1).attr("vaild")+
					"' type='"+tr.children("td").eq(i).children("input").eq(j-1).attr("type")+"' name='"+tr.children("td").eq(i).children("input").eq(j-1).attr("name")+
					"' "+(tr.children("td").eq(i).children("input").eq(j-1).attr("name")=="dataStatus"?"value='add'":"")+"  "+(tr.children("td").eq(i).children("input").eq(j-1).attr("readonly")=="readonly"?"readonly='readonly' value='"+tr.children("td").eq(i).children("input").eq(j-1).val()+"'":"")+">";
					}
					append +="</td>";
				}
				
			}
			append += "</tr>";
			$("#"+table).append(append);
		}
		function modyFormdata(form){
// 			console.log($(form).parent().parent().html());
			var status = $(form).parent().parent().children("td").eq(0).children("input").eq(0);
			
			if(status.val()=="data"){
				status.val("mody");
			}
		}
		/*
			form : 데이터 추가를 하려는 form의 ID
			recorder, sensor의 
		*/
		function fnSaveSubAttribute(form,type)
		{
// 			if(!validationCheck(form)){
// 				return false;
// 			}
// 			console.log(formSerializeToJsonStr($("#"+form),"list"));
			var jsonStr = formSerializeToJsonStr($("#"+form),"list");
			var url = "";
			if(type=="record"){
				url = "${pageContext.request.contextPath}/system/report/recorderInsert.ws";
			}else{
				url = "${pageContext.request.contextPath}/system/report/sensorInsert.ws";
			}
			
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
			      		return true;
		          	}else{
		          		return false;
		          	}
		          }
		           
        	});
		    return rtnVal;
		}
		function fnDeleteSubList(idx,type,obj)
		{
			if(type.indexOf("recorder")>-1){
				url = "${pageContext.request.contextPath}/system/report/recorderDelete.ws";
			}else{
				url = "${pageContext.request.contextPath}/system/report/sensorDelete.ws";
			}
			if(type.indexOf("data")>-1)
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
					      		alert("삭제되었습니다.");
				          	}
			          } 
	        	});
				
			}
// 			else if(type=="list")
// 			{
// 				alert("삭제 라인");
// 			}
			$(obj).parent().parent().parent().remove();
		}
		function getToday(){
			var d = new Date();
			var tday = d.getFullYear()+"-"+getFormattedPartTime(d.getMonth()+1)+"-"+getFormattedPartTime(d.getDate());
			return tday;
		}
		
		function fnSaveSationInfo(){
			
// 			if(!validationCheck("station-form") && !validationCheck("recorder-form") && !validationCheck("sensor-form")){
// 				return false;
// 			}

			var jsonStr = formSerializeToJsonStr($("#station-form").serialize()+"&status=${status}","one");
			var recStr = formSerializeToJsonStr($("#recorder-table"),"list");
			var senStr = formSerializeToJsonStr($("#sensor-table"),"list");
			
		    $.ajax({
		          url: "${pageContext.request.contextPath}/system/report/update.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jsonStr,
		          success : function(data){
		          	if(data.resultDesc=="success"){
		    		    $.ajax({
		  		          url: "${pageContext.request.contextPath}/system/report/recorderInsert.ws",
		  		          type: "POST",
		  		          dataType: 'json',
		  		          contentType: "application/json; charset=utf-8",
		  		          data: recStr,
		  		          success : function(data){
		  		        	console.log(data.resultDesc);
		  			      	if(data.resultDesc=="success")
		  			      	{
		  					    $.ajax({
		  				          url: "${pageContext.request.contextPath}/system/report/sensorInsert.ws",
		  				          type: "POST",
		  				          dataType: 'json',
		  				          contentType: "application/json; charset=utf-8",
		  				          data: senStr,
		  				          success : function(data){
		  				        	console.log(data.resultDesc);
		  					      	console.log("doit"+data);
		  					      	if(data.resultDesc=="success")
		  					      	{	
		  					      		alert("저장이 완료되었습니다.");
// 		  					      		setTimeout(function(){
// 		  					      			window.location.reload();
	  					        		opener.parent.location.reload();
	  					        		window.close();
// 		  					      		},300);
		  					      		return true;
		  				          	}else{
		  				          		alert("입력 도중 문제가 발생하였습니다.");
		  				          		return false;
		  				          	}
		  				          }
		  				           
		  		        	});
		  		          	}else{
		  		          		alert("입력 도중 문제가 발생하였습니다.");
		  		          		return false;
		  		          	}
		  		          }
		  		           
		          	});
		          	}else{
		          		alert("입력 도중 문제가 발생하였습니다.");
						return false;
		          	}
		          } 
            });
			
		}
		function fnTest(){
			if(confirm("저장하시겠습니까?")){
				fnSaveSationInfo();
			}
			return false;
			var txt = "rpt_data : "+getToday()+"\n";
			/*관측소 정보*/
			txt+="net : "+$("input[name='net']").val()+"\n";
			txt+="obs_id : "+$("input[name='obs_id']").val()+"\n";
			txt+="obs_name : "+$("input[name='obs_name']").val()+"\n";
			txt+="contractdate : "+$("input[name='contractdate']").val()+"\n";
			txt+="completedate : "+$("input[name='completedate']").val()+"\n";
			txt+="price_contract : "+$("input[name='price_contract']").val()+"\n";
			txt+="price_sw : "+$("input[name='price_sw']").val()+"\n";
			txt+="price_hw : "+$("input[name='price_hw']").val()+"\n";
			txt+="opendate : "+$("input[name='opendate']").val()+"\n";
			txt+="offdate : "+$("input[name='offdate']").val()+"\n";
			txt+="area : "+$("input[name='area']").val()+"\n";
			txt+="address : "+$("input[name='address']").val()+"\n";
			txt+="obs_kind : "+$("input[name='obs_kind']").val()+"\n";
			txt+="position : "+$("input[name='position']").val()+"\n";
			txt+="lon : "+$("input[name='lon']").val()+"\n";
			txt+="lat : "+$("input[name='lat']").val()+"\n";
			txt+="altitude : "+$("input[name='altitude']").val()+"\n";
			txt+="ground_ht : "+$("input[name='ground_ht']").val()+"\n";
			txt+="uground_ht : "+$("input[name='uground_ht']").val()+"\n";
			txt+="base : "+$("input[name='base']").val()+"\n";
			txt+="str_cd : "+$("input[name='str_cd']").val()+"\n";
			txt+="seis_cd : "+$("input[name='seis_cd']").val()+"\n";
			txt+="ground : "+$("input[name='ground']").val()+"\n";
			txt+="hole : "+$("select[name='hole']").val()+"\n";
			txt+="seis_ds : "+$("select[name='seis_ds']").val()+"\n";
			txt+="design_acc : "+$("input[name='design_acc']").val()+"\n";
			txt+="threshold_acc : "+$("input[name='threshold_acc']").val()+"\n";
			txt+="build_floor : "+$("input[name='build_floor']").val()+"\n";
			txt+="eq_area : "+$("select[name='eq_area']").val()+"\n";
			txt+="hole_map : "+$("input[name='hole_map']").val()+"\n";
			txt+="charge : "+$("input[name='charge']").val()+"\n";
			txt+="contact : "+$("input[name='contact']").val()+"\n";
			/*센서정보*/
			var sen_cnt = $("#sensor-table").children("tr").size()-1;
			txt+="sen_count : "+sen_cnt+"\n";
			for(var sen=0;sen<sen_cnt;sen++){

				txt+= "sen("+(sen+1)+")_id : "+$("input[name='net']").val()+"_"+$("input[name='sen_id']").val()+"\n";
				txt+= "sen("+(sen+1)+")_company : "+$("input[name='sen_company']").val()+"\n";
				txt+= "sen("+(sen+1)+")_model : "+$("input[name='sen_model']").val()+"\n";
				txt+= "sen("+(sen+1)+")_serial_no : "+$("input[name='sen_serial']").val()+"\n";
				txt+= "sen("+(sen+1)+")_kind : "+$("input[name='sen_kind']").val()+"\n";
				txt+= "sen("+(sen+1)+")_gubun : "+$("input[name='sen_gubun']").val()+"\n";
				txt+= "sen("+(sen+1)+")_position : "+$("input[name='sen_position']").val()+"\n";
				txt+= "sen("+(sen+1)+")_channel : "+$("input[name='sen_channel']").val()+"\n";
				txt+= "sen("+(sen+1)+")_lon : "+$("input[name='sen_lon']").val()+"\n";
				txt+= "sen("+(sen+1)+")_lat : "+$("input[name='sen_lat']").val()+"\n";
				txt+= "sen("+(sen+1)+")_z_response : "+$("input[name='sen_z_resp']").val()+"\n";
				txt+= "sen("+(sen+1)+")_n_response : "+$("input[name='sen_n_resp']").val()+"\n";
				txt+= "sen("+(sen+1)+")_e_response : "+$("input[name='sen_e_resp']").val()+"\n";
				txt+= "sen("+(sen+1)+")_z_sensitivity : "+$("input[name='sen_z_sens']").val()+"\n";
				txt+= "sen("+(sen+1)+")_n_sensitivity : "+$("input[name='sen_n_sens']").val()+"\n";
				txt+= "sen("+(sen+1)+")_e_sensitivity : "+$("input[name='sen_e_sens']").val()+"\n";
				txt+= "sen("+(sen+1)+")_rec_id : "+$("input[name='sen_rec_id']").val()+"\n";

			}
			/*기록계정보*/
			var rec_cnt = $("#recorder-table").children("tr").size()-1;
			txt+="rec_count : "+rec_cnt+"\n";	
			for(var rec=0;rec<rec_cnt;rec++)
			{

				txt+="rec("+(rec+1)+")_id : "+$("input[name='net']").val()+"_"+$("input[name='rec_id']").val()+"\n";
				txt+="rec("+(rec+1)+")_company : "+$("input[name='rec_company']").val()+"\n";
				txt+="rec("+(rec+1)+")_model : "+$("input[name='rec_model']").val()+"\n";
				txt+="rec("+(rec+1)+")_serial_no : "+$("input[name='rec_serial']").val()+"\n";
				txt+="rec("+(rec+1)+")_warranty : "+$("input[name='warrenty']").val()+"\n";
				txt+="rec("+(rec+1)+")_wformat : "+$("input[name='wformat']").val()+"\n";
				txt+="rec("+(rec+1)+")_protocol : "+$("input[name='protocol']").val()+"\n";

			}
			var txtName = "RPT02_"+$("input[name='net']").val()+"_"+$("input[name='obs_id']").val()+"_"+getToday().replace("-","").replace("-","");
// 			alert(txt);
			
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/sendReport.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: "${l_no}&"+txtName+"&"+txt,
		          success : function(data){
				      	if(data.resultDesc=="success")
				      	{
				      		alert("전송이 완료되었습니다.");
				      		
			          	}
		          } 
      		});
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="popup-tap-wrap">
		<ul class="tabs">
			<li rel="observatory-tab" class="active">관측소</li>
			<li rel="recorder-tab">기록계</li>
			<li rel="sensor-tab">센서</li>
		</ul>
		<div id="pop_wrap">
		  <section class="pop_topTit">
		    <h1>지진관측소 정보계측기 관리대장</h1>
		  </section>
		  <span style="float:right;margin-right:26px;">
		  	<c:if test="${stationInfo.l_status eq '6' or stationInfo.l_status eq '5'}">
		 	 <a href="#"><img src="<c:url value="/img/btt_save.png"/>" onclick="fnSaveSationInfo()" alt="전송"></a>
		 	</c:if>
<%-- 		  	<a href="#"><img src="<c:url value="/img/btt_pop_send.png"/>" onclick="fnTest()" alt="전송"></a> --%>
		  </span>
		</div>
		<div class="popup-info-container">
			<!-- 관측소 정보 영역 -->
			<div id="observatory-tab" class="tab-contrainer">
				<form id="station-form" name="station-form" enctype="multipart/form-data" action="${pageContext.request.contextPath}/system/observatory/insert" method="post">
					<input type="hidden" value="${stationInfo.sta_tmp2 }" name="sta_tmp2">
					<input type="hidden" value="${stationInfo.sta_no }" name="sta_no">
				  <section class="pop_body">
				    <h2>${stationInfo.obs_name } 관측소</h2>
				       <!--표 1-->
				             <article class="pop_table">
				              <table>
				                <caption>관측소 기본 정보</caption>
				                <colgroup>
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16%" />
		                            <col style="width:16%" />
				                </colgroup>
				                <thead>
				                  <tr>
<!-- 				                  <span style="float:right;margin-right:12px;"><button>저장</button></span> -->
				                    <th colspan="6">관측소 목록</th>
				                  </tr>
				                </thead>
				                <tbody>
				                   <tr>
				                    <th>관측소 코드</th>
				                    <td><input type="text" name="obs_id" value="${stationInfo.obs_id }"></td>
				                    <th>관측소명</th>
				                    <td><input type="text" name="obs_name" value="${stationInfo.obs_name }"></td>
				                    <th>소속기관</th>
				                    <td><input type="text" name="net" value="${stationInfo.net }"></td>
				                   </tr>
				                  <tr>
									<th>원전구분</th>
				                    <td><input type="text" name="sta_tmp1" value="${stationInfo.sta_tmp1 }"></td>				                  
				                    <th>관측소 주소</th>
				                    <td colspan="3"><input type="text" name="address" value="${stationInfo.address }"></td>
				                  </tr>
				                  <tr>
				                    <th>계약일자</th>
				                    <td><input type="text" name="contractdate" value="${stationInfo.contractdate }"></td>
				                    <th>준공일자</th>
				                    <td><input type="text" name="completedate" value="${stationInfo.completedate }"></td>
				                    <th>계약금액</th>
				                    <td><input type="text" name="price_contract" value="${stationInfo.price_contract }"></td>
				                  </tr>
				                  <tr>
				                    <th>소프트웨어 비용</th>
				                    <td><input type="text" name="price_sw" value="${stationInfo.price_sw }"></td>
				                    <th>계측장비 도입 비용</th>
				                    <td><input type="text" name="price_hw" value="${stationInfo.price_hw }"></td>
				                    <th>관측소 지역 코드</th>
				                    <td><input type="text" name="area" value="${stationInfo.area }"></td>
				                  </tr>					                  
				                  <tr>
				                    <th>관측 시작일</th>
				                    <td><input type="text" name="opendate" value="${stationInfo.opendate }"></td>
				                    <th>관측 종료일</th>
				                    <td><input type="text" name="offdate" value="${stationInfo.offdate }"></td>
				                    <th>시설물 종류</th>
				                    <td><input type="text" name="obs_kind" value="${stationInfo.obs_kind }"></td>
				                  </tr>
				                  <tr>
				                    <th>관측소 설치 위치</th>
				                    <td><input type="text" name="position" value="${stationInfo.position }"></td>
				                    <th>지상 높이</th>
				                    <td><input type="text" name="ground_ht" value="${stationInfo.ground_ht }"></td>
				                    <th>지하 높이</th>
				                    <td><input type="text" name="uground_ht" value="${stationInfo.uground_ht }"></td>
				                  </tr>				                  	
				                  <tr>
				                    <th>위도</th>
				                    <td><input type="text" name="lat" value="${stationInfo.lat }"></td>
				                    <th>경도</th>
				                    <td><input type="text" name="lon" value="${stationInfo.lon }"></td>
				                    <th>고도</th>
				                    <td><input type="text" name="altitude" value="${stationInfo.altitude }"></td>
				                  </tr>
				                  <tr>
				                    <th>기초 형식</th>
				                    <td><input type="text" name="base" value="${stationInfo.base }"></td>
				                    <th>구조물 형식</th>
				                    <td><input type="text" name="str_cd" value="${stationInfo.str_cd }"></td>
				                    <th>설계기준</th>
				                    <td><input type="text" name="seis_cd" value="${stationInfo.seis_cd }"></td>
				                  </tr>
				                  <tr>
				                    <th>지반 분류</th>
				                    <td><input type="text" name="ground" value="${stationInfo.ground }"></td>
				                    <th>주상도 여부</th>
				                    <td>
					                    <select name="hole" class="shot-select">
					                    	<c:if test="${stationInfo.hole eq 'Y'}">
					                    		<option value="Y" selected="selected">Y</option>
					                    		<option value="N">N</option>
					                    	</c:if>
											<c:if test="${stationInfo.hole ne 'Y'}">
					                    		<option value="Y">Y</option>
					                    		<option value="N" selected="selected">N</option>
					                    	</c:if>				                    	
					                    </select>
				                    </td>
				                    <th>내진설계 적용 여부</th>
				                    <td>
				                    	<select name="seis_ds" class="shot-select">
					                    	<c:if test="${stationInfo.seis_ds eq 'Y'}">
					                    		<option value="Y"selected="selected">Y</option>
					                    		<option value="N">N</option>
					                    	</c:if>
											<c:if test="${stationInfo.seis_ds ne 'Y'}">
					                    		<option value="Y">Y</option>
					                    		<option value="N" selected="selected">N</option>
					                    	</c:if>				                    	
					                    </select>
					                </td>
				                  </tr>
				                  <tr>
				                    <th>설계가속도</th>
				                    <td><input type="text" name="design_acc" value="${stationInfo.design_acc }"></td>
				                    <th>임계치</th>
				                    <td><input type="text" name="threshold_acc" value="${stationInfo.threshold_acc }"></td>
				                    <th>건물층수</th>
				                    <td><input type="text" name="build_floor" value="${stationInfo.build_floor }"></td>
				                  </tr>
				                  <tr>
				                    <th>지진구역</th>
				                    <td>
				                    	<select name="eq_area" class="shot-select">
					                    	<c:if test="${stationInfo.seis_ds eq '1'}">
					                    		<option value="Y" selected="selected">1</option>
					                    		<option value="N">2</option>
					                    	</c:if>
											<c:if test="${stationInfo.seis_ds ne '1'}">
					                    		<option value="Y">1</option>
					                    		<option value="N"selected="selected">2</option>
					                    	</c:if>				                    	
					                    </select>
					                </td>				                    
				                    <th>주상도이미지명</th>
				                    <td><input type="text" name="hole_map" value="${stationInfo.hole_map }"></td>
				                    <th>설치 업체명</th>
				                    <td><input type="text" name="charge" value="${stationInfo.charge }"></td>
				                  </tr>			
				                  <tr>
				                    <th>설치 업체 연락처</th>
				                    <td><input type="text" name="contact" value="${stationInfo.contact }"></td>
				                    <th>사용자 아이디</th>
				                    <td><input type="text" name="user_id" value="${stationInfo.user_id }"></td>
				                    <th>등록 일자</th>
				                    <td><input type="text" name="regdate" value="${stationInfo.regdate }"></td>
				                  </tr>			
				                  <tr>
				                    <th>sta_type</th>
				                    <td><input type="text" name="sta_type" value="${stationInfo.sta_type }"></td>
				                    <th>수신 관측소 IP 정보</th>
				                    <td colspan="3"><input type="text" name="sta_ip" value="${stationInfo.sta_ip }"></td>
				                  </tr>
<!-- 				                  <tr> -->
<!-- 				                  	<td colspan="6"> -->
<!-- 										<span onclick="fnAjaxTest()">저장</span> -->
<!-- 										<span onclick="fnSaveStationInfo()">저장</span> -->
<!-- 									</td> -->
<!-- 				                  </tr>				                  	                  	                  				                  						                  				                   -->
				                </tbody>
				              </table>
				            </article>

				    </section>
			    </form>
			</div>
			<!-- 레코더 정보 영역 -->
			<div id="recorder-tab" class="tab-contrainer">
			<form id="recorder-form">
			  <section class="pop_body">
			     <h2>${stationInfo.obs_name } 관측소</h2>
	<!-- 				            표2 -->
				 <span style="float:right;margin-right:26px;"><a href="#"><img src="<c:url value="/img/btt_hadd.png"/>" onclick="fnAddDataRow('recorder-table')" alt="목록"></a> </span>
	             <article class="pop_table" style="overflow:auto;max-height:511px;">
	             
	              <table>
	                <caption>지진기록계 정보</caption>
	                <thead>
	                
	                  <tr>
	                    <th colspan="12">레코더 목록</th>
	                  </tr>
	                </thead>
	                <tbody id="recorder-table">
	                   <tr chk="no">
	                   	<th></th>
	                    <th>기관코드</th>
	                    <th>관측소코드</th>
	                    <th>분류코드</th>
	                    <th>제조회사</th>
	                    <th>모델명</th>
	                    <th>시리얼 번호</th>
	                    <th>보증기간</th>
	                    <th>데이터포맷</th>
	                    <th>전송 프로토콜</th>
	                    <th>등록일자</th>
	                    <th></th>
	                  </tr>
	                  <c:if test="${recCnt < 1  }">
		              	<tr>
		              		
		              		<td>
		              			<input type="hidden" name="dataStatus" value="add">
		              			<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
		              			<input type="hidden" name="rec_tmp2" value="${stationInfo.sta_tmp2 }" readonly="readonly">
		              		</td>
		              		<td><input type="text" name="net" 	 value="${stationInfo.net }" readonly="readonly">	</td>
		                    <td><input type="text" name="obs_id" value="${stationInfo.obs_id }"  readonly="readonly" 	>	</td>
							<td><input type="text" name="rec_id" 	>	</td>
							<td><input type="text" name="rec_company">  	</td>
							<td><input type="text" name="rec_model"  >	</td>
							<td><input type="text" name="rec_serial" >	</td>
							<td><input type="text" name="warrenty" 	 >	</td>
							<td><input type="text" name="wformat" 	 >	</td>
							<td><input type="text" name="protocol"	 >	</td>
							<td><input type="text" name="regdate" vaild="false"	 readonly="readonly" >	</td>
							<td></td>
	                	</tr>
	                  </c:if>
	                  <c:forEach items="${recorderList }" var="rec">
		              	<tr>
		              		<td>
		              			<input type="hidden" name="dataStatus" value="data">
		              			<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
		              			<input type="hidden" name="rec_no" value="${rec.rec_no }" readonly="readonly">
		              			<input type="hidden" name="rec_tmp2" value="${stationInfo.sta_tmp2 }" readonly="readonly">
		              		</td>
		                    <td><input type="text" name="net" value="${rec.net }" readonly="readonly"></td>
							<td><input type="text" name="obs_id" value="${rec.obs_id }" readonly="readonly"></td>
							<td><input type="text" name="rec_id" value="${rec.rec_id }"></td>
							<td><input type="text" name="rec_company" value="${rec.rec_company }"></td>
							<td><input type="text" name="rec_model" value="${rec.rec_model }"></td>
							<td><input type="text" name="rec_serial" value="${rec.rec_serial }"></td>
							<td><input type="text" name="warrenty" value="${rec.warrenty }"></td>
							<td><input type="text" name="wformat" value="${rec.wformat }"></td>
							<td><input type="text" name="protocol" value="${rec.protocol }"></td>
							<td child="none"><input type="text" name="regdate" vaild="false" value="${rec.regdate }"></td>
							<td child="delete" style="width:40px;"><a href="#"><img src="<c:url value="/img/btt_dele.png"/>" onclick="fnDeleteSubList('${rec.rec_no}','recorder_data',this)" alt="목록"></a></td>
							
	                	</tr>
	                  </c:forEach>
	                </tbody>
	              </table>
	            </article>

			    </section>
			   </form>
			</div>
		<!-- 센서 정보 영역 -->
			<div id="sensor-tab" class="tab-contrainer">
			  <form id="sensor-form">
				  <section class="pop_body">
				    <h2>${stationInfo.obs_name } 관측소</h2>	
				    <span style="float:right;margin-right:26px;"><a href="#"><img src="<c:url value="/img/btt_hadd.png"/>" onclick="fnAddDataRow('sensor-table')" alt="목록"></a></span>	
					<article class="pop_table" style="overflow:auto;max-height:511px;">
		              <table style="width:2500px;">
		                <caption>지진기록계 정보</caption>
		                <thead>
		                  <tr>
		                    <th colspan="23">센서 정보</th>
		                  </tr>
		                </thead>
		                <tbody id="sensor-table">
							<tr chk="no">
								<th></th>
								<th>기관 코드</th>
								<th>관측소 코드</th>
								<th>센서 분류 코드</th>
								<th>설치 위치</th>
								<th>제조회사</th>
								<th>모델명</th>
								<th>시리얼 번호</th>
								<th>가속계 분류</th>
								<th>계측 용도 구분</th>
								<th>설치 층수 및 위치</th>
								<th>센서 채널 성분</th>
								<th>설치 경도</th>
								<th>설치 위도</th>
								<th>지진가속계 Z 성분 Response</th>
								<th>지진가속계 N 성분 Response</th>
								<th>지진가속계 E 성분 Response</th>
								<th>기록계 Z 성분 Sensitivity</th>
								<th>기록계 N 성분 Sensitivity</th>
								<th>기록계 E 성분 Sensitivity</th>
								<th>기록계 분류 코드</th>
								<th>등록일자</th>
								<th></th>
							</tr>
						  <c:if test="${senCnt < 1  }">
			              	<tr>
			                    <td>
			                    	<input type="hidden" name="dataStatus" 		value="add">
			                    	<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
			                    	<input type="hidden" name="sen_tmp2" value="${stationInfo.sta_tmp2 }" readonly="readonly">
			                    </td>
								<td><input type="hidden" name="net"		value="${stationInfo.net }"	readonly="readonly"></td>
								<td><input type="hidden" name="obs_id"	value="${stationInfo.obs_id }"	readonly="readonly"></td>
								<td><input type="hidden" name="sen_id"		></td>
								<td><input type="hidden" name="sen_location"	></td>
								<td><input type="hidden" name="sen_company"	></td>
								<td><input type="hidden" name="sen_model"	></td>
								<td><input type="hidden" name="sen_serial"	></td>
								<td><input type="hidden" name="sen_kind"	></td>
								<td><input type="hidden" name="sen_gubun"	></td>
			                    <td><input type="hidden" name="sen_position"></td>
								<td><input type="hidden" name="sen_channel"	></td>
								<td><input type="hidden" name="sen_lon"		></td>
								<td><input type="hidden" name="sen_lat"		></td>
								<td><input type="hidden" name="sen_z_resp"	></td>
								<td><input type="hidden" name="sen_n_resp"	></td>
								<td><input type="hidden" name="sen_e_resp"	></td>
								<td><input type="hidden" name="sen_z_sens"	></td>
								<td><input type="hidden" name="sen_n_sens"	></td>
								<td><input type="hidden" name="sen_e_sens"	></td>
								<td><input type="hidden" name="regdate" 	readonly="readonly"></td>	
								<td></td>													
		                	</tr>
		                  </c:if>
		                  <c:forEach items="${sensorList }" var="sen">
			              	<tr>
			              		<td>
			              			<input type="hidden" name="dataStatus" 		 value="data">
			              			<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
			              			<input type="hidden" name="sen_no" value="${sen.sen_no }" readonly="readonly">
			              			<input type="hidden" name="sen_tmp2" value="${stationInfo.sta_tmp2 }" readonly="readonly">
			              		</td>
			                    <td><input type="text" name="net" 		 value="${sen.net }" readonly="readonly"></td>
								<td><input type="text" name="obs_id"			 value="${sen.obs_id }" readonly="readonly"></td>
								<td><input type="text" name="sen_id"		 value="${sen.sen_id }"></td>
								<td><input type="text" name="sen_location"		 value="${sen.sen_location }"></td>
								<td><input type="text" name="sen_company" value="${sen.sen_company }"></td>
								<td><input type="text" name="sen_model"	 value="${sen.sen_model }"></td>
								<td><input type="text" name="sen_serial"	 value="${sen.sen_serial }"></td>
								<td><input type="text" name="sen_kind"	 value="${sen.sen_kind }"></td>
								<td><input type="text" name="sen_gubun"	 value="${sen.sen_gubun }"></td>
								<td><input type="text" name="sen_position"	 value="${sen.sen_position }"></td>
			                    <td><input type="text" name="sen_channel" value="${sen.sen_channel }"></td>
								<td><input type="text" name="sen_lon"	 value="${sen.sen_lon }"></td>
								<td><input type="text" name="sen_lat"		 value="${sen.sen_lat }"></td>
								<td><input type="text" name="sen_z_resp"		 value="${sen.sen_z_resp }"></td>
								<td><input type="text" name="sen_n_resp"	 value="${sen.sen_n_resp }"></td>
								<td><input type="text" name="sen_e_resp"	 value="${sen.sen_e_resp }"></td>
								<td><input type="text" name="sen_z_sens"	 value="${sen.sen_z_sens }"></td>
								<td><input type="text" name="sen_n_sens"	 value="${sen.sen_n_sens }"></td>
								<td><input type="text" name="sen_e_sens"	 value="${sen.sen_e_sens }"></td>
								<td><input type="text" name="sen_rec_id"	 value="${sen.sen_rec_id }"></td>
								<td><input type="text" name="regdate"  vaild="false"	 value="${sen.regdate }"></td>
								<td child="delete" style="width:40px;"><a href="#"><img src="<c:url value="/img/btt_dele.png"/>" onclick="fnDeleteSubList('${sen.sen_no}','sensor_data',this)" alt="목록"></a></td>
		                	</tr>
		                  </c:forEach>
		                  
		                </tbody>
		              </table>
		            </article>
		           </section> 
		        </form>        
			</div>	
		</div>		
	</div>
</body>
</html>
