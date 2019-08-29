<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags/" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
		
    <link href="<c:url value="/css/base.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/contrl.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />
    
	<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	
	<script src="<c:url value="/js/css/modernizr.js"/>"></script>
	<script src="<c:url value="/js/css/common.js"/>"></script>
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/user/list" />
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}//system/user" />
	
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
		tr{
			height:44px;
		}
		input,select{
			width:69%;
		}
		.modal{
			z-index:999;
			position:absolute;
			border:1px solid;
			width:500px;
			height:585px;
			top:17%;
			left:36%; 
			border-radius:12px; 
			background-color: white;
			display:none;
		}
		.modal-head{
		    background-color: #d8e8f5;
		    border-top-left-radius: 12px;
		    border-top-right-radius: 12px;
		    padding: 9px;
		    height: 18px;
		    text-align: center;
		    font-size: 16px;
		    font-weight: bold;
		}
		.modal-background{
			position: absolute;
			top:0px;height:200%;
			left:0px;width:200%;
			background-color: black;
			z-index:998;
			display: none;
			opacity:0.4;
		}
		.readonly{
			border:none;
		}
	</style>
	<script>
		var flag = "";
		var chkId = true;
		$(document).ready(function(){
			$("input[name='searchKeyword']").val('${searchKeyword}');
			$("input[name='searchKeyword2']").val('${searchKeyword2}');
			$("input[name='id']").focusout(function(){
// 				alert($(this).parent().html());
				var obj =$(this);
				if(chkId && flag != "mody"){
					$.ajax({
				          url: "${pageName2}/checkId.ws",
				          type: "POST",
				          dataType: 'json',
				          contentType: "application/json; charset=utf-8",
				          data: $(this).val(),
				          success : function(data){
				          	if(data.resultDesc != "success"){
				          		chkId = false;
				          		alert("아이디가 중복되었습니다.");
				          		obj.css("color","red");
				          		obj.focus();
				          	}else{
				          		chkId = true;
				          		obj.css("color","black");
				          	}
				          } 
		    		});
				}
			});
		});
		
		function fnDetailMemberInfo(obj){
			flag = "mody";
			$("#memberForm input[name='tmp2']").removeAttr("checked");
			$("#memberForm input[name='tmp3']").removeAttr("checked");
			var tr = $(obj).parent();
			$("#memberForm input[name='id']").val(tr.attr("user_id"));
			$("#memberForm input[name='id']").attr("readonly","readonly");
			$("#memberForm input[name='id']").addClass("readonly");
			$("#memberForm input[name='name']").val(tr.attr("user_name"));
// 			$("#memberForm input[name='pw']").val(tr.attr("user_pw"));
			$("#memberForm input[name='pw']").attr("placeHolder","입력시 기존 패스워드가 변경됩니다.");
			$("#memberForm input[name='pw2']").attr("placeHolder","입력시 기존 패스워드가 변경됩니다.");
// 			$("#memberForm input[name='pw2']").val(tr.attr("user_pw"));
			$("#memberForm select[name='org']").val(tr.attr("user_org")).attr("selected",true);
			$("#memberForm input[name='department']").val(tr.attr("user_id"));
			$("#memberForm input[name='duty']").val(tr.attr("user_duty"));
			$("#memberForm input[name='tel']").val(tr.attr("user_tel"));
			$("#memberForm input[name='email']").val(tr.attr("user_email"));
			$("#memberForm select[name='auth']").val(tr.attr("user_auth"));
			
			if(tr.attr("tmp2")=="y"){
				$("#memberForm input[name='tmp2']").prop("checked",true);
			}
			if(tr.attr("tmp3")=="y"){
				$("#memberForm input[name='tmp3']").prop("checked",true);
			}
			$("#delBtn").show();
			
			$("#modal-background").show();
			$("#user-modal").show();
// 			alert(staNo);

			if("${unaUser}"=="y"){
				console.log("y");
				$("#aBtn").hide();
				$("#sBtn").show();
			}else{
				console.log("n");
				$("#aBtn").show();
				$("#sBtn").hide();
			}

		}
		function fnShowModal(type,obj){
			flag = type;
			$("#memberForm input[name='id']").removeClass("readonly");
			$("#modal-background").show();
			$("#user-modal").show();
			$("#sBtn").show();
			$("#aBtn").hide();
		}
		function fnDeleteMember(){
			if(confirm("탈퇴하시겠습니까? \n삭제 후 복구는 불가능합니다.")){
				$.ajax({
			          url: "${pageName2}/DeleteMember.ws",
			          type: "POST",
			          dataType: 'json',
			          contentType: "application/json; charset=utf-8",
			          data: $("#modal-member-id").val(),
			          success : function(data){
			          	if(data.resultDesc == "success"){
			          		alert("완료되었습니다.");
			          		window.location.reload(true);
			          	}else{
			          		alert("작업이 실패하였습니다.");
			          	}
			          } 
		    		});
			}
			window.location.reload(); 
		}
		function fnModalClose(){
			$("#modal-background").hide();
			$("#user-modal").hide();
			$("#delBtn").hide();
			$("#memberForm input").each(function(i,v){
				$(this).val("");
				$(this).removeAttr("readonly");
				$(this).removeAttr("placeHolder");
			});
		}
		function fnInsertMember(){
			if(!validationCheck("memberForm")){
				alert("빈 값이 존재합니다."); 
				return false;
			}else if($("#pw").val() != $("#pw2").val()){
				alert("비밀번호를 확인하여주세요.");
				return false;
			}else if(!chkId){
				alert("아이디를 확인해주세요.");
				return false;
			}
//			console.log($("#station-form").serialize()+"&status=${status}");
		var jsonStr = formSerializeToJsonStr($("#memberForm").serialize()+"&start=a&update=b&last=c&tmp1=n&type="+flag,"one");
		console.log(jsonStr);
		
		$.ajax({
	          url: "${pageName2}/InsertMember.ws",
	          type: "POST",
	          dataType: 'json',
	          contentType: "application/json; charset=utf-8",
	          data: jsonStr,
	          success : function(data){
	          	if(data.resultDesc == "success"){
	          		alert("완료되었습니다.");
	          		window.location.reload(true);
	          	}else{
	          		alert("작업이 실패하였습니다.");
	          	}
	          } 
    		});
		}
		
		function fnUnaList(){
			$("#searchKeyword").val("");
			$("#searchKeyword2").val("");
			$("#switchKey").val(("${unaUser}"=="y"?"n":"y"));
			
			$("#user_page").val("1");
			$("#searchForm").submit();
		}
		function fnAcceptJoin(){
			//AcceptJoinMember
			$.ajax({
		          url: "${pageName2}/AcceptJoinMember.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: $("#memberForm input[name='id']").val(),
		          success : function(data){
		          	if(data.resultDesc == "success"){
		          		alert("승인 처리가 완료되었습니다.");
		          		window.location.reload(true);
		          	}else{
		          		alert("작업이 실패하였습니다.");
		          	}
		          } 
    		});
		}

	</script>
