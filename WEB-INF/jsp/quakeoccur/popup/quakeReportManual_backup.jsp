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
	<script src="<c:url value="/js/jquery/jquery.flot_wave.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.flot.time.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.flot.axislabels.js"/>"></script>	
	<link href="<c:url value="/css/wave_mapicons.css"/>" rel="stylesheet" type="text/css" />
	
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
			$(".popup-info-container div:first").show();
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
			 
			 $(".stations").each(function(i,v){
				var top_data = fnCalTopToPopupWave(Number($(this).attr("lat")));
				var left_data = fnCalleftToPopupWave(Number($(this).attr("lon")));
				
				fnSetMapIcon(document.getElementById("map_layout"),left_data,top_data,'AL','blue');
			 });
			 
			var top_data = fnCalTopToPopupWave(Number('${mainData.lat}'));
			var left_data = fnCalleftToPopupWave(Number('${mainData.lon}'));
			
			fnSetMapIcon(document.getElementById("map_layout"),left_data,top_data,'AL','red');
			
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
		function getWaveGraphData(tabId,type){
			var sch_data = {};
			sch_data["type"] =  type;
			sch_data["org_type"] = $("#org_type").val();
			sch_data["lat"] =  '${mainData.lat}';
			sch_data["lon"] =  '${mainData.lon}';
			sch_data["time_data"] =  '${req_date}';
			sch_data["path1"] =  '${req_id}';
			sch_data["pop_type"] =  'manual';
			
			
			
			post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakePopupData.ws', JSON.stringify(sch_data), 
			function(response){
				//success
				var list = response.data;
				for(var i=0;i<list.length;i++){
					if(type == "g1"){
						if($("#org_type").val()=="NC" || $("#org_type").val() == "CJ"){
							parseJSONObject(list[i].ac100_z,"#charts_ac100_z_"+list[i].obs_id);
							parseJSONObject(list[i].ac100_n,"#charts_ac100_n_"+list[i].obs_id);
							parseJSONObject(list[i].ac100_e,"#charts_ac100_e_"+list[i].obs_id);
							parseJSONObject(list[i].sp100_z,"#charts_sp100_z_"+list[i].obs_id);
							parseJSONObject(list[i].sp100_n,"#charts_sp100_n_"+list[i].obs_id);
							parseJSONObject(list[i].sp100_e,"#charts_sp100_e_"+list[i].obs_id);
						}else{
							parseJSONObject(list[i].g_z,"#charts_g_z_"+list[i].obs_id);
							parseJSONObject(list[i].g_n,"#charts_g_n_"+list[i].obs_id);
							parseJSONObject(list[i].g_e,"#charts_g_e_"+list[i].obs_id);
							parseJSONObject(list[i].b_z,"#charts_b_z_"+list[i].obs_id);
							parseJSONObject(list[i].b_n,"#charts_b_n_"+list[i].obs_id);
							parseJSONObject(list[i].b_e,"#charts_b_e_"+list[i].obs_id);
							if(parseInt(list[i].cnt)>2){
								parseJSONObject(list[i].m_n,"#charts_m_n_"+list[i].obs_id);
								parseJSONObject(list[i].m_e,"#charts_m_e_"+list[i].obs_id);
							}
							if(parseInt(list[i].cnt)>3){
								parseJSONObject(list[i].r_n,"#charts_r_n_"+list[i].obs_id);
								parseJSONObject(list[i].r_e,"#charts_r_e_"+list[i].obs_id);
							}
						}
						$("#img_"+list[i].obs_id).attr("src","/customImgPath"+list[i].image_path);
					}else{
						
						var tr = "<tr><th>"+list[i].obs_id+"</th><td><div id='charts_wave_g_z_"+list[i].obs_id+"' class='charts' style='float:left;display:block;width:1230px;height:80px;'></div></td></tr>";
						$("#waveBody").append(tr);
						parseJSONObject(list[i].g_z,"#charts_wave_g_z_"+list[i].obs_id);
					}
					
				}
				switchPrograss();
				$("#" + tabId).fadeIn();
				if(type=="g1"){
					$(".flot-overlay").css("width","242px");
					$(".flot-overlay").css("height","80px");
					$(".flot-base").css("width","242px");
					$(".flot-base").css("height","80px");
				}else{
					$(".flot-overlay").css("width","1230px");
					$(".flot-overlay").css("height","80px");
					$(".flot-base").css("width","1230px");
					$(".flot-base").css("height","80px");
				}
			}, fnError);
			
			
		}
		function parseJSONObject(data,id){
			if(data.indexOf("Error")==-1){
				var obj = JSON.parse(data);
				console.log(obj);
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
			mapLayout.innerHTML = mapLayout.innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'><div id ='"+obs_type+color+"' sta_id ='"+left_data+"' style ='display:block;width:7px;height:7px;background-color:"+color+";-webkit-transform:translate("+left_data+"px,"+top_data+"px); -ms-transform:translate("+left_data+"px,"+top_data+"px); transform:translate("+left_data+"px,"+top_data+"px);'></div></li></ul>"; 
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<input type="hidden" id="org_type" value="${org_type }"/>
	<div id="prograss-bar-background">
	</div>
<%-- 	<img id="prograss-bar" src="<c:url value="/img/loading.gif"/>"> --%>
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="popup-tap-wrap">
		<ul class="tabs">
			<li rel="simple-report-tab" class="active">요약보고서</li>
			<li rel="wave-report-tab">관측파형</li>
			<li rel="wave-report2-tab">관측파형2</li>
		</ul>
		<div id="pop_wrap">
		  <section class="pop_topTit">
		    <h1>이벤트 보고서</h1>
		  </section>
		</div>
		<div class="popup-info-container">
			<div id="simple-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2 style="padding-left: 35px;text-align: left;">1. 개요 <span>(분석시간-${mainData.realTime })</span></h2>
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
							<tr>
								<td rowspan="2">${mainData.date }</td>
								<td rowspan="2">${mainData.time }</td>
								<td>${mainData.lat }</td>
								<td>${mainData.lon }</td>
							</tr>			
							<tr>
								<td colspan="2" id="mainArea">${mainData.area }</td>
							</tr>
							<tr>
								<td colspan="5">${mainData.comment }</td>
							</tr>			
						</table>
					</article>
					<h2 style="padding-left: 35px;text-align: left;">2. 지진관측소 관측값(${ mainData.timeArea})</h2>
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
					<article class="pop_table">
						<article class="map_type_wide" style="float:left;width:394px;height:410px;overflow: hide;margin-top:55px;">
							<div id="map_layout" style="display: block;position: absolute;top:416px;left:35px;width:394px;height:410px;"></div>
							<br/>
							<br/>
							<br/>
							<br/>
							<br/>
							<div id="triangle"></div>
						</article>						
						<table style="width:70%">
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
									<td>${data.obs_name }</td>
<%-- 									<td>${data.sen_id }</td> --%>
									<td>${data.address }</td>
									<td>${data.kmeter }</td>
									<td>${data.max_z }</td>
									<td>${data.max_n }</td>
									<td>${data.max_e }</td>
								</tr>
							</c:forEach>
						</table>
					</article>	
					<h2 style="padding-left: 35px;text-align: left;">3. 특이사항</h2>
					<article class="pop_table">
						<table>
							<caption>보고서 기본 정보</caption>
							<tr>
								<td>${mainData.etc }</td>
							</tr>
						</table>
					</article>
				</section>
			</div>
			<div id="wave-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>4. 관측파형 및 응답스펙트럼</h2>
					<article class="pop_table">
						<table>
							<caption>보고서 기본 정보</caption>
							<colgroup>
								<col width="5%"/>
								<col width="10%"/>
								<col width="20%"/>
								<col width="20%"/>
								<col width="20%"/>
								<col width="25%"/>
							</colgroup>
<%-- 							<c:if test="${dataList ne 'null' }"> --%>
							<c:if test="${org_type eq 'NC' or org_type eq 'CJ' }">
								<c:forEach items="${dataList }" var="data" varStatus="idx">
								<tr>
									<th rowspan="3" style="width:50px;">${data.obs_name }</th>
									<th></th>
									<th>Z</th>
									<th>N</th>
									<th>E</th>
									<td rowspan="3" style="width:370px;">
										<img id="img_${data.obs_id }" style="width:370px;height:247px;" src="<c:url value="/img/KAG_response_spectrum.png"/>"  onError="this.src='<c:url value="/img/white.png" />'">
									</td>
								</tr>
								<tr>
									<th>가속도<br>(100샘플)</th>
									<td>
										<div id="charts_ac100_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_ac100_n_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_ac100_e_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
								</tr>
								<tr>
									<th>속도<br>(100샘플)</th>
									<td>
										<div id="charts_sp100_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_sp100_n_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_sp100_e_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
								</tr>	
								</c:forEach>
							</c:if>
							<c:if test="${org_type eq 'PP' or org_type eq 'WP' }">
								<c:forEach items="${dataList }" var="data" varStatus="idx">
								<tr>
									<th rowspan="${data.cnt+1 }" style="width:50px;">${data.obs_name }</th>
									<th></th>
									<th>Z</th>
									<th>N</th>
									<th>E</th>
									<td rowspan="${data.cnt+1 }" style="width:370px;">
										<img id="img_${data.obs_id }" style="width:370px;" src="<c:url value="/img/KAG_response_spectrum.png"/>">
									</td>
								</tr>
								<tr>
									<th>자유장</th>
									<td>
										<div id="charts_g_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_g_n_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_g_e_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
								</tr>
								<c:if test="${data.cnt > 2 }">
								<tr>
									<th>하부</th>
									<td>
										<div id="charts_b_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_b_n_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_b_e_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
								</tr>
								</c:if>
								<tr>
									<th>상부(M)</th>
									<td>
										<div id="charts_m_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_m_n_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_m_e_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
								</tr>
								<c:if test="${data.cnt > 3 }">
								<tr>
									<th>상부(R)</th>
									<td>
										<div id="charts_r_z_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_r_n_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
									<td>
										<div id="charts_r_e_${data.obs_id }" class="charts" style="float:left;display:block;width:242px;height:80px;"></div>
									</td>
								</tr>								
								</c:if>	
								</c:forEach>
							</c:if>							
						</table>
					</article>
				</section>			
			</div>
			<div id="wave-report2-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>5. 관측파형 [진앙거리 순]</h2>
					<article class="pop_table">
						<table>
							<caption>보고서 기본 정보</caption>
							<tbody id="waveBody">
							</tbody>
						</table>
					</article>
				</section>			
			</div>
		</div>		
	</div>
</body>
</html>
