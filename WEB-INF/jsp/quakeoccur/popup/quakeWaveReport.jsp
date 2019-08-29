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
	 	.pop_table tbody td{
	 	    border: 1px solid #e2e2e2;
	 	}
	 	.pop_table tbody th{
	 	    border: 1px solid #e2e2e2;
	 	}	 	
	</style>
	<script>
// 		var baseLat = 35.52;
// 		var baseLon = 128.35;

		var baseLat = 37.566667;
		var baseLon = 126.978056;
		
		obsType=null;
		sta_type=null;
		timer1=null;
		timer2=null;
		stationInfos=null;
		station=null;
		mapType = 'AL';
		var image;
		var image2 = "";
		var image3 = "";
		var image4 = "";
		var image5 = "";
		var image6 = "";
		var image7 = "";
		var now_tap ="simple1";
		
		var colorArr = ["#EECBE1","#EECBE1","#D398E8","#04BFEC","#68be11","#ffe340","#FFAD45","red","#585858"];
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
			$("#wave2_img").attr("src","/customImgPath/data/HSGEO/remoteseg/${param.no }/${param.type}/imgTT/${param.type}_distance_time_graph.png");
			$(".popup-info-container div:first").show();
// 			$("#mainArea").html('${mainData.area}' + ' 지역');
			
			if('${viewTap}'=="y"){
				$(".tabs li").hide();
			}
			 $("ul.tabs li").click(function () {
			        $("ul.tabs li").removeClass("active").css("color", "#333");
			        //$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
			        $(this).addClass("active");//.css("color", "darkred");
			        $(".tab-contrainer").hide();
			        var activeTab = $(this).attr("rel");
			        $("#main_title").html("지진관측 상세 보고서");
			        if(activeTab=="wave-report-tab"){
// 			        	switchPrograss();
// 			        	getWaveGraphData(activeTab,"g1");
			        	$("#" + activeTab).fadeIn();
			        	$("#main_title").html("최근 지진현황");
			        }else if(activeTab=="wave-report2-tab"){
// 			        	switchPrograss();
// 			        	getWaveGraphData(activeTab,"g2");
			        	$("#" + activeTab).fadeIn();
			        	$("#main_title").html("Travel time curve");
			        }else if(activeTab=="simple-report-tab"){
			        	$("#" + activeTab).fadeIn();
			        	now_tap ="simple1";
			        }else if(activeTab=="simple-report2-tab"){
			        	$("#" + activeTab).fadeIn();
			        	now_tap ="simple2";
			        }else if(activeTab=="simple-report3-tab"){
			        	$("#" + activeTab).fadeIn();
			        	now_tap ="simple3";
			        }
			 });
			 
			 
			 /*
			if('${param.type}'=="NC"){
			 $(".stations").each(function(i,v){
				var top_data = fnCalTopToPopupWave(Number($(this).attr("lat")));
				var left_data = fnCalleftToSimpleWave(Number($(this).attr("lon")));
				
				fnSetMapIcon(document.getElementById("map_layout"),left_data,top_data,'AL','blue');
			 });
			var top_data = fnCalTopToPopupWave(Number('${mainData.lat}'));
			var left_data = fnCalleftToSimpleWave(Number('${mainData.lon}'));
			
			 $(".stations2").each(function(i,v){
				var top_data = fnCalTopToPopupWave(Number($(this).attr("lat")));
				var left_data = fnCalleftToSimpleWave(Number($(this).attr("lon")));
				
				fnSetMapIcon(document.getElementById("map_layout2"),left_data,top_data,'AL','blue');
			 });
			 $(".stations3").each(function(i,v){
				var top_data = fnCalTopToPopupWave(Number($(this).attr("lat")));
				var left_data = fnCalleftToSimpleWave(Number($(this).attr("lon")));
				
				fnSetMapIcon(document.getElementById("map_layout3"),left_data,top_data,'AL','blue');
			 });			 
			fnSetMapIcon(document.getElementById("map_layout2"),left_data,top_data,'AL','red');
			fnSetMapIcon(document.getElementById("map_layout3"),left_data,top_data,'AL','red');
			fnSetMapIcon(document.getElementById("map_layout"),left_data,top_data,'AL','red');
			 }
			*/
			var wave_idx = 1;
			 $(".waves").each(function(i,v){
				var top_data = fnCalTopToPopupWave(Number($(this).attr("lat")));
				var left_data = fnCalleftToSimpleWave(Number($(this).attr("lon")));
				var mag_data = $(this).children("td").eq(5);
				var quake = Math.ceil((parseFloat(mag_data.html())%1==0?parseFloat(mag_data.html())+1:parseFloat(mag_data.html())));
				
				fnSetMapIcon2(document.getElementById("map_layout4"),left_data,top_data,'AL',colorArr[quake],wave_idx++);
			 });			 
			
