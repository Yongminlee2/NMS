<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" 			uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt"			uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"			uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring"		uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"		uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="page"		uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ taglib prefix="decorator" 	uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		<link href="<c:url value="/css/base.css"/>" rel="stylesheet" type="text/css" />
		<link href="<c:url value="/css/contrl.css"/>" rel="stylesheet" type="text/css" />
		<link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />	 
		<link href="<c:url value='/css/jquery-ui-1.10.3.css'/>" rel="stylesheet">
		<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery.form.js"/>"></script>
		<script src="<c:url value="/js/nms/common.js"/>"></script>
		<script src="<c:url value="/js/css/modernizr.js"/>"></script>
		<script src="<c:url value="/js/css/common.js"/>"></script>
		<decorator:head />
		<title><decorator:title default="한국수력원자력::모니터링 소프트웨어" /></title>
		
		<script type="text/javascript">
			var accessInfo;
			var accessAuth;
			function pageAccessSetting(){
				post("${pageContext.request.contextPath}/system/access/accessInfo.ws","",function(data){
// 					console.log(data);
					accessInfo = data.data;
					accessAuth = data.data2;
					
					for(var i = 0; i < accessInfo.length ; i ++)
					{
						if(accessAuth=="ROLE_ADMIN"){
							if(accessInfo[i].s1=="N"){
								$("#subMenu li[name='"+accessInfo[i].subcategory+"']").hide();
							}
						}else if(accessAuth=="ROLE_USER"){
							if(accessInfo[i].s2=="N"){
								$("#subMenu li[name='"+accessInfo[i].subcategory+"']").hide();
							}
						}else if(accessAuth=="ROLE_VIEWER"){
							if(accessInfo[i].s3=="N"){
								$("#subMenu li[name='"+accessInfo[i].subcategory+"']").hide();
							}							
						}else if(accessAuth=="ROLE_OUTSIDER"){
							
							if(accessInfo[i].s4=="N"){
								$("#subMenu li[name='"+accessInfo[i].subcategory+"']").hide();
							}						
						}
					}
					$("#userInfo .g1").hide();
// 					$("#userInfo .g2").html("!");
					$("#userInfo .g4").show();
				},function(){console.log('fail');});
			}
		</script>
	</head>
	<body class="sBg" onload="pageAccessSetting()">
<%-- 		${accessInfoTxt } --%>
		<div id="wrap">
			<section class="topGnb">
				<!--상단 메뉴-->
				<h1 class="logo"><a href="<c:url value="/"/>">한국수력원자력</a></h1>
				<ul class="gnb">
					<li class="g1" style="display:none;"><a href="<c:url value="/login"/>">로그인</a></li>
					<li class="g2" style="display:none;"><a href="<c:url value="/system/observatory/list"/>">정보수정</a></li>
					<li class="g4" ><a href="<c:url value="/j_spring_security_logout" />">로그아웃</a></li>
				</ul>
			</section>
			<!--## top menu ##-->
			<div id="gnb">
				<div id="mainMenu">
					<ul style="padding-left:160px;">
						<li id="m1"><a href="#">실시간모니터링</a></li>
						<li id="m2"><a href="#">지진발생현황</a></li>
						<li id="m3"><a href="#">데이터수신현황</a></li>
