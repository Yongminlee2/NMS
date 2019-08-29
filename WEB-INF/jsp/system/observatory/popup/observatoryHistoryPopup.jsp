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
/* 		.info-modal { */
/* 			height: 332px!important; */
/* 		} */
/* 		td{ */
/* 			width: 100px; */
/* 		} */
		.popup-info-container div{
			display:none;
		}
		form input,select{
			border: 0px;
			height:100%;
			width:100%;
			text-align: center;
			color:#72716f;
			font-family: Calibri, sans-serif;
		}
		form .shot-select{
			width:20%;
		}
		
		ul.tabs {
		    margin: 0;
		    padding: 0;
		    float: left;
		    list-style: none;
		    height: 32px;
		    border-bottom: 1px solid #eee;
		    border-left: 1px solid #eee;
		    width: 100%;
		    font-family:"dotum";
		    font-size:12px;
		}
		ul.tabs li {
		    float: left;
		    text-align:center;
		    cursor: pointer;
		    width:82px;
		    height: 31px;
		    line-height: 31px;
		    border: 1px solid #eee;
		    border-left: none;
		    font-weight: bold;
		    background: #fafafa;
		    overflow: hidden;
		    position: relative;
		    color:black;
		}
		ul.tabs li.active {
		    background: #FFFFFF;
		    border-bottom: 1px solid #FFFFFF;
/* 		    color:darkred; */
		}
	 	.modal_img{
	 		width: 150px;
	 		height: 150px;
/* 	 		position: absolute; */
	/*  		border: 1px solid; */
	/*  		border-color: rgb(212,212,212); */
	 		left:50%;
/* 	 		margin-top : 20px; */
	 		margin-left:-75px;
	 		background: url('/NMS/img/dodo1.png') no-repeat;
	 		border-radius : 15px;
	 		display: block;
	 	}		
	</style>
	<script>
		var observatoryImgObj = new Image();
		var fileObj = "";
		$(document).ready(function(){
			$(".popup-info-container div:first").show();
		});
		function fnExcelDownload(){
			alert("엑셀 다운로드를 시작합니다. \n완료될때까지 기다려주세요.");

			$(".search-form").attr('action','${pageContext.request.contextPath}/system/observatory/getStationExcel.do').submit();
			
// 			alert("엑셀 다운로드가 완료되기 전까지 화면의 조작을 멈춰주세요.");
			
			
			
						
		}
	</script>
</head>
<body style="overflow-y:hidden;">
<form class="search-form" name="searchForm2" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" id="" name="type" value="${param.type }" />
	<input type="hidden" id="sta_no" name="sta_no" value='${param.sh_no }'/>
</form>
<!-- 	<div style="width:50px;height:50px;position: absolute;top:200px;left:50%;background-color:black;"></div> -->
	<div class="popup-tap-wrap">
		<div id="pop_wrap">
		  <section class="pop_topTit">
		    <h1>지진관측소 이력</h1>
		  </section>
		</div>
		<div class="popup-info-container">
			<!-- 관측소 정보 영역 -->
			<div id="observatory-tab" class="tab-contrainer">
				<form id="station-form" name="station-form" enctype="multipart/form-data" action="${pageContext.request.contextPath}/system/observatory/insert" method="post">
				  <section class="pop_body">
				    <h2>${historyInfo.obs_name } 관측소</h2>
				    <span style="float:right;margin-right:26px;"><a href="#"  onclick="fnExcelDownload()"><img src="<c:url value="/img/btt_exell_down.png"/>" alt="엑셀"></a></span>
<!-- 				    <span style="float:right;">저장</span> -->
				       <!--표 1-->
				       	<c:if test="${type eq 'sta' }">
				             <article class="pop_table">
				              <table>
				                <caption>관측소 기본 정보</caption>
				                <colgroup>
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16%" />
		                            <col style="width:16%" />
				                </colgroup>
				                <thead>
				                  <tr>
