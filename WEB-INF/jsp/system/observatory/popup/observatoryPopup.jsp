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
	<script src="<c:url value="/js/jquery/jquery.form.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	
	<script src="<c:url value="/js/css/common.js"/>"></script>
	<script src="<c:url value="/js/nms/html2canvas.js"/>"></script>
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
	 	.view_img{
			width: 80%;
			height: 80%;
			border: 2px solid;
			position: absolute;
			z-index: 999;
			left: 10%;
			top: 10%;
			display:none;	 	
	 	}
	 	.view_img img{
	 		width:100%;
	 		height:100%;
	 	}
	</style>
	<script>
		var observatoryImgObj = new Image();
		var fileObj = "";
		var subIdx=0;
		var subType="rec";
		
		var image = "";
		var image2 = "";
		var image3 = "";
		$(document).ready(function(){
			$(".popup-info-container div:first").show();
// 			modyFormdata()

			$("#recorder-table,#sensor-table").children("tr").each(function(){
				if($(this).attr("chk")!="no"){
					$(this).children("td").each(function(){
// 						console.log($(this).html());
						$(this).children().attr("onChange","modyFormdata(this)");
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
		        if(activeTab == "observatory-tab"){
		        	$("#head_title").html("관측소 정보");
		        }else if(activeTab == "recorder-tab"){
		        	$("#head_title").html("기록계 정보");
		        }else{
		        	$("#head_title").html("센서 정보");
		        }
		        $("#" + activeTab).fadeIn();
		    });
		    /* 탭 이벤트 종료 */
		    
			/* 이미지 처리 관련 */
			$(".profileImg").click(function(){
// 				$("#"+$(this).attr("inputId")).trigger("click");
				$(".view_img img").attr("src",$(this).attr("src"));
				$(".view_img").show();
			});
			
		});
		
		function fnDetailStationInfo(staNo){
		}
		function fnSaveStationInfo(){
// 			if(!validationCheck("station-form")){
// 				alert("빈 값이 존재합니다."); 
// 				return false;
// 			}
// 			console.log($("#station-form").serialize()+"&status=${status}");
			var jsonStr = formSerializeToJsonStr($("#station-form").serialize()+"&status=${status}&sta_no=${sta_no}","one");
			var url = "${pageContext.request.contextPath}/system/observatory/insert.ws";
// 			var formData = new FormData($("#station-form"));

			console.log(jsonStr);
			if('${status}'=="new"){
				url="${pageContext.request.contextPath}/system/observatory/insert.ws";
			}else{
				url="${pageContext.request.contextPath}/system/observatory/update.ws";
			}
			
		    $.ajax({
		          url: url,
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jsonStr,
		          success : function(data){
		           //입력 및 수정 후처리
// 		          	alert(data.resultDesc);
		        	if(data.resultDesc=="success"){
// 		        		alert("입력력되었습니다.");
						$("#station-img-form").ajaxSubmit({
							success : function(data) {
								console.log(data);
								if(data=="success"){
									alert("입력 완료되었습니다.");	
									window.location.reload();
								}
							},
							error : function(error) {
								alert("요청 처리 중 오류가 발생하였습니다.");
							}
						});
							
					}else{
						alert("오류가 하였습니다.");
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
// 			alert(table);//recorder-table , sensor-table
			var tr = $("#"+table).children("tr").eq(1);
			var tdCnt = tr.children("td").length;
			var append = "<tr mody='new' onclick='fnSelectAttribute(this,"+(table=="recorder-table"?"\"recorder\"":"\"sensor\"")+")'>";
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
				url = "${pageContext.request.contextPath}/system/observatory/recorderInsert.ws";
			}else{
				url = "${pageContext.request.contextPath}/system/observatory/sensorInsert.ws";
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
			      		alert("입력되었습니다.");
			      		window.location.reload();
		          	}
		          }
		           
        	});
		}
		function fnDeleteSubList(idx,type,obj)
		{	
			event.stopPropagation();
			if(type.indexOf("recorder")>-1){
				url = "${pageContext.request.contextPath}/system/observatory/recorderDelete.ws";
			}else{
				url = "${pageContext.request.contextPath}/system/observatory/sensorDelete.ws";
			}
			var tr = $(obj).parent().parent().parent();
			var trLength = tr.parent().children("tr").length;
			if(tr.attr("mody")=="new" && trLength == 2)
			{
				alert("삭제할 수 없습니다.");
			}else{
				if(tr.attr("mody")!="new"){
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
						      		alert("삭제하였습니다.");
									if(trLength == 2){
										window.location.reload();
									}
					          	}
				          } 
		        	});
				}
				tr.remove();
			}
