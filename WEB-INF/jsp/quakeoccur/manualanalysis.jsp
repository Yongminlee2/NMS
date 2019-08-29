<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link href="<c:url value="/css/main.css"/>" rel="stylesheet" type="text/css" />
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.flot.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/nms/paging.js"/>"></script>
		<style type="text/css">
			form input[type='text'],select{
				border: 0px;
				height:100%;
				width:100%;
				text-align: center;
				color:#72716f;
				font-family: Calibri, sans-serif;
			}
			label{
				margin-right:10px;
			}
			.pop_table tbody th{
				border: 1px solid #e2e2e2;
			}
		</style>
		<script type="text/javascript">
			var rFlag = false;
			$(document).ready(function(){
				
			});
			
			function openManualPopup(){
				rFlag = false;
				$("input[type='text']").each(function(i,v){
					if($(this).val().replace(/^\s+|\s+$/g,"")==""){
						alert("빈 값은 입력하실 수 없습니다.");
						rFlag = true;
						return false;
					}
				});
				setTimeout("openPop()",1000);

			}
			function openPop(){
				if(rFlag){
					return false;
				}
				switchPrograss();
				var winHeight	= document.body.clientHeight;		// 현재창의 높이
				var winWidth	= document.body.clientWidth;		// 현재창의 너비
				
				var popWidth = 865;//940
			    var popHeight = 900;//530
				
			    var pop_title = "manualPopup";
				var sch_data = {};
				sch_data["org"] =  $("input[name='org']:checked").val();
				sch_data["time"] =  $("input[name='time']").val();
				sch_data["lat"] =  $("input[name='lat']").val();
				sch_data["lon"] =  $("input[name='lon']").val();
				
				
				
				
// 				console.log(sch_data);
// 				return false;
				post('${pageContext.request.contextPath}/quakeoccur/quakeinfo/createManualData.ws', JSON.stringify(sch_data), 
				function(response){
					if(response.resultDesc=="OK"){
// 						switchPrograss();
						console.log(response);
						$("#realtime").val(response.resultCode);
// 						var detailWindow = 
						window.open("",pop_title,"resizable=yes,width="+popWidth+"px,height="+popHeight+"px,top="+(screen.availHeight - popHeight) / 2+",left="+(window.screenLeft + (winWidth - popWidth)/2));
						
// 						if(detailWindow.focus)
// 							detailWindow.focus();
						
						var form = document.manualForm;
						form.target = pop_title;
						form.action = "/NMS/quakeoccur/manualanalysis/popup/report";
						form.submit();
					}else{
// 						alert("작업에 실패하였습니다.");
						window.open("",pop_title,"resizable=yes,width="+popWidth+"px,height="+popHeight+"px,top="+(screen.availHeight - popHeight) / 2+",left="+(window.screenLeft + (winWidth - popWidth)/2));
						console.log("데이터 생성 실패");
						var form = document.manualForm;
						form.target = pop_title;
						form.action = "/NMS/quakeoccur/manualanalysis/popup/report";
						form.submit();
					}
				},function(){});
			}
			function fnSendMailTest(){
				var json = "{\"siteType\":\""+$("#tmpIpt3").val()+"\",\"fromEvent\":\""+$("#tmpIpt2").val()+"\",\"dbKey\":\""+$("#tmpIpt").val()+"\"}";
				if($("#tmpIpt3").val()==""){
					console.log("패턴 A");
					post('${pageContext.request.contextPath}/getMailSendTest.do', $("#tmpIpt").val(),
//			 				post('${pageContext.request.contextPath}/getMailSend.do', json,
									function(response){
										if(response=="ok"){
											alert("메일 전송 성공");
										}else{
											alert("메일 전송 실패");
										}
									},function(e){
										alert("완료");
										console.log(e);
									});
				}else{
					console.log("패턴 B");
					post('${pageContext.request.contextPath}/getMailSend.do', json,
							function(response){
								if(response=="ok"){
									alert("메일 전송 성공");
								}else{
									alert("메일 전송 실패");
								}
							},function(e){
								alert("완료");
								console.log(e);
							});
				}
				
			}
			function switchPrograss(){
				if($("#prograss-bar").css("display")=="none"){
					$("#prograss-bar").show();
		        	$("#prograss-bar-background").show();
				}else{
					$("#prograss-bar").hide();
		        	$("#prograss-bar-background").hide();
				}
			}
		</script>	
	</head>
	<body class="sBg">
<!-- 		<div id="prograss-bar-background" style="    left: 0;"> -->
<!-- 		</div> -->
<%-- 		<img id="prograss-bar" src="<c:url value="/img/loading.gif"/>"> --%>
		<div id="wrap">
			<section class="con_title">
				<!--서브제목-->
				<p class="sTit">수동정밀분석</p>
				<ul class="address">
					<li class="addHome">Home</li>
					<li>지진발생현황</li>
					<li class="addNow">수동정밀분석</li>
				</ul>
			</section>
			<section class="con_body" >
				<article class="pop_table">
					<form name="manualForm" id="manualForm" method="post">
						<input type="hidden" name="realtime" id="realtime" />
						<table style="width: 78%; margin: auto; height:500px; text-align: center;">
							<tr>
								<th colspan="2">구분</th>
								<td colspan="2">
									<input type="radio" name="org" checked="checked" value="NC"><label>원전부지</label>
									<input type="radio" name="org" value="WP"><label>수력</label>
									<input type="radio" name="org" value="PP"><label>양수</label>
<!-- 									<input type="radio" name="org" value="CJ"><label>천지</label> -->
								</td>
							</tr>
							<tr>
								<th colspan="2" style="border-top:1px solid #e1e1e1;">발생시간</th><td style="border-top:1px solid #e1e1e1;"><input type="text" name="time" placeholder="2017-07-01 00:00:00"/></td>
							</tr>
							<tr>
								<th colspan="2">규모</th><td><input type="text" name="mag" /></td>
							</tr>
							<tr>
								<th rowspan="3">진앙위치</th><th>위도</th><td><input type="text" name="lat"/></td>
							</tr>
							<tr>
								<th>경도</th><td><input type="text" name="lon" /></td>
							</tr>
							<tr>
								<th>지역</th><td><input type="text" name="area" /></td>
							</tr>
							<tr>
								<th colspan="2">보고자(소속/이름/연락처)</th><td><input type="text" name="user_info" id="tmpIpt3"/></td>
							</tr>
							<tr>
								<th colspan="2">개요 코멘트</th><td><input type="text" name="comment" id="tmpIpt2"/></td>
							</tr>
							<tr>
								<th colspan="2">특이사항</th><td><input type="text" name="etc" id="tmpIpt" /></td>
							</tr>
							<tr>
								<td colspan="4">
<!-- 									<button onclick="test()">보고서 생성</button> -->
<!-- 									<span onclick="openManualPopup()">보고서 생성</span> -->
									<span><a href="#"  onclick="openManualPopup()"><img src="<c:url value="/img/Crop_btt_report.png"/>" alt="보고서생성"></a></span>
									<span><a href="#"  onclick="fnSendMailTest()"><img src="<c:url value="/img/Crop_btt_okay.png"/>" alt="보고서생성"></a></span>
									
								</td>
							</tr>																		
						</table>
					</form>
				</article>
			</section>
		</div>
	</body>
</html>