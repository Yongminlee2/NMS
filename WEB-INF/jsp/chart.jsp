<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%= JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %></title>
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
		<meta charset="utf-8">
		<link href="<c:url value='/css/examples.css'/>" rel="stylesheet">
		<script src="<c:url value="/js/jquery/jquery.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script type="text/javascript">

			$(function() {
				var data = [],
					totalPoints = 299;
				
				if (data.length > 0)
					data = data.slice(1);
				
				while (data.length < 299) {
					data.push(-1);
				}
				
				function setPGAData(response){
					if (data.length > 0)
						data = data.slice(1);
					
					data.push(response);
					
					var res = [];
					for (var i = 0; i < data.length; ++i) {
						res.push([i, data[i]]);
					}
					
					plot.setData([res]);
					var opts = plot.getOptions();
					
					// Since the axes don't change, we don't need to call plot.setupGrid()
					plot.setupGrid();
					plot.draw();
					
					setTimeout(getPGAData, 800);
				}
	
				var plot = $.plot("#placeholder", [ ], {
					series: {
						shadowSize: 0	// Drawing is faster without shadows
					},
					xaxis: {
						show: false
					},
					yaxis: {
						min : 0
					},
					autoscale : true
				});
				
				function getPGAData()
				{
					post('/NMS/datas.ws', '', setPGAData, fnFail);
				}
				
				getPGAData();
				
				function fnFail()
				{
					console.log('실패');
				}

			});
	
		</script>
	</head>
	<body>
		<tag:code type="combo" grpCd="stationList" id="sch_dispStatus" name="sch_dispStatus" defaultTxt="전체"  style="width:200px"/> 
		<div id="content">
			<select id="station">
				<option value="st01">st01</option>
			</select>
			<div class="demo-container">
				<div id="placeholder" class="demo-placeholder"></div>
			</div>
		</div>
	</body>
</html>