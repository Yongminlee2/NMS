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
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	<title>한국수력원자력::모니터링 소프트웨어</title>
	<style type="text/css" media="all">
		
	</style>
</head>
	<body>
		<div id="pop_wrap">
			<section class="pop_body">
				<article class="pop_img">
					<img src="<c:url value="/img/pop_sta/${sta.img_url}"/>" alt="지도이미지">
				</article>
				<!--표 2-->
				<article class="pop_table_report22">
					<table>
						<colgroup>
						<col style="width:10%" />
						<col style="width:15%" />
						<col style="width:10%" />
						<col style="width:15%" />
						</colgroup>
						<!--1-->
						<thead>
							<tr>
								<th colspan="4">${sta.obs_name} 지진 관측소 정보</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>기관명</th>
								<td>${sta.net_name}</td>
								<th>관측소 명</th>
								<td>${sta.obs_name}</td>
							</tr>
							<tr>
								<th>기관 코드</th>
								<td>${sta.net}</td>
								<th>관측소 코드</th>
								<td>${sta.obs_id}</td>
							</tr>
							<tr>
								<th>관측소 구분</th>
								<td>${sta.sta_tmp1}</td>
								<th>위경도</th>
								<td>${sta.lon}/${sta.lat}</td>
							</tr>
							<tr>
								<th>주소</th>
								<td colspan="3">${sta.address}</td>
							</tr>
						</tbody>
						<!--1-->
						<thead>
							<tr>
								<th colspan="4">기록계 정보</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>고유번호</th>
								<td>${sta.rec_id}</td>
								<th>모델명</th>
								<td>${sta.rec_model}</td>
							</tr>
							<tr>
								<th>제작사</th>
								<td>${sta.rec_company}</td>
								<th>시리얼번호</th>
								<td>${sta.rec_serial}</td>
							</tr>
						</tbody>
						<!--3-->
						<thead>
							<tr>
								<th colspan="4">센서 정보</th>
							</tr>
							</thead>
						<tbody>
							<tr>
								<th>위치구분</th>
								<td>${sta.sen_location}</td>
								<th>모델명</th>
								<td>${sta.sen_model}</td>
							</tr>
							<tr>
								<th>제작사</th>
								<td>${sta.sen_company}</td>
								<th>시리얼번호</th>
								<td>${sta.sen_serial}</td>
							</tr>
						</tbody>
					</table>
				</article>
			</section>
		</div>
	</body>
</html>



