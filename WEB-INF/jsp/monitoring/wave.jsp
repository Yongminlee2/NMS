<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link href="<c:url value="/css/wave_mapicons.css"/>" rel="stylesheet" type="text/css" />
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/vertx/socket.io.js"/>"></script>
		<script type="text/javascript">
			//var socket = io.connect("http://192.168.50.3:1809");
			var socket = io.connect("http://121.66.142.174:1809");
			var obsType=null;
			var station=null;
			var mapType = 'AL';
			var chartMapObject = [];
			var map = null;
			var sharedObject = null;
			var chartObject = null;
			
			/* */
			
			function fnSetStationList(response)
			{
				var mapLayout = document.getElementById("map_layout");
				mapLayout.innerHTML = '';
				$.each(response.data, function(key, stationInfo) {
					if(mapType == 'AL'){
						stationInfo.top = fnCalTopRecevied(Number(stationInfo.lat));
						stationInfo.left = fnCalleftRecevied(Number(stationInfo.lon));
						stationInfo.obstype = stationInfo.sta_tmp1;
						fnSetMapIcon(mapLayout, stationInfo);
					}else {
						if(mapType == stationInfo.sta_tmp1){
							stationInfo.top = fnCalTopRecevied(Number(stationInfo.lat));
							stationInfo.left = fnCalleftRecevied(Number(stationInfo.lon));
							stationInfo.obstype = stationInfo.sta_tmp1;
							fnSetMapIcon(mapLayout, stationInfo);
						}
					}
				});
			}
			
			function fnSetStationSenList(response){
				document.getElementById('pgaBox0').innerHTML = '';
				document.getElementById('pgaBox1').innerHTML = '';
				document.getElementById('pgaBox2').innerHTML = '';
				document.getElementById('pgaBox3').innerHTML = '';
				if(mapType == 'AL'){
					document.getElementById('pgaName0').innerHTML = '원전';
					document.getElementById('pgaName1').innerHTML = '수력';
					document.getElementById('pgaName2').innerHTML = '양수';
					document.getElementById('pgaName3').innerHTML = '국가';
				}else if(mapType == 'NC'){
					document.getElementById('pgaName0').innerHTML = '고리';
					document.getElementById('pgaName1').innerHTML = '월성';
					document.getElementById('pgaName2').innerHTML = '영광';
					document.getElementById('pgaName3').innerHTML = '울진';
				}else{
					document.getElementById('pgaName0').innerHTML = '관측소';
					document.getElementById('pgaName1').innerHTML = '관측소';
					document.getElementById('pgaName2').innerHTML = '관측소';
					document.getElementById('pgaName3').innerHTML = '관측소';
				}
				/* else if(mapType == 'WP'){
					
				}else if(mapType == 'PP'){
					
				} */
				var i = 0;
				map = new Map();
				$.each(response.data, function(key, stationSenInfo){
					var obsName = stationSenInfo.obs_name;
					if(mapType == 'AL'){
						if(stationSenInfo.sta_tmp1 == 'NC'){
							document.getElementById('pgaBox0').innerHTML = document.getElementById('pgaBox0').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							map.put(stationSenInfo.obs_id, false );
						}else if(stationSenInfo.sta_tmp1 == 'WP'){
							document.getElementById('pgaBox1').innerHTML = document.getElementById('pgaBox1').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							map.put(stationSenInfo.obs_id, false );
						}else if(stationSenInfo.sta_tmp1 == 'PP'){
							document.getElementById('pgaBox2').innerHTML = document.getElementById('pgaBox2').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							map.put(stationSenInfo.obs_id, false );
						}else{
							document.getElementById('pgaBox3').innerHTML = document.getElementById('pgaBox3').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							map.put(stationSenInfo.obs_id, false );
						}
						
						i++;
					}else if(mapType == 'NC' && stationSenInfo.sta_tmp1 == 'NC'){
							if(stationSenInfo.obs_name.indexOf("고리")> -1){
								document.getElementById('pgaBox0').innerHTML = document.getElementById('pgaBox0').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
								i++;
								map.put(stationSenInfo.obs_id, false );
							}else if(stationSenInfo.obs_name.indexOf("월성")> -1){
								document.getElementById('pgaBox1').innerHTML = document.getElementById('pgaBox1').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
								i++;
								map.put(stationSenInfo.obs_id, false );
							}else if(stationSenInfo.obs_name.indexOf("영광")> -1){
								document.getElementById('pgaBox2').innerHTML = document.getElementById('pgaBox2').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
								i++;
								map.put(stationSenInfo.obs_id, false );
							}else if(stationSenInfo.obs_name.indexOf("울진")> -1){
								document.getElementById('pgaBox3').innerHTML = document.getElementById('pgaBox3').innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
								i++;
								map.put(stationSenInfo.obs_id, false );
							}
						
					} else if(mapType == 'WP' && stationSenInfo.sta_tmp1 == 'WP'){
						if(mapType == stationSenInfo.sta_tmp1){
							document.getElementById('pgaBox'+i%4).innerHTML = document.getElementById('pgaBox'+i%4).innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							i++;
							map.put(stationSenInfo.obs_id, false );
						}
					} else if(mapType == 'PP' && stationSenInfo.sta_tmp1 == 'PP'){
						if(mapType == stationSenInfo.sta_tmp1){
							document.getElementById('pgaBox'+i%4).innerHTML = document.getElementById('pgaBox'+i%4).innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							i++;
							map.put(stationSenInfo.obs_id, false );
						}
					} else {
						if(mapType == stationSenInfo.sta_tmp1){
							document.getElementById('pgaBox'+i%4).innerHTML = document.getElementById('pgaBox'+i%4).innerHTML + '<li><p>'+obsName+'</p><input id="'+stationSenInfo.obs_id+'" type="text" name="text" readonly="readonly" obsname="'+obsName+'" onclick="fnSelectChart(\''+stationSenInfo.obs_id+'\')"/></li>';
							i++;
							map.put(stationSenInfo.obs_id, false );
						}
					}
					
				});
			}
			
			$(document).ready(function(){
				var audioElement = document.createElement('audio');
				audioElement.setAttribute('id', 'alarm');
				audioElement.setAttribute('src', '${pageContext.request.contextPath}/sound/warning.wav');
				
				audioElement.addEventListener('ended', function() {
					this.play();
				}, false);
				
				document.body.append(audioElement);
				
				/*기본 셋팅*/
				$('#map_icons').hide();
				$('#boxLis').hide();
				
				/*관측소 정보 셋팅*/
				post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
				post('${pageContext.request.contextPath}/util/common/stationofsensor2.ws', '', fnSetStationSenList, fnError);
				
				/*소켓 통신을 위한 기본 셋팅*/
				socket.emit('maproomjoin', {room : mapType});
				
				socket.on('maproomjoinok', function(res){
					if(res =='ok')
					{
						socket.emit('wavemapdatareq', {room : mapType});
					}
				});
				
				socket.on('wavemapdatares', function(res){
					fnDrawMapIcon(eval(res.data));
					res = null;
				});
				
				socket.emit('alarmroomjoin', {room : 'alarm'});
				
				socket.on('alarmroomjoinok', function(res){
					if(res =='ok')
					{
						socket.emit('wavealarmdatareq', {room : 'alarm'});
					}
				});
				
				socket.on('wavealarmdatares', function(res){
					fnAlarmData(eval(res.data));
					res = null;
				});
				
				/*  */
			});
			
			function fnAlarmData(res){
				document.getElementById('alarm').play();
				
				for(var i =0; i < res.length; i ++){
					fnAlarmPop(res[i]);
				}
			}
			
			function fnStopAlarm(){
				document.getElementById('alarm').pause();
			}
			var checkVal = 1;
			function fnSelectChart(id){
				
				if(checkVal < 6){
					if(map.get(id)){
						$("#"+id).removeClass("cskyblue");
						//socket.emit('chartroomout', {room : id});
						//$("div[name=pga_"+id+"]").remove();
						//$("h3[name=pga_"+id+"]").remove();
						map.put(id, false);
						checkVal --;
					}else{
						$("#"+id).addClass("cskyblue");
						//socket.emit('chartroomjoin', {room : id, name : name});
						map.put(id, true);
						checkVal ++;
					}
				}else{
					if(map.get(id)){
						$("#"+id).removeClass("cskyblue");
						//socket.emit('chartroomout', {room : id});
						//$("div[name=pga_"+id+"]").remove();
						//$("h3[name=pga_"+id+"]").remove();
						map.put(id, false);
						checkVal --;
					}else{
						alert('더 이상 차트를 그릴 수 없습니다.');
					}
				}
			}
			
			function fnDrawMapIcon(response)
			{
				try {
					response.forEach(function(mapInfo){
						if('Y' == mapInfo.sen_rep){
							if("WP" == mapInfo.maptype){
								document.getElementById(mapInfo.tablename.replace('_g','')).style.borderBottom = '14px solid' +mapInfo.color;
							}
							else{
								document.getElementById(mapInfo.tablename.replace('_g','')).style.backgroundColor = mapInfo.color;
							}
						}
						
						document.getElementById(mapInfo.tablename).value = mapInfo.pga_val;
						mapInfo = null;
					});
				} catch (e) {
					console.log('fnDrawMapIcon');
				}finally{
					response = null;
				}
			}
			
			function fnSetMapIcon(mapLayout, stationInfo)
			{
				try{
					mapLayout.innerHTML = mapLayout.innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'><div class='"+stationInfo.obstype+"' id='"+stationInfo.sta_type+"' sta_id ='"+stationInfo.obs_id+"' obs_name ='"+stationInfo.obs_name+"' style =' -webkit-transform:translate("+stationInfo.left+"px,"+stationInfo.top+"px); -ms-transform:translate("+stationInfo.left+"px,"+stationInfo.top+"px); transform:translate("+stationInfo.left+"px,"+stationInfo.top+"px);' onclick='fnStaPop(this);'></div></li></ul>";
				}catch (e) {
					console.log('fnSetMapIcon');
				}finally{
					mapLayout = null;
					stationInfo = null;
				}
			}
			
			function setMapIcon(type)
			{
				var className = [".mapbtt2", ".mapbtt3", ".mapbtt4", ".mapbtt5", ".mapbtt6", "", "", "", "", ".mapbtt1"];
				var imageName = ["btt_map_02_o.jpg", "btt_map_03_o.jpg", "btt_map_04_o.jpg", "btt_map_05_o.jpg", "btt_map_06_o.jpg", "", "", "", "", "btt_map_01_o.jpg"];
				var dataName = ["NC", "WP", "PP", "GO", "CJ", "", "", "", "", "AL"];
				
				socket.emit('maproomout', {room : mapType});
				mapType = dataName[type];
				socket.emit('maproomjoin', {room : mapType});
				
				mapType = dataName[type];
				var chk = $(className[type]).css('background');
				
				className.forEach(function(data, i){
					if(data != "")
					{
						$(className[i]).css('background', 'url(${pageContext.request.contextPath}/img/'+imageName[i].replace('_o', '')+') no-repeat');
					}
				});
				
				$(className[type]).css('background', 'url(${pageContext.request.contextPath}/img/'+imageName[type]+') no-repeat');
				
				post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
				post('${pageContext.request.contextPath}/util/common/stationofsensor2.ws', '', fnSetStationSenList, fnError);
				
				$(".chart-area").empty();
			}
			
			function fnCallChartPop(){
				
				chartObject = $('li .cskyblue');
				if(chartObject.length == 0){
					alert("관측소를 1개 이상 선택 하세요");
				}else{
					var chartWindow = window.open("", "chartWindow", "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=810, height=710");
					var frm = $("<form>", {id: 'chartWindow', action : "${pageContext.request.contextPath}/monitoring/wave/popup2", method : "POST", target : "chartWindow"});
					
					$('body').append(frm);
					frm.submit();
					chartWindow.window.focus();
					
					frm = null;
				}
				
				
			}
			
			function fnAlarmPop(alarmData)
			{
				if(document.getElementById(alarmData.station) == null){
					var div = $('div[sta_id='+alarmData.station+']').clone(true);
					div.attr('id', alarmData.station);
					var img = $('<img>', {src : '${pageContext.request.contextPath}/img/map_pointer.png', width : '15px'});
					div.append(img);
					$('#map_layout').append(div);
				}
				
				alarmData.obs_name = $('div[sta_id='+alarmData.station+']').attr('obs_name');
				sharedObject = alarmData;
				
				var alarmWindow = window.open("", "alarmPop"+alarmData.epochtime, "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=690, height=240");
				var frm = $("<form>", {id: 'alarmForm', action : "${pageContext.request.contextPath}/monitoring/wave/popup", method : "POST", target : "alarmPop"+alarmData.epochtime});
				
				$('body').append(frm);
				frm.submit();
				alarmWindow.window.focus();
				var timer = setInterval(function() { 
					if(alarmWindow.closed) {
						$('#'+alarmData.station).remove();
						clearInterval(timer);
						fnStopAlarm();
					}
				}, 1000);
				
				frm = null;
			}
			
			
			function fnStaPop(o)
			{
				var title = "stationInfo";
				var url = "${pageContext.request.contextPath}/monitoring/datareceived/popup";
				var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=890, height=410";
				var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=1100, height=520";
				window.open("", title, status);
				var frm = $("<form>", {action : url, method : "POST", target : title});
				var input = $("<input>", {type : 'hidden', name : 'sta_code', value : $(o).attr('sta_id')});
				frm.append(input);
				$('body').append(frm);
				frm.submit();
			}
			
			function findStay(data)
			{
				return data.obs_id === station;
			}
			
			function fnError(response)
			{
				console.log(response);
			}
			
		</script>
	</head>
	<body>
		<section class="con_title">
			<!--서브제목-->
			<p class="sTit">지반 가속도 모니터링</p>
			<ul class="address">
				<li class="addHome">Home</li>
				<li>실시간모니터링</li>
				<li class="addNow">지반 가속도 모니터링</li>
			</ul>
		</section>
		<!--## contents ##-->
		<section class="con_body">
			<article class="con_left map_type2">
				<!-- <input type="text" readonly="readonly" onclick="fnSelectChart('st01_g', '테스트')" value="차트 테스트"> -->
				<!-- <input type="text" readonly="readonly" onclick="fnStopAlarm()" value="알람 테스트"> -->
				<ul class="map_btts">
					<li class="mapbtt1" onclick="setMapIcon(9);" style="cursor: pointer;">전체</li>
					<li class="mapbtt2" onclick="setMapIcon(0);" style="cursor: pointer;">원전부지</li>
					<li class="mapbtt3" onclick="setMapIcon(1);" style="cursor: pointer;">수력</li>
					<li class="mapbtt4" onclick="setMapIcon(2)" style="cursor: pointer;">양수</li>
					<li class="mapbtt5" onclick="setMapIcon(3)" style="cursor: pointer;">국가지진관측망</li>
					<!-- <li class="mapbtt6" onclick="setMapIcon(4);" style="cursor: pointer;">천지발전</li> -->
				</ul>
				<p id="map_layout"></p>
			</article>
			<article style="float: right; width: 848px; margin-bottom: 10px;">
				
				<div style="float:right;">
					<a style="float:right;" onclick="fnCallChartPop();"><img src="<c:url value="/img/btt_chart_call.jpg"/>"/></a>
					<!-- <button type="button" title="차트 호출" style="float:right;" onclick="fnCallChartPop();">차트 호출</button> -->
					<br/>
					<div style="text-align: right;">(100sps)</div>
				</div>
			</article>
			
			<!--우측 표1-->
			<article class="con_right_box1">
				<section>
					<ul class="tit">
						<li class="left_list" id="pgaName0"> 관측소 </li>
						<li class="right_list"> 지반 </li>
					</ul>
					<ul class="conlistBox" id="pgaBox0"></ul>
				</section>
				<section>
					<ul class="tit">
						<li class="left_list" id="pgaName1"> 관측소 </li>
						<li class="right_list"> 지반 </li>
					</ul>
					<ul class="conlistBox" id="pgaBox1"></ul>
				</section>
				<section>
					<ul class="tit">
						<li class="left_list" id="pgaName2"> 관측소 </li>
						<li class="right_list"> 지반 </li>
					</ul>
					<ul class="conlistBox bnone" id="pgaBox2"></ul>
				</section>
				<section class="bnone">
					<ul class="tit">
						<li class="left_list" id="pgaName3"> 관측소 </li>
						<li class="right_list"> 지반 </li>
					</ul>
					<ul class="conlistBox bnone" id="pgaBox3"></ul>
				</section>
			</article>
		</section>
	</body>
</html>