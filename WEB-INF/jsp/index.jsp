
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		<link href="<c:url value="/css/index_mapicons.css"/>" rel="stylesheet" type="text/css" />
		<%-- <link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" /> --%>
		<style>
		.imgSelect {
			cursor: pointer;
		}
		
		#map_tool_tip{position:absolute;top:0;left:0;width:240px;overflow:hidden;display: none;}
		#map_tool_tip div {position: absolute;top: 5px;right: 5px}
		#map_tool_tip .map_bg_top{width:240px;background:url(/NMS/img/tootip_top_bg.png)no-repeat;height:28px;}
		#map_tool_tip .map_bg_midd{width:240px;background:url(/NMS/img/tootip_midd_bg.png)repeat-y;height:100%;}
		#map_tool_tip .map_bg_bottom{width:240px;background:url(/NMS/img/tootip_bottom_bg.png)no-repeat;height:12px;}
		#map_tool_tip table{clear:both;position:relative;margin:0 auto;width:90px;width:94%;}
		#map_tool_tip table thead{border-top:2px solid #12a3cc;height:22px;background:#e4f0fa;}
		#map_tool_tip table tbody tr{border-top:1px solid #d4d9da;border-bottom:1px solid #d4d9da;}
		#map_tool_tip table tbody td{text-align:center;font-size:11px;color:#696969;height:24px;line-height:24px;} 
		#map_tool_tip table thead th{text-align:center;font-size:12px;font-weight:bold;color:#4d72a6;height:24px;line-height:24px;}	
		#map_tool_tip .top_con_button{width:230px;height:24px;text-align:right;background:url(/NMS/img/tootip_img.gif) no-repeat right;}
		#map_tool_tip .top_con_button button{display:inline-block;width:20px;height:20px;text-indent:-9999px;border:none;font-size:15px;background:none;}
		</style>
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.validate.js" />"></script>
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js" />"></script>
		<script type="text/javascript">
		$(document).ready(function(){
			post('/NMS/getMainQuakeEventList.ws', '', fnDrawTable, fnError);
			
		});
		function closeLayer( obj ) {
			$('#map_tool_tip').hide();
		}
		
		function fnTooltip(origintime, lat, rlong, mag){
			var clientX = event.clientX;
			var clientY = event.clientY;
			
			var sWidth = window.innerWidth;
			var sHeight = window.innerHeight;

			var oWidth = $('#map_tool_tip').width();
			var oHeight = $('#map_tool_tip').height();

			// 레이어가 나타날 위치를 셋팅한다.
			var divLeft = clientX + 10;
			var divTop = clientY + 5;

			// 레이어가 화면 크기를 벗어나면 위치를 바꾸어 배치한다.
			if( divLeft + oWidth > sWidth ) divLeft -= oWidth;
			if( divTop + oHeight > sHeight ) divTop -= oHeight;

			// 레이어 위치를 바꾸었더니 상단기준점(0,0) 밖으로 벗어난다면 상단기준점(0,0)에 배치하자.
			if( divLeft < 0 ) divLeft = 0;
			if( divTop < 0 ) divTop = 0;

			$('#map_tool_tip').css({
				"top": divTop,
				"left": divLeft - 50,
				"position": "absolute"
			}).show();
			
			$('#map_tool_tip #origintime').text(origintime);
			$('#map_tool_tip #lat').text(lat);
			$('#map_tool_tip #rlong').text(rlong);
			$('#map_tool_tip #mag').text(mag);
		}
		
		function fnDrawTable(res)
		{
			$('#dataTable').html('');
			var data = res.data;
			
			document.getElementById("m_map").innerHTML = '';
			
			$(data).each(function(i, data){
				var targetTop = fnCalTop(Number(data.lat));
				var targetLeft = fnCalLeft(Number(data.rlong));
				
				if(!(targetTop < 0 || targetLeft < 0 || targetTop > 500 || targetLeft > 500))
				{
					var n_mag = quakeScale(Number(data.mag));
					var div_won = "<div id ='won_"+n_mag+"' style ='-webkit-transform:translate("+targetLeft+"px,"+targetTop+"px); -ms-transform:translate("+targetLeft+"px,"+targetTop+"px); transform:translate("+targetLeft+"px,"+targetTop+"px);' onclick='fnTooltip(\""+data.origintime+"\", \""+data.lat+"\", \""+data.rlong+"\", \""+Number(data.mag)+"\")'></div>";
					document.getElementById("m_map").innerHTML = document.getElementById("m_map").innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'>"+div_won+"</li></ul>";
				}
				
				var tr = $('<tr>');
				var td1 = $('<td>', {text : data.origintime});
				var td2 = $('<td>', {text : data.lat});
				var td3 = $('<td>', {text : data.rlong});
				var td4 = $('<td>', {text : Number(data.mag)});
				var td5 = $('<td>', {text : data.origin_area});
				
				tr.append(td1);
				tr.append(td2);
				tr.append(td3);
				tr.append(td4);
				tr.append(td5);
				
				$('#dataTable').append(tr);
			});
		}
		
		function fnError(res)
		{
			console.log(res);
		}
		</script>
	</head>
	
	<body>
		<section class="con_body">
			<!--지도-->
			<article class="con_left">
				<p class="m_text"></p>
				<p id="m_map" class="m_map"></p>
			</article>
			<!--상단::검색-->
			<article class="con_right">
				<ul class="m_icon">
					<li class="mcon1"><a href="<c:url value="/monitoring/datareceived/list"/>">데이터 수신현황</a></li>
					<li class="mcon2"><a href="<c:url value="/monitoring/wave/list"/>">파형 모니터링</a></li>
					<li class="mcon3"><a href="<c:url value="/quakeoccur/quakeinfo/list"/>">지진 발생정보</a></li>
					<li class="mcon4"><a href="<c:url value="/report/quakeanalysis/list"/>">지진 분석현황</a></li>
				</ul>
				<section class="m_table">
					<p class="m_more"><a href="<c:url value="/quakeoccur/distribution/list"/>">more</a></p>
					<table>
						<caption>지진발생현황</caption>
							<colgroup>
								<col style="width:35%" />
								<col style="width:10%" />
								<col style="width:10%" />
								<col style="width:5%" />
								<col style="width:40%" />
							</colgroup>
						<thead>
							<tr>
								<th>지진발생 시간(진원시:KST)</th>
								<th>위도</th>
								<th>경도</th>
								<th>규모</th>
								<th>위치</th>
							</tr>
						</thead>
						<tbody id="dataTable">
							
						</tbody>
					</table>
				</section>
			</article>
		</section>
		<div id="map_tool_tip">
			<ul>
				<li class="map_bg_top"></li>
				<li class="map_bg_midd">
					<!--내용-->
					<article class="top_con_button">
						<button type="button" class="close" onclick="closeLayer(this)">닫기</button>
					</article>
					<table>
						<colgroup>
							<col style="width:46%" />
							<col style="width:18%" />
							<col style="width:18%" />
							<col style="width:18%" />
						</colgroup>
						<thead>
							<tr>
								<th>진원시(KST)</th>
								<th>위도</th>
								<th>경도</th>
								<th>규모</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td id="origintime"></td>
								<td id="lat"></td>
								<td id="rlong"></td>
								<td id="mag"></td>
							</tr>
						</tbody>
					</table>
					<!--//내용 끝-->
				</li>
				<li class="map_bg_bottom"></li>
			</ul>
		</div>
	</body>
</html>