</head>
<body>
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">사용자 관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템 관리</li>
	       <li class="addNow">사용자 관리</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	       <!--선택박스-->
	       	<form id="searchForm" name="searchForm" action="${pageName }" method="post">
	        <input type="hidden" id="user_page" name="page" value="${pagingInfo.currentPage }">
	        <input type="hidden" id="switchKey" name="switchKey" value="${unaUser}">
	       <article class="selectbox_long">
	           <ul>
	             <li>사용자ID <input type="text" id="searchKeyword" name="searchKeyword" ></li>
	             <li>사용자명 <input type="text" id="searchKeyword2" name="searchKeyword2" ></li>

	             <li class="btt_filecomplt"><a href="javascript:searchForm.submit();">자료확인</a></li>
	           </ul>
	       </article>
	       </form>
	       <!--표-->
	       <article class="s_table2">
             <p class="f20">검색자료 <span class="fOrange">총 ${pagingInfo.totalCnt }건</span></p>
             <p class="f14"> 
             	<c:if test="${role eq 'ROLE_ADMIN' }">
	             	<c:if test="${unaUser eq 'y'}">
	             		<span onclick="fnUnaList()"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_sure.jpg"/>" alt="추가"></a></span>
	             	</c:if>
	             	<c:if test="${unaUser eq 'n'}">
		             	<span onclick="fnShowModal('new',this)"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_add.png"/>" alt="추가"></a></span>
	             		<span onclick="fnUnaList()"><a href="#" ><img style="width:80px;" src="<c:url value="/img/btt_sure_wating.jpg"/>" alt="추가"></a></span>
	             	</c:if>
             	</c:if>
             </p>
             <div style="min-height:535px;">
	             <table>
	               <caption>관측소 목록</caption>
	               <colgroup>
                          <col style="width:8%" />
                          <col style="width:8%" />
                          <col style="width:5%" />
                          <col style="width:8%" />
                          <col style="width:5%" />
                          <col style="width:10%" />
                          <col style="width:10%" />
                          <col style="width:10%" />
                          <col style="width:10%" />
	               </colgroup>
	               <thead>
	                 <tr>
	                   <th>ID</th>
	                   <th>사용자명</th>
	                   <th>기관</th>
	                   <th>부서</th>
	                   <th>직급</th>
	                   <th>연락처</th>
	                   <th>email</th>
	                   <th>가입일</th>
	                   <th>최종 접속일</th>
	                 </tr>
	               </thead>
	               <tbody>
	               <c:if test="${pagingInfo.totalCnt < 1 }">
	               		<tr>
	               			<td colspan="9">검색된 자료가 없습니다.</td>
	               		</tr>
	               </c:if>		               
					<c:forEach items="${userList}" var="ur" varStatus="idx">
						<c:if test="${(idx.index+1) % 2 eq 0}">
							<tr class="bg_gray2" user_id="${ur.id }" user_name="${ur.name }" user_org="${ur.org2 }" user_duty="${ur.duty }" user_tel="${ur.tel }" user_email="${ur.email }" user_auth="${ur.auth }" tmp2=${ur.tmp2 } tmp3=${ur.tmp3 }>
						</c:if>
						<c:if test="${(idx.index+1) % 2 ne 0}">
							<tr user_id="${ur.id }" user_name="${ur.name }" user_org="${ur.org2 }" user_duty="${ur.duty }" user_tel="${ur.tel }" user_email="${ur.email }" user_auth="${ur.auth }" tmp2=${ur.tmp2 } tmp3=${ur.tmp3 }>
						</c:if>
							<td onclick="fnDetailMemberInfo(this)">${ur.id }</td>
							<td>${ur.name2 }</td>
							<td>${ur.org }</td>
							<td>${ur.department }</td>
							<td>${ur.duty }</td>
							<td>${ur.tel2 }</td>
							<td>${ur.email }</td>
							<td>${ur.start }</td>
							<td>${ur.last }</td>
						</tr>
					</c:forEach>
	               </tbody>
	             </table>
             </div>
			<tag:paging url="${pageName }" firstPage="${pagingInfo.firstPage }" endPage="${pagingInfo.endPage }" lastPage="${pagingInfo.totalLastPage }" curPage="${pagingInfo.currentPage }" totalCnt="${pagingInfo.totalCnt }"/>
          </article>
	    </section>
	    
	</div>
	
	<div id="user-modal" class="modal" style="" >