// 			if('${param.type}'=="NC"){
				getWaveGraphData('${param.type}');
// 			}else{
// 				getGraphData();
// 			}
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
		function getWaveGraphData(type){
			var sch_data = {};
			sch_data["type"] =  'g1';
			sch_data["org_type"] = $("#org_type").val();
			sch_data["lat"] =  '${mainData.lat}';
			sch_data["lon"] =  '${mainData.lon}';
			sch_data["time_data"] =  '${req_date}';
			sch_data["path1"] =  '${req_id}';
			sch_data["pop_type"] =  'wave';
			
			
			
			post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakePopupData.ws', JSON.stringify(sch_data), 
			function(response){
				//success
				console.log(response);
				console.log(response.data);
				var list = response.data;
				var mob = 5 % 2;
				var bodyTxt = "<tr>";
				var imgTd = "";
				var graphTd = "";
				var imgTdTitle = "";
				var graphTdTitle = "";
				var cnt = 0;
				
				if(type=="NC"){
					for(var i=0;i<list.length;i++){
						if(list[i].obs_id == "KA" || list[i].obs_id == "KB" || list[i].obs_id == "KC" || list[i].obs_id == "KD" || list[i].obs_id == "KE"){
							graphTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
							imgTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
							graphTd += "<td>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_z_"+list[i].obs_id+"'></div>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_n_"+list[i].obs_id+"'></div>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_e_"+list[i].obs_id+"'></div>";
							graphTd += "</td>";
							imgTd += "<td><img style='width:200px;height:135px;' id='img_"+list[i].obs_id+"'></td>";
							
							if((cnt+1)%2==0){
								bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
								graphTd = "";
								imgTd = "";
								graphTdTitle ="";
								imgTdTitle = "";
								if(cnt < 5){
									bodyTxt += "<tr>";
								}
							}
							cnt++;
						}
					}
					if(mob > 0){
						graphTdTitle += "<th style='height:30px;'>-</th>";
						imgTdTitle += "<th style='height:30px;'>-</th>";					
						graphTd += "<td></td>";
						imgTd += "<td></td>";
						bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
					}
// 					console.log(bodyTxt);
					$("#simple_graph").html(bodyTxt);
					
					mob = 4 % 2;
					bodyTxt = "<tr>";
					imgTd = "";
					graphTd = "";
					imgTdTitle = "";
					graphTdTitle = "";
					cnt = 0;
					//2번째
					for(var i=0;i<list.length;i++){
						if(list[i].obs_id == "WA" || list[i].obs_id == "WB" || list[i].obs_id == "WC" || list[i].obs_id == "WD"){
							graphTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
							imgTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
							graphTd += "<td>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_z_"+list[i].obs_id+"'></div>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_n_"+list[i].obs_id+"'></div>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_e_"+list[i].obs_id+"'></div>";
							graphTd += "</td>";
							imgTd += "<td><img style='width:200px;height:135px;' id='img_"+list[i].obs_id+"'></td>";
							
							if((cnt+1)%2==0){
								bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
								graphTd = "";
								imgTd = "";
								graphTdTitle ="";
								imgTdTitle = "";
								if(cnt < 4){
									bodyTxt += "<tr>";
								}
							}
							cnt++;
						}
					}
					if(mob > 0){
						graphTdTitle += "<th style='height:30px;'>-</th>";
						imgTdTitle += "<th style='height:30px;'>-</th>";					
						graphTd += "<td></td>";
						imgTd += "<td></td>";
						bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
					}
// 					console.log(bodyTxt);
					$("#simple_graph2").html(bodyTxt);
					
					mob = 4 % 2;
					bodyTxt = "<tr>";
					imgTd = "";
					graphTd = "";
					imgTdTitle = "";
					graphTdTitle = "";
					cnt = 0;
					//3번째
					for(var i=0;i<list.length;i++){
						if(list[i].obs_id == "YA" || list[i].obs_id == "YB" || list[i].obs_id == "UA" || list[i].obs_id == "UB"){
							graphTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
							imgTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
							graphTd += "<td>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_z_"+list[i].obs_id+"'></div>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_n_"+list[i].obs_id+"'></div>";
							graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_ac100_e_"+list[i].obs_id+"'></div>";
							graphTd += "</td>";
							imgTd += "<td><img style='width:200px;height:135px;' id='img_"+list[i].obs_id+"'></td>";
							
							if((cnt+1)%2==0){
								bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
								graphTd = "";
								imgTd = "";
								graphTdTitle ="";
								imgTdTitle = "";
								if(cnt < 4){
									bodyTxt += "<tr>";
								}
							}
							cnt++;
						}
					}
					if(mob > 0){
						graphTdTitle += "<th style='height:30px;'>-</th>";
						imgTdTitle += "<th style='height:30px;'>-</th>";					
						graphTd += "<td></td>";
						imgTd += "<td></td>";
						bodyTxt += graphTdTitle+imgTdTitle+"</tr><tr>"+ graphTd + imgTd+"</tr>";
					}
					
// 					console.log(bodyTxt);
					$("#simple_graph3").html(bodyTxt);
					
					
					
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
//	 					parseJSONObject(list[i].sp100_z,"#charts_sp100_z_"+list[i].obs_id);
//	 					parseJSONObject(list[i].sp100_n,"#charts_sp100_n_"+list[i].obs_id);
//	 					parseJSONObject(list[i].sp100_e,"#charts_sp100_e_"+list[i].obs_id);
						
						$("#img_"+list[i].obs_id).attr("src","/customImgPath"+list[i].image_path);
						
					}

					
					$(".flot-overlay").css("width","200px");
					$(".flot-overlay").css("height","35px");
					$(".flot-base").css("width","200px");
					$(".flot-base").css("height","35px");
					
				}else{
					mob = list.length % 4;
					console.log("else");
					for(var i=0;i<list.length;i++){
// 						console.log(list[i]);
						graphTdTitle += "<th style='height:30px;'>"+list[i].obs_id+"</th>";
						graphTd += "<td>";
						graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_g_z_"+list[i].obs_id+"'></div>";
						graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_g_n_"+list[i].obs_id+"'></div>";
						graphTd += "<div class='charts' style='display:block;width:200px;height:35px;' id='charts_g_e_"+list[i].obs_id+"'></div>";
						graphTd += "</td>";
						
						
						if((i+1)%4==0){
							bodyTxt += graphTdTitle+"</tr><tr>"+ graphTd + "</tr>";
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
					
// 					console.log(bodyTxt);
					$("#simple_graph").html(bodyTxt);
					
					for(var i=0;i<list.length;i++){
						/*
							데이터 행수에 따라 화면을 구성하여 집어넣는다.
						*/
						if(list[i].g_z != null){
							parseJSONObject(list[i].g_z,"#charts_g_z_"+list[i].obs_id);
						}
						if(list[i].g_n != null){
							parseJSONObject(list[i].g_n,"#charts_g_n_"+list[i].obs_id);
						}
						if(list[i].g_e != null){
							parseJSONObject(list[i].g_e,"#charts_g_e_"+list[i].obs_id);
						}
						
					}
					
					$(".flot-overlay").css("width","200px");
					$(".flot-overlay").css("height","35px");
					$(".flot-base").css("width","200px");
					$(".flot-base").css("height","35px");
				}
				
				
				
				
			});
			
		}
		function parseJSONObject(data,id){
			if(data.indexOf("Error")==-1){
				var obj = JSON.parse(data);
// 				console.log(label + " / "+obj[0].data[0].values);
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
		function fnSetMapIcon2(mapLayout, left_data,top_data, obs_type, color, idx)
		{
			if(left_data > 0 && left_data < 546 && top_data > 0 && top_data < 644 ){
				mapLayout.innerHTML = mapLayout.innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'><div id ='"+obs_type+color+"' sta_id ='"+left_data+"' style ='text-align:center;color:white;border-radius:100px;display:block;width:15px;height:15px;background-color:"+color+";-webkit-transform:translate("+left_data+"px,"+top_data+"px); -ms-transform:translate("+left_data+"px,"+top_data+"px); transform:translate("+left_data+"px,"+top_data+"px);'>"+idx+"</div></li></ul>";
			}
			
		}				
		function test(){
			var info = prompt("보고자를 소속 이름(전화번호)의 양식으로 입력해주세요.");
	
			$("#men_info").val(info);
			if(info=="" || info == null){
				alert("공백은 입력하실 수 없습니다");
				return false;
			}
			alert("엑셀 다운로드를 시작합니다. \n완료될때까지 기다려주세요.");
			$("#map_layout4").children("ul").each(function(i,v){
				if($(this).children().children().html()>5){
					$(this).hide();
				}
			})
			
// 			$(".temp_map").css("height","280px");
			if("${param.type}"=="NC"){
// 				html2canvas($('#map_cap1'), {
// 	                onrendered: function(canvas) {
// 	                    if (typeof FlashCanvas != "undefined") {
// 	                        FlashCanvas.initElement(canvas);
// 	                    }
// 	                    image = canvas.toDataURL("image/png");
// 	                    $("#imgData").val(image);
// 	                }
// 	            });	
				
// 				html2canvas($('#simple_graph'), {
// // 				html2canvas($('#simple-report-tab'), {
					
// 	                onrendered: function(canvas) {
// 	                    if (typeof FlashCanvas != "undefined") {
// 	                        FlashCanvas.initElement(canvas);
// 	                    }
// 	                    image2 = canvas.toDataURL("image/png");
// 	                    $("#imgData2").val(image2);
// 	                }
// 	            });					
// 				setTimeout(function(){
// 					$("#simple-report-tab").hide();
// 					$("#simple-report2-tab").show();
					
// 					html2canvas($('#map_cap2'), {
// 		                onrendered: function(canvas) {
// 		                	console.log('map1');
// 		                    if (typeof FlashCanvas != "undefined") {
// 		                        FlashCanvas.initElement(canvas);
// 		                    }
// 		                    image3 = canvas.toDataURL("image/png");
// 		                    $("#imgData3").val(image3);
// 		                }
// 		            });	
// 					html2canvas($('#simple_graph2'), {
// 		                onrendered: function(canvas) {
// 		                	console.log('graph1');
// 		                    if (typeof FlashCanvas != "undefined") {
// 		                        FlashCanvas.initElement(canvas);
// 		                    }
// 		                    image4 = canvas.toDataURL("image/png");
// 		                    $("#imgData4").val(image4);
// 		                }
// 		            });		
// 				},5000);
// 				setTimeout(function(){
// 					$("#simple-report2-tab").hide();
// 					$("#simple-report3-tab").show();
// 					html2canvas($('#map_cap3'), {
// 		                onrendered: function(canvas) {
// 		                	console.log('map2');
// 		                    if (typeof FlashCanvas != "undefined") {
// 		                        FlashCanvas.initElement(canvas);
// 		                    }
// 		                    image5 = canvas.toDataURL("image/png");
// 		                    $("#imgData5").val(image5);
// 		                }
// 		            });	
// 					html2canvas($('#simple_graph3'), {
// 		                onrendered: function(canvas) {
// 		                	console.log('graph2');
// 		                    if (typeof FlashCanvas != "undefined") {
// 		                        FlashCanvas.initElement(canvas);
// 		                    }
// 		                    image6 = canvas.toDataURL("image/png");
// 		                    $("#imgData6").val(image6);
// 		                }
// 		            });		
// 				},10000);

				$("#simple-report-tab").hide();
				$("#wave-report-tab").show();
				html2canvas($('#map_cap4'), {
	                onrendered: function(canvas) {
	                    if (typeof FlashCanvas != "undefined") {
	                        FlashCanvas.initElement(canvas);
	                    }
	                    image7 = canvas.toDataURL("image/png");
	                    $("#imgData7").val(image7);
	                }
	            });	
				setTimeout(function(){
					$("#wave-report-tab").hide();
					$("#simple-report-tab").show();
				},2000);
				
			}else{
// 				html2canvas($('#simple_graph'), {
// 	                onrendered: function(canvas) {
// 	                    if (typeof FlashCanvas != "undefined") {
// 	                        FlashCanvas.initElement(canvas);
// 	                    }
// 	                    image2 = canvas.toDataURL("image/png");
// 	                    $("#imgData2").val(image2);
// 	                }
// 	            });	
				
// 				setTimeout(function(){
				$("#simple-report-tab").hide();
				$("#wave-report-tab").show();
				html2canvas($('#map_cap4'), {
	                onrendered: function(canvas) {
	                    if (typeof FlashCanvas != "undefined") {
	                        FlashCanvas.initElement(canvas);
	                    }
	                    image7 = canvas.toDataURL("image/png");
	                    $("#imgData7").val(image7);
	                }
	            });						
// 				},3000);
				setTimeout(function(){
					$("#wave-report-tab").hide();
					$("#simple-report-tab").show();
				},2000);
			}		
			
			
// 			return false;
					
			setTimeout(function(){
// 				$("#imgData").val(image);
// 				$("#imgData2").val(image2);
// 				$("#imgData3").val(image3);
// 				$("#imgData4").val(image4);
// 				$("#imgData5").val(image5);
// 				$("#imgData6").val(image6);
				$("#imgData7").val(image7);
				$(".temp_map").css("height","232px");
				$("#map_layout4").children("ul").each(function(i,v){
					$(this).show();
				})
				$(".search-form").attr('action','${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakeExcel.do').submit();
			},5000);
					
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<input type="hidden" id="org_type" value="${org_type }"/>
<form class="search-form" name="searchForm" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" id="imgData"  name="imgData" />
	<input type="hidden" id="imgData2" name="imgData2" />
	<input type="hidden" id="imgData3" name="imgData3" />
	<input type="hidden" id="imgData4" name="imgData4" />
	<input type="hidden" id="imgData5" name="imgData5" />
	<input type="hidden" id="imgData6" name="imgData6" />
	<input type="hidden" id="imgData7" name="imgData7" />
	<input type="hidden" id="f_no" name="no" value='${param.no }'/>
	<input type="hidden" id="f_type" name="type" value='${param.type }'/>
	<input type="hidden" id="men_info" name="men_info" />
	<input type="hidden" name="time" value="${mainData.timearea }" />
</form>
	<div id="prograss-bar-background">
	</div>
<%-- 	<img id="prograss-bar" src="<c:url value="/img/loading.gif"/>"> --%>
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="popup-tap-wrap">
		<ul class="tabs">
			<c:if test="${param.type eq 'NC' }">
			<li id="menu1" rel="simple-report-tab" class="active">고리보고서</li>
			<li id="menu2" rel="simple-report2-tab">월성보고서</li>
			<li id="menu3" rel="simple-report3-tab">영광/울진보고서</li>
			</c:if>
			<c:if test="${param.type ne 'NC' }">
			<li id="menu1" rel="simple-report-tab" class="active">분석보고서</li>
			</c:if>
			<li id="menu4" rel="wave-report-tab">지진현황</li>
			<li id="menu5" rel="wave-report2-tab">파형 분석</li>
		</ul>
		<div id="pop_wrap">
		  <section class="pop_topTit">
		    <h1 id="main_title">지진관측 상세보고서</h1>
		  </section>
		</div>
		<div class="popup-info-container">
<!-- 			원전 -->
			<c:if test="${param.type eq 'NC' }">
			<div id="simple-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>1. 개요</h2><div style="display: block;position: absolute;top:44px;right:20px;cursor: pointer;" onclick="test()"><img src="<c:url value="/img/btt_exell_down.png"/>"></div>
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
								<td colspan="2" id="mainArea">${mainData.area} 지역</td>
							</tr>			
						</table>
					</article>
					<h2>2. 지진관측소 관측값(${ mainData.timearea})</h2>
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
					<article class="pop_table">
						<article class="temp_map" id="map_cap1" style="float:left;width:250px;height:230px;overflow: hide;margin-top:7px; background-image: url('/customImgPath/var/www/html/mkOriginArea/${param.type}_${param.no }.jpg'); background-size:300px; background-position:top;">
							<div id="map_layout" style="display: block;position: absolute;top:281px;left:21px;width:251px;height:201px;"></div>
							<br/>
							<br/>
							<br/>
							<br/>
							<br/>
							<div id="triangle"></div>
						</article>	
						<div style="min-height:240px;display:block;">			
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
								<c:if test="${data.obs_id eq 'KA' or data.obs_id eq 'KB' or data.obs_id eq 'KC' or data.obs_id eq 'KD' or data.obs_id eq 'KE'}">
									<tr class="stations" lat="${data.lat }" lon="${data.lon }">
										<td>${data.obs_name }</td>
										<td>${data.address }</td>
										<td>${data.kmeter }</td>
										<td>${data.max_z }</td>
										<td>${data.max_n }</td>
										<td>${data.max_e }</td>
									</tr>
								</c:if>
							</c:forEach>
						</table>
						</div>
					</article>
					<h2>3. 관측파형 및 응답스펙트럼</h2>
					<article class="pop_table">				
						<table id="simple_graph">
							<caption>보고서 기본 정보</caption>
							<tbody>
							</tbody>
						</table>
					</article>									
				</section>
			</div>
			<div id="simple-report2-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>1. 개요</h2>
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
								<td colspan="2" id="mainArea2">${mainData.area} 지역</td>
							</tr>			
						</table>
					</article>
					<h2>2. 지진관측소 관측값(${ mainData.timearea})</h2>
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
						<article class="pop_table">
						<article class="temp_map" id="map_cap2" style="float:left;width:250px;height:230px;overflow: hide;margin-top:7px; background-image: url('/customImgPath/var/www/html/mkOriginArea/${param.type}_${param.no }.jpg'); background-size:300px; background-position:top;">
							<div id="map_layout2" style="display: block;position: absolute;top:281px;left:21px;width:251px;height:201px;"></div>
							<br/>
							<br/>
							<br/>
							<br/>
							<br/>
							<div id="triangle"></div>
						</article>				
						<div style="min-height:240px;display:block;">			
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
								<c:if test="${data.obs_id eq 'WA' or data.obs_id eq 'WB' or data.obs_id eq 'WC' or data.obs_id eq 'WD'}">
									<tr class="stations2" lat="${data.lat }" lon="${data.lon }">
										<td>${data.obs_name }</td>
										<td>${data.address }</td>
										<td>${data.kmeter }</td>
										<td>${data.max_z }</td>
										<td>${data.max_n }</td>
										<td>${data.max_e }</td>
									</tr>
								</c:if>
							</c:forEach>
						</table>
						</div>
					</article>	
					<h2>3. 관측파형 및 응답스펙트럼</h2>
					<article class="pop_table">				
						<table id="simple_graph2">
							<caption>보고서 기본 정보</caption>
							<tbody>
							</tbody>
						</table>
					</article>								
				</section>
			</div>
			<div id="simple-report3-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>1. 개요</h2>
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
								<td colspan="2" id="mainArea3">${mainData.area} 지역</td>
							</tr>			
						</table>
					</article>
					<h2>2. 지진관측소 관측값(${ mainData.timearea})</h2>
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
						<article class="pop_table">
						<article class="temp_map" id="map_cap3" style="float:left;width:250px;height:230px;overflow: hide;margin-top:7px; background-image: url('/customImgPath/var/www/html/mkOriginArea/${param.type}_${param.no }.jpg'); background-size:300px; background-position:top;">
							<div id="map_layout3" style="display: block;position: absolute;top:281px;left:21px;width:251px;height:201px;"></div>
							<br/>
							<br/>
							<br/>
							<br/>
							<br/>
							<div id="triangle"></div>
						</article>				
						<div style="min-height:240px;display:block;">			
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
								<c:if test="${data.obs_id eq 'YA' or data.obs_id eq 'YB' or data.obs_id eq 'UA' or data.obs_id eq 'UB'}">
									<tr class="stations3" lat="${data.lat }" lon="${data.lon }">
										<td>${data.obs_name }</td>
										<td>${data.address }</td>
										<td>${data.kmeter }</td>
										<td>${data.max_z }</td>
										<td>${data.max_n }</td>
										<td>${data.max_e }</td>
									</tr>
								</c:if>
							</c:forEach>
						</table>
						</div>
					</article>		
					<h2>3. 관측파형 및 응답스펙트럼</h2>
					<article class="pop_table">				
						<table id="simple_graph3">
							<caption>보고서 기본 정보</caption>
							<tbody>
							</tbody>
						</table>
					</article>						
				</section>
			</div>
			</c:if>
<!-- 			원전 -->
<!-- 			그외 -->
			<c:if test="${param.type ne 'NC' }">
			<div id="simple-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>1. 개요</h2><div style="display: block;position: absolute;top:44px;right:20px;cursor: pointer;" onclick="test()"><img src="<c:url value="/img/btt_exell_down.png"/>"></div>
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
								<td colspan="2" id="mainArea">${mainData.area} 지역</td>
							</tr>			
						</table>
					</article>
					<h2>2. 지진관측소 관측값(${ mainData.timearea})</h2>
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
					<article class="pop_table">
						<table style="width:100%">
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
									<td>${data.address }</td>
									<td>${data.kmeter }</td>
									<td>${data.max_z }</td>
									<td>${data.max_n }</td>
									<td>${data.max_e }</td>
								</tr>
							</c:forEach>
						</table>
					</article>
					<h2>3. 관측파형</h2>
					<article class="pop_table">				
						<table id="simple_graph">
							<caption>보고서 기본 정보</caption>
							<tbody>
							</tbody>
						</table>
					</article>									
				</section>
			</div>			
			</c:if>
			<div id="wave-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2 style="font-size:20px;margin-bottom:-6px;line-height:30px;">1. 최근 지진 현황</h2>
					<article class="pop_table" style="min-height: 245px">
						<table>
							<caption>보고서 기본 정보</caption>
							<tr>
								<th style="height:20px;">순번</th>
								<th style="height:20px;">발생 시각 (KST)</th>
								<th style="height:20px;">위도</th>
								<th style="height:20px;">경도</th>
								<th style="height:20px;">진앙 위치</th>
								<th style="height:20px;">규모</th>
							</tr>
							<c:forEach items="${historyList }" var="data" varStatus="hl">
								<tr class="waves" lat=${data.lat } lon=${data.lon }>
									<td style="height:20px;">${hl.index + 1}</td>
									<td style="height:20px;">${data.date } ${data.time }</td>
									<td style="height:20px;">${data.lat }</td>
									<td style="height:20px;">${data.lon }</td>
									<td style="height:20px;">${data.area }</td>
									<td style="height:20px;">${data.mag }</td>
								</tr>			
							</c:forEach>
						</table>
					</article>
					<h2 style="font-size:20px;margin-bottom:-6px;line-height:30px;">2. 지진 분포도</h2>
					<article id="map_cap4"class="map_type4" style="height:658px;width:561px;margin:0 auto;">
						<div id="map_layout4" style="display: block;position: absolute;top:387px;left:144px;width:560px;height:658px;"></div>
						<br/>
						<br/>
						<br/>
						<br/>
						<br/>
						<div id="triangle"></div>
					</article>				
				</section>
			</div>
			<div id="wave-report2-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2>1. Travel time curve</h2>
					<h2 style="font-size: 18px;">${mainData.req_starttime } - ${mainData.req_endtime } 규모 ${mainData.mag }</h2>
					<img id="wave2_img" src="" style="width:80%;margin-left:10%;"></img>					
				</section>
			</div>		
		</div>		
	</div>
</body>
</html>

