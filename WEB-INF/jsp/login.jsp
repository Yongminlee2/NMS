<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
    <link href="css/base.css" rel="stylesheet" type="text/css" />
    <link href="css/contrl.css" rel="stylesheet" type="text/css" />
    <link href="css/sub.css" rel="stylesheet" type="text/css" />
	<!-- Modernizr -->
    <script src="js/modernizr.js"></script>
    <!--[if lt IE 9]>
	<script type="text/javascript" src="common/js/respond.min.js"></script>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <script type="text/javascript" src="js/jquery.min.js"></script>
    
	<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery.validate.js" />"></script>
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js" />"></script>
	<script src="<c:url value="/js/nms/login.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
    <script src="<c:url value="/js/css/common.js"/>"></script>
	<c:set var="pageName2" 		value="${pageContext.request.contextPath}//main" />
	<title>한국수력원자력::로그인</title>
	<style type="text/css" media="all">
		tr{
			height:44px;
		}
		.modal input,select{
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
	</style>
</head>
<script>
var flag = "";
var chkId = true;
$(document).ready(function(){
	
	$("input[name='id']").focusout(function(){
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
	function fnModalClose(){
		$("#modal-background").hide();
		$("#user-modal").hide();
		$("#memberForm input").each(function(i,v){
			$(this).val("");
			$(this).removeAttr("readonly");
			$(this).removeAttr("placeHolder");
		});
	}
	function fnShowModal(){
		$("#modal-background").show();
		$("#user-modal").show();
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
		
		var jsonStr = formSerializeToJsonStr($("#memberForm").serialize()+"&start=a&update=b&last=c&tmp1=n&type="+flag,"one");
		console.log(jsonStr);
		console.log('${pageName2}/InsertMember.ws');
	
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
		console.log("end");
	}
</script>
<body class="sBg">
<div id="wrap">
   <!-----## TOP ##----->
   
   <!--## subTitle & Address ##-->
   <section class="con_title">
     <!--서브제목-->
     <p class="sTit"></p>
<!--      <ul class="address"> -->
<!--        <li class="addHome">Home</li> -->
<!--        <li>자료수신현황</li> -->
<!--        <li class="addNow">DSS자료</li> -->
<!--      </ul> -->
   </section>
   <!--## contents ##-->
   <section class="con_body">
   	<form id="loginForm" name="loginForm" class="form-signin" action="<c:url value='j_spring_security_check'/>" method="post" autocomplete="off">
    <article class="loinBox">
      <ul>
	      <li>
	         <p><input name="j_username" type="text" placeholder="아이디"></p>
	         <p><input name="j_password" type="password" placeholder="비밀번호"></p>
	      </li>
      	<li class="btn-login"><input type="image" src="<c:url value="/img/btt_login.gif"/>"></li>
      	<li class="chekTxt"><input name="idSave" type="checkbox" value="" id="keepid" class="checkbox"> 아이디 저장</li>
      	<li class="chekTxt" style="margin-top:10px;margin-left:467px;"><span onclick="fnShowModal()"><a href="#"><img style="width:212px;" src="<c:url value="/img/btt_join.jpg"/>" ></a></span></li>
      </ul>
	<div class="error-box" style="position: absolute;top: 450px;left: 340px;">
		<c:if test="${not empty login_error}">
			<div id="alertMessage" class="alert alert-error">
<!-- 					<button type="button" class="close" data-dismiss="alert">&times;</button> -->
				<c:if test="${login_error eq 1 }">
					<b style="color:red;">Login Error!</b> : 아이디 또는 비밀번호를 다시 확인하세요. 등록되지 않은 아이디이거나, 아이디 또는 비밀번호를 잘못 입력하셨습니다.
				</c:if>
				<c:if test="${login_error eq 2 }">
					<b style="color:red;">Login Error!</b> : 허가되지 않은 사용자입니다. 관리자의 허가를 기다려주세요.
				</c:if>				
			</div>
		</c:if>
	</div>      
    </article>
    </form>
   </section>
    
</div>
<div id="user-modal" class="modal" style="" >
	<div class="modal-head">회원 정보</div>
	<div class="modal-body">
		<form id="memberForm">
		<article class="pop_table">
			<table>
				<tbody>
					<tr>
						<th>ID</th><td><input type="text" name="id" placeholder="user001"></td>
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
			<a href="#"><img style="width:98px;" src="<c:url value="/img/btt_note_save.png"/>" onclick="fnInsertMember()"></a>
			<a href="#"><img style="width:98px;" src="<c:url value="/img/btt_note_cancle.png"/>" onclick="fnModalClose()"></a>
			<c:if test="${unaUser eq 'y' }">
				<a href="#"><img style="width:98px;" src="<c:url value="/img/btt_note_cancle.png"/>" onclick="fnAcceptJoin()"></a>
			</c:if>
		</article>
	</div>
</div>

<div id="modal-background" class="modal-background"></div>
</body>
</html>