<!-- 	<div class="modal" style="position:absolute; border:1px solid;width:500px;height:600px;top:17%;left:36%; border-radius:12px; background-color: white;" > -->
		<div class="modal-head">회원 정보</div>
		<div class="modal-body">
			<form id="memberForm">
			<article class="pop_table">
				<table>
					<tbody>
						<tr>
							<th>ID</th><td><input type="text" id="modal-member-id" name="id" placeholder="user001"></td>
						</tr>
						<tr>
							<th>이름</th><td><input type="text"  name="name"placeholder="홍길동"></td>
						</tr>
						<tr>
							<th>비밀번호</th><td><input id="pw" type="password"  name="pw"></td>
						</tr>
						<tr>
							<th>비밀번호 확인</th><td><input id="pw2" type="password"  name="pw2"></td>
						</tr>		
						<tr>
							<th>기관</th>
							<td>
								<select name="org">
									<option value="AL">전체</option>
									<option value="NC">원전</option>
									<option value="WP">수력</option>
									<option value="PP">양수</option>
									<option value="KP">경주변전소</option>
								</select>
							</td>
						</tr>	
						<tr>
							<th>부서</th><td><input type="text"  name="department"placeholder="내전설계팀"></td>
						</tr>			
						<tr>
							<th>직급</th><td><input type="text"  name="duty"placeholder="차장"></td>
						</tr>
						<tr>
							<th>전화번호</th><td><input type="text"  name="tel"placeholder="010-1234-1234"></td>
						</tr>										
						<tr>
							<th>이메일</th><td><input type="text"  name="email"placeholder="honggildong@khnp.co.kr"></td>
						</tr>
						<tr>
							<th>수신여부</th><td>E-mail<input type="checkbox"  name="tmp2" style="width:auto;"> SMS<input type="checkbox"  name="tmp3" style="width:auto;"></td>
						</tr>						
						<tr>
							<th>권한</th>
							<td>
								<select name="auth">
									<option value="ROLE_ADMIN">관리자</option>
									<option value="ROLE_USER">사용자</option>
									<option value="ROLE_VIEWER">뷰어</option>
									<option value="ROLE_OUTSIDER">외부인</option>
								</select>
							</td>
						</tr>																																										
					</tbody>
				</table>
			</article>
			</form>
		</div>
		<div class="modal-footer">
			<article class="pop_table">
<%-- 				<c:if test="${unaUser eq 'n' }"> --%>
				<a id="aBtn" href="#"><img style="width:98px;" src="<c:url value="/img/Crop_btt_okey.png"/>" onclick="fnAcceptJoin()"></a>
<%-- 				</c:if> --%>
<%-- 				<c:if test="${unaUser eq 'y' }"> --%>
				<a id="sBtn" href="#"><img style="width:98px;" src="<c:url value="/img/btt_note_save.png"/>" onclick="fnInsertMember()"></a>
<%-- 				</c:if> --%>
				<a href="#"><img style="width:98px;" src="<c:url value="/img/btt_note_cancle.png"/>" onclick="fnModalClose()"></a>
				<a href="#"><img style="width:98px;display: none;" id="delBtn" src="<c:url value="/img/Crop_btt_out.png"/>" onclick="fnDeleteMember()"></a>
			</article>
		</div>
	</div>
	
	<div id="modal-background" class="modal-background"></div>
</body>
</html>