// 			else if(type=="list")
// 			{
// 				alert("삭제 라인");
// 			}
		}
		function fnSelectAttribute(obj,type){
			var sendType="";
			if($(obj).attr("mody")!="new"){
				if(type=="sensor"){
					subIdx = $(obj).children("td").eq(0).children("input[name='sen_no']").val();
					subType="sensor";
					sendType = "sen";
				}else{
					subIdx = $(obj).children("td").eq(0).children("input[name='rec_no']").val();
					sendType = "rec";
					subType="recorder";
				}
			    $.ajax({
			          url: "${pageContext.request.contextPath}/system/observatory/getImages.ws",
			          type: "POST",
			          dataType: 'json',
			          contentType: "application/json; charset=utf-8",
			          data: subIdx+"&"+sendType,
			          success : function(data){
			        	  	console.log(data.resultDesc);
			        	  	console.log(data.data);
					      	if(data.resultDesc=="sen")
					      	{
					      		$("#sen_pic1").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.sen_pic1);
					      		$("#sen_pic2").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.sen_pic2);
					      		$("#sen_pic3").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.sen_pic3);
					      		$("#sen_pic4").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.sen_pic4);
				          	}
					      	else
					      	{
					      		$("#rec_pic1").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.rec_pic1);
					      		$("#rec_pic2").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.rec_pic2);
					      		$("#rec_pic3").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.rec_pic3);
					      		$("#rec_pic4").attr("src","${pageContext.request.contextPath}/images/observatory/"+data.data.rec_pic4);
					      	}
					   
			          } 
	        	});
			}else{
// 				alert("new");
				if(type=="sensor"){
					subType="sensor";
		      		$("#sen_pic1").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
		      		$("#sen_pic2").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
		      		$("#sen_pic3").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
		      		$("#sen_pic4").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
				}else{
					subType="recorder";
		      		$("#rec_pic1").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
		      		$("#rec_pic2").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
		      		$("#rec_pic3").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
		      		$("#rec_pic4").attr("src","${pageContext.request.contextPath}/images/observatory/m_bg.jpg");
				}
				subIdx = 0;
			}
		}
		function fnSaveImage(type){
			if(subType!=type){
				alert("저장하려는 "+type+" 값을 선택해주세요.");
				return false;
			}else if(subIdx==0){
				alert("해당 정보를 먼저 입력한 뒤 업로드해주세요.");
			}
			var sendType = (type=="sensor"?"sen":"rec");
			 $.ajax({
		          url: "${pageContext.request.contextPath}/system/observatory/setValue.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: subIdx+"&"+sendType,
		          success : function(data){
				  		$("#"+subType+"-img-form").ajaxSubmit({
							success : function(data) {
								console.log(data);
								if(data=="success"){
									alert("완료되었습니다.");	
									window.location.reload();
								}
							},
							error : function(error) {
								alert("요청 처리 중 오류가 발생하였습니다.");
							}
						});
		          } 
       	});
		}
		function fnCloseViewImg()
		{
			$(".view_img").hide();
		}
		function fnStationMaintenance(no){
			if(confirm("점검내용을 입력하시겠습니까?")){
				var pmt = prompt("점검내용을 입력해주세요.");
				var pdate = prompt("점검 일자를 입력해주세요.\n (예 - 2017-01-01)");
					//alert(pmt);
				if(typeof pmt == 'null' || pmt == '' || pmt == null ){
					alert("점검 내역을 입력해주세요.");
					return false;
				}
				if(typeof pdate == 'null' || pdate == '' || pdate == null ){
					alert("점검 일자를 입력해주세요.");
					return false;
				}
				var msg = "sta&"+no+"&"+pmt+"&"+pdate;
				$.ajax({
		          url: "${pageContext.request.contextPath}/system/observatory/insertMaintenance.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: msg,
		          success : function(data){
		        	  console.log(data);
		        	  if(data.resultDesc =="success"){
		        		  alert("점검 내용을 입력하였습니다.");
		        	  }else{
		        		  alert("점검 내용의 입력에 실패하였습니다.");
		        	  }
		          } 
	       		});
			}
		}
		function fnMaintenanceSubList(no,type,obj){
			event.stopPropagation();
			var tr = $(obj).parent().parent().parent();
			if(tr.attr("mody")=="new"){
				alert("데이터를 먼저 저장해주세요");
			}else{
				if(confirm("점검내용을 입력하시겠습니까?")){
					var pmt = prompt("점검내용을 입력해주세요.");
					var pdate = prompt("점검 일자를 입력해주세요.\n (예 - 2017-01-01)");
					if(typeof pmt == 'null' || pmt == null || compactTrim(pmt) == ""){
						alert("점검 내역을 입력해주세요.");
						return false;
					}
					if(typeof pdate == 'null' || pdate == '' || pdate == null ){
						alert("점검 일자를 입력해주세요.");
						return false;
					}
					var msg = type+"&"+no+"&"+pmt+"&"+pdate;
					$.ajax({
			          url: "${pageContext.request.contextPath}/system/observatory/insertMaintenance.ws",
			          type: "POST",
			          dataType: 'json',
			          contentType: "application/json; charset=utf-8",
			          data: msg,
			          success : function(data){
			        	  console.log(data);
			        	  if(data.resultDesc =="success"){
			        		  alert("점검 내용을 입력하였습니다.");
			        	  }else{
			        		  alert("점검 내용의 입력에 실패하였습니다.");
			        	  }
			          } 
		       		});
				}
			}
		}
		function fnExcelDownload(){
			alert("엑셀 다운로드를 시작합니다. \n완료될때까지 기다려주세요.");
			$("input[type='file']").hide();
			
			//observatory-tab
			$("#recorder-tab").show();
			$("#sensor-tab").show();
			
			//return false;

			
			html2canvas($('#st_img'), {
                onrendered: function(canvas) {
                    if (typeof FlashCanvas != "undefined") {
                        FlashCanvas.initElement(canvas);
                    }
                    image = canvas.toDataURL("image/png");
                    $("#imgData").val(image);
                }
            });		

			html2canvas($('#rc_img'), {
                onrendered: function(canvas) {
                    if (typeof FlashCanvas != "undefined") {
                        FlashCanvas.initElement(canvas);
                    }
                    image2 = canvas.toDataURL("image/png");
                    $("#imgData2").val(image2);
                }
            });		

			html2canvas($('#sn_img'), {
                onrendered: function(canvas) {
                    if (typeof FlashCanvas != "undefined") {
                        FlashCanvas.initElement(canvas);
                    }
                    image3 = canvas.toDataURL("image/png");
                    $("#imgData3").val(image3);
                }
            });		
			setTimeout(function(){
				$("#imgData").val(image);
				$("#imgData2").val(image2);
				$("#imgData3").val(image3);
				$(".search-form").attr('action','${pageContext.request.contextPath}/system/observatory/getStationExcel.do').submit();
				$("input[type='file']").show();
				$("#recorder-tab").hide();
				$("#sensor-tab").hide();
			},5000);
// 			alert("엑셀 다운로드가 완료되기 전까지 화면의 조작을 멈춰주세요.");
			
			
			
						
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<form class="search-form" name="searchForm" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" id="imgData" name="imgData" />
	<input type="hidden" id="imgData2" name="imgData2" />
	<input type="hidden" id="imgData3" name="imgData3" />
	<input type="hidden" id="" name="type" value="station" />
	<input type="hidden" id="sta_no" name="sta_no" value='${param.sta_no }'/>
</form>
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="view_img">
		<img alt="" src="" onclick="fnCloseViewImg()">
	</div>
	<div class="popup-tap-wrap">
		<c:if test="${status eq 'mody'}">
		<ul class="tabs">
			<li rel="observatory-tab" class="active">관측소</li>
			<li rel="recorder-tab">기록계</li>
			<li rel="sensor-tab">센서</li>
		</ul>
		</c:if>
		<div id="pop_wrap">
		  <section class="pop_topTit">
		    <h1 id="head_title">관측소 정보</h1>
		  </section>
		</div>
		<div class="popup-info-container">
			<!-- 관측소 정보 영역 -->
			<div id="observatory-tab" class="tab-contrainer">
				  <section class="pop_body">
				    <h2>${stationInfo.obs_name } 관측소</h2>
				    <span style="float:right;margin-right:26px;"><a href="#"  onclick="fnSaveStationInfo()"><img style="width:109px;" src="<c:url value="/img/btt_note_save.png"/>" alt="점검"></a></span>
				    <c:if test="${status eq 'mody'}">
					    <span style="float:right;margin-right:12px;"><a href="#"  onclick="fnExcelDownload()"><img src="<c:url value="/img/btt_exell_down.png"/>" alt="엑셀"></a></span>
					    <span style="float:right;margin-right:12px;"><a href="#"  onclick="fnStationMaintenance(${stationInfo.sta_no})"><img src="<c:url value="/img/btt_check.png"/>" alt="점검"></a></span>
				    </c:if>
				       <!--표 1-->
				            <article class="pop_table">
							<form id="station-form" name="station-form" enctype="multipart/form-data" action="${pageContext.request.contextPath}/system/observatory/insert" method="post">
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
					                    		<option selected="selected">Y</option>
					                    		<option>N</option>
					                    	</c:if>
											<c:if test="${stationInfo.hole ne 'Y'}">
					                    		<option>Y</option>
					                    		<option selected="selected">N</option>
					                    	</c:if>				                    	
					                    </select>
				                    </td>
				                    <th>내진설계 적용 여부</th>
				                    <td>
				                    	<select name="seis_ds" class="shot-select">
					                    	<c:if test="${stationInfo.seis_ds eq 'Y'}">
					                    		<option selected="selected">Y</option>
					                    		<option>N</option>
					                    	</c:if>
											<c:if test="${stationInfo.seis_ds ne 'Y'}">
					                    		<option>Y</option>
					                    		<option selected="selected">N</option>
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
					                    		<option selected="selected">1</option>
					                    		<option>2</option>
					                    	</c:if>
											<c:if test="${stationInfo.seis_ds ne '1'}">
					                    		<option>1</option>
					                    		<option selected="selected">2</option>
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
				              </form>
				            </article>
				            
				            <!--표4-->
			             <article class="pop_table">
			             	<form id="station-img-form" action="${pageContext.request.contextPath}/system/observatory/fileUpload.ws" method="post" enctype="multipart/form-data">
				              <table style="height:200px;">
				                <caption>지진기록계 정보</caption>
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
				                    <th colspan="4">관측소 사진 정보</th>
				                  </tr>
				                </thead>
				                <tbody>
				                  <tr>
				                    <td class="downImgBox" id="st_img">
				                      <!--S:사진 이미지-->
				                      <ul>
				                        <li>
				                        	<img id="sta_pic1" inputId="sta_pic1" class="profileImg" style="width:100%;height:100%;" src="<c:url value="/images/observatory/${sta_pic1 }"/>" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
				                        	<input name="sta_pic1" type="file" style="" accept=".jpg, .png">
				                        </li>
				                        <li>
				                        	<img id="sta_pic2" inputId="sta_pic2" class="profileImg" style="width:100%;height:100%;" src="<c:url value="/images/observatory/${sta_pic2 }"/>" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
				                        	<input name="sta_pic2" type="file" style="" accept=".jpg, .png" >
				                        </li>
				                        <li>
				                        	<img id="sta_pic3" inputId="sta_pic3" class="profileImg" style="width:100%;height:100%;" src="<c:url value="/images/observatory/${sta_pic3 }"/>" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
				                        	<input name="sta_pic3" type="file" style=""  accept=".jpg, .png">
				                        </li>
				                        <li>
				                        	<img id="sta_pic4" inputId="sta_pic4" class="profileImg" style="width:100%;height:100%;" src="<c:url value="/images/observatory/${sta_pic4 }"/>" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
				                        	<input name="sta_pic4" type="file"  style="" accept=".jpg, .png">
				                        </li>                   
				                      </ul>
				                      <!--//E:사진 이미지-->
				                    </td>
				                  </tr>				                
				                </tbody>
				              </table>
				             </form>
			            </article>
				    </section>
			</div>
			<!-- 레코더 정보 영역 -->
			<div id="recorder-tab" class="tab-contrainer">
			  <section class="pop_body">
			     <h2>${stationInfo.obs_name } 관측소</h2>
	<!-- 				            표2 -->
				 <span style="float:right;margin-right:26px;"><a href="#"><img src="<c:url value="/img/btt_hadd.png"/>" onclick="fnAddDataRow('recorder-table')" alt="목록"></a> <a href="#"  onclick="fnSaveSubAttribute('recorder-table','record')"><img src="<c:url value="/img/btt_save.png"/>" alt="목록"></a></span>
	             <article class="pop_table" style="overflow:auto;max-height:511px;">
	             
				  <form id="recorder-form">
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
		              	<tr mody="new" onclick="fnSelectAttribute(this,'recorder')" sta_no="${stationInfo.sta_no }">
		              		
		              		<td>
		              			<input type="hidden" name="dataStatus" value="add">
		              			<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
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
							<td child="delete" style="width:40px;">
								<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_check.png"/>" onclick="fnMaintenanceSubList('${rec.rec_no}','rec',this)" alt="목록"></a>
								<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_del_large.png"/>" onclick="fnDeleteSubList('${rec.rec_no}','recorder_data',this)" alt="목록"></a>
							</td>
	                	</tr>
	                  </c:if>
	                  <c:forEach items="${recorderList }" var="rec">
		              	<tr onclick="fnSelectAttribute(this,'recorder')" sta_no="${stationInfo.sta_no }">
		              		<td>
		              			<input type="hidden" name="dataStatus" value="data">
		              			<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
		              			<input type="hidden" name="rec_no" value="${rec.rec_no }" readonly="readonly">
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
							<td child="delete" style="width:40px;">
								<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_check.png"/>" onclick="fnMaintenanceSubList('${rec.rec_no}','rec',this)" alt="목록"></a>
								<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_del_large.png"/>" onclick="fnDeleteSubList('${rec.rec_no}','recorder_data',this)" alt="목록"></a>
							</td>
							
	                	</tr>
	                  </c:forEach>
	                </tbody>
	              </table>
	              </form>
	            </article>
		         <br><br><br>   
		         <!--표4-->
		         <span style="float:right;margin-right:26px;"><a href="#"  onclick="fnSaveImage('recorder')"><img src="<c:url value="/img/btt_save.png"/>" alt="목록"></a></span>
	             <article class="pop_table">
	             	<form id="recorder-img-form" action="${pageContext.request.contextPath}/system/observatory/fileUpload.ws" method="post" enctype="multipart/form-data">
		              <table style="height:200px;">
		                <caption>지진기록계 정보</caption>
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
		                    <th>레코더 사진 정보</th>
		                  </tr>
		                </thead>
		                <tbody>
		                  <tr>
		                    <td class="downImgBox" id="rc_img">
		                      <!--S:사진 이미지-->
		                      <ul>
		                        <li>
		                        	<img id="rec_pic1" inputId="rec_pic1" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
		                        	<input name="rec_pic1" type="file" style="" accept=".jpg, .png">
		                        </li>
		                        <li>
		                        	<img id="rec_pic2" inputId="rec_pic2" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
		                        	<input name="rec_pic2" type="file" style="" accept=".jpg, .png" >
		                        </li>
		                        <li>
		                        	<img id="rec_pic3" inputId="rec_pic3" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
		                        	<input name="rec_pic3" type="file" style=""  accept=".jpg, .png">
		                        </li>
		                        <li>
		                        	<img id="rec_pic4" inputId="rec_pic4" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
		                        	<input name="rec_pic4" type="file"  style="" accept=".jpg, .png">
		                        </li>                   
		                      </ul>
		                      <!--//E:사진 이미지-->
		                    </td>
		                  </tr>
		                </tbody>
		              </table>
		            </form>
	           	 </article>
			    </section>
			   
			</div>
		<!-- 센서 정보 영역 -->
			<div id="sensor-tab" class="tab-contrainer">
				  <section class="pop_body">
				    <h2>${stationInfo.obs_name } 관측소</h2>	
				    <span style="float:right;margin-right:26px;"><a href="#"><img src="<c:url value="/img/btt_hadd.png"/>" onclick="fnAddDataRow('sensor-table')" alt="목록"></a> <a href="#"  onclick="fnSaveSubAttribute('sensor-table','sensor')"><img src="<c:url value="/img/btt_save.png"/>" alt="목록"></a></span>	
					<article class="pop_table" style="overflow:auto;max-height:511px;">
					  <form id="sensor-form">
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
			              	<tr  mody="new" onclick="fnSelectAttribute(this,'sensor')" sta_no="${stationInfo.sta_no }">
			                    <td>
			                    	<input type="hidden" name="dataStatus" 		value="add">
			                    	<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
			                    </td>
								<td><input type="text" name="net"		value="${stationInfo.net }"	readonly="readonly"></td>
								<td><input type="text" name="obs_id"	value="${stationInfo.obs_id }"	readonly="readonly"></td>
								<td><input type="text" name="sen_id"		></td>
								<td><input type="text" name="sen_location"	></td>
								<td><input type="text" name="sen_company"	></td>
								<td><input type="text" name="sen_model"	></td>
								<td><input type="text" name="sen_serial"	></td>
								<td><input type="text" name="sen_kind"	></td>
								<td><input type="text" name="sen_gubun"	></td>
			                    <td><input type="text" name="sen_position"></td>
								<td><input type="text" name="sen_channel"	></td>
								<td><input type="text" name="sen_lon"		></td>
								<td><input type="text" name="sen_lat"		></td>
								<td><input type="text" name="sen_z_resp"	></td>
								<td><input type="text" name="sen_n_resp"	></td>
								<td><input type="text" name="sen_e_resp"	></td>
								<td><input type="text" name="sen_z_sens"	></td>
								<td><input type="text" name="sen_n_sens"	></td>
								<td><input type="text" name="sen_e_sens"	></td>
								<td><input type="text" name="regdate" 	readonly="readonly"></td>	
								<td child="delete" style="width:40px;">
									<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_check.png"/>" onclick="fnMaintenanceSubList('${sen.sen_no}','sen',this)" alt="목록"></a>
									<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_del_large.png"/>" onclick="fnDeleteSubList('${sen.sen_no}','sensor_data',this)" alt="목록"></a>
								</td>												
		                	</tr>
		                  </c:if>
		                  <c:forEach items="${sensorList }" var="sen">
			              	<tr onclick="fnSelectAttribute(this,'sensor')" sta_no="${stationInfo.sta_no }">
			              		<td>
			              			<input type="hidden" name="dataStatus" 		 value="data">
			              			<input type="hidden" name="sta_no" value="${stationInfo.sta_no }" readonly="readonly">
			              			<input type="hidden" name="sen_no" value="${sen.sen_no }" readonly="readonly">
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
								<td child="delete" style="width:40px;">
									<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_check.png"/>" onclick="fnMaintenanceSubList('${sen.sen_no}','sen',this)" alt="목록"></a>
									<a href="#"><img style="width:40px;" src="<c:url value="/img/btt_del_large.png"/>" onclick="fnDeleteSubList('${sen.sen_no}','sensor_data',this)" alt="목록"></a>
								</td>
		                	</tr>
		                  </c:forEach>
		                  
		                </tbody>
		              </table>
		              </form>
		            </article>
		            
		            <span style="float:right;margin-right:26px;"><a href="#"  onclick="fnSaveImage('sensor')"><img src="<c:url value="/img/btt_save.png"/>" alt="목록"></a></span>
		            <!--표4-->
		             <article class="pop_table">
		             	<form id="sensor-img-form" action="${pageContext.request.contextPath}/system/observatory/fileUpload.ws" method="post" enctype="multipart/form-data">
			              <table style="height:200px;">
			                <caption>지진기록계 정보</caption>
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
			                    <th>관측소 사진 정보</th>
			                  </tr>
			                </thead>
			                <tbody>
			                  <tr>
			                    <td class="downImgBox" id="sn_img">
			                      <!--S:사진 이미지-->
			                      <ul>
			                        <li>
			                        	<img id="sen_pic1" inputId="sen_pic1" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
			                        	<input name="sen_pic1" type="file" style="" accept=".jpg, .png">
			                        </li>
			                        <li>
			                        	<img id="sen_pic2" inputId="sen_pic2" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
			                        	<input  name="sen_pic2" type="file" style="" accept=".jpg, .png" >
			                        </li>
			                        <li>
			                        	<img id="sen_pic3" inputId="sen_pic3" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
			                        	<input  name="sen_pic3" type="file" style=""  accept=".jpg, .png">
			                        </li>
			                        <li>
			                        	<img id="sen_pic4" inputId="sen_pic4" class="profileImg" style="width:100%;height:100%;" src="" onerror="this.src='<c:url value="/img/m_bg.jpg"/>'" >
			                        	<input  name="sen_pic4" type="file"  style="" accept=".jpg, .png">
			                        </li>                   
			                      </ul>
			                      <!--//E:사진 이미지-->
			                    </td>
			                  </tr>
			                </tbody>
			              </table>
				        </form>        
		           	 </article>
		           </section> 
			</div>	
		</div>		
	</div>
</body>
</html>
