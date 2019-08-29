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
	<script src="<c:url value="/js/jquery/jquery.flot.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.flot.time.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.flot.axislabels.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	<script src="<c:url value="/js/nms/html2canvas.js"/>"></script>
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
	</style>
	<script>
		var options = {
			series: {
				shadowSize: 0,	// Drawing is faster without shadows
				show:true,
				showLine:false
			},
			yaxis:{
				autoscaleMargin:1
		// 		tickDecimals:1
			},
			lines:{
				show:true
			},
			autoscale : true,
			legend: {backgroundColor:"#ffffff"}
		};
		var image = "";
		var image2 = "";
		$(document).ready(function(){
// 			setTimeout("reCreateChart()",15000);
			$(".popup-info-container div:first").show();
			if('${viewTap}'=="y"){
				$(".tabs li").hide();
			}			
			/* 탭 이벤트 */
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
			sch_data["lat"] =  '0.0';
			sch_data["lon"] =  '0.0';
			sch_data["time_data"] =  '${req_date}';
			sch_data["path1"] =  '${req_id}';
			sch_data["pop_type"] =  'self';
			
			$("#waveBody").html("");
			
			post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakePopupData.ws', JSON.stringify(sch_data), 
			function(response){
				//success
				
				console.log(response.data);
				var list = response.data;
				for(var i=0;i<list.length;i++){
					if(type == "g1"){
						image = "1";
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
							if(parseInt(list[i].cnt)>2){
								parseJSONObject(list[i].b_z,"#charts_b_z_"+list[i].obs_id);
								parseJSONObject(list[i].b_n,"#charts_b_n_"+list[i].obs_id);
								parseJSONObject(list[i].b_e,"#charts_b_e_"+list[i].obs_id);
							}
							if(parseInt(list[i].cnt)>3){
								parseJSONObject(list[i].r_n,"#charts_r_n_"+list[i].obs_id);
								parseJSONObject(list[i].r_e,"#charts_r_e_"+list[i].obs_id);
							}
							parseJSONObject(list[i].m_n,"#charts_m_n_"+list[i].obs_id);
							parseJSONObject(list[i].m_e,"#charts_m_e_"+list[i].obs_id);
						}
						
						$("#img_"+list[i].obs_id).attr("src","/customImgPath"+list[i].image_path);
						
						switchPrograss();
						$("#" + tabId).fadeIn();
						$(".flot-overlay").css("width","242px");
						$(".flot-overlay").css("height","80px");
						$(".flot-base").css("width","242px");
						$(".flot-base").css("height","80px");
						
					}else{
						image2 = "2";
						var tr = "<tr><th>"+list[i].obs_id+"</th><td><div id='charts_wave_g_n_"+list[i].obs_id+"' class='charts' style='float:left;display:block;width:1230px;height:80px;'></div></td></tr>";
						$("#waveBody").append(tr);
						parseJSONObject(list[i].g_z,"#charts_wave_g_n_"+list[i].obs_id);
						
						switchPrograss();
						$("#" + tabId).fadeIn();
						$(".flot-overlay").css("width","1287px");
						$(".flot-overlay").css("height","80px");
						$(".flot-base").css("width","1287px");
						$(".flot-base").css("height","80px");
							
					}
				}
			}, fnError);
			
			
		}		
		
		function parseJSONObject(data,id){
			console.log(data);
			if(data != null){
				if(data.indexOf("Error")==-1){
					var obj = JSON.parse(data);
					drawGraph(obj[0].data[0].values,id);
				}
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
		function test(){
			if(image2 == "" && image == "" && '${param.summary}'=='n'){
				alert("관측파형 페이지를 모두 열람하신 후 다운로드 가능합니다.");
				return false;
			}
			var info = prompt("보고자를 소속 이름(전화번호)의 양식으로 입력해주세요.");
			$("#men_info").val(info);
			if(info=="" || info == null){
				alert("공백은 입력하실 수 없습니다");
				return false;
			}
			
			if('${param.summary}'=='n'){
				$("#wave-report-tab").show();
				$("#wave-report2-tab").show();
				$(".flot-overlay").css("width","242px");
				$(".flot-overlay").css("height","80px");
				$(".flot-base").css("width","242px");
				$(".flot-base").css("height","80px");
				html2canvas($('#waveTable1'), {
	                onrendered: function(canvas) {
	                    if (typeof FlashCanvas != "undefined") {
	                        FlashCanvas.initElement(canvas);
	                    }
	                    image= canvas.toDataURL("image/png");
	                    $("#imgData").val(image);
	                }
	            });		
				setTimeout(function(){
					$(".flot-overlay").css("width","1287px");
					$(".flot-overlay").css("height","80px");
					$(".flot-base").css("width","1287px");
					$(".flot-base").css("height","80px");
					
					html2canvas($('#waveTable2'), {
		                onrendered: function(canvas) {
		                    if (typeof FlashCanvas != "undefined") {
		                        FlashCanvas.initElement(canvas);
		                    }
		                    image2= canvas.toDataURL("image/png");
		                    $("#imgData2").val(image2);
		                }
		            });	
				},2000);
			}
			
			setTimeout(function(){
				$("#imgData").val(image);
				$("#imgData2").val(image2);
				$(".search-form").attr('action','${pageContext.request.contextPath}/quakeoccur/quakeinfo/getManualExcel.do').submit();
				$("#wave-report-tab").hide();
				$("#wave-report2-tab").hide();
			},6000);
			alert("엑셀 다운로드가 완료되기 전까지 화면의 조작을 멈춰주세요.");
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<input type="hidden" id="org_type" value="${org_type }"/>
<form class="search-form" name="searchForm" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" id="imgData" name="imgData" />
	<input type="hidden" id="imgData2" name="imgData2" />
	<input type="hidden" id="f_no" name="no" value='${param.no }'/>
	<input type="hidden" id="f_type" name="type" value='${param.type }'/>
	<input type="hidden" id="men_info" name="men_info" />
	<input type="hidden" name="time" value="${mainData.tmp2 }" />
	<input type="hidden" name="summary" value="${param.summary }"/>
</form>
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
					<h2 style="padding-left: 35px;text-align: left;">1. 개요(감지 정보)</h2><div style="display: block;position: absolute;top:44px;right:20px;cursor: pointer;" onclick="test()"><img src="<c:url value="/img/btt_exell_down.png"/>"></div>
					<article class="pop_table">
						<table>
							<caption>보고서 기본 정보</caption>
							<tr>
								<th>감지시각 (KST)</th>
								<th>감지 관측소</th>
								<th>감지 값</th>
								<th>감지 단계</th>
							</tr>
							<tr>
								<td>${mainData.timestamp }</td>
								<td>${mainData.org }</td>
								<td>${mainData.z }</td>
								<td>${mainData.n }</td>
							</tr>
						</table>
					</article>
					<h2 style="padding-left: 35px;text-align: left;">2. 지진관측소 관측값(${mainData.tmp2 })</h2>
<!-- 					<button onclick="test1()">test1</button><button onclick="test2()">test2</button> -->
					<span style="float:right;margin-right:25px;">(1g=980cm/sec²=980gal, SSE=0.2g, OBE=0.1g)</span>
					<article class="pop_table">
						<table>
							<caption>보고서 기본 정보</caption>
							<tr>
								<th rowspan="2">관측소</th>
								<th rowspan="2">최대값 시간</th>
								<th rowspan="2">최대지반<br>가속도(g)</th>
								<th colspan="3">성분별 최대지반 가속도(g)</th>
							</tr>
							<tr>
								<th>수직(UD)</th>
								<th>남북(NS)</th>
								<th>동서(EW)</th>
							</tr>
							<c:forEach items="${dataList }" var="data">
								<tr>
									<td>${data.obs_name }</td>
									<td>${data.max_time }</td>
									<td>${data.max_g }</td>
									<td>${data.max_z }</td>
									<td>${data.max_n }</td>
									<td>${data.max_e }</td>
								</tr>
							</c:forEach>
						</table>
					</article>				
				</section>
			</div>
			
			<div id="wave-report-tab" class="tab-contrainer">
				<section class="pop_body">
					<h2 style="padding-left: 35px;text-align: left;">3. 관측파형 및 응답스펙트럼</h2>
					<article class="pop_table">
							<table id="waveTable1">
								<caption>보고서 기본 정보</caption>
								<colgroup>
									<col width="15%"/>
									<col width="15%"/>
									<col width="15%"/>
									<col width="15%"/>
									<col width="15%"/>
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
					<h2>4. 관측파형</h2>
					<article class="pop_table">
						<table id="waveTable2">
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
