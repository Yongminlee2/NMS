<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/nms/paging.js"/>"></script>
		<script src="<c:url value="/js/css/common.js"/>"></script>
		
		<script type="text/javascript">
		var stationInfos;
		var station;
		$(document).ready(function(){
			var timer;
// 			document.getElementById('sch_date').valueAsDate = new Date();
			var first_day_of_year;
			var q_date = new Date();
			first_day_of_year = q_date.getFullYear();
			
			fnSetDatePickerAndToDate($("input[name='sch_date']"), 0);
			fnSetDatePickerAndToDate($("input[name='sch_date2']"), 0);
			$("#sch_date").val(first_day_of_year+"-01-01");
			var sch_data = {};
			
			$("#hid_date").val($("#sch_date").val());
			$("#hid_date2").val($("#sch_date2").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			
			sch_data["date"] =  $("#sch_date").val();
			sch_data["date2"] =  $("#sch_date2").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["page"] = "1";
			
			post('${pageContext.request.contextPath}/report/eventalarm/getEventAlarmList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
// 			post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
			
			function fnSetStationList(response)
			{	
				console.log(response);
				stationInfos = response.data;
			}
			
		});
		
		function fnGetTable(page)
		{
			var sch_data = {};
			
			$("#hid_date").val($("#sch_date").val());
			$("#hid_date2").val($("#sch_date2").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			
			sch_data["date"] =  $("#sch_date").val();
			sch_data["date2"] =  $("#sch_date2").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/report/eventalarm/getEventAlarmList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
		}
		
		function fnGetTablePage(page)
		{
			var sch_data = {};
			
			sch_data["date"] =  $("#hid_date").val();
			sch_data["date2"] =  $("#sch_date2").val();
			sch_data["obs_kind"] = $("#hid_obs_kind").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/report/eventalarm/getEventAlarmList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
		}
		
		function fnDrawTable(response)
		{
			$('.table').html('');
			$('.fOrange').html('총 ' + response.totalDataCount + '건');
			if(response.totalDataCount != 0)
			{
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
				if(i%2 == 0)
				{
					tr = $("<tr>",{class : ""});
				}
				else
				{
					tr = $("<tr>",{class : "bg_gray2"});
				}
// 				var stationInfo = stationInfos.find(findStay);
				var gubun = '';
				console.log(data);
				if('NC' == data.org)
				{
					gubun = '원전부지';
				}else if('WP' == data.org)
				{
					gubun = '수력발전';
				}else if('PP' == data.org)
				{
					gubun = '양수발전';
				}
				
				var th = $("<th>",{text : data.no});
				var td1 = $("<td>",{text : (data.type=="K"?"지진감지":"자체보고")});
				var td2 = $("<td>",{text : data.id});
				var td3 = $("<td>",{text : (data.sms_flag=="1"?"전송":"미전송")});
				var td4 = $("<td>",{text : (data.sms_time=="null"?"":data.sms_time)});
				var td5 = $("<td>",{text : (data.mail_flag=="1"?"전송":"미전송")});
				var td6 = $("<td>",{text : (data.mail_time=="null"?"":data.mail_time)});
				var td7 = $("<td>",{text : data.user_id});
				
				tr.append(th);
				tr.append(td1);
				tr.append(td2);
				tr.append(td3);
				tr.append(td4);
				tr.append(td5);
				tr.append(td6);
				tr.append(td7);
				
				$('.table').append(tr);
			});
			
		}
		
		function fnDrawListPages(total)
		{
			var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fnGetTablePage",
					recordCount : 10
			};
			gfn_renderPaging(params);
		}
		
		function fnError(response)
		{
			console.log(response);
		}
		
		function findStay(data)
		{
			return data.obs_id === station;
		}
		</script>
	</head>
	<body class="sBg">
		<div id="wrap">
			<section class="con_title">
				<!--서브제목-->
				<p class="sTit">이벤트 통보 현황</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>시스템 관리</li>
					<li class="addNow">이벤트 통보 현황</li>
				</ul>
			</section>
			<section class="con_body">
				<article class="selectbox_long">
					<ul>
						<li>발생기간 <input type="" id="sch_date" name="sch_date" value="" />-<input type="" id="sch_date2" name="sch_date2" value="" /></li>
						<li>이벤트 구분
							<select id="sch_obs_kind" name="sch_obs_kind" style="width:200px">
								<option value="H">자체감지</option>
								<option value="K">지진통보</option>
							</select>
						</li>
						<li class="btt_filecomplt"><a onclick="fnGetTable(1);">자료확인</a></li>
					</ul>
				</article>
				<!--표-->
				<article class="s_table2">
					<p class="f20">검색자료 <span class="fOrange">총 11건</span></p>
					<p class="f14">본 자료는 10분 간격으로 수신자료를 검사한 내용입니다.</p>
					<table>
						<caption>관측소 목록</caption>
							<colgroup>
								<col style="width:5%" />
								<col style="width:10%" />
								<col style="width:10%" />
								<col style="width:20%" />
								<col style="width:10%" />
								<col style="width:10%" />
								<col style="width:10%" />
								<col style="width:20%" />
							</colgroup>
						<thead>
							<tr>
								<th>순번</th>
								<th>유형</th>
								<th>ID</th>
								<th>SMS</th>
								<th>전송시간</th>
								<th>E-mail</th>
								<th>전송시간</th>
								<th>수신자</th>
							</tr>
						</thead>
						<tbody class="table"></tbody>
					</table>
					<!--페이지넘김-->
					<ul class="pagebox" id="PAGE_NAVI"></ul>
					<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
					<input type="hidden" id="hid_date" name="hid_date"/>
					<input type="hidden" id="hid_obs_kind" name="hid_obs_kind"/>
				</article>
			</section>
		</div>
	</body>
</html>