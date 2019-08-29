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
	<script src="<c:url value="/js/nms/html2canvas.js"/>"></script>
	
	<script src="<c:url value="/js/jquery/jquery.flot_wave.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.flot.time.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.flot.axislabels.js"/>"></script>	
	<link href="<c:url value="/css/wave_mapicons.css"/>" rel="stylesheet" type="text/css" />
	
	<script src="<c:url value="/js/css/common.js"/>"></script>
	
	<title>한국수력원자력::모니터링 소프트웨어</title>
	<style>
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
	 	.pop_table tbody td{
	 	    border: 1px solid #e2e2e2;
	 	}
	 	.pop_table tbody th{
	 	    border: 1px solid #e2e2e2;
	 	}	 	
	 	td{
	 		height:20px;
	 		font-size:10px;
	 	}
	</style>
<!-- 	프린트용 -->
	<style type="text/css" media="print">
		.test-1{
			display:block;
		}
		#excel-down{
			display:none;
		}
		@page{  size:auto; margin : 2mm;  }
		
	</style>
	<script>
		var baseLat = 35.49;
		var baseLon = 129.15;

		obsType=null;
		sta_type=null;
		timer1=null;
		timer2=null;
		stationInfos=null;
		station=null;
		mapType = 'AL';
		
		var image="";
		var image2="";
		
		var options = {
				series: {
					shadowSize: 0,	// Drawing is faster without shadows
					show:true,
					showLine:false
				},
// 				yaxis:{
// 					autoscaleMargin:1
// // 					tickDecimals:1
// 				},
				lines:{
					show:true
				},
				autoscale : false,
				legend: {backgroundColor:"#ffffff"}
			};
		$(document).ready(function(){
			
		    var beforePrint = function() {
		        console.log('Functionality to run before printing.');
// 		        alert("test");
		    };
		    var afterPrint = function() {
		        console.log('Functionality to run after printing');
		    };
		  
		    if (window.matchMedia) {
		        var mediaQueryList = window.matchMedia('print');
		        mediaQueryList.addListener(function(mql) {
		            if (mql.matches) {
		                beforePrint();
		            } else {
		                afterPrint();
		            }
		        });
		    }
		  
		    window.onbeforeprint = beforePrint;
		    window.onafterprint = afterPrint;
			
			$(".popup-info-container div:first").show();
// 			$("#mainArea").html('${mainData.area}' + ' ' + direction(baseLat,baseLon,'${mainData.lat}','${mainData.lon}') + '  '+ '${mainData.kmeter}' + ' km 지역');
			$("#mainArea").html('${mainData.area}' + ' 지역');
			
// 			console.log(calculateDistance2(baseLat,baseLon,34.48,126.49));
			if('${param.type}' != "NC"){
				$("#four_title").html("3. 최근 지진 현황");
			}
			 $("ul.tabs li").click(function () {
			        $("ul.tabs li").removeClass("active").css("color", "#333");
			        //$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
			        $(this).addClass("active");//.css("color", "darkred");
			        $(".tab-contrainer").hide();
			        var activeTab = $(this).attr("rel");
			        if(activeTab=="wave-report-tab"){
			        	switchPrograss();
			        	getWaveGraphData(activeTab,"g1");
			        }else if(activeTab=="wave-report2-tab"){
			        	switchPrograss();
			        	getWaveGraphData(activeTab,"g2");
			        }else{
			        	$("#" + activeTab).fadeIn();
			        }
			 });
			 
// 			 $(".stations").each(function(i,v){
// 				var top_data = fnCalTopToSimpleWave(Number($(this).attr("lat")));
// 				var left_data = fnCalleftToSimpleWave(Number($(this).attr("lon")));
				
// 				fnSetMapIcon(document.getElementById("map_layout"),left_data,top_data,'AL','blue');
// 			 });
			 
// 			var top_data = fnCalTopToSimpleWave(Number('${mainData.lat}'));
// 			var left_data = fnCalleftToSimpleWave(Number('${mainData.lon}'));
			
			
// 			fnSetMapIcon(document.getElementById("map_layout"),left_data,top_data,'AL','red');
			
			if('${param.type}'=="NC"){
				getWaveGraphData();
			}
			
		});
		function switchPrograss(){
			if($("#prograss-bar").css("display")=="none"){
				$("#prograss-bar").show();
	        	$("#prograss-bar-background").show();
			}else{
				$("#prograss-bar").hide();
	        	$("#prograss-bar-background").hide();
			}
		}
		function getWaveGraphData(){
			var sch_data = {};
			
			sch_data["org_type"] = $("#org_type").val();
			sch_data["lat"] =  '${mainData.lat}';
			sch_data["lon"] =  '${mainData.lon}';
			sch_data["time_data"] =  '${req_date}';
			sch_data["path1"] =  '${req_id}';
			sch_data["pop_type"] =  'wave';
			
			
			
			post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakeSimplePopupData.ws', JSON.stringify(sch_data), 
			function(response){
				//success
				console.log(response.data);
				var list = response.data;
				var mob = list.length % 2;
				var bodyTxt = "<tr>";
				var imgTd = "";
				var graphTd = "";
				var imgTdTitle = "";
				var graphTdTitle = "";
				//<div id="charts_ac100_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
				for(var i=0;i<list.length;i++){
					graphTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
					imgTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
					graphTd += "<td>";
					graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_z_"+list[i].obs_id+"'></div>";
					graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_n_"+list[i].obs_id+"'></div>";
					graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_e_"+list[i].obs_id+"'></div>";
					graphTd += "</td>";
					imgTd += "<td><img style='width:200px;height:135px;' id='img_"+list[i].obs_id+"'></td>";
					
					if((i+1)%2==0){
						bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
						graphTd = "";
						imgTd = "";
						graphTdTitle ="";
						imgTdTitle = "";
						if(i < list.length){
							bodyTxt += "<tr>";
						}
					}
				}
				if(mob > 0){
					graphTdTitle += "<th style='height:30px;'>-</th>";
					imgTdTitle += "<th style='height:30px;'>-</th>";					
					graphTd += "<td></td>";
					imgTd += "<td></td>";
					bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
				}
				$("#simple_graph").html(bodyTxt);
				for(var i=0;i<list.length;i++){
					/*
						데이터 행수에 따라 화면을 구성하여 집어넣는다.
					*/
					if(list[i].ac100_z != null){
						parseJSONObject(list[i].ac100_z,"#charts_ac100_z_"+list[i].obs_id);
					}
					if(list[i].ac100_n != null){
						parseJSONObject(list[i].ac100_n,"#charts_ac100_n_"+list[i].obs_id);
					}
					if(list[i].ac100_e != null){
						parseJSONObject(list[i].ac100_e,"#charts_ac100_e_"+list[i].obs_id);
					}
// 					parseJSONObject(list[i].sp100_z,"#charts_sp100_z_"+list[i].obs_id);
// 					parseJSONObject(list[i].sp100_n,"#charts_sp100_n_"+list[i].obs_id);
// 					parseJSONObject(list[i].sp100_e,"#charts_sp100_e_"+list[i].obs_id);
					
					$("#img_"+list[i].obs_id).attr("src","/customImgPath"+list[i].image_path);
					
				}

				
				$(".flot-overlay").css("width","200px");
				$(".flot-overlay").css("height","35px");
				$(".flot-base").css("width","200px");
				$(".flot-base").css("height","35px");
				
//	 				#simple_graph
				html2canvas($('#simple_graph'), {
	                onrendered: function(canvas) {
	                    if (typeof FlashCanvas != "undefined") {
	                        FlashCanvas.initElement(canvas);
	                    }
	                    image2 = canvas.toDataURL("image/png");
	                    $("#imgData2").val(image2);
	                }
	            });					
				
			}, fnError);
			
			
		}
		function parseJSONObject(data,id){
			if(data.indexOf("Error")==-1){
				var obj = JSON.parse(data);
				drawGraph(obj[0].data[0].values,id);
			}
		}
		function drawGraph(data,chart){
			var dd = [];
			for(var j=0;j<data.length;j++){
				dd.push([j,data[j]]);
			}
			var dataset = [{
					data: dd,color:'blue',label:'abc'
				}];		
			$.plot($(chart), dataset,options);
			    	
		}
		function fnError(response)
		{
			console.log(response);
		}	
	
		function fnSetMapIcon(mapLayout, left_data,top_data, obs_type, color)
		{
			mapLayout.innerHTML = mapLayout.innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'><div id ='"+obs_type+color+"' sta_id ='"+left_data+"' style ='display:block;width:5px;height:5px;background-color:"+color+";-webkit-transform:translate("+left_data+"px,"+top_data+"px); -ms-transform:translate("+left_data+"px,"+top_data+"px); transform:translate("+left_data+"px,"+top_data+"px);'></div></li></ul>"; 
		}
		function test2(){
			post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getMailSend.do', "{\"data\":\"abc\",\"no\":\"16\",\"type\":\"NC\",\"menInfo\":\"abc\",\"receiverMail\":\"tjpark@dodo1.co.kr\"}",function(res){},fnError()); 
		}
		function test(){

			$("#f_no").val('${param.no}');
			$("#f_type").val('${param.type}');
			var info = prompt("보고자를 소속 이름(전화번호)의 양식으로 입력해주세요.");
			$("#men_info").val(info);
			if(info==""){
				alert("공백은 입력하실 수 없습니다");
				return false;
			}
			
			$("#map_type_wide").css("margin-top","0px");
			$("#map_layout").css("top","274px");
			html2canvas($('#map_type_wide'), {
                onrendered: function(canvas) {
                    if (typeof FlashCanvas != "undefined") {
                        FlashCanvas.initElement(canvas);
                    }
                    image = canvas.toDataURL("image/png");
                    $("#map_type_wide").css("margin-top","7px");
                    $("#map_layout").css("top","281px");
                    $("#imgData").val(image);
                }
            });		
			
			setTimeout(function(){
				$("#imgData").val(image);
				$("#imgData2").val(image2);
				$(".search-form").attr('action','${pageContext.request.contextPath}/quakeoccur/quakeinfo/getSimpleQuakeExcel.do').submit();
			},5000);
			alert("엑셀 다운로드가 완료되기 전까지 화면의 조작을 멈춰주세요.");
// 			$(".search-form").attr('action','${pageContext.request.contextPath}/quakeoccur/quakeinfo/getExcel.do').submit();
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<div class="test-1" style="position: absolute;top: 0px;width:100%;height:100%;background-color: black;display:none;"></div>
<input type="hidden" id="org_type" value="${org_type }"/>
<form class="search-form" name="searchForm" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" id="imgData" name="imgData" />
	<input type="hidden" id="imgData2" name="imgData2" />
	<input type="hidden" id="f_no" name="no" />
	<input type="hidden" id="f_type" name="type" />
	<input type="hidden" id="men_info" name="men_info" />
	<input type="hidden" name="time" value="${mainData.timearea }" />
</form>
	<div id="prograss-bar-background">
	</div>
<%-- 	<img id="prograss-bar" src="<c:url value="/img/loading.gif"/>"> --%>
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="popup-tap-wrap">
		<div id="pop_wrap">
		  <section class="pop_topTit">
		    <h1>이벤트 보고서</h1>
		  </section>
		</div>
		<div class="popup-info-container">
			<div id="simple-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>1. 개요</h2><div id="excel-down" style="display: block;position: absolute;top:10px;right:20px;cursor: pointer;" onclick="test()"><img src="<c:url value="/img/btt_exell_down.png"/>"></div>
					<span style="float:right;margin-right:25px;">(KST : Korean Standard Time)</span>
					<article class="pop_table">
						<table>
							<caption>보고서 기본 정보</caption>
							<tr>
								<th colspan="2">발생 시각 (KST)</th>
								<th colspan="2">진앙 위치</th>
								<th>규모</th>
							</tr>
							<tr>
								<th>연월일</th>
								<th>시각</th>
								<th>위도</th>
								<th>경도</th>
								<td rowspan="3">${mainData.mag }<br>(기상청)</td>
							</tr>
							<tr id="tempCapture">
								<td style="height:22px;" rowspan="2">${mainData.date }</td>
								<td style="height:22px;" rowspan="2">${mainData.time }</td>
								<td style="height:22px;">${mainData.lat }</td>
								<td style="height:22px;">${mainData.lon }</td>
							</tr>			
							<tr>
								<td style="height:22px;" colspan="2" id="mainArea"></td>
							</tr>			
						</table>
					</article>
					<h2>2. 지진관측소 관측값(${ mainData.timearea})</h2>
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
					<article class="pop_table">
						<article id="map_type_wide" style="float:left;width:250px;height:203px;overflow: hide;margin-top:7px; background-image: url('/customImgPath/var/www/html/mkOriginArea/${param.type}_${param.no }.jpg'); background-size:300px; background-position:top;">
							<div id="map_layout" style="display: block;position: absolute;top:281px;left:21px;width:251px;height:201px;"></div>
							<br/>
							<br/>
							<br/>
							<br/>
							<br/>
							<div id="triangle"></div>
						</article>	
						<div style="min-height:210px;display:block;">					
						<table style="/*width:554px*/width:68%;">
							<caption>보고서 기본 정보</caption>
							<tr>
								<th colspan="2">관측소</th>
								<th rowspan="2">진앙<br>거리<br>(km)</th>
								<th colspan="3">성분별 최대지반 가속도(g)</th>
							</tr>
							<tr>
								<th>원전</th>
<!-- 								<th>ID</th> -->
								<th>위치</th>
								<th>수직(UD)</th>
								<th>남북(NS)</th>
								<th>동서(EW)</th>
							</tr>
							<c:forEach items="${dataList }" var="data">
								<tr class="stations" lat="${data.lat }" lon="${data.lon }">
									<td style="height:22px;">${data.obs_name }</td>
									<td style="height:22px;">${data.address }</td>
									<td style="height:22px;">${data.kmeter }</td>
									<td style="height:22px;">${data.max_z }</td>
									<td style="height:22px;">${data.max_n }</td>
									<td style="height:22px;">${data.max_e }</td>
								</tr>
							</c:forEach>
						</table>
						</div>
					</article>	
					<c:if test="${param.type eq 'NC'}">
					<h2>3. 관측파형 및 응답스펙트럼</h2>
					<article class="pop_table">				
						<table id="simple_graph">
							<caption>보고서 기본 정보</caption>
							<tbody>
							</tbody>
						</table>
					</article>
					</c:if>
					<h2 id="four_title">4. 최근 지진 현황</h2>
					<article class="pop_table">				
						<table>
							<caption>보고서 기본 정보</caption>
							<tbody>
								<tr>
									<th>발생 시각</th>
									<th>위도</th>
									<th>경도</th>
									<th>진앙 위치</th>
									<th>규모</th>
								</tr>
								<c:forEach items="${historyList }" var="hs">
									<tr>
										<td style="height:22px;">${hs.date } ${hs.time }</td>
										<td style="height:22px;">${hs.lat }</td>
										<td style="height:22px;">${hs.lon }</td>
										<td style="height:22px;">${hs.area }</td>
										<td style="height:22px;">${hs.mag }</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</article>					
				</section>
			</div>
		</div>		
	</div>
</body>
</html>
