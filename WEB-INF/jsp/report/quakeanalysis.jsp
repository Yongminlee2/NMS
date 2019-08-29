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
			$('.fOrange').html('�� ' + response.totalDataCount + '��');
			if(response.totalDataCount != 0)
			{
				fnDrawListTable(response.data);
			}
			else
			{
				var tr = $("<tr>");
				var td = $("<th>",{colspan : 10, text : '�˻��� �ڷᰡ �����ϴ�.'});
				
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
					gubun = '��������';
				}else if('WP' == data.org)
				{
					gubun = '���¹���';
				}else if('PP' == data.org)
				{
					gubun = '�������';
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
				<!--��������-->
				<p class="sTit">�����м� ��Ȳ</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>�м��׺���</li>
					<li class="addNow">�����м� ��Ȳ</li>
				</ul>
			</section>
			<section class="con_body">
				<article class="selectbox_long">
					<ul>
						<li>�߻��Ⱓ <input type="date" id="sch_date" name="sch_date" value="" /></li>
						<li>�����ұ���
							<tag:code type="combo" grpCd="obs_kind" id="sch_obs_kind" name="sch_obs_kind" style="width:200px" defaultTxt="===��ü==="/>
						</li>
						<li class="btt_filecomplt"><a onclick="fnGetTable(1);">�ڷ�Ȯ��</a></li>
					</ul>
				</article>
				<!--ǥ-->
				<article class="s_table2">
					<p class="f20">�˻��ڷ� <span class="fOrange">�� 11��</span></p>
					<p class="f14">�� �ڷ�� 10�� �������� �����ڷḦ �˻��� �����Դϴ�.</p>
					<div style="min-height: 544px;">
						<table>
							<caption>������ ���</caption>
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
									<th>����</th>
									<th>����</th>
									<th>�м��ð�</th>
									<th>�Ը�</th>
									<th>������</th>
									<th>����</th>
									<th>�浵</th>
									<th>���</th>
								</tr>
							</thead>
							<tbody class="table"></tbody>
						</table>
					</div>
					<!--�������ѱ�-->
					<ul class="pagebox" id="PAGE_NAVI"></ul>
					<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
					<input type="hidden" id="hid_date" name="hid_date"/>
					<input type="hidden" id="hid_obs_kind" name="hid_obs_kind"/>
				</article>
			</section>
		</div>
	</body>
</html>