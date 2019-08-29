<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<c:url value="/css/wave_mapicons.css"/>" rel="stylesheet" type="text/css" />
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/vertx/socket.io.js"/>"></script>
		<title>한국수력원자력::모니터링 소프트웨어</title>
		<script type="text/javascript">
			//var socket = io.connect("http://192.168.50.3:1809");
			var socket = io.connect("http://121.66.142.174:1809");
			var mapType = 'AL';
			var mapIconType = 9;
			$(document).ready(function(){
				post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
				
				socket.emit('maproomjoin', {room : 'data_'+mapType});
				socket.on('maproomjoinok', function(res){
					if(res =='ok')
					{
						socket.emit('datareceiveddatareq', {room : 'data_'+mapType});
					}
				});
				
				socket.on('datareceiveddatares', function(res){
					fnDataReceviedTable(eval(res.data));
					res = null;
				});
			});
			
			function fnDataReceviedTable(dataSets)
			{
				var cnt = 1;
				
				dataSets.forEach(function (datas, i){
					var normal = 0;
					var delay = 0;
					var all = dataSets[i].length;
					
					datas.forEach(function (data){
						
						if(data["epochtime"] >= 0 && data["epochtime"] <= 10)	{normal = normal + 1;}
						else if(data["epochtime"] >= 11 && data["epochtime"] <= 30) {delay = delay +1;}
						
						if(mapIconType == 9)
						{
							fnDrawMapIcon(data);
						}else if(mapIconType != 9 && i == mapIconType){
							fnDrawMapIcon(data);
						}
						
						cnt ++;
						
						data = null;
					});
					
					$('.normal_'+i).text(normal);
					$('.delay_'+i).text(delay);
					$('.rest_'+i).text(all - normal - delay);
					$('.all_'+i).text(all);
					
				});
				
				$('.normal_4').text(0);
				$('.delay_4').text(0);
				$('.rest_4').text(0);
				$('.all_4').text(0);
				
				dataSets = null;
				
			}
			
			function fnDrawMapIcon(response)
			{
				var divElement = document.getElementById(response.tablename.replace('_g',''));
				var tdElement = document.getElementById('td_'+response.tablename.replace('_g',''));
				
				
				if('#FB3A31' == response.color){
					tdElement.innerHTML = '미수신';
				}else{
					tdElement.innerHTML = '';
				}
				
				if("WP" == response.maptype){
					divElement.style.borderBottom = '14px solid' +response.color;
				}
				else{
					divElement.style.backgroundColor = response.color;
				}
				divElement = null;
				
				response = null;
			}
			
			function fnSetStationList(response)
			{
				var mapLayout = document.getElementById("map_layout");
				var targetTbody = document.getElementById("dataReceivedTbody");
				targetTbody.innerHTML = '';
				mapLayout.innerHTML = '';
				$.each(response.data, function(key, stationInfo) {
					var trClass=''; 
					if(mapType == 'AL'){
						stationInfo.top = fnCalTopRecevied(Number(stationInfo.lat));
						stationInfo.left = fnCalleftRecevied(Number(stationInfo.lon));
						stationInfo.obstype = stationInfo.sta_tmp1;
						fnSetMapIcon(mapLayout, stationInfo);
						
						if(key%2 == 0)
						{
							trClass = "bg_gray2";
						}
						html = "<tr class='"+trClass+"'>";
						html += "<th>"+(Number(key)+1)+"</th>";
						html += "<td>"+stationInfo.obs_kind_name+"</td>";
						html += "<td>"+stationInfo.obs_name+"</td>";
						html += "<td>"+stationInfo.net_name+"</td>";
						html += "<td>"+parseFloat(stationInfo.lat).toFixed(2) +"</td>";
						html += "<td>"+parseFloat(stationInfo.lon).toFixed(2) +"</td>";
						html += "<td>"+stationInfo.altitude +"</td>";
						html += "<td id='td_"+stationInfo.sta_type+"'></td>";
						html += "</tr>";
						
						targetTbody.innerHTML = targetTbody.innerHTML + html;
						
					}else {
						if(mapType == stationInfo.sta_tmp1){
							stationInfo.top = fnCalTopRecevied(Number(stationInfo.lat));
							stationInfo.left = fnCalleftRecevied(Number(stationInfo.lon));
							stationInfo.obstype = stationInfo.sta_tmp1;
							fnSetMapIcon(mapLayout, stationInfo);
							
							if(key%2 == 0)
							{
								trClass = "bg_gray2";
							}
							html = "<tr class='"+trClass+"'>";
							html += "<th>"+(Number(key)+1)+"</th>";
							html += "<td>"+stationInfo.obs_kind_name+"</td>";
							html += "<td>"+stationInfo.obs_name+"</td>";
							html += "<td>"+stationInfo.net_name+"</td>";
							html += "<td>"+parseFloat(stationInfo.lat).toFixed(2) +"</td>";
							html += "<td>"+parseFloat(stationInfo.lon).toFixed(2) +"</td>";
							html += "<td>"+stationInfo.altitude +"</td>";
							html += "<td id='td_"+stationInfo.sta_type+"'></td>";
							html += "</tr>";
							
							targetTbody.innerHTML = targetTbody.innerHTML + html;
						}
					}
				});
			}
			
			function fnSetMapIcon(mapLayout, stationInfo)
			{
				mapLayout.innerHTML = mapLayout.innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'><div class='"+stationInfo.obstype+"' id='"+stationInfo.sta_type+"' sta_id ='"+stationInfo.obs_id+"' obs_name ='"+stationInfo.obs_name+"' style =' -webkit-transform:translate("+stationInfo.left+"px,"+stationInfo.top+"px); -ms-transform:translate("+stationInfo.left+"px,"+stationInfo.top+"px); transform:translate("+stationInfo.left+"px,"+stationInfo.top+"px);' onclick='fnStaPop(this);'></div></li></ul>"; 
			}
			
			
			function setMapIcon(type)
			{
				mapIconType = type;
				var className = [".mapbtt2", ".mapbtt3", ".mapbtt4", ".mapbtt5", ".mapbtt6", "", "", "", "", ".mapbtt1"];
				var imageName = ["btt_map_02_o.jpg", "btt_map_03_o.jpg", "btt_map_04_o.jpg", "btt_map_05_o.jpg", "btt_map_06_o.jpg", "", "", "", "", "btt_map_01_o.jpg"];
				var dataName = ["NC", "WP", "PP", "GO", "CJ", "", "", "", "", "AL"];
				
				socket.emit('maproomout', {room : 'data_'+mapType});
				mapType = dataName[type];
				socket.emit('maproomjoin', {room : 'data_'+mapType});
				
				var chk = $(className[type]).css('background');
				
				className.forEach(function(data, i){
					if(data != "")
					{
						$(className[i]).css('background', 'url(${pageContext.request.contextPath}/img/'+imageName[i].replace('_o', '')+') no-repeat');
					}
				});
				
				$(className[type]).css('background', 'url(${pageContext.request.contextPath}/img/'+imageName[type]+') no-repeat');
				
				post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
				
				$(".chart-area").empty();
			}
			
			function fnStaPop(o)
			{
				var title = "stationInfo";
				var url = "${pageContext.request.contextPath}/monitoring/datareceived/popup";
				var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=1100, height=520";
				
				window.open("", title, status);
				var frm = $("<form>", {action : url, method : "POST", target : title});
				var input = $("<input>", {type : 'hidden', name : 'sta_code', value : $(o).attr('sta_id')});
				frm.append(input);
				$('body').append(frm);
				frm.submit();
			}
			
			function fnError(response)
			{
				console.log(response);
			}
		</script>
	</head>
	<body class="sBg">
		<div id="wrap">
			<section class="con_title">
				<!--서브제목-->
				<p class="sTit">데이터 수신현황</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>실시간모니터링</li>
					<li class="addNow">데이터 수신현황</li>
				</ul>
			</section>
			<!--## contents ##-->
			<section class="con_body">
				<article class="con_left map_type1">
					<ul class="map_btts">
						<li class="mapbtt1" onclick="setMapIcon(9);" style="cursor: pointer;">전체</li>
						<li class="mapbtt2" onclick="setMapIcon(0);" style="cursor: pointer;">원전부지</li>
						<li class="mapbtt3" onclick="setMapIcon(1);" style="cursor: pointer;">수력</li>
						<li class="mapbtt4" onclick="setMapIcon(2)" style="cursor: pointer;">양수</li>
						<li class="mapbtt5" onclick="setMapIcon(3)" style="cursor: pointer;">국가지진관측망</li>
						<!-- <li class="mapbtt6" onclick="setMapIcon(4);" style="cursor: pointer;">천지발전</li> -->
					</ul>
					<div id="map_layout"></div>
				</article>
				<!--우측 표-->
				<article class="con_right">
					<!--표1-->
					<section class="s_table1">
						<p>관측소 현황</p>
						<table>
							<caption>관측소 현황</caption>
							<colgroup>
								<col style="width:20%" />
								<col style="width:16%" />
								<col style="width:16%" />
								<col style="width:16%" />
								<col style="width:16%" />
								<col style="width:16%" />
								<%-- <col style="width:16%" /> --%>
							</colgroup>
							<thead>
								<tr class="topBgline">
									<th rowspan="2"></th>
									<th rowspan="2">원전부지</th>
									<th rowspan="2">수력발전</th>
									<th rowspan="2">양수발전</th>
									<th colspan="2">국가지진관측망</th>
									<!-- <th>천지발전</th> -->
								</tr>
								<tr>
									<th>기상청</th>
									<th>지자연</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>정상</th>
									<td class="normal_0">-</td>
									<td class="normal_1">-</td>
									<td class="normal_2">-</td>
									<td class="normal_3">-</td>
									<td class="normal_4">-</td>
									<!-- <td class="normal_4">-</td> -->
								</tr>
								<tr class="bg_gray2">
									<th>지연(10초)</th>
									<td class="delay_0">-</td>
									<td class="delay_1">-</td>
									<td class="delay_2">-</td>
									<td class="delay_3">-</td>
									<td class="delay_4">-</td>
									<!-- <td class="delay_4">-</td> -->
								</tr>
								<tr>
									<th>미수신(30초)</th>
									<td class="rest_0">-</td>
									<td class="rest_1">-</td>
									<td class="rest_2">-</td>
									<td class="rest_3">-</td>
									<td class="rest_4">-</td>
									<!-- <td class="rest_4">-</td> -->
								</tr>
								<tr class="bg_gray2">
									<th>전체</th>
									<td class="all_0">-</td>
									<td class="all_1">-</td>
									<td class="all_2">-</td>
									<td class="all_3">-</td>
									<td class="all_4">-</td>
									<!-- <td class="all_4">-</td> -->
								</tr>
							</tbody>
						</table>
					</section>
					<!--표2-->
					<section class="s_table2">
						<p>관측소 목록</p>
						
						<div class="display">
							<table class="display" id="example">
								<caption>관측소 목록</caption>
								<colgroup>
									<col style="width:8%" />
									<col style="width:12%" />
									<col style="width:20%" />
									<col style="width:15%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:10%" />
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<th>시설구분</th>
										<th>관측소명</th>
										<th>기관명</th>
										<th>위도</th>
										<th>경도</th>
										<th>고도</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody id="dataReceivedTbody"></tbody>
							</table>
						</div>
					</section>
				</article>
			</section>
		</div>
	</body>
</html>