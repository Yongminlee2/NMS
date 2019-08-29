<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.time.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.axislabels.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.tickrotor.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.categories.js"/>"></script>
		<script type="text/javascript">
			var searchType;
			var stationinfo;
			$(document).ready(function(){
				
				fnSetDatePickerAndToDate($("#sch_date_s"), -1);
				fnSetDatePickerAndToDate($("#sch_date_e"), 0);
				fnSetDatePickerAndToDate($("#sch_date_y"), 0);
				
				$("<div id='tooltip'></div>").css({
					position: "absolute",
					display: "none",
					border: "1px solid #fdd",
					padding: "2px",
					"background-color": "#fee",
					opacity: 0.80
				}).appendTo("body");
				
				$("input:radio[name='sch_type']:radio[value='R']").attr("checked",true);
				post('${pageContext.request.contextPath}/util/common/stationofsensor.ws', '', fnSetStationList, fnError);
				
				fnSetYearSelector();
				
				$(".year").hide();
				
				function fnSetYearSelector()
				{
					var html = "";
					
					var d = new Date();
					
					for(var i = d.getFullYear(); i > d.getFullYear() - 7 ; i -- )
					{
						html += "<option value='"+i+"'>" + i + "</option>";
					}
					
					$(".sch_year").append(html);
					
				}
				
				function fnSetStationList(response)
				{
					stationinfo = response.data;
					$(response.data).each(function(i,e){
						var html = "<option value='"+e.obs_id+"'>" + e.obs_name + "</option>";
						$("#sch_sta_type").append(html);
						html = null;
					});
				}
				
			});
			
			function fnError(response)
			{
				console.log(response);
			}
			
			function fnGetDataCollRateTable()
			{
				searchType = $("input:radio[name='sch_type']:checked").val();
				var sch_data = {};
				
				sch_data["type"] = searchType;
				sch_data["sta_type"] = $("#sch_sta_type option:selected").val();
				
				if('R' == searchType || 'M' == searchType){
					sch_data["date_s"] =  $("#sch_date_s").val();
					sch_data["date_e"] =  $("#sch_date_e").val();
					
					if(sch_data["date_s"] == "" || sch_data["date_e"] == ""){
						alert("날짜를 선택 해 주세요");
						return false;
					}else{
						post('${pageContext.request.contextPath}/inforeceived/datacollrate/getRateList.ws', JSON.stringify(sch_data), fnDrawDataCollRateTable, fnError);
					}
				}else{
					sch_data["date_s"] =  $("#sch_date_y").val();
					
					if(sch_data["sta_type"] == ""){
						alert("관측소를 선택해 주십시오.");
						return false;
					}else{
						post('${pageContext.request.contextPath}/inforeceived/datacollrate/getRateList.ws', JSON.stringify(sch_data), fnDrawDataCollRateTable, fnError);
					}
				}
			}
			
			function fnDrawDataCollRateTable(response)
			{
				$(".rate-table-tbody").html('');
				$('.chart-area').html('');
				$('.demo-container2').remove();
				$('.s_table3').show();
				if('R' == searchType || 'M' == searchType)
				{
					$('.NC').css('display', 'none');
					$('.WP').css('display', 'none');
					$('.PP').css('display', 'none');
					
					if(searchType == "R"){
						fnDrawDayTable(response.data);
					}else{
						fnDrawMonthTable(response.data);
					}
				}
				else
				{
					if(searchType == "D")
					{
						$('.s_table3').css('display', 'none');
						fnDrawDayCheckChart(response.data);
					}
					/* else if(searchType == "Y")
					{
						fnDrawYearCheckChart(datasets[0]);
					} */
				}
			}
			
			function fnDrawDayTable(list){
				var checkDate = '';
				
				var ncCheck = false;
				var wpCheck = false;
				var ppCheck = false;
				
				$('#NC #name').empty();
				$('#NC #gChannel').empty();
				$('#NC #channel').empty();
				
				$('#WP #name').empty();
				$('#WP #gChannel').empty();
				$('#WP #channel').empty();
				
				$('#PP #name').empty();
				$('#PP #gChannel').empty();
				$('#PP #channel').empty();
				$(list).each(function(i, d){
					if(i == 0){
						checkDate = d.date;
					}
					
					if($('#NC #ncCheck').length == 0 && "NC" == d.tmp1){
						$('.NC').css('display', '');
						$('#NC #name').append("<th id='ncCheck' rowspan='2'>날짜</th>");
					}
					
					if($('#WP #wpCheck').length == 0 && "WP" == d.tmp1){
						$('.WP').css('display', '');
						$('#WP #name').append("<th id='wpCheck' rowspan='2'>날짜</th>");
					}
					
					if($('#PP #ppCheck').length == 0 && "PP" == d.tmp1){
						$('.PP').css('display', '');
						$('#PP #name').append("<th id='ppCheck' rowspan='2'>날짜</th>");
					}
					
					var least1, least2;
					
					if(d.tmp1 == 'NC'){
						least1 = fnLeast(d.hgz, d.hge, d.hgn);
						least2 = fnLeast(d.hhz, d.hhe, d.hhn);
					}
					
					if(checkDate == d.date){
						/*상단 제목*/
						var obsName = d.obs_name;
						if(d.tmp1 == 'NC'){
							var th = $('<th>', {text : obsName, colspan : 2});
							th.click(function(){
								fnCallChart('R', list, d.station, obsName);
							});
							$('#'+ d.tmp1 + ' #name').append(th);
						}else{
							var th = $('<th>', {text : obsName});
							th.click(function(){
								fnCallChart('R', list, d.station, obsName);
							});
							$('#'+ d.tmp1 + ' #name').append(th);
						}
						$('#'+ d.tmp1 + ' #gChannel').append("<th>가속도</th>");
						if(d.tmp1 == 'NC'){
							$('#'+ d.tmp1 + ' #gChannel').append("<th>속도</th>");
						}
					}
					
					/*하단 데이터*/
					if($('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).length == 0){
						$('#'+ d.tmp1 + ' .rate-table-tbody').append("<tr id='"+d.date+"'>");
						$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td>"+d.date+"</td>");
					}
					
					
					if(d.tmp1 == 'NC'){
						
						if(least1 == "Z"){
							$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgz))+"; color: "+fnSetColor(Number(d.hgz))+";'>"+d.hgz+"("+least1+")"+"</td>");
						}else if(least1 == "E"){
							$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hge))+"; color: "+fnSetColor(Number(d.hge))+";'>"+d.hge+"("+least1+")"+"</td>");
						}else{
							$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgn))+"; color: "+fnSetColor(Number(d.hgn))+";'>"+d.hgn+"("+least1+")"+"</td>");
						}
						
						if(least2 == "Z"){
							$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hhz))+"; color: "+fnSetColor(Number(d.hhz))+";'>"+d.hhz+"("+least2+")"+"</td>");
						}else if(least1 == "E"){
							$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hhe))+"; color: "+fnSetColor(Number(d.hhe))+";'>"+d.hhe+"("+least2+")"+"</td>");
						}else{
							$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hhn))+"; color: "+fnSetColor(Number(d.hhn))+";'>"+d.hhn+"("+least2+")"+"</td>");
						}
					}else {
						var sensorLoc = d.station.substring(2,3);
						
						if(d.tmp1 == 'WP'){
							if(sensorLoc == 'M' || sensorLoc == 'R'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hdy))+"; color: "+fnSetColor(Number(d.hdy))+";'>"+d.hdy+"</td>");
							}else if(sensorLoc == 'B'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hdz))+"; color: "+fnSetColor(Number(d.hdz))+";'>"+d.hdz+"</td>");
							}else{
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgz))+"; color: "+fnSetColor(Number(d.hgz))+";'>"+d.hgz+"</td>");
							}
						}else{
							if(sensorLoc == 'M'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hpy))+"; color: "+fnSetColor(Number(d.hpy))+";'>"+d.hpy+"</td>");
							}else if(sensorLoc == 'B'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hpz))+"; color: "+fnSetColor(Number(d.hpz))+";'>"+d.hpz+"</td>");
							}else{
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgz))+"; color: "+fnSetColor(Number(d.hgz))+";'>"+d.hgz+"</td>");
							}
						}
					}
				});
				
			}
			
			function fnDrawMonthTable(list){
				var checkDate = '';
				
				var ncCheck = false;
				var wpCheck = false;
				var ppCheck = false;
				
				$('#NC #name').empty();
				$('#NC #gChannel').empty();
				$('#NC #channel').empty();
				
				$('#WP #name').empty();
				$('#WP #gChannel').empty();
				$('#WP #channel').empty();
				
				$('#PP #name').empty();
				$('#PP #gChannel').empty();
				$('#PP #channel').empty();
				$(list).each(function(i, d){
					if(i == 0){
						checkDate = d.date;
					}
					
					if($('#NC #ncCheck').length == 0 && "NC" == d.tmp1){
						$('.NC').css('display', '');
						$('#NC #name').append("<th id='ncCheck' rowspan='2'>날짜</th>");
					}
					
					if($('#WP #wpCheck').length == 0 && "WP" == d.tmp1){
						$('.WP').css('display', '');
						$('#WP #name').append("<th id='wpCheck' rowspan='2'>날짜</th>");
					}
					
					if($('#PP #ppCheck').length == 0 && "PP" == d.tmp1){
						$('.PP').css('display', '');
						$('#PP #name').append("<th id='ppCheck' rowspan='2'>날짜</th>");
					}
					
					if(checkDate == d.date){
						/*상단 제목*/
						var obsName = d.obs_name;
						if(d.tmp1 == 'NC'){
							var th = $('<th>', {text : obsName, colspan : 2});
							th.click(function(){
								fnCallChart('M', list, d.station, obsName);
							});
							$('#'+ d.tmp1 + ' #name').append(th);
						}else{
							var th = $('<th>', {text : obsName});
							th.click(function(){
								fnCallChart('M', list, d.station, obsName);
							});
							$('#'+ d.tmp1 + ' #name').append(th);
						}
						$('#'+ d.tmp1 + ' #gChannel').append("<th>가속도</th>");
						if(d.tmp1 == 'NC'){
							$('#'+ d.tmp1 + ' #gChannel').append("<th>속도</th>");
						}
					}
					
					/*하단 데이터*/
					if($('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).length == 0){
						$('#'+ d.tmp1 + ' .rate-table-tbody').append("<tr id='"+d.date+"'>");
						$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td>"+d.date+"</td>");
					}
					
					if(d.tmp1 == 'NC'){
						$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgz))+"; color: "+fnSetColor(Number(d.hgz))+";'>"+d.hgz+"</td>");
						$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hhz))+"; color: "+fnSetColor(Number(d.hhz))+";'>"+d.hhz+"</td>");
					}else{
						var sensorLoc = d.station.substring(2,3);
						
						if(d.tmp1 == 'WP'){
							if(sensorLoc == 'M' || sensorLoc == 'R'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hdy))+"; color: "+fnSetColor(Number(d.hdy))+";'>"+d.hdy+"</td>");
							}else if(sensorLoc == 'B'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hdz))+"; color: "+fnSetColor(Number(d.hdz))+";'>"+d.hdz+"</td>");
							}else{
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgz))+"; color: "+fnSetColor(Number(d.hgz))+";'>"+d.hgz+"</td>");
							}
						}else{
							if(sensorLoc == 'M'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hpy))+"; color: "+fnSetColor(Number(d.hpy))+";'>"+d.hpy+"</td>");
							}else if(sensorLoc == 'B'){
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hpz))+"; color: "+fnSetColor(Number(d.hpz))+";'>"+d.hpz+"</td>");
							}else{
								$('#'+ d.tmp1 + ' .rate-table-tbody #'+d.date).append("<td style='background-color: "+fnSetBackGroundColor(Number(d.hgz))+"; color: "+fnSetColor(Number(d.hgz))+";'>"+d.hgz+"</td>");
							}
						}
					}
				});
			}
			
			function fnCallChart(t, l, o, n){
				
				station = o;
				var list = [];
				$(l).each(function(i,d){
					if(d.station == o){
						list.push(d);
					}
				});
				$('.chart-area').html('');
				$('.chart-area').attr('id', o);
				$('.demo-container2').remove();
				if(t == 'R'){
					fnDrawDayChart(list, n);
				}if(t == 'M'){
					fnDrawMonthChart(list, n);
				}
				
			}
			
			function fnSetBackGroundColor(v){
				var color = "";
				if(v <= 95){
					color = "blue";
				}
				
				if(v <= 90){
					color = "red";
				}
				
				return color;
			}
			
			function fnSetColor(v){
				var color = "";
				if(v <= 95){
					color = "white";
				}
				
				if(v <= 90){
					color = "white";
				}
				
				return color;
			}
			
			function fnLeast(a, b, c){
				var a = Number(a);
				var b = Number(b);
				var c = Number(c);
				if(a > b){
					if(b > c){
						return "N";
					}else{
						return "E";
					}
				}else{
					if(a > c){
						return "N";
					}else{
						return "Z";
					}
				}
			}
			
			function fnDrawDayChart(list, name)
			{
				var options = 
				{
					lines: {
						show: true
					},
					points: {
						show: true
					},
					xaxis: {
						mode: "categories",
						tickLength: 0
						//rotateTicks: 135
					},
					yaxis: {
						min : 0,
						max : 100
					},
					series: {
						lines: {
							show: true
						},
						points: {
							show: true
						}
					},
					grid: {
						hoverable: true,
						clickable: true
					}
				};
				
				var chartDatas = [];
				var object = {};
				var date = '';
				var dataa = [];
				var datas = [];
				
				$(list).each(function(i, d){
					
					var least1 = fnLeast(d.hgz, d.hge, d.hgn);
					var least2 = fnLeast(d.hhz, d.hhe, d.hhn);
					
					if(i == 0){
						date = d.date;
					}
					if(d.tmp1 == 'NC'){
						
						if(least1 == "Z"){
							dataa.push([d.date, d.hgz]);
						}else if(least1 == "E"){
							dataa.push([d.date, d.hge]);
						}else{
							dataa.push([d.date, d.hgn]);
						}
					
						if(least2 == "Z"){
							datas.push([d.date, d.hhz]);
						}else if(least1 == "E"){
							datas.push([d.date, d.hhe]);
						}else{
							datas.push([d.date, d.hhn]);
						}
					}else{
						var sensorLoc = d.station.substring(2,3);
						if(d.tmp1 == 'WP'){
							if(sensorLoc == 'M' || sensorLoc == 'R'){
								dataa.push([d.date, d.hdy]);
							}else if(sensorLoc == 'B'){
								dataa.push([d.date, d.hdz]);
							}else{
								dataa.push([d.date, d.hgz]);
							}
						}else{
							if(sensorLoc == 'M'){
								dataa.push([d.date, d.hpy]);
							}else if(sensorLoc == 'B'){
								dataa.push([d.date, d.hpz]);
							}else{
								dataa.push([d.date, d.hgz]);
							}
						}
					}
					
					if((i+1) == list.length){
						object.label = "가속도";
						object.data = dataa;
						chartDatas.push(object);
						object = {};
						if(d.tmp1 == 'NC'){
							object.label = "속도";
							object.data = datas;
							chartDatas.push(object);
							object = {};
						}
					}
					
				});
				
				var chartdaydiv = $("<div>",{class : "demo-placeholder2", id : 'rate_day_chart'});
				var daytitlediv = $("<div>",{class: "f20" ,style : "width : 100%;", text : name +" 수집률 그래프(일일)"});
				var daydiv = $("<div>",{class : "demo-container2", style : "width : 100%;"});
				
				chartdaydiv.bind("plothover", function (event, pos, item) {
					if (item) {
						var x = item.series.data[item.datapoint[0]][0],
						y = item.datapoint[1].toFixed(2);
						
						$("#tooltip").html(item.series.label + " = " + x + " , " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
					} else {
						$("#tooltip").hide();
					}
				});

				daydiv.append(chartdaydiv.show());

				$('.chart-area').append(daytitlediv);
				$('.chart-area').append("</br></br>");
				$('.chart-area').append(daydiv);

				$.plot("#rate_day_chart", chartDatas, options);
			}
			
			function fnDrawMonthChart(list, name)
			{
				
				var options = {
					lines: {
						show: true
					},
					points: {
						show: true
					},
					xaxis: {
						mode: "categories",
						tickLength: 0
						//rotateTicks: 135
					},
					yaxis: {
						min : 0,
						max : 100
					},
					series: {
						lines: {
							show: true
						},
						points: {
							show: true
						}
					},
					grid: {
						hoverable: true,
						clickable: true
					}
				};
				
				var chartDatas = [];
				var object = {};
				var date = '';
				var dataa = [];
				var datas = [];
				
				$(list).each(function(i, d){
					
					if(i == 0){
						date = d.date;
					}
					
					
					if(d.tmp1 == 'NC'){
						dataa.push([d.date, d.hgz]);
						datas.push([d.date, d.hhz]);
					}else{
						var sensorLoc = d.station.substring(2,3);
						
						if(d.tmp1 == 'WP'){
							if(sensorLoc == 'M' || sensorLoc == 'R'){
								dataa.push([d.date, d.hdy]);
							}else if(sensorLoc == 'B'){
								dataa.push([d.date, d.hdz]);
							}else{
								dataa.push([d.date, d.hgz]);
							}
						}else{
							if(sensorLoc == 'M'){
								dataa.push([d.date, d.hpy]);
							}else if(sensorLoc == 'B'){
								dataa.push([d.date, d.hpz]);
							}else{
								dataa.push([d.date, d.hgz]);
							}
						}
					}
					
					
					if((i+1) == list.length){
						object.label = "가속도";
						object.data = dataa;
						chartDatas.push(object);
						object = {};
						if(d.tmp1 == 'NC'){
							object.label = "속도";
							object.data = datas;
							chartDatas.push(object);
							object = {};
						}
					}
					
				});
				
				var chartmonthdiv = $("<div>",{class : "demo-placeholder2", id : 'rate_month_chart'});
				var monthtitlediv = $("<div>",{class: "f20" ,style : "width : 100%;", text : name + " 수집률 그래프(월별)"});
				var monthdiv = $("<div>",{class : "demo-container2", style : "width : 100%;"});
				
				chartmonthdiv.bind("plothover", function (event, pos, item) {
					if (item) {
						var x = item.series.data[item.datapoint[0]][0],
						y = item.datapoint[1].toFixed(2);
						
						$("#tooltip").html(item.series.label + " = " + x + " , " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
					} else {
						$("#tooltip").hide();
					}
				});
				
				monthdiv.append(chartmonthdiv.show());
				
				$('.chart-area').append(monthtitlediv);
				$('.chart-area').append("</br></br>");
				$('.chart-area').append(monthdiv);
				
				$.plot("#rate_month_chart", chartDatas, options);
			}
			
			function fnString(arg)
			{
				return Number(arg);
			}
			
			/* function fnDrawYearCheckChart(datasets)
			{
				var chart_datasets = [];
				var hide_datasets = [];
				
				datasets.forEach(function(data, i){
					var data_obj = {};
					var data_set = [];
					var start_set = [];
					var end_set = [];
					var hide_data = [];
					
					var start_p = parseFloat(data.tmp1);
					var end_p = parseFloat(data.tmp2);
					
					if((start_p == end_p))
					{
						start_set.push(start_p);
						start_set.push(parseInt(data.month));
						
						data_set.push(start_set);
						hide_data.push(data.tmp3);
						
						data_obj["data"] = data_set;
						data_obj["color"] = "red";
						
						chart_datasets.push(data_obj);
						
						hide_datasets.push(hide_data);
					}
					else if(start_p != end_p)
					{
						start_set.push(start_p);
						start_set.push(parseInt(data.month));
						
						end_set.push(end_p);
						end_set.push(parseInt(data.month));
						
						data_set.push(start_set);
						data_set.push(end_set);
						
						hide_data.push(data.tmp3);
						hide_data.push(data.tmp4);
						
						data_obj["data"] = data_set;
						data_obj["color"] = "red";
						
						chart_datasets.push(data_obj);
						
						hide_datasets.push(hide_data);
					}
				});
				
				var dayoptions = 
				{
					xaxis: {
						min : 1,
						max : 31,
						tickSize : 1,
						tickFormatter : fnString
					},
					yaxis: {
						min : 1,
						max : 12,
						tickSize : 1
					},
					series: {
						lines: {
							show: true
						},
						points: {
							show: true
						}
					},
					grid: {
						hoverable: true,
						clickable: true
					},
					hidedata : hide_datasets
				};
				
				var chartdaydiv = $("<div>",{class : "demo-placeholder2", id : 'rate_day_chart'});
				
				chartdaydiv.bind("plothover", function (event, pos, item) {
					
					if (item) {
						$("#tooltip").html(item.hidedata).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
					} else {
						$("#tooltip").hide();
					}
				});
				
				var daytitlediv = $("<div>",{class: "f20" ,style : "width : 100%;", text : "연간 그래프"});
				var daydiv = $("<div>",{class : "demo-container2", style : "width : 1000%;"});
				
				daydiv.append(chartdaydiv.show());

				$('.chart-area').append(daytitlediv);
				$('.chart-area').append("</br></br>");
				$('.chart-area').append(daydiv);
				$.plot("#rate_day_chart", chart_datasets, dayoptions);
				
			} */
			
			function fnDrawDayCheckChart(datasets)
			{
				
				var chart_datasets = [];
				
				$(datasets).each(function(i, data){
					var data_obj = {};
					var data_set = [];
					var start_set = [];
					var end_set = [];
					
					var start_h = Number(data.tmp1);
					var start_m = Number(data.tmp2);
					var end_h = Number(data.tmp3);
					var end_m = Number(data.tmp4);
					
					if((start_h == end_h) && (start_m == end_m))
					{
						start_set.push(start_m);
						start_set.push(start_h);
						
						data_set.push(start_set);
						
						data_obj["data"] = data_set;
						data_obj["color"] = "red";
						
						chart_datasets.push(data_obj);
					}
					else if((start_h == end_h) && (start_m != end_m))
					{
						start_set.push(start_m);
						start_set.push(start_h);
						
						end_set.push(end_m);
						end_set.push(end_h);
						
						data_set.push(start_set);
						data_set.push(end_set);
						
						data_obj["data"] = data_set;
						data_obj["color"] = "red";
						
						chart_datasets.push(data_obj);
					}
					else if((start_h != end_h) && (start_m != end_m))
					{
						start_set.push(start_m);
						start_set.push(start_h);
						
						end_set.push(60);
						end_set.push(start_h);
						
						data_set.push(start_set);
						data_set.push(end_set);
						
						data_obj["data"] = data_set;
						data_obj["color"] = "red";
						
						chart_datasets.push(data_obj);
						
						for(var i =start_h+1; i < end_h; i ++){
							start_set.push(0);
							start_set.push(start_h);
							
							end_set.push(60);
							end_set.push(start_h);
							
							data_set.push(start_set);
							data_set.push(end_set);
							
							data_obj["data"] = data_set;
							data_obj["color"] = "red";
							
							chart_datasets.push(data_obj);
						}
						
						start_set = [];
						end_set = [];
						data_set = [];
						data_obj = {};
						
						start_set.push(0);
						start_set.push(end_h);
						
						end_set.push(end_m);
						end_set.push(end_h);
						
						data_set.push(start_set);
						data_set.push(end_set);
						
						data_obj["data"] = data_set;
						data_obj["color"] = "red";
						
						chart_datasets.push(data_obj);
					}
				});
				
				var dayoptions = 
				{
				
					xaxis: {
						min : 0,
						max : 60,
						tickSize : 10
					},
					yaxis: {
						min : 0,
						max : 24,
						tickSize : 1
					},
					series: {
						lines: {
							show: true
						},
						points: {
							show: true
						}
					},
				};
				
				var chartdaydiv = $("<div>",{class : "demo-placeholder2", id : 'rate_day_chart'});
				var daytitlediv = $("<div>",{class: "f20" ,style : "width : 100%;", text : "일일 그래프"});
				var daydiv = $("<div>",{class : "demo-container2", style : "width : 100%;"});
				
				daydiv.append(chartdaydiv.show());

				$('.chart-area').append(daytitlediv);
				$('.chart-area').append("</br></br>");
				$('.chart-area').append(daydiv);
				$.plot("#rate_day_chart", chart_datasets, dayoptions);
			}
			
			function fnChangeDate(arg)
			{
				if("D" == arg )
				{
					$('.day').hide();
					$('.year').show();
				}
				else
				{
					$('.year').hide();
					$('.day').show();
				}
			}
			
			function fnGetTable(){
				if($(".demo-container2")){
					$("#chartSta").val($(".chart-area").attr("id"));
				}
				$(".search-form").attr('action','${pageContext.request.contextPath}/inforeceived/datacollrate/getExcel.do').submit();
			}
		</script>
	</head>
	<body class="sBg">
		<form name="frm" method="post">
			<input type="hidden" name="excel_data" />
		</form>
		<div id="wrap">
			<section class="con_title">
				<!--��������-->
				<p class="sTit">원시데이터 수집률</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>데이터수신현황</li>
					<li class="addNow">원시데이터 수집률</li>
				</ul>
			</section>
			<section class="con_body">
				<!--���ùڽ�-->
				<form class="search-form" name="searchForm" method="post" autocomplete="off" enctype="multipart/form-data">
					<article class="selectbox_long">
						<ul style="width : 100%;">
							<li style="padding:0 2px;">관측소
								<select id = "sch_sta_type" name="sch_sta_type" style="width : 200px;">
									<option value ="" selected>===========</option>
								</select>
								<input type="hidden" id="chartSta" name="chartSta" />
							</li>
							<li class="day" style="padding:0 2px;">
								기간 <input type="text" id="sch_date_s" name="sch_date_s" value="" style="width:195px;"/> - <input type="text" id="sch_date_e" name="sch_date_e" value="" style="width:195px;"/>
							</li>
							<li class="year">날짜
								<input type="text" id="sch_date_y" name="sch_date_y" value="" />
							</li>
							<li class="btt_excel"><a onclick="fnGetTable(1);">엑셀다운로드</a></li>
							<li class="btt_filecomplt" style="top:0px;"><a style="float:right;" onclick="fnGetDataCollRateTable();">자료확인</a></li>
							<li style="padding:0 2px; ">
								<label style="margin-top: 10px;"><input type="radio" id="sch_type" name="sch_type" value="R" style="height: 22px; width: 50px;" onclick="fnChangeDate(this.value);"/>수집률(일)</label>
								<label style="margin-top: 10px;"><input type="radio" id="sch_type" name="sch_type" value="M" style="height: 22px; width: 50px;" onclick="fnChangeDate(this.value);"/>수집률(월)</label>
								<label style="margin-top: 10px;"><input type="radio" id="sch_type" name="sch_type" value="D" style="height: 22px; width: 50px;" onclick="fnChangeDate(this.value);"/>누수율</label>
							</li>
						</ul>
					</article>
				</form>
				<div id="excel_body">
					<article class="s_table3 NC" style="overflow: auto;">
						<table id="NC">
							<thead>
								<tr class="topBgline" id="name">
								</tr>
								<tr id="gChannel">
								</tr>
								<tr id="channel"></tr>
							</thead>
							<tbody class="rate-table-tbody"></tbody>
						</table>
					</article>
					<article class="s_table3 WP" style="overflow: auto;">
						<table id="WP">
							<thead>
								<tr class="topBgline" id="name">
								</tr>
								<tr id="gChannel">
								</tr>
								<tr id="channel"></tr>
							</thead>
							<tbody class="rate-table-tbody"></tbody>
						</table>
					</article>
					<article class="s_table3 PP" style="overflow: auto;">
						<table id="PP">
							<thead>
								<tr class="topBgline" id="name">
								</tr>
								<tr id="gChannel">
								</tr>
								<tr id="channel"></tr>
							</thead>
							<tbody class="rate-table-tbody"></tbody>
						</table>
					</article>
					<div class="chart-area" style="clear: both;"></div>
				</div>
			</section>
		</div>
	</body>
</html>