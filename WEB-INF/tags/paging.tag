<%@ tag language="java" pageEncoding="EUC-KR" body-content="empty"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="url" type="java.lang.String" required="true" description="�ش� �������� url ����"%>
<%@ attribute name="firstPage" type="java.lang.String" required="true" description="���� ������ ������ ù������"%>
<%@ attribute name="endPage" type="java.lang.String" required="true" description="���� ������ ������ ������������"%>
<%@ attribute name="lastPage" type="java.lang.String" required="true" description="�ش� �������� ���� ������ ������"%>
<%@ attribute name="curPage" type="java.lang.String" required="true" description="�ش� ���� ������"%>
<%@ attribute name="totalCnt" type="java.lang.String" required="true" description="�� ������ ��"%>

<form id="paging-form" action="${url }" method="post">
	<input type="hidden" name="page" value="">
</form>
<c:if test="${totalCnt > 0 }">
	<ul class="pagebox">
	  <li class="prev">
	  	<c:if test="${firstPage > 5 }">
		    <p class="btt_prev1" onclick="fnPaging('1')"><a href="#">firstprev</a></p>
		    <p class="btt_prev2" onclick="fnPaging('${firstPage-1 }')"><a href="#">prev</a></p>
	    </c:if>
	    <c:if test="${firstPage < 6 }">
		    <p class="btt_prev1"><a href="#">firstprev</a></p>
		    <p class="btt_prev2"><a href="#">prev</a></p>
	    </c:if>
	  </li>
	  <li class="page">
	  	<c:forEach begin="${firstPage }" end="${endPage }" varStatus="idx">
	<%--   		${idx.current  } --%>
	  		<c:if test="${curPage eq idx.current }">
	  			<p><a class="on" href="#">${idx.current }</a></p>
	  		</c:if>
	  		<c:if test="${curPage ne idx.current }">
	  			<p onclick="fnPaging('${idx.current }')" ><a href="#">${idx.current }</a></p>
	  		</c:if>  				
	  	</c:forEach>
	  </li>
	  <li class="next">
	  	<c:if test="${endPage eq lastPage }">
		    <p class="btt_next1"><a href="#">last next</a></p>
		    <p class="btt_next2"><a href="#">next</a></p>
	    </c:if>
	  	<c:if test="${endPage ne lastPage }">
		    <p class="btt_next1" onclick="fnPaging('${endPage +1}')" ><a href="#">next</a></p>
		    <p class="btt_next2" onclick="fnPaging('${lastPage}')" ><a href="#">last next</a></p>
	    </c:if>    
	  </li>
	</ul>
</c:if>