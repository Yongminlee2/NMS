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
	<title>�ѱ����¿��ڷ�::����͸� ����Ʈ����</title>
	<style type="text/css" media="all">
		
	</style>
</head>
	<body>
		<div id="pop_wrap">
			<section class="pop_body">
				<article class="pop_img">
					<img src="<c:url value="/img/pop_sta/${sta.img_url}"/>" alt="�����̹���">
				</article>
				<!--ǥ 2-->
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
								<th colspan="4">${sta.obs_name} ���� ������ ����</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>�����</th>
								<td>${sta.net_name}</td>
								<th>������ ��</th>
								<td>${sta.obs_name}</td>
							</tr>
							<tr>
								<th>��� �ڵ�</th>
								<td>${sta.net}</td>
								<th>������ �ڵ�</th>
								<td>${sta.obs_id}</td>
							</tr>
							<tr>
								<th>������ ����</th>
								<td>${sta.sta_tmp1}</td>
								<th>���浵</th>
								<td>${sta.lon}/${sta.lat}</td>
							</tr>
							<tr>
								<th>�ּ�</th>
								<td colspan="3">${sta.address}</td>
							</tr>
						</tbody>
						<!--1-->
						<thead>
							<tr>
								<th colspan="4">��ϰ� ����</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>������ȣ</th>
								<td>${sta.rec_id}</td>
								<th>�𵨸�</th>
								<td>${sta.rec_model}</td>
							</tr>
							<tr>
								<th>���ۻ�</th>
								<td>${sta.rec_company}</td>
								<th>�ø����ȣ</th>
								<td>${sta.rec_serial}</td>
							</tr>
						</tbody>
						<!--3-->
						<thead>
							<tr>
								<th colspan="4">���� ����</th>
							</tr>
							</thead>
						<tbody>
							<tr>
								<th>��ġ����</th>
								<td>${sta.sen_location}</td>
								<th>�𵨸�</th>
								<td>${sta.sen_model}</td>
							</tr>
							<tr>
								<th>���ۻ�</th>
								<td>${sta.sen_company}</td>
								<th>�ø����ȣ</th>
								<td>${sta.sen_serial}</td>
							</tr>
						</tbody>
					</table>
				</article>
			</section>
		</div>
	</body>
</html>