<!-- 				                  <span style="float:right;margin-right:12px;"><button>저장</button></span> -->
				                    <th colspan="6">관측소 정보</th>
				                  </tr>
				                </thead>
				                <tbody>
				                   <tr>
				                    <th>관측소 코드</th>
				                    <td><input type="text" name="obs_id" value="${historyInfo.obs_id }"></td>
				                    <th>관측소명</th>
				                    <td><input type="text" name="obs_name" value="${historyInfo.obs_name }"></td>
				                    <th>소속기관</th>
				                    <td><input type="text" name="net" value="${historyInfo.net }"></td>
				                   </tr>
				                  <tr>
									<th>원전구분</th>
				                    <td><input type="text" name="sta_tmp1" value="${historyInfo.sta_tmp1 }"></td>				                  
				                    <th>관측소 주소</th>
				                    <td colspan="3"><input type="text" name="address" value="${historyInfo.address }"></td>
				                  </tr>
				                  <tr>
				                    <th>계약일자</th>
				                    <td><input type="text" name="contractdate" value="${historyInfo.contractdate }"></td>
				                    <th>준공일자</th>
				                    <td><input type="text" name="completedate" value="${historyInfo.completedate }"></td>
				                    <th>계약금액</th>
				                    <td><input type="text" name="price_contract" value="${historyInfo.price_contract }"></td>
				                  </tr>
				                  <tr>
				                    <th>소프트웨어 비용</th>
				                    <td><input type="text" name="price_sw" value="${historyInfo.price_sw }"></td>
				                    <th>계측장비 도입 비용</th>
				                    <td><input type="text" name="price_hw" value="${historyInfo.price_hw }"></td>
				                    <th>관측소 지역 코드</th>
				                    <td><input type="text" name="area" value="${historyInfo.area }"></td>
				                  </tr>					                  
				                  <tr>
				                    <th>관측 시작일</th>
				                    <td><input type="text" name="opendate" value="${historyInfo.opendate }"></td>
				                    <th>관측 종료일</th>
				                    <td><input type="text" name="offdate" value="${historyInfo.offdate }"></td>
				                    <th>시설물 종류</th>
				                    <td><input type="text" name="obs_kind" value="${historyInfo.obs_kind }"></td>
				                  </tr>
				                  <tr>
				                    <th>관측소 설치 위치</th>
				                    <td><input type="text" name="position" value="${historyInfo.position }"></td>
				                    <th>지상 높이</th>
				                    <td><input type="text" name="ground_ht" value="${historyInfo.ground_ht }"></td>
				                    <th>지하 높이</th>
				                    <td><input type="text" name="uground_ht" value="${historyInfo.uground_ht }"></td>
				                  </tr>				                  	
				                  <tr>
				                    <th>위도</th>
				                    <td><input type="text" name="lat" value="${historyInfo.lat }"></td>
				                    <th>경도</th>
				                    <td><input type="text" name="lon" value="${historyInfo.lon }"></td>
				                    <th>고도</th>
				                    <td><input type="text" name="altitude" value="${historyInfo.altitude }"></td>
				                  </tr>
				                  <tr>
				                    <th>기초 형식</th>
				                    <td><input type="text" name="base" value="${historyInfo.base }"></td>
				                    <th>구조물 형식</th>
				                    <td><input type="text" name="str_cd" value="${historyInfo.str_cd }"></td>
				                    <th>설계기준</th>
				                    <td><input type="text" name="seis_cd" value="${historyInfo.seis_cd }"></td>
				                  </tr>
				                  <tr>
				                    <th>지반 분류</th>
				                    <td><input type="text" name="ground" value="${historyInfo.ground }"></td>
				                    <th>주상도 여부</th>
				                    <td>
					                    <select name="hole" class="shot-select">
					                    	<c:if test="${historyInfo.hole eq 'Y'}">
					                    		<option selected="selected">Y</option>
					                    		<option>N</option>
					                    	</c:if>
											<c:if test="${historyInfo.hole ne 'Y'}">
					                    		<option>Y</option>
					                    		<option selected="selected">N</option>
					                    	</c:if>				                    	
					                    </select>
				                    </td>
				                    <th>내진설계 적용 여부</th>
				                    <td>
				                    	<select name="seis_ds" class="shot-select">
					                    	<c:if test="${historyInfo.seis_ds eq 'Y'}">
					                    		<option selected="selected">Y</option>
					                    		<option>N</option>
					                    	</c:if>
											<c:if test="${historyInfo.seis_ds ne 'Y'}">
					                    		<option>Y</option>
					                    		<option selected="selected">N</option>
					                    	</c:if>				                    	
					                    </select>
					                </td>
				                  </tr>
				                  <tr>
				                    <th>설계가속도</th>
				                    <td><input type="text" name="design_acc" value="${historyInfo.design_acc }"></td>
				                    <th>임계치</th>
				                    <td><input type="text" name="threshold_acc" value="${historyInfo.threshold_acc }"></td>
				                    <th>건물층수</th>
				                    <td><input type="text" name="build_floor" value="${historyInfo.build_floor }"></td>
				                  </tr>
				                  <tr>
				                    <th>지진구역</th>
				                    <td>
				                    	<select name="eq_area" class="shot-select">
					                    	<c:if test="${historyInfo.seis_ds eq '1'}">
					                    		<option selected="selected">1</option>
					                    		<option>2</option>
					                    	</c:if>
											<c:if test="${historyInfo.seis_ds ne '1'}">
					                    		<option>1</option>
					                    		<option selected="selected">2</option>
					                    	</c:if>				                    	
					                    </select>
					                </td>				                    
				                    <th>주상도이미지명</th>
				                    <td><input type="text" name="hole_map" value="${historyInfo.hole_map }"></td>
				                    <th>설치 업체명</th>
				                    <td><input type="text" name="charge" value="${historyInfo.charge }"></td>
				                  </tr>			
				                  <tr>
				                    <th>설치 업체 연락처</th>
				                    <td><input type="text" name="contact" value="${historyInfo.contact }"></td>
				                    <th>사용자 아이디</th>
				                    <td><input type="text" name="user_id" value="${historyInfo.user_id }"></td>
				                    <th>등록 일자</th>
				                    <td><input type="text" name="regdate" value="${historyInfo.regdate }"></td>
				                  </tr>			
				                  <tr>
				                    <th>sta_type</th>
				                    <td><input type="text" name="sta_type" value="${historyInfo.sta_type }"></td>
				                    <th>수신 관측소 IP 정보</th>
				                    <td colspan="3"><input type="text" name="sta_ip" value="${historyInfo.sta_ip }"></td>
				                  </tr>
				                  <tr>
				                  	<th colspan="6">관측소 점검 내역</th>
				                  </tr>
				                  <c:forEach items="${historyList }" var="hl">
				                  	<tr>
				                  		<th>점검일자</th>
				                  		<td>${hl.sta_tmp3 }</td>
				                  		<th>점검내용</th>
				                  		<td colspan="3">${hl.sta_tmp2 }</td>
				                  	</tr>
				                  </c:forEach>
