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
	
	<c:set var="pageName" 		value="${pageContext.request.contextPath}//system/ent" />
	
	
	<!-- 1. 기타로 조회시 생각 -->

	<style>
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
		tr{
			height:44px;
		}
		.con-word{
			width:100%;
			height:100%;
			border:none;
			text-align:center;
		}
	</style>
	<script>
		$(document).ready(function(){
			
		});
		
		function fnDetailStationInfo(staNo){
			var url = "${pageContext.request.contextPath}//system/observatory/popup";
			fnOpenPop(url,1100,900,"sta_no="+staNo);
		}
		function getByteSet(obj){
			var val;
			var shap = false;
			if($(obj).val().indexOf("#") > -1){
				val = $(obj).val().split("#");
				shap=true;
			}else{
				val = $(obj).val();
			}
			var bVal = "";
			var conByte = 0;
			var msgArr = [];
			if(shap){
				for(var i=1;i<val.length;i++){
					conByte += getByteConText("#"+val[i].substring(0,1));
					bVal += val[i].substring(1,val[i].length);
				}
			}else{
				bVal = val;
			}
			
			var txtByte = conByte+getByteLength(bVal);
			console.log("bate : "+txtByte);
			$(obj).parent().parent().children("td").eq(2).children("span").html(txtByte);
		}
		
		function fnSaveConText(){
			var data = "[";
			
			for(var j = 0 ; j < 4 ; j ++)
			{	
				data+="{\"tNo\":\""+(j+1)+"\"";
				var msgArr = [];
				var cnt=1;
				var val;
				if($("#input"+(j+1)).val().indexOf("#") > -1){
					val = $("#input"+(j+1)).val().split("#");
					for(var i=0;i<val.length;i++){
						if(i>0){
							data+= ",\"tText"+(cnt++)+"\""+":\"#"+val[i].substring(0,1)+"\"";
							data+= ",\"tText"+(cnt++)+"\""+":\""+val[i].substring(1,val[i].length)+"\"";
						}else{
							data+= ",\"tText"+(cnt++)+"\""+":\""+val[i]+"\"";
						}
					}
					for(var k=cnt;k<76;k++)
					{
						data+= ",\"tText"+(k)+"\""+":\"\"";
					}
				}else{
					data+= ",\"tText1\""+":\""+$("#input"+(j+1)).val()+"\"";
					for(var k=2;k<76;k++)
					{
						data+= ",\"tText"+(k)+"\""+":\"\"";
					}
				}
				data+=",\"t_tmp1\":\""+$("#byte"+(j+1)).html()+"\"";
				data+=",\"tCnt\":\""+(cnt-1)+"\"";
				data+="}";
				if(j < 3 ){
					data+=",";
				}
			}
			
			data+="]";
			console.log(data);
			
// 			return false;
			$.ajax({
				url: "${pageName}/update.ws",
				type: "POST",
		        dataType: 'json',
		        contentType: "application/json; charset=utf-8",
				data: data,
				success : function(data){
					if(data.resultDesc=="success"){
						alert("수정하였습니다.");
					}else if (data.reulstDesc=="fail"){
						alert("오류가 발생하였습니다.");
					}else{
						alert("업데이트에 실패하였습니다.");
					}
					window.location.reload();
				} 
			}); 
			console.log(JSON.parse(data));
		}
		
		/*일반문자열 byte계산*/		
		function getByteLength(message){
			var totalByte = 0;
			
	        for(var i =0; i < message.length; i++) {
                var currentByte = message.charCodeAt(i);
                if(currentByte > 128) totalByte += 2;
				else totalByte++;
        	}
	        return totalByte;
		}		
		/*규약어 byte계산*/
		function getByteConText(txt){
			var conArr = ["#T","#O","#S","#M","#G","#L","#Y","#I","#R","#N"];
			var conVal = [19,4,4,4,12,4,19,5,8,3];
			if(conArr.indexOf(txt)==-1){
				return getByteLength(txt);
			}else{
				return conVal[conArr.indexOf(txt)];
			}
			
		}
	</script>
