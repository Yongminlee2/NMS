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
	    <link href="<c:url value="/css/main.css"/>" rel="stylesheet" type="text/css" />	 
	    
	    <script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
	    <script src="<c:url value="/js/jquery/jquery.form.js"/>"></script>
		<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	    <script src="<c:url value="/js/css/modernizr.js"/>"></script>
	    <script src="<c:url value="/js/nms/common.js"/>"></script>
	    <script src="<c:url value="/js/css/common.js"/>"></script>
	       
		<title><decorator:title default="NMS" /></title>
		
		<decorator:head />
	</head>
	<body>
		<decorator:body />
		
		<div class="save-loading"></div>
	</body>
</html>