<!-- 				                  <tr> -->
<!-- 				                    <th>점검내역</th> -->
<%-- 				                    <td colspan="5"><input type="text" name="sta_tmp2" value="${historyInfo.sta_tmp2 }"></td> --%>
<!-- 				                  </tr>				                   -->
<!-- 				                  <tr> -->
<!-- 				                  	<td colspan="6"> -->
 <!-- 										<span onclick="fnAjaxTest()">저장</span> --> 
<!-- 										<span onclick="fnSaveStationInfo()">저장</span> -->
<!-- 									</td> -->
<!-- 				                  </tr>				                  	                  	                  				                  						                  				                   -->
				                </tbody>
				              </table>
				            </article>
				            </c:if>
				            
				            
				            <c:if test="${type eq 'sen' }">
				             <article class="pop_table">
				              <table>
				                <caption>관측소 기본 정보</caption>
				                <colgroup>
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16%" />
		                            <col style="width:16%" />
				                </colgroup>
				                <thead>
				                  <tr>
<!-- 				                  <span style="float:right;margin-right:12px;"><button>저장</button></span> -->
				                    <th colspan="6">센서 정보</th>
				                  </tr>
				                </thead>
				                <tbody>
				                   <tr>
				                    <th>관측소 코드</th>
				                    <td><input type="text" name="obs_id" value="${historyInfo.obs_id }"></td>
				                    <th>관측소명</th>
				                    <td><input type="text" name="obs_name" value="${historyInfo.obs_name }"></td>
				                    <th>소속기관</th>
				                    <td><input type="text" name="net" value="${historyInfo.net }"></td>
				                   </tr>
				                  <tr>
									<th>센서 분류 코드</th>
				                    <td><input type="text" name="sta_tmp1" value="${historyInfo.sen_id }"></td>				                  
				                    <th>센서 위치</th>
				                    <td><input type="text" name="address" value="${historyInfo.sen_location }"></td>
				                    <th>센서 제조회사</th>
				                    <td><input type="text" name="address" value="${historyInfo.sen_company }"></td>				                    
				                  </tr>
				                  <tr>
				                    <th>센서 모델</th>
				                    <td><input type="text" name="contractdate" value="${historyInfo.sen_model }"></td>
				                    <th>센서 시리얼 번호</th>
				                    <td><input type="text" name="completedate" value="${historyInfo.sen_serial }"></td>
				                    <th>가속도계 분류</th>
				                    <td><input type="text" name="price_contract" value="${historyInfo.sen_kind }"></td>
				                  </tr>
				                  <tr>
				                    <th>센서 설치 층수 및 위치</th>
				                    <td><input type="text" name="price_sw" value="${historyInfo.sen_position }"></td>
				                    <th>센서 채널 성분</th>
				                    <td><input type="text" name="price_hw" value="${historyInfo.sen_channel }"></td>
				                    <th>기록계 분류 코드</th>
				                    <td><input type="text" name="area" value="${historyInfo.sen_rec_id }"></td>
				                  </tr>					                  
				                  <tr>
				                    <th>센서 설치 경도</th>
				                    <td><input type="text" name="opendate" value="${historyInfo.sen_lon }"></td>
				                    <th>센서 설치 위도</th>
				                    <td><input type="text" name="offdate" value="${historyInfo.sen_lat}"></td>
				                    <th>등록일자</th>
				                    <td><input type="text" name="obs_kind" value="${historyInfo.regdate }"></td>
				                  </tr>
				                  <tr>
				                    <th>지진가속도계 Z 성분 Response</th>
				                    <td><input type="text" name="position" value="${historyInfo.sen_z_resp }"></td>
				                    <th>지진가속도계 N 성분 Response</th>
				                    <td><input type="text" name="ground_ht" value="${historyInfo.sen_n_resp }"></td>
				                    <th>지진가속도계 E 성분 Response</th>
				                    <td><input type="text" name="uground_ht" value="${historyInfo.sen_e_resp }"></td>
				                  </tr>	
				                  <tr>
				                    <th>기록계 Z 성분 Sensitivity</th>
				                    <td><input type="text" name="position" value="${historyInfo.sen_z_sens }"></td>
				                    <th>기록계 N 성분 Sensitivity</th>
				                    <td><input type="text" name="ground_ht" value="${historyInfo.sen_z_sens }"></td>
				                    <th>기록계 E 성분 Sensitivity</th>
				                    <td><input type="text" name="uground_ht" value="${historyInfo.sen_z_sens }"></td>
				                  </tr>	
				                  <tr>
				                  	<th colspan="6">센서 점검 내역</th>
				                  </tr>
				                  <c:forEach items="${historyList }" var="hl">
				                  	<tr>
				                  		<th>점검일자</th>
				                  		<td>${hl.sen_tmp3 }</td>
				                  		<th>점검내용</th>
				                  		<td colspan="3">${hl.sen_tmp2 }</td>
				                  	</tr>
				                  </c:forEach>				                  				                  			                  	
