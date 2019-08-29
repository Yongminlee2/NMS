<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		<link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />
		<!-- Modernizr -->
		<title>한국수력원자력::모니터링 소프트웨어</title>
		<script type="text/javascript">
		$(document).ready(function(){
			var sharedObject = window.opener.sharedObject;
			$('#obs_name').text(sharedObject.obs_name);
			$('#timestamp').text(sharedObject.timestamp);
			$('#zne').text('Z : '+sharedObject.z+', N : '+sharedObject.n+', E : '+sharedObject.e);
		});
		
		</script>
	</head>
	<body>
		<div id="pop_wrap2">
			<section class="pop_body">
				<!--표 1-->
				<article class="pop_table">
					<table>
						<caption>관측소 기본 정보</caption>
						<colgroup>
							<col style="width:30%" />
							<col style="width:70%" />
						</colgroup>
						<thead>
							<tr><th colspan="6">지진 감지 알림</th></tr>
						</thead>
						<tbody>
							<tr>
								<th>감지 관측소</th>
								<td id="obs_name">고리원전력 발전소</td>
							</tr>
							<tr>
								<th>감지 시간</th>
								<td id="timestamp">2017-06-12 12:34:34</td>
							</tr>
							<tr>
								<th>감지 값</th>
								<td id="zne">0.0001g</td>
							</tr>
						</tbody>
					</table>
				</article>
			</section>
		</div>
	</body>
</html>



