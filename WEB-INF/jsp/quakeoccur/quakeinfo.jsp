<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
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
		var viewType='Q';
		$(document).ready(function(){
			$("#hid_date").val('');
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			$("#hid_sta_type").val($("#sch_sta_type option:selected").val());
			
			var first_day_of_year;
			var q_date = new Date();
			first_day_of_year = q_date.getFullYear();
			$("#sch_date_o").val(first_day_of_year+"-01-01");
			
			fnSetDatePickerAndToDate($("#sch_date_o"),0);
			fnSetDatePickerAndToDate($("#sch_date_n"),0);
			
			$("#sch_date_o").val(first_day_of_year+"-01-01");
// 			$("#sch_date_n").val("");
			var sch_data = {};
			
			sch_data["date"] =  $("#sch_date_o").val();
			sch_data["date2"] =  $("#sch_date_n").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["sta_type"] = $("#sch_sta_type option:selected").val();
			sch_data["page"] = "1";
			
			post('${pageContext.request.contextPath}/util/common/station.ws', '', fnSetStationList, fnError);
			setTimeout(post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakeEventList.ws', JSON.stringify(sch_data), fnDrawTable, fnError),300);

			
			function fnSetStationList(response)
			{
				stationInfos = response.data;
			}
		});
		
		function fnGetTable(page)
		{
			var sch_data = {};
			
			$("#hid_date").val($("#sch_date_o").val());
			$("#hid_date2").val($("#sch_date_n").val());
			$("#hid_obs_kind").val($("#sch_obs_kind").val());
			$("#hid_sta_type").val($("#sch_sta_type option:selected").val());
			
			sch_data["date"] =  $("#sch_date_o").val();
			sch_data["date2"] =  $("#sch_date_n").val();
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["sta_type"] = $("#sch_sta_type option:selected").val();
			sch_data["page"] = page+"";
			
			if('Q' == viewType)
			{
				post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakeEventList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			}
			else if('S' == viewType)
			{
				post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getSelfEventList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			}
		}
		
		function fnGetTablePage(page)
		{
			var sch_data = {};
			
			sch_data["date"] =  $("#hid_date").val();
			sch_data["date2"] =  $("#hid_date2").val();
			sch_data["obs_kind"] = $("#hid_obs_kind").val();
			sch_data["sta_type"] = $("#hid_sta_type").val();
			sch_data["page"] = page+"";

			console.log($("#hid_date").val());
			
			if('Q' == viewType)
			{
				post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakeEventList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			}
			else if('S' == viewType)
			{
				post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getSelfEventList.ws', JSON.stringify(sch_data), fnDrawTable, fnError);
			}
		}
		
		function fnDrawHeadTable()
		{
			var theadTr = $("<tr>");

			if('Q' == viewType)
			{
				
				var colgroup = $("#colgroup2");
				$("#colgroup2").empty();
				
				var col1 = $("<col>",{width : "5%"});
				var col2 = $("<col>",{width : "15%"});
				var col3 = $("<col>",{width : "10%"});
				
				colgroup.append(col1);
				colgroup.append(col2);
				colgroup.append(col3);
				
				var theadTh1 = $("<th>",{text : "지진번호"}); // 번호
				var theadTh2 = $("<th>",{text : "진원시"}); // 번호
				var theadTh3 = $("<th>",{text : "규모"}); // 번호
				
				theadTr.append(theadTh1);
				theadTr.append(theadTh2);
				theadTr.append(theadTh3);
				
				$('.thead2').append(theadTr);
				
				
				var colgroup_sub = $("#colgroup3");
				$("#colgroup3").empty();
				
				var scol0 = $("<col>",{width : "6%"});
				var scol1 = $("<col>",{width : "8%"});
				var scol2 = $("<col>",{width : "20%"});
				var scol3 = $("<col>",{width : "11%"});
				var scol4 = $("<col>",{width : "15%"});
				var scol5 = $("<col>",{width : "7%"});
				var scol6 = $("<col>",{width : "7%"});
				var scol7 = $("<col>",{width : "7%"});
				
				colgroup_sub.append(scol0);
				colgroup_sub.append(scol1);
				colgroup_sub.append(scol2);
				colgroup_sub.append(scol3);
				colgroup_sub.append(scol4);
				colgroup_sub.append(scol5);
				colgroup_sub.append(scol6);
				colgroup_sub.append(scol7);
				
				var theadTr2 =  $("<tr>");
				
				var theadThs0 = $("<th>",{text : "구분"}); // 번호
				var theadThs1 = $("<th>",{text : "관측소"}); // 번호
				var theadThs2 = $("<th>",{text : "진앙지"}); // 번호
				var theadThs3 = $("<th>",{text : "위경도"}); // 번호
				var theadThs4 = $("<th>",{text : "전송시간"}); // 번호
				var theadThs5 = $("<th>",{text : "전송상태"}); // 번호
				var theadThs6 = $("<th>",{text : "요약"}); // 번호
				var theadThs7 = $("<th>",{text : "상세"}); // 번호
				
				theadTr2.append(theadThs0);
				theadTr2.append(theadThs1);
				theadTr2.append(theadThs2);
				theadTr2.append(theadThs3);
				theadTr2.append(theadThs4);
				theadTr2.append(theadThs5);
				theadTr2.append(theadThs6);
				theadTr2.append(theadThs7);
				
				$('.thead3').append(theadTr2);
			}
			else if('S' == viewType)
			{
				var colgroup = $("#colgroup");
				$("#colgroup").empty();
				
				var col1 = $("<col>",{width : "5%"});
				var col2 = $("<col>",{width : "20%"});
				var col3 = $("<col>",{width : "15%"});
				var col4 = $("<col>",{width : "10%"});
				var col5 = $("<col>",{width : "15%"});
				var col6 = $("<col>",{width : "15%"});
				var col7 = $("<col>",{width : "5%"});
// 				var col8 = $("<col>",{width : "5%"});
				
				var col9 = $("<col>",{width : "5%"});
				var col10 = $("<col>",{width : "5%"});
				
				colgroup.append(col1);
				colgroup.append(col2);
				colgroup.append(col3);
				colgroup.append(col4);
				colgroup.append(col5);
				colgroup.append(col6);
				colgroup.append(col7);
// 				colgroup.append(col8);
				
				colgroup.append(col9);
				colgroup.append(col10);
				
				var theadTh1 = $("<th>",{text : "순번"}); 
				var theadTh2 = $("<th>",{text : "감지날짜"});
				var theadTh3 = $("<th>",{text : "감지 관측소"});
				var theadTh4 = $("<th>",{text : "감지 단계"});
				var theadTh5 = $("<th>",{text : "감지 값(g)"});
				var theadTh6 = $("<th>",{text : "전송시간"});
				var theadTh7 = $("<th>",{text : "전송상태"});
// 				var theadTh8 = $("<th>",{text : "재전송"});
				
				var theadTh9 = $("<th>",{text : "요약"});
				var theadTh10 = $("<th>",{text : "상세"});
				
				theadTr.append(theadTh1);
				theadTr.append(theadTh2);
				theadTr.append(theadTh3);
				theadTr.append(theadTh4);
				theadTr.append(theadTh5);
				theadTr.append(theadTh6);
				theadTr.append(theadTh7);
// 				theadTr.append(theadTh8);
				
				theadTr.append(theadTh9);
				theadTr.append(theadTh10);
				
				$('.thead').append(theadTr);
			}
			
			
		}
		
		function fnDrawListTable(datasets)
		{
			datasets.forEach(function (data, i){
				
				var tbodyTr;
				
				
// 				station =  data.station;
// 				var stationInfo = stationInfos.find(findStay);
				
				if('Q' == viewType)
				{
					if(i%2 == 0)
					{
						tbodyTr = $("<tr>",{onclick : "fnQuakeSubList('"+data.id+"')"});
						
					}
					else
					{
						tbodyTr = $("<tr>",{class : "bg_gray2",onclick : "fnQuakeSubList('"+data.id+"')"});
					}
					
					var tbodyTh = $("<th>",{text : data.id}); // 번호
// 					var tbodyTd1 = $("<td>",{text : data.origin_area}); // 관측소명
					var tbodyTd1 = $("<td>",{text : data.origintime}); // 관측소명
					var tbodyTd2 = $("<td>",{text : parseFloat(data.mag).toFixed(1)}); // 지진번호
					
					tbodyTr.append(tbodyTh);
					tbodyTr.append(tbodyTd1);
					tbodyTr.append(tbodyTd2);
					
					$('.tbody2').append(tbodyTr);
				}
				else if('S' == viewType)
				{
					if(i%2 == 0)
					{
						tbodyTr = $("<tr>");
					}
					else
					{
						tbodyTr = $("<tr>",{class : "bg_gray2"});
					}
					console.log(data);
					var gVal = maxValue(parseFloat(data.z),parseFloat(data.n),parseFloat(data.e));
					gVal = ''+gVal/980;
					var tbodyTh = $("<th>",{text : data.no});
					var tbodyTd1 = $("<td>",{text : data.timestamp.replace(".0","")});
// 					var tbodyTd2 = $("<td>",{text : stationInfo.obs_name});
					var tbodyTd2 = $("<td>",{text : data.station.replace("원자력발전소","")});
					var tbodyTd3 = $("<td>",{text : data.level + '단계'});
					
// 					var tbodyTd4 = $("<td>",{text : data.twod + '(g)'});
					var tbodyTd4 = $("<td>",{text : gVal.substring(0,8) + '(g)'});
					
					var tbodyTd5 = $("<td>",{text : data.send.replace(".0","")});
					var tbodyTd6 = $("<td>",{text : data.status});
// 					var tbodyTd7 = $("<td>",{text : ''});
					
					var tbodyTd8 = $("<td>",{text : '[보기]',onclick : "fnEventReportPopup('summary',"+data.tmp1+",'"+data.org+"')"}); // 요약
					var tbodyTd9 = $("<td>",{text : '[보기]',onclick : "fnEventReportPopup('',"+data.tmp1+",'"+data.org+"')"}); // 요약
					
					tbodyTr.append(tbodyTh);
					tbodyTr.append(tbodyTd1);
					tbodyTr.append(tbodyTd2);
					tbodyTr.append(tbodyTd3);
					tbodyTr.append(tbodyTd4);
					tbodyTr.append(tbodyTd5);
					tbodyTr.append(tbodyTd6);
// 					tbodyTr.append(tbodyTd7);
					
					tbodyTr.append(tbodyTd8);
					tbodyTr.append(tbodyTd9);
					
					//s일때 특정 div를 show하고 데이터를 보여주도록한다.
					$('.tbody').append(tbodyTr);
				}
			});
		}
		function maxValue(z,n,e){
			var max = 0;
			if(z>max){max = z;}
			if(n>max){max = n;}
			if(e>max){max = e;}
			return max;
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
		
		function fnDrawTable(response)
		{	
			if('Q' == viewType){
				$('.thead2').html('');
				$('.tbody2').html('');
				$('.thead3').html('');
				//$('.tbody3').html('');
				
				$('#queak_event_list').show();
				$('#self_event_list').hide();
			}else if('S' == viewType){
				$('.thead').html('');
				$('.tbody').html('');
				
				$('#queak_event_list').hide();
				$('#self_event_list').show();				
			}
			
			$('.fOrange').html('총 ' + response.totalDataCount + '건');
			fnDrawHeadTable();
			if(response.totalDataCount != 0)
			{
				fnDrawListTable(response.data);
			}
			else
			{
				var tr = $("<tr>");
				var td;
				
				if('Q' == viewType)
				{
					td = $("<th>",{colspan : 3, text : '검색된 자료가 없습니다.'});
					tr.append(td);
					$('.tbody2').append(tr);
					
					var tr2 = $("<tr>");
					var td2;
					
// 					td2 = $("<th>",{colspan : 7, text : '검색된 자료가 없습니다.'});
// 					tr2.append(td2);
// 					$('.tbody3').append(tr2);
					
				}
				else if('S' == viewType)
				{
					td = $("<th>",{colspan : 9, text : '검색된 자료가 없습니다.'});
					tr.append(td);
					$('.tbody').append(tr);
				}
			}
			fnDrawListPages(response.totalDataCount);
		}
		
		function fnChangeTable(type)
		{
			viewType = type;
			fnReSetView();
			if('Q' == type)
			{
				$('#tab1').attr('class','on');
				$('#tab2').attr('class','');
				fnGetTable(1);
			}
			else if('S' == type)
			{
				$('#tab2').attr('class','on');
				$('#tab1').attr('class','');
				fnGetTable(1);
			}
		}
		
		function fnReSetView()
		{
			fnDrawListPages(0);
			$('.fOrange').html('총 0건');
// 			document.getElementById('sch_date').valueAsDate = new Date();
// 			document.getElementById('sch_date_o').value = "";
// 			document.getElementById('sch_date_n').value = "";
// 			alert($("#sch_date").val());
			$("#hid_date").val($("#sch_date_o").val());
			$("#hid_date2").val($("#sch_date_n").val());
			
		}
		
		function fnError(response)
		{
			console.log(response);
		}
		
		function fnSelectedObsKind(e)
		{
			obsType = e.value;
			post('${pageContext.request.contextPath}/util/common/stationobskind.ws', obsType, fnDrawSelectSta, fnError);
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
			console.log(data);
			return data.obs_id === station;
		}
		
		function fnQuakeReportPopup(view,no,type){
			if(view=="summary"){
				fnOpenPop("/NMS/quakeoccur/quakeinfo/popup/reportWave/summary",865,900,"summary=y&no="+no+"&type="+type);
			}else{
// 				fnOpenPop("/NMS/quakeoccur/quakeinfo/popup/reportWave",1400,850,"summary=n&no="+no+"&type="+type);
				fnOpenPop("/NMS/quakeoccur/quakeinfo/popup/reportWave",865,900,"summary=n&no="+no+"&type="+type);
			}
		}
		function fnEventReportPopup(view,no,type){
			if(view=="summary"){
				fnOpenPop("/NMS/quakeoccur/quakeinfo/popup/report",1400,760,"summary=y&no="+no+"&type="+type);
			}else{
				fnOpenPop("/NMS/quakeoccur/quakeinfo/popup/report",1400,760,"summary=n&no="+no+"&type="+type);
			}
		}
		function fnQuakeSubList(qNo){
	
// 			alert("으쌰");
			//return false;
			var sch_data = {};
			sch_data["req_id"] =  qNo;
			sch_data["obs_kind"] = $("#sch_obs_kind").val();
			sch_data["sta_type"] = $("#sch_sta_type option:selected").val();
// 			$(".tbody3").html("");
			post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/getQuakeEventSubList.ws', JSON.stringify(sch_data), function(response){
				var list = response.data;
// 				thead3
				console.log(list);
				var tbodyTr;
				
				for(var i = 0;i<list.length;i++){
					var stCode = list[i].station2;
					var trObj = $(".tbody3 tr[st='"+stCode+"']");
					
					trObj.children("th[col='loc']").html(list[i].origin_area);
					trObj.children("th[col='lonlat']").html(list[i].rlong+" / "+list[i].lat);
					trObj.children("th[col='time']").html(list[i].send.replace(".0",""));
					trObj.children("th[col='state']").html(list[i].status);
					
					console.log($("#simple_"+list[i].org).html());
					$("#simple_"+list[i].org).html("<span onclick=\"fnQuakeReportPopup('summary','"+list[i].id+"','"+list[i].org+"')\">[요 약]</span>");
					$("#detail_"+list[i].org).html("<span onclick=\"fnQuakeReportPopup('detail','"+list[i].id+"','"+list[i].org+"')\">[상세보기]</span>");
				}
			}, fnError);
		}
			
		</script>
	</head>
	<body class="sBg">
		<div id="wrap">
			<section class="con_title">
				<!--서브제목-->
				<p class="sTit">지진발생정보</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>지진발생현황</li>
					<li class="addNow">지진발생정보</li>
				</ul>
			</section>
			<section class="con_body">
			<!--선택박스-->
				<article class="selectbox_long">
					<ul>
						<li>발생기간 <input id="sch_date_o" name="sch_date" value="" style="width:140px;"/>-<input id="sch_date_n" name="sch_date" value="" style="width:140px;" /></li>
						<li>시설구분
							<tag:code type="combo" grpCd="obs_kind" id="sch_obs_kind" name="sch_obs_kind" style="width:200px" onchange="fnSelectedObsKind(this)" defaultTxt="===전체==="/>
						</li>
						<li>관측소
							<select id = "sch_sta_type" name="sch_sta_type">
								<option value ="" selected>===========</option>
							</select>
						</li>
						<li class="btt_filecomplt"><a onclick="fnGetTable(1);">자료확인</a></li>
					</ul>
				</article>
				<!--표-->
				<!--TAB MENU-->
				<article class="sTab_menu">
					<ul>
						<li><a class="on" onclick="fnChangeTable('Q');" id="tab1">지진 통보</a></li>
						<li><a onclick="fnChangeTable('S');" id="tab2">자체 감지</a></li>
					</ul>
				</article>
				<article class="s_table2">
					<p class="f20">검색자료 <span class="fOrange">총 0건</span></p>