<!-- 				                  <tr> -->
<!-- 				                    <th>점검내역</th> -->
<%-- 				                    <td colspan="5"><input type="text" name="sta_tmp2" value="${historyInfo.sen_tmp1 }"></td> --%>
<!-- 				                  </tr>				                   -->
<!-- 				                  <tr> -->
<!-- 				                  	<td colspan="6"> -->
 <!-- 										<span onclick="fnAjaxTest()">저장</span> --> 
<!-- 										<span onclick="fnSaveStationInfo()">저장</span> -->
<!-- 									</td> -->
<!-- 				                  </tr>				                  	                  	                  				                  						                  				                   -->
				                </tbody>
				              </table>
				            </article>
				            </c:if>
				            
				            
				            
				            <c:if test="${type eq 'rec' }">
				             <article class="pop_table">
				              <table>
				                <caption>관측소 기본 정보</caption>
				                <colgroup>
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16.1%" />
		                            <col style="width:16%" />
		                            <col style="width:16%" />
				                </colgroup>
				                <thead>
				                  <tr>
<!-- 				                  <span style="float:right;margin-right:12px;"><button>저장</button></span> -->
				                    <th colspan="6">기록계 정보</th>
				                  </tr>
				                </thead>
				                <tbody>
				                   <tr>
				                    <th>관측소 코드</th>
				                    <td><input type="text" name="obs_id" value="${historyInfo.obs_id }"></td>
				                    <th>관측소명</th>
				                    <td><input type="text" name="obs_name" value="${historyInfo.obs_name }"></td>
				                    <th>소속기관</th>
				                    <td><input type="text" name="net" value="${historyInfo.net }"></td>
				                   </tr>
				                  <tr>
									<th>기록계 분류 코드</th>
				                    <td><input type="text" name="sta_tmp1" value="${historyInfo.rec_id }"></td>				                  
				                    <th>보증기간</th>
				                    <td><input type="text" name="address" value="${historyInfo.warrenty }"></td>
				                    <th>기록계 제조회사</th>
				                    <td><input type="text" name="address" value="${historyInfo.rec_company }"></td>				                    
				                  </tr>
				                  <tr>
				                    <th>기록계 모델</th>
				                    <td><input type="text" name="contractdate" value="${historyInfo.rec_model }"></td>
				                    <th>기록계 시리얼 번호</th>
				                    <td><input type="text" name="completedate" value="${historyInfo.rec_serial }"></td>
				                    <th>데이터 포멧</th>
				                    <td><input type="text" name="price_contract" value="${historyInfo.wformat }"></td>
				                  </tr>
				                  <tr>
				                    <th>기록계 전송 프로토콜</th>
				                    <td><input type="text" name="price_sw" value="${historyInfo.protocol }"></td>
				                    <th>등록일자</th>
				                    <td><input type="text" name="price_hw" value="${historyInfo.regdate }"></td>
				                    <td></td>
				                    <td></td>
				                  </tr>	
				                  <tr>
				                  	<th colspan="6">기록계 점검 내역</th>
				                  </tr>
				                  <c:forEach items="${historyList }" var="hl">
				                  	<tr>
				                  		<th>점검일자</th>
				                  		<td>${hl.rec_tmp3 }</td>
				                  		<th>점검내용</th>
				                  		<td colspan="3">${hl.rec_tmp2 }</td>
				                  	</tr>
				                  </c:forEach>						                  				                  
<!-- 				                  <tr> -->
<!-- 				                    <th>점검내역</th> -->
<%-- 				                    <td colspan="5"><input type="text" name="sta_tmp2" value="${historyInfo.rec_tmp1 }"></td> --%>
<!-- 				                  </tr>				                   -->
<!-- 				                  <tr> -->
<!-- 				                  	<td colspan="6"> -->
 <!-- 										<span onclick="fnAjaxTest()">저장</span> --> 
<!-- 										<span onclick="fnSaveStationInfo()">저장</span> -->
<!-- 									</td> -->
<!-- 				                  </tr>				                  	                  	                  				                  						                  				                   -->
				                </tbody>
				              </table>
				            </article>
				            </c:if>
				            <!--표4-->
				    </section>
			    </form>
			</div>
		</div>		
	</div>
</body>
</html>
