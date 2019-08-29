<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link href="<c:url value="/css/index_mapicons.css"/>" rel="stylesheet" type="text/css" />
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/nms/paging.js"/>"></script>
		<title>한국수력원자력::모니터링 소프트웨어</title>
		<script type="text/javascript">
		var colorArr = ["#EECBE1","#EECBE1","#D398E8","#04BFEC","#68be11","#ffe340","#FFAD45","red","#585858"];
		$(document).ready(function(){
			var dt = new Date();
			var year = dt.getFullYear();
			
			fnSetDatePickerAndToDate($("#sch_date_str"), -1);
			fnSetDatePickerAndToDate($("#sch_date_end"), 0);
			
			var sch_data = {};
			
			$("#sch_date_str").val(year+'-01-01');
			
			$("#hid_date_str").val($("#sch_date_str").val());
			$("#hid_date_end").val($("#sch_date_end").val());
			
			sch_data["date_str"] =  $("#sch_date_str").val();
			sch_data["date_end"] =  $("#sch_date_end").val();
			sch_data["page"] = "1";
			
			post('${pageContext.request.contextPath}/quakeoccur/distribution/getDistributionList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			
			//post('/NMS/quakeoccur/distribution/getDistributionMap.ws', JSON.stringify(sch_data), fnDrawMap, fnError);
			
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
		
		function fnGetTable(page)
		{
			var sch_data = {};
			
			$("#hid_date_str").val($("#sch_date_str").val());
			$("#hid_date_end").val($("#sch_date_end").val());
			
			sch_data["date_str"] =  $("#sch_date_str").val();
			sch_data["date_end"] =  $("#sch_date_end").val();
			sch_data["page"] = page+"";
			
			post('${pageContext.request.contextPath}/quakeoccur/distribution/getDistributionList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			
			//post('/NMS/quakeoccur/distribution/getDistributionMap.ws', JSON.stringify(sch_data), fnDrawMap, fnError);
		}
		
		/* function fnGetTablePage(page)
		{
			var sch_data = {};
			
			sch_data["date_str"] =  $("#sch_date_str").val();
			sch_data["date_end"] =  $("#sch_date_end").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/quakeoccur/distribution/getDistributionList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
		} */
		
		function fnDrawMap(response)
		{
			document.getElementById("map_layout").innerHTML = '';
			
			response.forEach(function (data, i){
				
				var targetTop = fnCalTopDistribution(Number(data.lat));
				var targetLeft = fnCalleftDistribution(Number(data.rlong));
				
				if(!(targetTop < 0 || targetLeft < 0 || targetTop > 500 || targetLeft > 500))
				{
					var n_mag = quakeScale(Number(data.mag));
					console.log(n_mag);
					var div_won = "<div id ='won_"+n_mag+"' style ='background-color:"+colorArr[n_mag]+"; -webkit-transform:translate("+targetLeft+"px,"+targetTop+"px); -ms-transform:translate("+targetLeft+"px,"+targetTop+"px); transform:translate("+targetLeft+"px,"+targetTop+"px);' onclick='fnTooltip(\""+data.origintime+"\", \""+data.lat+"\", \""+data.rlong+"\", \""+Number(data.mag)+"\")'></div>";
					document.getElementById("map_layout").innerHTML = document.getElementById("map_layout").innerHTML + "<ul id='mapUl' style='position: absolute;'><li style='position: relative;'>"+div_won+"</li></ul>";
				}
				
			});
		}
		
		function fnDrawTable(response)
		{
			$('.table').html('');
			$('.fOrange').html('총 ' + response.totalDataCount + '건');
			if(response.totalDataCount != 0)
			{
				console.log(response.data2);
				fnDrawMap(response.data2);
				fnDrawListTable(response.data);
				
			}
			else
			{
				var tr = $("<tr>");
				var td = $("<th>",{colspan : 10, text : '검색된 자료가 없습니다.'});
				
				tr.append(td);
				$('.table').append(tr);
			}

			fnDrawListPages(response.totalDataCount);
			
		}
		
		function fnDrawListTable(datasets)
		{
			datasets.forEach(function (data, i){
				var tr;
				if(i%2 == 1)
				{
					tr = $("<tr>");
				}
				else
				{
					tr = $("<tr>",{class : "bg_gray2"});
				}
				
				var th = $("<th>",{text : data.no});
				var td1 = $("<td>",{text : data.origintime});
				var td2 = $("<td>",{text : Number(data.mag)});
				var td3 = $("<td>",{text : data.lat});
				var td4 = $("<td>",{text : data.rlong});
				var td5 = $("<td>",{text : data.nearSta});
				var td6 = $("<td>",{text : data.nearKM});
				var td7 = $("<td>",{text : data.maxPga});
				var td8 = $("<td>",{text : data.maxChan});
				var td9 = $("<td>",{text : data.origin_area});
				
				tr.append(th);
				tr.append(td1);
				tr.append(td2);
				tr.append(td3);
				tr.append(td4);
				tr.append(td5);
				tr.append(td6);
				tr.append(td7);
				tr.append(td8);
				tr.append(td9);
				
				$('.table').append(tr);
			});
			
		}
		
		function fnDrawListPages(total)
		{
			var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fnGetTable",
					recordCount : 10
			};
			gfn_renderPaging(params);
		}
		
		function fnError(response)
		{
			console.log(response);
		}
		
		function fnExcelDown()
		{
			$(".search-form").attr('action','${pageContext.request.contextPath}/quakeoccur/distribution/getExcel.do').submit();
		}
			
		</script>
	</head>
	<body class="sBg">
		<div id="wrap">
			<section class="con_title">
				<!--서브제목-->
				<p class="sTit">지진 분포도</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>지진발생현황</li>
					<li class="addNow">지진 분포도</li>
				</ul>
			</section>
			<!--## contents ##-->
			<section class="con_body">
				<article class="con_left map_type4">
					<div id="map_layout"></div>
				</article>
				<form class="search-form" name="searchForm" method="post" autocomplete="off">
					<article class="selectbox_long2">
						<ul>
							<li>기&nbsp;&nbsp;&nbsp;&nbsp;간 <input type="text" id="sch_date_str" name="sch_date_str" value="" /></li>-
							<li><input type="text" id="sch_date_end" name="sch_date_end" value="" /></li>
							<li class="btt_filecomplt"><a onclick="fnGetTable(1);">자료확인</a></li>
						</ul>
					</article>
				</form>
				<!--우측 표-->
				<article class="con_right">
					<!--표1-->
					
					<section class="s_table1">
						<p class="f20">검색자료 <span class="fOrange" style="color:#ff9540;">총 0건</span></p>
						<ul>
							<li class="btt_excel"><a onclick="fnExcelDown();">엑셀다운로드</a></li>
						</ul>
						<!-- <li class="btt_excel"><a onclick="fnGetTable(1);">자료확인</a></li> -->
						<div style="min-height: 544px;">
							<table>
								<caption>관측소 목록</caption>
									<colgroup>
										<col style="width:5%" />
										<col style="width:20%" />
										<col style="width:5%" />
										<col style="width:8%" />
										<col style="width:8%" />
										<col style="width:6%" />
										<col style="width:6%" />
										<col style="width:6%" />
										<col style="width:6%" />
										<col style="width:30%" />
									</colgroup>
								<thead>
									<tr class="topBgline">
										<th rowspan="2">순번</th>
										<th rowspan="2">진원시</th>
										<th rowspan="2">규모</th>
										<th rowspan="2">위도</th>
										<th rowspan="2">경도</th>
										<th colspan="2">인근원전</th>
										<th colspan="2">PGA</th>
										<th rowspan="2">위치</th>
									</tr>
									<tr>
										<th>원전</th>
										<th>거리</th>
										<th>g</th>
										<th>성분</th>
									</tr>
								</thead>
								<tbody class="table"></tbody>
							</table>
						</div>
						<!--페이지넘김-->
						<ul class="pagebox" id="PAGE_NAVI"></ul>
						<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
						<input type="hidden" id="hid_date_str" name="hid_date_str"/>
						<input type="hidden" id="hid_date_end" name="hid_date_end"/>
					</section>
				</article>
			</section>
		</div>
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
								<td id="origintime">2017-06-04 05:16:11</td>
								<td id="lat">26.83</td>
								<td id="rlong">128.10</td>
								<td id="mag">2.1</td>
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