<!-- 						<li id="m4"><a href="#">분석및보고서</a></li>						 -->
						<li id="m5"><a href="#">시스템관리</a></li>
						<li id="m6"><a href="#">알림마당</a></li>
					</ul>
				</div>
				<div id="subMenu">
					<div class="sub">
						<div id="sub1">
							<ul>
								<li name="데이터수신현황"><a href="<c:url value="/monitoring/datareceived/list"/>" target="_self" class="mMnuS1">데이터수신현황</a></li>
								<li name="지반 가속도 모니터링"><a href="<c:url value="/monitoring/wave/list"/>" target="_self" class="mMnuS2">지반 가속도 모니터링</a></li>
							</ul>
						</div>
					</div>
					<div class="sub">
						<div id="sub2">
							<ul>
								<li name="지진발생정보"><a href="<c:url value="/quakeoccur/quakeinfo/list"/>" target="_self" class="mMnuS1">지진발생정보</a></li>
								<li name="지진 진도분포도"><a href="<c:url value="/quakeoccur/distribution/list"/>" target="_self" class="mMnuS2">지진 분포도</a></li>
								<li name="수동분석보고서"><a href="<c:url value="/quakeoccur/manualanalysis/list"/>" target="_self" class="mMnuS3">수동분석보고서</a></li>
							</ul>
						</div>
					</div>
					<div class="sub">
						<div id="sub3">
							<ul>
								<li name="국가지진관측망 DSS자료"><a href="<c:url value="/inforeceived/dss/list"/>" target="_self" class="mMnuS1">PGA 데이터 수신현황</a></li>
								<li name="국가지진관측망 RAW자료"><a href="<c:url value="/inforeceived/raw/list"/>" target="_self" class="mMnuS2">원시 데이터 수신 현황</a></li>
								<li name="원시데이터 수집률"><a href="<c:url value="/inforeceived/datacollrate/list"/>" target="_self" class="mMnuS3">원시데이터 수집률</a></li>
							</ul>
						</div>
					</div>
					<!-- <div class="sub">
						<div id="sub4">
							<ul>
								<li name=""><a href="/NMS/report/quakeanalysis/list" target="_self" class="mMnuS1">지진분석 현황</a></li>
								<li name=""><a href="/NMS/report/eventalarm/list" target="_self" class="mMnuS2">이벤트 통보현황</a></li>
							</ul>
						</div>
					</div> -->
					<div class="sub">
						<div id="sub5">
							<ul>
								<li name="관측소 관리"><a href="<c:url value="/system/observatory/list"/>" target="_self" class="mMnuS1">관측소 관리</a></li>
								<li name="보고서 관리"><a href="<c:url value="/system/report/list"/>" target="_self" class="mMnuS2">보고서 관리</a></li>
								<li name="접근권한 관리"><a href="<c:url value="/system/access/list"/>" target="_self" class="mMnuS3">접근권한 관리</a></li>
								<li name="트리거 관리"><a href="<c:url value="/system/trigger/list"/>" target="_self" class="mMnuS4">트리거 관리</a></li>
								<li name="로그 관리"><a href="<c:url value="/system/log/list"/>" target="_self" class="mMnuS5">로그 관리</a></li>
								<li name="이벤트 통보현황"><a href="<c:url value="/report/eventalarm/list"/>" target="_self" class="mMnuS2">이벤트 통보현황</a></li>
								<li name="이벤트 통보템플릿 관리"><a href="<c:url value="/system/ent/list"/>" target="_self" class="mMnuS6">이벤트 통보템플릿 관리</a></li>
								<li name="사용자 관리"><a href="<c:url value="/system/user/list"/>" target="_self" class="mMnuS7">사용자 관리</a></li>
<!-- 								<li><a href="/NMS/report/eventalarm/list" target="_self" class="mMnuS7">이벤트 통보 이력 관리</a></li> -->
							</ul>
						</div>
					</div>
					<div class="sub">
						<div id="sub6">
							<ul>
								<li name="공지사항"><a href="<c:url value="/board/notice/list"/>" target="_self" class="mMnuS1">공지사항</a></li>
								<li name="자료실"><a href="<c:url value="/board/info/list"/>" target="_self" class="mMnuS2">자료실</a></li>
								<!-- <li name="규모,진도 비교표"><a href="#" target="_self" class="mMnuS3">규모,진도 비교표</a></li> -->
							</ul>
						</div>
					</div>
				</div>
				<!--//submenu-->
			</div>
			<decorator:body />
			
			<div class="save-loading"></div>
		</div>
	</body>
</html>
