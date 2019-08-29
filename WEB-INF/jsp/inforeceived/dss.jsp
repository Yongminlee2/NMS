<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/nms/paging.js"/>"></script>
		<script type="text/javascript">
		var stationInfos;
		var station;
		$(document).ready(function(){
			
			fnSetDatePickerAndToDate($("#sch_date_s"), -1);
			fnSetDatePickerAndToDate($("#sch_date_e"), 0);
			
			$("#hid_date_s").val($("#sch_date_s").val());
			$("#hid_date_e").val($("#sch_date_e").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			$("#hid_sta_type").val($("#sch_sta_type option:selected").val());
			
			var sch_data = {};
			
			sch_data["date_s"] =  $("#sch_date_s").val();
			sch_data["date_e"] =  $("#sch_date_e").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["sta_type"] = $("#sch_sta_type option:selected").val();
			sch_data["page"] = "1";
			post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
			
			function fnSetStationList(response)
			{
				stationInfos = response.data;
				post('${pageContext.request.contextPath}/inforeceived/dss/getDssList.ws', JSON.stringify(sch_data), fnDrawDssTable, fnError);
			}
		});
		
		function fnGetDssTable(page)
		{
			var sch_data = {};
			
			$("#hid_date_s").val($("#sch_date_s").val());
			$("#hid_date_e").val($("#sch_date_e").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			$("#hid_sta_type").val($("#sch_sta_type option:selected").val());
			
			sch_data["date_s"] =  $("#sch_date_s").val();
			sch_data["date_e"] =  $("#sch_date_e").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["sta_type"] = $("#sch_sta_type option:selected").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/inforeceived/dss/getDssList.ws', JSON.stringify(sch_data), fnDrawDssTable, fnError);
		}
		
		/* function fnGetDssTablePage(page)
		{
			var sch_data = {};
			
			sch_data["date_s"] =  $("#hid_date_s").val();
			sch_data["date_e"] =  $("#hid_date_e").val();
			sch_data["obs_kind"] = $("#hid_obs_kind").val();
			sch_data["sta_type"] = $("#hid_sta_type").val();
			sch_data["page"] = page+"";

			post('${pageContext.request.contextPath}/inforeceived/dss/getDssList.ws', JSON.stringify(sch_data), fnDrawDssTable, fnError);
		} */
		
		function fnDrawDssTable(response)
		{
			$('.dssList').html('');
			$('.fOrange').html('총 ' + response.totalDataCount + '건');
			if(response.totalDataCount != 0)
			{
				fnDrawDssListTable(response.data);
			}
			else
			{
				var tr = $("<tr>");
				var td = $("<th>",{colspan : 11, text : '검색된 자료가 없습니다.'});
				
				tr.append(td);
				$('.dssList').append(tr);
			}
			fnDrawDssListPages(response.totalDataCount);
		}
		
		function fnDrawDssListTable(datasets)
		{
			
			datasets.forEach(function (data, i){
				var tr;
				if(i%2 == 0)
				{
					tr = $("<tr>");
				}
				else
				{
					tr = $("<tr>",{class : "bg_gray2"});
				}
				
				station = data.code.length > 2 ? data.code.substring(0,2) : data.code;
				var stationInfo = stationInfos.find(findStay);
				
				var th = $("<th>",{text : data.no}); // 번호
				var td1 = $("<td>",{text : data.code}); // 코드
				var td2 = $("<td>",{text : stationInfo.obs_name}); // 관측소명
				var td3 = $("<td>",{text : data.chk_time}); // 최종확인시간
				var td4 = $("<td>",{text : data.last_time}); // 발생시간
				var td5 = $("<td>",{text : data.sub_time}); // 시간 차이
				var td6 = $("<td>",{text : data.two_pga}); // 수평성분
				var td7 = $("<td>",{text : data.three_pga}); // 3성분
				var td8 = $("<td>",{text : data.ud_pga});
				var td9 = $("<td>",{text : data.ns_pga});
				var td10 = $("<td>",{text : data.ew_pga});
				
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
				tr.append(td10);
				
				$('.dssList').append(tr);
			});
			
		}
		
		function fnDrawDssListPages(total)
		{
			var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fnGetDssTable",
					recordCount : 10,
					indexCount : 5
			};
			gfn_renderPaging(params);
		}
		
		function fnError(response)
		{
			console.log(response);
		}
		
		function fnSelectedObsKind(e)
		{
			obsType = e.value;
			post('${pageContext.request.contextPath}/util/common/stationofsensor.ws', obsType, fnDrawSelectSta, fnError);
		}
		
		function fnDrawSelectSta(response)
		{
			var datasets = response.data;
			
			var html = "<option value ='' selected>전체</option>";
			
			$(datasets).each(function(i,e){
				html += "<option value='"+e.obs_id+"'>" + e.obs_name + "</option>";
			});
			$("#sch_sta_type").html(html);
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
				<p class="sTit">PGA 데이터 수신현황</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>데이터수신현황</li>
					<li class="addNow">PGA 데이터 수신현황</li>
				</ul>
			</section>
			<section class="con_body">
			<!--선택박스-->
				<article class="selectbox_long">
					<ul style="width:1403px;">
						<li>기간 <input type="text" id="sch_date_s" name="sch_date_s" value="" /> - <input type="text" id="sch_date_e" name="sch_date_e" value="" /></li>
						<li>시설구분
							<tag:code type="combo" grpCd="obs_kind" id="sch_obs_kind" name="sch_obs_kind" style="width:200px" onchange="fnSelectedObsKind(this)" defaultTxt="===전체==="/>
						</li>
						<li>관측소
							<select id = "sch_sta_type" name="sch_sta_type">
								<option value ="" selected>===========</option>
							</select>
						</li>
						<li class="btt_filecomplt"><a onclick="fnGetDssTable(1);">자료확인</a></li>
					</ul>
				</article>
				<!--표-->
				<article class="s_table2">
					<p class="f20">검색자료 <span class="fOrange">총 0건</span></p>
					<p class="f14">본 자료는 10분 간격으로 수신자료를 검사한 내용입니다.</p>
					<div style="min-height: 544px;">
						<table>
							<caption>관측소 목록</caption>
								<colgroup>
									<col style="width:5%" />
									<col style="width:5%" />
									<col style="width:12%" />
									<col style="width:12%" />
									<col style="width:12%" />
									<col style="width:5%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:10%" />
									<col style="width:10%" />
								</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>코드</th>
									<th>관측소명</th>
									<th>계측 시간</th>
									<th>수신 시간</th>
									<th>시간차이(s)</th>
									<th>U/D PGA</th>
									<th>N/S PGA</th>
									<th>E/W PGA</th>
									<th>수평성분PGA(g)</th>
									<th>PGA(3성분,g)</th>
								</tr>
							</thead>
							<tbody class="dssList"></tbody>
						</table>
					</div>
					
					<!--페이지넘김-->
					<ul class="pagebox" id="PAGE_NAVI"></ul>
					<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
					<input type="hidden" id="hid_date_s" name="hid_date_s"/>
					<input type="hidden" id="hid_date_e" name="hid_date_e"/>
					<input type="hidden" id="hid_obs_kind" name="hid_obs_kind"/>
					<input type="hidden" id="hid_sta_type" name="hid_sta_type"/>
				</article>
			</section>
		</div>
	</body>
</html>