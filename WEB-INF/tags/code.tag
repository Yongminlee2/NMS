<%@ tag language="java" pageEncoding="EUC-KR" body-content="empty"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="type" type="java.lang.String" required="true" description="combo, radio, code, codeDesc"%>
<%@ attribute name="grpCd" type="java.lang.String" required="true" description="그룹코드"%>
<%@ attribute name="id" type="java.lang.String" required="false"%>
<%@ attribute name="name" type="java.lang.String" required="false"%>
<%@ attribute name="style" type="java.lang.String" required="false" description="임의의 style"%>
<%@ attribute name="cls" type="java.lang.String" required="false" description="style의 class"%>
<%@ attribute name="value" type="java.lang.String" required="false" description="콤보박스, 라디오버튼의 선택된 값"%>
<%@ attribute name="defaultTxt" type="java.lang.String" required="false" description="콤보박스 : 초기값"%>
<%@ attribute name="defaultCheck" type="java.lang.Integer" required="false" description="라디오버튼 : default 체크되는 값(1,2,3,4,5...)"%>
<%@ attribute name="code" type="java.lang.String" required="false"%>
<%@ attribute name="codeDesc" type="java.lang.String" required="false"%>
<%@ attribute name="onchange" type="java.lang.String" required="false"%>
<c:set var="codeMap" value="<%=nms.util.controller.UtilController.CODE_MAP %>" />
<c:choose>
	<c:when test="${type eq 'combo'}">
		<select id="${id}" name="${name}" class="${cls}" style="${style}" onchange="${onchange}">
			<c:if test="${defaultTxt != null && fn:length(defaultTxt) gt 0 }">
				<option value="" >${defaultTxt}</option>
			</c:if>
			<c:if test="${fn:length(codeMap[fn:trim(grpCd)]) gt 0}">   
				<c:forEach var="result" items="${codeMap[fn:trim(grpCd)]}" varStatus="i">
					<c:set var="selChk" value="" />
					<c:if test="${result.codeId eq value}">
						<c:set var="selChk" value="selected" />
					</c:if>
					<option value="${result.codeId}" ${selChk}>${result.codeDesc}</option>
				</c:forEach>
			</c:if>
		</select>
	</c:when>
	
	<c:when test="${type eq 'radio'}">
		<c:if test="${fn:length(codeMap[fn:trim(grpCd)]) gt 0}">   
			<c:forEach var="result" items="${codeMap[fn:trim(grpCd)]}" varStatus="i">
				<c:set var="selChk" value="" />

				<c:if test="${i.codeId eq defaultCheck}">
					<c:set var="selChk" value="checked" />
				</c:if>

				<c:if test="${result.codeId eq value}">
					<c:set var="selChk" value="checked" />
				</c:if>
				<input type="${type}" id="${id}${i.count}" name="${name}" class="${cls}" style="${style}" value="${result.codeId}" ${selChk} /> ${result.codeDesc}
			</c:forEach>
		</c:if>
	</c:when>

	<c:when test="${type eq 'codeDesc'}">
		<c:if test="${fn:length(codeMap[fn:trim(grpCd)]) gt 0}">   
			<c:forEach var="result" items="${codeMap[fn:trim(grpCd)]}" varStatus="i">
				<c:if test="${fn:trim(result.codeId) eq fn:trim(code)}">
				${result.codeDesc}
				</c:if>    
			</c:forEach>
		</c:if>
	</c:when>

	<c:when test="${type eq 'codeId'}">
		<c:if test="${fn:length(codeMap[fn:trim(grpCd)]) gt 0}">   
			<c:forEach var="result" items="${codeMap[grpCd]}" varStatus="i">
				<c:if test="${fn:trim(result.codeDesc) eq fn:trim(codeDesc) }">
					${result.codeId}
				</c:if>    
			</c:forEach>
		</c:if>
	</c:when>
</c:choose>
