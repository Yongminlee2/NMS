<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		<link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />
		<script src="<c:url value="/js/jquery/jquery.flot_wave.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.time.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.axislabels.js"/>"></script>
		<script src="<c:url value="/js/vertx/socket.io.js"/>"></script>
		<!-- Modernizr -->
		<title>한국수력원자력::모니터링 소프트웨어</title>
		<script type="text/javascript">
		//var socket = io.connect("http://192.168.50.3:1809");
		var socket = io.connect("http://121.66.142.174:1809");
		
		var options = {
				series: {
					shadowSize: 0	// Drawing is faster without shadows
				},
				xaxis: { mode: "time",
						tickFormatter: function (v, axis) {
							
							var date = new Date(v);
							if (date.getSeconds() % 30 == 0) {
								var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
								var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
								
								return minutes + ":" + seconds;
							} else {
								return "";
							} 
						}
					},
				yaxis: {
					min : 0,
					labelPadding: 7
				},
				autoscale : true,
				legend: {backgroundColor:"#ffffff"}
			}; 
		
		$(document).ready(function(){
			$('.demo-container').hide();
			$.plot("#pga_chart_dummy", [], options);
			
			var chartObject = window.opener.chartObject;
			$(chartObject).each(function(index) {
				socket.emit('chartroomjoin', {room : $(this).attr('id'), name : $(this).attr('obsname')});
			}); 
			
			socket.on('chartroomjoinok', function(res){
				if(res.result =='ok')
				{
					socket.emit('wavechartalldatareq', {room : res.staType, name : res.name});
				}
			});
			
			socket.on('wavechartalldatares', function(res){
				fnDrawChart(res);
				res = null;
			}); 
			
			socket.on('wavechartdatares', function(res){
				fnSetPGAData(res);
				res = null;
			});
		});
		
		function fnDrawChart(response)
		{
			$("div[name=pga_"+response.staType+"]").remove();
			$("h3[name=pga_"+response.staType+"]").remove();
			
			var chartData = eval(response.data);
			var data_z = [];
			var data_n = [];
			var data_e = [];
			var data_twod = [];
			var data_threed = [];
			
			var now = Math.abs(Number(chartData[0].epochtime));
			var chk = 200;
			
			for(var i = 0; i < 200; i ++)
			{
				data_z.push([(now - (chk-i))*1000, 0]);
				data_n.push([(now - (chk-i))*1000, 0]);
				data_e.push([(now - (chk-i))*1000, 0]);
				data_twod.push([(now - (chk-i))*1000, 0]);
				data_threed.push([(now - (chk-i))*1000, 0]);
			}
			
			var dataset = 
				[
					{
						label: "Z",
						data: data_z
					}, {
						label: "N",
						data: data_n
					}, {
						label: "E",
						data: data_e
					}, {
						label: "2D",
						data: data_twod
					}, {
						label: "3D",
						data: data_threed
					}
				];
			
			var dummy = $('#pga_chart_dummy').clone(true);
			dummy.attr('id', "pga_"+response.staType);
			dummy.attr('class', 'demo-placeholder');
			var chkDummy = $('#choices').clone(true);
			chkDummy.attr('id', 'chk_'+response.staType);
			
			$.each(dataset, function(key, val) {
				
				var checkString = "checked='checked'";
				/* 
				if(val.label == "2D" || val.label == "3D"){
					checkString ="";
				} */
				
				chkDummy.append("<input type='checkbox' name='chk_" + val.label +
					"' "+checkString+" id='id_chk_" + val.label + "' onclick=\"fnChartClick("+"'"+response.staType+"', 'chk_"+val.label+"')\"></input>&nbsp;&nbsp;" +
					"<label for='id_chk_" + val.label + "'>"
					+ val.label + "</label>&nbsp;&nbsp;");
			});
			
			var h3 = $("<h3>", {text : response.name, name : 'pga_'+response.staType, style:'margin-top :5px;margin-left:11px;'});
			var div = $("<div>",{class : "demo-container", name : 'pga_'+response.staType, id : "chkval"});
			
			div.append(chkDummy.show());
			div.append(dummy.show());
			
			$('.chart-area').append(h3);
			$('.chart-area').append(div);
			
			$.plot("#pga_"+response.staType, dataset, options);
			
			socket.emit('wavechartdatareq', {room : response.staType});
			
			$('#id_chk_2D').click();
			$('#id_chk_3D').click();
		}
		
		function fnSetPGAData(response){
			var chartData = eval(response.data);
			var chartObj = $.data($("#" + "pga_"+response.staType+".demo-placeholder")[0], "plot");
			
			var datasets = chartObj.getData();
			var chartLastTime = datasets[0].data[datasets[0].data.length-1][0];
			var nowTime = Math.abs(Number(chartData[0].epochtime)) * 1000;
			
			datasets[0].data = datasets[0].data.slice(1);
			datasets[1].data = datasets[1].data.slice(1);
			datasets[2].data = datasets[2].data.slice(1);
			datasets[3].data = datasets[3].data.slice(1);
			datasets[4].data = datasets[4].data.slice(1);
			
			datasets[0].data[datasets[0].data.length] = [nowTime, Number(chartData[0].pga_z)];
			datasets[1].data[datasets[1].data.length] = [nowTime, Number(chartData[0].pga_n)];
			datasets[2].data[datasets[2].data.length] = [nowTime, Number(chartData[0].pga_e)];
			datasets[3].data[datasets[3].data.length] = [nowTime, Number(chartData[0].pga_2d)];
			datasets[4].data[datasets[4].data.length] = [nowTime, Number(chartData[0].pga_3d)];
			
			chartObj.setData(datasets); 
			
			chartObj.setupGrid(); 
			chartObj.draw();
			
			chartLastTime = null;
			datasets = null;
			chartObj = null;
			
			chartData = null;
			response = null;
			
		}
		
		function fnChartClick(id, chkid)
		{
			var chartObj = $.data($("#" + "pga_"+id+".demo-placeholder")[0], "plot");
			
			var datasets = chartObj.getData();
			
			var data = [];
			var choiceContainer = $('#chk_'+id);
			if(choiceContainer.find("input:checked").length != 0)
			{
				$(datasets).each(function (){
					if(chkid == 'chk_'+$(this).attr("label"))
					{
						if(choiceContainer.find('#id_'+chkid).is(":checked"))
						{
							$(this)[0].lines.show = true;
						}
						else
						{
							$(this)[0].lines.show = false;
						}
					}
					
				});
				chartObj.setData(datasets); 
				
				chartObj.setupGrid(); 
				chartObj.draw();
			}
			else
			{
				choiceContainer.find('#id_'+chkid).prop("checked", true);
			}
			
		}
		</script>
	</head>
	<body>
		<div>
			<section>
				<!--표 1-->
				<article>
					<section>
						<div class="chart-area" style="clear: both;"></div>
						<div id="dummy-div" class="demo-container">
							<p id="choices" style="width:200px; float: right; text-align: right;"></p>
							<div id="pga_chart_dummy" class="demo-placeholder" style="float:left;"></div>
						</div>
					</section>
				</article>
			</section>
		</div>
	</body>
</html>