<!-- 					<p class="f14">본 자료는 10분 간격으로 수신자료를 검사한 내용입니다.</p> -->
					<div id="self_event_list" style="min-height: 544px;">
						<table>
							<caption>관측소 목록</caption>
							<colgroup id="colgroup"></colgroup>
							<thead class="thead">
								<tr>
									<th>순번</th>
									<th>관측소</th>
									<th>지진번호</th>
									<th>진원시</th>
									<th>규모</th>
									<th>진앙지</th>
									<th>전송시간</th>
									<th>전송상태</th>
									<!-- TJ 수정부 -->
									<th>요약</th>
									<th>상세보기</th>
									<!-- TJ 수정부 -->
								</tr>
							</thead>
							<tbody class="tbody"></tbody>
						</table>
					</div>
					<div id="queak_event_list" style="min-height: 544px;display: none;">
					<br><br><div style="height:8px;"></div>
						<table style="float:left;width:30%;margin-top:0px;">
							<caption>관측소 목록</caption>
							<colgroup id="colgroup2"></colgroup>
							<thead class="thead2">
								<tr>
									<th>지진번호</th>
									<th>진원시</th>
									<th>규모</th>
								</tr>
							</thead>
							<tbody class="tbody2"></tbody>
						</table>
						<div style="max-height:504px;float:right;width:65%;overflow-y:auto;">
						<table style="margin-top:0px;">
							<caption>관측소 목록</caption>
							<colgroup id="colgroup3">
							</colgroup>
							<thead class="thead3">
								<tr>
									<th>구분</th>
									<th>관측소</th>
									<th>진앙지</th>
									<th>규모</th>
									<th>위경도</th>
									<th>전송시간</th>
									<th>전송상태</th>
									<!-- TJ 수정부 -->
									<th>요약</th>
									<th>상세보기</th>
									<!-- TJ 수정부 -->
								</tr>
							</thead>
							<tbody class="tbody3" style="overflow-y:auto;max-height:200px;">
								<c:forEach items="${stationInfo}" var="st">
									<tr st="${st.obs_id }">
										<c:if test="${st.sta_tmp3 ne 'sub' }">
											<th rowspan="${st.sta_tmp3 }">${st.sta_tmp1 }</th>
										</c:if>
										<th>${st.obs_name }<c:if test="${st.obs_id == 'KA' || st.obs_id == 'YA' || st.obs_id == 'UA' || st.obs_id == 'WA'}">A</c:if> </th>
										<th col="loc"></th>
										<th col="lonlat"></th>
										<th col="time"></th>
										<th col="state"></th>
										<c:if test="${st.sta_tmp3 ne 'sub' }">
											<th col="simple" rowspan="${st.sta_tmp3 }" id="simple_${st.obs_kind }" style="cursor: pointer;">[ 요 약 ]</th>
											<th col="detail" rowspan="${st.sta_tmp3 }" id="detail_${st.obs_kind }" style="cursor: pointer;">[ 상세보기 ]</th>
										</c:if>										
									</tr>
								</c:forEach>							
							</tbody>
						</table>
						</div>						
					</div>					
					<!--페이지넘김-->
					<ul class="pagebox" id="PAGE_NAVI"></ul>
					<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
					<input type="hidden" id="hid_date" name="hid_date"/>
					<input type="hidden" id="hid_date2" name="hid_date2"/>
					<input type="hidden" id="hid_obs_kind" name="hid_obs_kind"/>
					<input type="hidden" id="hid_sta_type" name="hid_sta_type"/>
					
				</article>
			</section>
		</div>
	</body>
</html>