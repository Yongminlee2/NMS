<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/nms/paging.js"/>"></script>
		<script type="text/javascript">
		$(document).ready(function(){
			document.getElementById('sch_date').valueAsDate = new Date();
			
			var sch_data = {};
			
			$("#hid_date").val($("#sch_date").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			
			sch_data["date"] =  $("#sch_date").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["page"] = "1";
			
			post('${pageContext.request.contextPath}/report/quakeanalysis/getQuakeAnalysisList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			
			function fnSetStationList(response)
			{
				stationInfos = response.data;
			}
			
		});
		
		function fnGetTable(page)
		{
			var sch_data = {};
			
			$("#hid_date").val($("#sch_date").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			
			sch_data["date"] =  $("#sch_date").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/report/quakeanalysis/getQuakeAnalysisList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
		}
		
		function fnGetTablePage(page)
		{
			var sch_data = {};
			
			sch_data["date"] =  $("#hid_date").val();
			sch_data["obs_kind"] = $("#hid_obs_kind").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/report/quakeanalysis/getQuakeAnalysisList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
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
				
				var gubun = '';
				
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
				var td1 = $("<td>",{text : gubun});
				var td2 = $("<td>",{text : data.origintime});
				var td3 = $("<td>",{text : data.mag});
				var td4 = $("<td>",{text : data.address});
				var td5 = $("<td>",{text : data.lat});
				var td6 = $("<td>",{text : data.mlong});
				var td7 = $("<td>",{text : ''});
				
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
		
		</script>
	</head>
	<body class="sBg">
		<div id="wrap">
			<section class="con_title">
				<!--서브제목-->
				<p class="sTit">지진분석 현황</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>분석및보고서</li>
					<li class="addNow">지진분석 현황</li>
				</ul>
			</section>
			<section class="con_body">
				<article class="selectbox_long">
					<ul>
						<li>발생기간 <input type="date" id="sch_date" name="sch_date" value="" /></li>
						<li>관측소구분
							<tag:code type="combo" grpCd="obs_kind" id="sch_obs_kind" name="sch_obs_kind" style="width:200px" defaultTxt="===전체==="/>
						</li>
						<li class="btt_filecomplt"><a onclick="fnGetTable(1);">자료확인</a></li>
					</ul>
				</article>
				<!--표-->
				<article class="s_table2">
					<p class="f20">검색자료 <span class="fOrange">총 11건</span></p>
					<p class="f14">본 자료는 10분 간격으로 수신자료를 검사한 내용입니다.</p>
					<div style="min-height: 544px;">
						<table>
							<caption>관측소 목록</caption>
								<colgroup>
									<col style="width:5%" />
									<col style="width:10%" />
									<col style="width:20%" />
									<col style="width:5%" />
									<col style="width:20%" />
									<col style="width:15%" />
									<col style="width:15%" />
									<col style="width:10%" />
								</colgroup>
							<thead>
								<tr>
									<th>순번</th>
									<th>구분</th>
									<th>분석시간</th>
									<th>규모</th>
									<th>진앙지</th>
									<th>위도</th>
									<th>경도</th>
									<th>비고</th>
								</tr>
							</thead>
							<tbody class="table"></tbody>
						</table>
					</div>
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