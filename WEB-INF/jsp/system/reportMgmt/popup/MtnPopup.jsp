<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no,target-densitydpi=medium-dpi">
    
    <link href="<c:url value="/css/base.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/sub.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/css/common.css"/>" rel="stylesheet" type="text/css" />
	<!-- 1. 기타로 조회시 생각 -->
	<script src="<c:url value="/js/jquery/jquery-1.10.2.js"/>"></script>
	<script src="<c:url value="/js/jquery/jquery-ui-1.10.3.js"/>"></script>
	<script src="<c:url value="/js/nms/common.js"/>"></script>
	
	<script src="<c:url value="/js/css/common.js"/>"></script>
	<title>한국수력원자력::모니터링 소프트웨어</title>
	<style>
	</style>
	<script>
		$(document).ready(function(){
			var date = '${report.rpt_date}';
			if(date!=""){
				$("#yyyy").val(date.substring(0,4));
				$("#mm").val(date.substring(5,7));
				$("#dd").val(date.substring(8,10));
			}
			$("td").on("click",function(i,v){
				$(this).children().attr("checked","checked");
			});
			
		});
		
		function getToday(){
			var d = new Date();
			var tday = d.getFullYear()+"-"+getFormattedPartTime(d.getMonth()+1)+"-"+getFormattedPartTime(d.getDate());
			return tday;
		}
		
		function fnSaveMaintenance(flag){
			var txt = "rpt_data : "+$("#yyyy").val()+"-"+$("#mm").val()+"-"+$("#dd").val()+"\n";
			var jsonStr = "{";
			var savaFlag = false;
			txt +="net : "+$("#net-ipt").val()+"\n";
			txt +="obs_id : "+$("#obs-ipt").val()+"\n";
			
			jsonStr += "\"rpt_rno\":\""+'${l_no}'+"\",";
			jsonStr += "\"net\":\""+$("#net-ipt").val()+"\",";
			jsonStr += "\"obs_id\":\""+$("#obs-ipt").val()+"\",";
			var arr = [];
// 			alert(typeof a == $("input[name='q1_3']:checked").val());
			$("#MtnForm input[type='radio']").each(function(i,v){
				  var myname= this.name;
				  if( $.inArray( myname, arr ) < 0 ){
				     arr.push(myname);
				  }
			});
			
			for(var i = 0 ; i < arr.length ; i++)
			{
				txt +=arr[i]+" : "+$("input[name='"+arr[i]+"']:checked").val()+"\n";	
				jsonStr += "\""+arr[i]+"\":\""+$("input[name='"+arr[i]+"']:checked").val()+"\",";
			}
			
			txt += "bigo : "+$("#bigo").val()+"\n";
			txt += "result : "+$("#result").val()+"\n";
			txt += "user_dept : "+$("input[name='user_dept']").val()+"\n";
			txt += "user_duty : "+$("input[name='user_duty']").val()+"\n";
			txt += "user_name : "+$("input[name='user_name']").val()+"\n";
			txt += "user_tel : "+$("input[name='user_tel']").val()+"\n";
			
			jsonStr += "\"bigo\":\""+$("#bigo").val()+"\",";
			jsonStr += "\"result\":\""+$("#result").val()+"\",";
			jsonStr += "\"user_dept\":\""+$("input[name='user_dept']").val()+"\",";
			jsonStr += "\"user_duty\":\""+$("input[name='user_duty']").val()+"\",";
			jsonStr += "\"user_name\":\""+$("input[name='user_name']").val()+"\",";
			jsonStr += "\"user_tel\":\""+$("input[name='user_tel']").val()+"\",";
			jsonStr += "\"rpt_date\":\""+$("#yyyy").val()+"-"+$("#mm").val()+"-"+$("#dd").val()+"\"}";
			
// 			alert(txt);
			jsonStr = jsonStr.replace(/undefined/gi,"");
			console.log(jsonStr);
			console.log(flag);
			var txtName = "RPT04_"+$("#net-ipt").val()+"_"+$("#obs-ipt").val()+"_"+getToday().replace("-","").replace("-","");
			
// 			if(flag=="t"){
// 				if(confirm("전송하시겠습니까?")){
// 					saveAjax(jsonStr,txtName,txt);
// 				}else{
					saveOnlyAjax(jsonStr);
// 				}
// 			}else{
// 				sendOnlyAjax(txtName,txt);
// 			}
			
		}
		function sendOnlyAjax(tName,text){
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/sendReport.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: "${l_no}&"+tName+"&"+text,
		          success : function(data){
				      	if(data.resultDesc=="success")
				      	{
				      		alert("전송 및 저장이 완료되었습니다.");
			          	}else{
			          		alert("전송에 실패하였습니다.");
			          	}
		          } 
			});
		}
		function saveOnlyAjax(jStr){
			console.log("saveOnly");
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/updateMaintenance.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jStr,
		          success : function(data){
				      	if(data.resultDesc=="success")
				      	{
				      		alert("저장이 완료되었습니다.");
			        		opener.parent.location.reload();
			        		window.close();
			          	}else{
			          		alert("저장이 실패하였습니다.");
			          	}
		          } 
  		});
		}
		function saveAjax(jStr,tName,text){
			console.log("save");
			$.ajax({
		          url: "${pageContext.request.contextPath}/system/report/updateMaintenance.ws",
		          type: "POST",
		          dataType: 'json',
		          contentType: "application/json; charset=utf-8",
		          data: jStr,
		          success : function(data){
				      	if(data.resultDesc=="success")
				      	{
							$.ajax({
						          url: "${pageContext.request.contextPath}/system/report/sendReport.ws",
						          type: "POST",
						          dataType: 'json',
						          contentType: "application/json; charset=utf-8",
						          data: "${l_no}&"+tName+"&"+text,
						          success : function(data){
								      	if(data.resultDesc=="success")
								      	{
								      		alert("전송 및 저장이 완료되었습니다.");
							          	}else{
							          		alert("전송에 실패하였습니다.");
							          	}
						          } 
				  			});
			          	}else{
			          		alert("저장에 실패하였습니다.");
			          	}
		          } 
    		});
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<input type="hidden" id="net-ipt" value="${report.net }">
<input type="hidden" id="obs-ipt" value="${report.obs_id }">
<div id="pop_wrap">
  <section class="pop_topTit2">
    <h1 style="width:90%;">${report.obs_name } 지진가속도계측기 정기점검 보고서</h1>
    <ul class="pop_top_btt">
    <c:if test="${report.l_status eq '6' or report.l_status eq '5'}">
    	<li><a href="#"><img src="<c:url value="/img/btt_save.png"/>" onclick="fnSaveMaintenance('t')" alt="전송"></a></li>
    </c:if>
<%--     	<li><a href="#" onclick="fnSaveMaintenance('f')"><img src="<c:url value="/img/btt_pop_send.png"/>" alt="다음" /></a></li> --%>
    </ul>
  </section>
  <section class="pop_body">
  	<form id="MtnForm" >
       <!--표 1-->
             <article class="pop_table_report3">
              <table>
                <caption>관측소 기본 정보</caption>
                <colgroup>
                            <col style="width:15%" />
                            <col style="width:5%" />
                            <col style="width:5%" />
                            <col style="width:10%" />
                            <col style="width:10%" />
                            <col style="width:10%" />
                            <col style="width:15%" />
                </colgroup>
                <thead>
                  <tr>
                    <th>점검일자</th>
                    <th rowspan="2">점 검 자</th>
                    <th colspan="2">소 속</th>
                    <th>직 책</th>
                    <th>성 명</th>
                    <th>연 락 처</th>
                  </tr>
                   <tr>
                    <td><input type="text" class="short2" id="yyyy"> 년 <input type="text" class="short" id="mm"> 월 <input type="text" class="short" id="dd"> 일</td>
                    <td> 담당<br>부서 </td>
                    <td><input type="text" name="user_dept" value="${report.user_dept }"></td>
                    <td><input type="text" class="mid" name="user_duty" value="${report.user_duty }"></td>
                    <td><input type="text" class="mid" name="user_name" value="${report.user_name }"></td>
                    <td><input type="text" name="user_tel" value="${report.user_tel }"></td>
                  </tr>
                </thead>
              </table>
            </article>
                         
            <!--표 2-->
             <article class="pop_table_report3">
              <table>
                <caption>관측소 기본 정보</caption>
                <colgroup>
                            <col style="width:20%" />
                            <col style="width:70%" />
                            <col style="width:5%" />
                            <col style="width:5%" />
                </colgroup>
                <thead>
                
                  <tr>
                    <th rowspan="2">구분</th>
                    <th>점검 내용</th>
                    <th colspan="2">확인</th>
                  </tr>
                   <tr>
                    <th>항목</th>
                    <th>적합</th>
                    <th>부적합</th>
                  </tr>
                </thead>
                <tbody>
                   <tr>
                    <td rowspan="4">설치상태</td>
                    <td class="tleft">지반 또는 시설물의 바닥에 견고히 고정</td>
                    <c:if test="${report.q1_1 eq 'Y' }">
	                    <td><input name="q1_1" value="Y" type="radio" checked></td>
	                    <td><input name="q1_1" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q1_1 eq 'N' }">
	                    <td><input name="q1_1" value="Y" type="radio"></td>
	                    <td><input name="q1_1" value="N" type="radio" checked></td>
                    </c:if>
                    <c:if test="${report.q1_1 eq '' }">
	                    <td><input name="q1_1" value="Y" type="radio"checked></td>
	                    <td><input name="q1_1" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                   <tr>
                    <td class="tleft">기후변화, 전가지 및 낙뢰 영향 방지 등의 보호장치 작동 여부</td>
                   	<c:if test="${report.q1_2 eq 'Y' }">
	                    <td><input name="q1_2" value="Y" type="radio" checked></td>
	                    <td><input name="q1_2" value="N" type="radio"></td>
                    </c:if>
                   	<c:if test="${report.q1_2 eq 'N' }">
	                    <td><input name="q1_2" value="Y" type="radio"></td>
	                    <td><input name="q1_2" value="N" type="radio" checked></td>
                    </c:if>
                   	<c:if test="${report.q1_2 eq '' }">
	                    <td><input name="q1_2" value="Y" type="radio"checked></td>
	                    <td><input name="q1_2" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td class="tleft">자유장 지진가속계측센서의 수평방향이 동서방향과 남북방향 유지 여부</td>
                    <c:if test="${report.q1_3 eq 'Y' }">
	                    <td><input name="q1_3" value="Y" type="radio"checked></td>
	                    <td><input name="q1_3" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q1_3 eq 'N' }">
	                    <td><input name="q1_3" value="Y" type="radio"></td>
	                    <td><input name="q1_3" value="N" type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q1_3 eq '' }">
	                    <td><input name="q1_3" value="Y" type="radio"checked></td>
	                    <td><input name="q1_3" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td class="tleft">모든 지진가속도계측센서의 동일한 좌표축 유지 여부</td>
                    <c:if test="${report.q1_4 eq 'Y' }">
	                    <td><input name="q1_4" value="Y" type="radio" checked></td>
	                    <td><input name="q1_4" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q1_4 eq 'N' }">
	                    <td><input name="q1_4" value="Y" type="radio"></td>
	                    <td><input name="q1_4" value="N" type="radio" checked></td>
                    </c:if>
                    <c:if test="${report.q1_4 eq '' }">
	                    <td><input name="q1_4" value="Y" type="radio"checked></td>
	                    <td><input name="q1_4" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td rowspan="4">전원부</td>
                    <td class="tleft">지진가속도계측기 접지 여부</td>
                    <c:if test="${report.q2_1 eq 'Y' }">
	                    <td><input name="q2_1" value="Y" type="radio"checked></td>
	                    <td><input name="q2_1" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q2_1 eq 'N' }">
	                    <td><input name="q2_1" value="Y" type="radio"></td>
	                    <td><input name="q2_1" value="N" type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q2_1 eq '' }">
	                    <td><input name="q2_1" value="Y" type="radio"checked></td>
	                    <td><input name="q2_1" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                   <tr>
                    <td class="tleft">외부 입력 전기/전화선에 서지보호장지(Surge Protector)작동 여부</td>
                    <c:if test="${report.q2_2 eq 'Y' }">
	                    <td><input name="q2_2" value="Y" type="radio"checked></td>
	                    <td><input name="q2_2" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q2_2 eq 'N' }">
	                    <td><input name="q2_2" value="Y" type="radio"></td>
	                    <td><input name="q2_2" value="N" type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q2_2 eq '' }">
	                    <td><input name="q2_2" value="Y" type="radio"checked></td>
	                    <td><input name="q2_2" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td class="tleft">연결상태 및 전원 공급 정상 상태 확인</td>
                    <c:if test="${report.q2_3 eq 'Y' }">
	                    <td><input name="q2_3" value="Y" type="radio"checked></td>
	                    <td><input name="q2_3" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q2_3 eq 'N' }">
	                    <td><input name="q2_3" value="Y" type="radio"></td>
	                    <td><input name="q2_3" value="N" type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q2_3 eq '' }">
	                    <td><input name="q2_3" value="Y" type="radio"checked></td>
	                    <td><input name="q2_3" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td class="tleft">비상전원공급장치 작동 여부</td>
                    <c:if test="${report.q2_4 eq 'Y' }">
	                    <td><input name="q2_4" value="Y" type="radio"checked></td>
	                    <td><input name="q2_4" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q2_4 eq 'N' }">
	                    <td><input name="q2_4" value="Y" type="radio"></td>
	                    <td><input name="q2_4" value="N" type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q2_4 eq '' }">
	                    <td><input name="q2_4" value="Y" type="radio"checked></td>
	                    <td><input name="q2_4" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td rowspan="2">지진가속도계측 센서/지진 가속도 기록계</td>
                    <td class="tleft">연결부와 고리부분 등 외관의 피해 및 손상 여부 확인</td>
                    <c:if test="${report.q3_1 eq 'Y' }">
	                    <td><input name="q3_1" value="Y"type="radio"checked></td>
	                    <td><input name="q3_1" value="N"type="radio"></td>
                    </c:if>
                    <c:if test="${report.q3_1 eq 'N' }">
	                    <td><input name="q3_1" value="Y"type="radio"></td>
	                    <td><input name="q3_1" value="N"type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q3_1 eq '' }">
	                    <td><input name="q3_1" value="Y"type="radio"checked></td>
	                    <td><input name="q3_1" value="N"type="radio"></td>
                    </c:if>                                        
                  </tr>
                   <tr>
                    <td class="tleft">구성품 손/망실여부 확인</td>
                    <c:if test="${report.q3_2 eq 'Y' }">
	                    <td><input name="q3_2" value="Y" type="radio"checked></td>
	                    <td><input name="q3_2" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q3_2 eq 'N' }">
	                    <td><input name="q3_2" value="Y" type="radio"></td>
	                    <td><input name="q3_2" value="N" type="radio"checked></td>
                    </c:if>
                    <c:if test="${report.q3_2 eq '' }">
	                    <td><input name="q3_2" value="Y" type="radio"checked></td>
	                    <td><input name="q3_2" value="N" type="radio"></td>
                    </c:if>
                  </tr>
                  <tr>
                    <td rowspan="3">현장 점검</td>
                    <td class="tleft">지진가속도계측센서 및 지진가속도기록계 설치 장소 이상 유무</td>
                    <c:if test="${report.q4_1 eq 'Y' }">
	                    <td><input name="q4_1" value="Y" type="radio" checked></td>
	                    <td><input name="q4_1" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q4_1 eq 'N' }">
	                    <td><input name="q4_1" value="Y" type="radio"></td>
	                    <td><input name="q4_1" value="N" type="radio" checked></td>
                    </c:if>
                    <c:if test="${report.q4_1 eq '' }">
	                    <td><input name="q4_1" value="Y" type="radio"checked></td>
	                    <td><input name="q4_1" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                   <tr>
                    <td class="tleft">전원장치 이상 유무 확인</td>
                    <c:if test="${report.q4_2 eq 'Y' }">
	                    <td><input name="q4_2" value="Y" type="radio" checked></td>
	                    <td><input name="q4_2" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q4_2 eq 'N' }">
	                    <td><input name="q4_2" value="Y" type="radio"></td>
	                    <td><input name="q4_2" value="N" type="radio" checked></td>
                    </c:if>
                    <c:if test="${report.q4_2 eq '' }">
	                    <td><input name="q4_2" value="Y" type="radio"checked></td>
	                    <td><input name="q4_2" value="N" type="radio"></td>
                    </c:if>                                        
                  </tr>
                  <tr>
                    <td class="tleft">통신선 이상유무 확인</td>
                    <c:if test="${report.q4_3 eq 'Y' }">
	                    <td><input name="q4_3" value="Y" type="radio" checked></td>
	                    <td><input name="q4_3" value="N" type="radio"></td>
                    </c:if>
                    <c:if test="${report.q4_3 eq 'N' }">
	                    <td><input name="q4_3" value="Y" type="radio"></td>
	                    <td><input name="q4_3" value="N" type="radio" checked></td>
                    </c:if>
                    <c:if test="${report.q4_3 eq '' }">
	                    <td><input name="q4_3" value="Y" type="radio"checked></td>
	                    <td><input name="q4_3" value="N" type="radio"></td>
                    </c:if>
                  </tr>
                  <tr>
                    <td>점검 결과</td>
                    <td colspan="3" class="tleft">부적합 사항 조치 내용 및 조치계획<br>
<%--                        <div id="bigo" style="border:1px solid;width:97%;height:75px;background-color: white;" contenteditable="true">${report.bigo }</div> --%>
						<textarea id="bigo" name="message" rows="4" maxlength="256">${report.bigo }</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>처리 결과</td>
                    <td colspan="3" class="tleft">조치 내용<br>
<%--                        <div id="result" style="border:1px solid;width:97%;height:75px;background-color: white;" contenteditable="true">${report.result }</div> --%>
						<textarea id="result" name="message" rows="4"  maxlength="256">${report.result }</textarea>
                    </td>
                  </tr>
                </tbody>
              </table>
            </article>
       </form>
    </section>
    
</div>
</body>
</html>
