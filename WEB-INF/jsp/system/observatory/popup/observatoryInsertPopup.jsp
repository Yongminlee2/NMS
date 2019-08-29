<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>

<html>
<head>
		
	<!-- 1. 기타로 조회시 생각 -->

	<title>popup</title>
	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
		td{
			width: 100px;
		}
	</style>
	<script>
		$(document).ready(function(){

		});
		
		function fnDetailStationInfo(staNo){
			alert(staNo);
		}
	</script>
</head>
<body>
	<div id="observatory-info-top">
		<table border="1">
			<thead>
				<tr>
					<th colspan="6">"e" 지진 관측소 정보</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th colspan="6">station 테이블 정보 제공</th>
				</tr>
				<tr>
					<th>관측소명</th><td>${stationInfo.obs_desc }</td>
					<th>관측소 코드</th><td>${stationInfo.obs_id }</td>
					<th>행정지역코드</th><td>${stationInfo.area}</td>
				</tr>
				<tr>
					<th>주소</th><td colspan="3">${stationInfo.address }</td>
					<th>시설물 종류</th><td>${stationInfo.obs_desc }</td>
				</tr>
				<tr>
					<th>위경도</th><td>${stationInfo.lon }/${stationInfo.lat }</td>
					<th>지반 분류</th><td>${stationInfo.ground_desc }</td>
					<th>설계 기준</th><td>${stationInfo.seis_cd_desc }</td>
				</tr>		
				<tr>
					<th colspan="6">recorder 테이블 정보 제공</th>
				</tr>
				<c:forEach items="${recorderList }" var="recorderInfo">
					<tr>
						<th>모델명</th><td>${recorderInfo.rec_model }</td>
						<th>제조사</th><td>${recorderInfo.rec_company }</td>
						<th>시리얼 번호</th><td>${recorderInfo.rec_serial }</td>
					</tr>	
				</c:forEach>
				<tr>
					<th colspan="6">sensor 테이블 정보 제공</th>
				</tr>
				<c:forEach items="${sensorList }" var="sensorInfo">
					<tr>
						<th>모델명</th><td>${sensorInfo.sen_model }</td>
						<th>제조사</th><td>${sensorInfo.sen_company }</td>
						<th>시리얼 번호</th><td>${sensorInfo.sen_serial }</td>
					</tr>
					<tr>
						<th>위치코드</th><td>${sensorInfo.sen_position }</td>
						<th>가속도 분류</th><td>${sensorInfo.sen_kind_desc }</td>
						<th>계측용도 구분</th><td>${sensorInfo.sen_gubun_desc }</td>
					</tr>						
					<tr>
						<th>설치 위경도</th><td colspan="5">${sensorInfo.sen_lon}/${sensorInfo.sen_lat }</td>
					</tr>
				</c:forEach>													
			</tbody>
		</table>
	</div>
	<div id="observatory-info-middle">
		<table border="1">
			<thead>
				<tr>
					<th colspan="6">관측소 사진 제공</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th colspan="6">station 테이블 정보 제공</th>
				</tr>
				<tr>
					<td>${stationInfo.sta_pic1 }</td><td>${stationInfo.sta_pic2 }</td>
				</tr>
				<tr>
					<td>${stationInfo.sta_pic3 }</td><td>${stationInfo.sta_pic4 }</td>
				</tr>															
			</tbody>
		</table>	
	</div>
	<div id="observatory-info-bottom">
		<c:if test="${historySwitch eq 'y' }">
			<table border="1">
				<tr>
					<th>점검 내용</th>
					<td>${stationHistory.get(0).history }</td>
				</tr>
			</table>
		</c:if>
		<c:if test="${historySwitch ne 'y' }">
			<table border="1">
				<thead>
					<tr>
						<th colspan="6">관측소 이력 정보</th>
					</tr>
					<tr>
						<th>순번</th>
						<th>등록일자</th>
						<th>관측소명</th>
						<th>관측소 코드</th>
						<th>점검 내용</th>
						<th>작성자</th>
					</tr>				
				</thead>
				<tbody>
					<c:if test="${stationHistory eq 'null' }">
						<tr>
							<td colspan="6">노 데이터</td>
						</tr>
					</c:if>
					<c:if test="${stationHistory ne 'null' }">
						<c:forEach items="${stationHistory }" var="hs" varStatus="status">
							<tr>
								<td>${status.index +1}</td>
								<td>${hs.history_date }</td>
								<td>${hs.obs_desc }</td>
								<td>${hs.obs_id }</td>
								<td>${hs.history }</td>
								<td>${hs.user_id }</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>	
		</c:if>
	</div>	
</body>
</html>