</head>
<body>
	<div id="wrap">
	   <!--## subTitle & Address ##-->
	   <section class="con_title">
	     <!--서브제목-->
	     <p class="sTit">이벤트 통보템플릿 관리</p>
	     <ul class="address">
	       <li class="addHome">Home</li>
	       <li>시스템 관리</li>
	       <li class="addNow">이벤트 통보템플릿 관리</li>
	     </ul>
	   </section>
	   <!--## contents ##-->
	   <section class="con_body">
	   	<p class="f14">  <span style="float:right" onclick="fnSaveConText()"><a href="#" ><img style="width:98px;" src="<c:url value="/img/btt_note_save.png"/>" alt="추가"></a></span></p>
	   	<article class="pop_table" style="width:100%;">
		   	<table>
		   		<thead>
		   			<tr>
		   				<td colspan="3" style="font-size:18px;font-weight: bold;">규약어 정보 표시</td>
		   			</tr>
		   			<tr>
		   				<th>구분</th>
		   				<th>전송 내용</th>
		   				<th>비고</th>
		   			</tr>		   			
		   		</thead>
		   		<tbody>
		   			<tr>
		   				<td>이벤트감지(1단계)</td>
		   				<td><input id="input1" class="con-word" value="${value1.tText1 } ${value1.tText2 }" onkeyup="getByteSet(this)"></td>
		   				<td><span id="byte1">${value1.t_tmp1 }</span> Byte</td>
		   			</tr>
		   			<tr>
		   				<td>이벤트감지(2단계)</td>
		   				<td><input id="input2" class="con-word" value="${value2.tText1 } ${value2.tText2 }" onkeyup="getByteSet(this)"></td>
		   				<td><span id="byte2">${value2.t_tmp1 }</span> Byte</td>
		   			</tr>
		   			<tr>
		   				<td>이벤트감지(3단계)</td>
		   				<td><input id="input3" class="con-word" value="${value3.tText1 } ${value3.tText2 }" onkeyup="getByteSet(this)"></td>
		   				<td><span id="byte3">${value3.t_tmp1 }</span> Byte</td>
		   			</tr>
		   			<tr>
		   				<td>지진 발생(원전)</td>
		   				<td><input id="input4" class="con-word" value="${value4.tText1 } ${value4.tText2 }" onkeyup="getByteSet(this)"></td>
		   				<td><span id="byte4">${value4.t_tmp1 }</span> Byte</td>
		   			</tr>
		   			<tr>
		   				<td>지진 발생(수력)</td>
		   				<td><input id="input5" class="con-word" value="${value5.tText1 } ${value5.tText2 }" onkeyup="getByteSet(this)"></td>
		   				<td><span id="byte5">${value5.t_tmp1 }</span> Byte</td>
		   			</tr>
		   			<tr>
		   				<td>지진 발생(양수)</td>
		   				<td><input id="input6" class="con-word" value="${value6.tText1 } ${value6.tText2 }" onkeyup="getByteSet(this)"></td>
		   				<td><span id="byte6">${value6.t_tmp1 }</span> Byte</td>
		   			</tr>		   					   			
		   		</tbody>
		   	</table>
	   	</article>
	   <span style="float:right;">#이 포함된 특수 문자는 규약어로 처리될 수 있으니 확인바랍니다.</span>
		<br><br>
		<article class="pop_table" style="width:100%;">
		   	<table>
		   		<thead>
		   			<tr>
		   				<td colspan="6" style="font-size:18px;font-weight: bold;">규약어</td>
		   			</tr>	 
		   			<tr>
		   				<th>구분자</th>
		   				<th>크기</th>
		   				<th>설명</th>
		   			</tr>  			
		   		</thead>
		   		<tbody>
		   			<tr>
		   				<th>#T</th>
		   				<td>19 byte</td>
		   				<td>감지시간 정보(2017-01-02 12:12:12)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#O</th>
		   				<td>4 byte</td>
		   				<td>감지구분 명(원전,수력,양수)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#S</th>
		   				<td>4 byte</td>
		   				<td>감지관측소 명(고리, 춘천, 무주)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#M</th>
		   				<td>4 byte</td>
		   				<td>감지 규모(02.1)</td>	   				
		   			</tr>
<!-- 		   			<tr> -->
<!-- 		   				<th>#J</th> -->
<!-- 		   				<td>2 byte</td> -->
<!-- 		   				<td>감지 진도(Ⅶ)</td>	   				 -->
<!-- 		   			</tr> -->
		   			<tr>
		   				<th>#G</th>
		   				<td>12 byte</td>
		   				<td>감지 g 값 (자체지진용)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#L</th>
		   				<td>4 byte</td>
		   				<td>감지 단계(주의)</td>	   				
		   			</tr>		   					   					   					   					   			
		   			<tr>
		   				<th>#Y</th>
		   				<td>19 byte</td>
		   				<td>지진 발생 시간(2017-06-20 12:23:45)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#I</th>
		   				<td>5 byte</td>
		   				<td>진앙지와의 거리(22km)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#R</th>
		   				<td>8 byte</td>
		   				<td>감지 g 값(지진통보용)</td>	   				
		   			</tr>
		   			<tr>
		   				<th>#N</th>
		   				<td>3 byte</td>
		   				<td>개행문자(\r\n)</td>	   				
		   			</tr>		 		   					   					   			   				   			
		   		</tbody>
		   	</table>
	   	</article>	       
	       
	    </section>
	    
	</div>
</body>
</html>
