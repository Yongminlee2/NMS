/* ﻿ajax post */
function post(webServiceUrl, requestData, fnSuccess, fnError) {
    $.ajax({
        type: "POST",
        url: webServiceUrl,
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        data: decodeURIComponent((requestData+'').replace(/\+/g, '%20').replace(/%+/g, '%25')),
		beforeSend: function(xhr) {
            xhr.setRequestHeader("AJAX", true);
            if($(".save-loading").length > 0) $(".save-loading").show();
        },
        complete: function(){
        	if($(".save-loading").length > 0) $(".save-loading").hide();
        },
        success: fnSuccess,
        error: fnError
    });
}

/**
 * 팝업 기능 
 * @param url 열고자 하는 페이지 
 * @param width 팝업창 너비
 * @param height 팝업창 높이
 * @param popKey 팝업에 사용될 Key값 ( name=value & name2=value )
 */
function fnOpenPop(url,width,height,popKey) {
	
//	url = "${pageContext.request.contextPath}//pallet/weekly/popup/insertLastWeek?productCode=" + $(el).attr("productCode");
	var winHeight	= document.body.clientHeight;		// 현재창의 높이
	var winWidth	= document.body.clientWidth;		// 현재창의 너비
	
	var popWidth = width;//940
    var popHeight = height;//530
	
    if(popKey != null || popKey != "")
    {
    	url = url + "?"+popKey;
    }
    
	var detailWindow = window.open(url,"lastWeekPop","resizable=yes,width="+popWidth+"px,height="+popHeight+"px,top="+(screen.availHeight - popHeight) / 2+",left="+(window.screenLeft + (winWidth - popWidth)/2));
	
	if(detailWindow.focus)
		detailWindow.focus();
	
	/*
	타이머 : 팝업 창이 닫혔을때의 이벤트
	var timer = setInterval(function() {   
	    if(detailWindow.closed) {  
	        clearInterval(timer);
	        fnPageWeeklyReportSearchList();
	    }  
	}, 1000);
	*/
}

function fnOpenPopForReport(url,width,height,popKey,event) {
	
//	url = "${pageContext.request.contextPath}//pallet/weekly/popup/insertLastWeek?productCode=" + $(el).attr("productCode");
	var winHeight	= document.body.clientHeight;		// 현재창의 높이
	var winWidth	= document.body.clientWidth;		// 현재창의 너비
	
	var popWidth = width;//940
    var popHeight = height;//530
	
    if(popKey != null || popKey != "")
    {
    	url = url + "?"+popKey;
    }
    
	var detailWindow = window.open(url,"lastWeekPop","resizable=yes,width="+popWidth+"px,height="+popHeight+"px,top="+(screen.availHeight - popHeight) / 2+",left="+(window.screenLeft + (winWidth - popWidth)/2));
	
	if(detailWindow.focus)
		detailWindow.focus();
	
	
//	타이머 : 팝업 창이 닫혔을때의 이벤트
	var timer = setInterval(function() {   
	    if(detailWindow.closed) {  
	        clearInterval(timer);
	        event;
	    }  
	}, 1000);
	
}	

function getToday(type){
	var d = new Date();
	
	var tday = d.getFullYear()+"-"+getFormattedPartTime(d.getMonth()+1)+"-"+getFormattedPartTime(d.getDate());
	if(type=="noBar"){
		tday = tday.repalce(/-/gi,"");
	}
	return tday;
}
/**
 * 문자열 앞뒤 공백제거
 * @param str
 */
function trim(str){
	return str.replace(/(^\s*)|(\s*$)/g,"");
}
/**
 * 문자열 전체 공백 제거
 * @param str
 */
function compactTrim(str){
	return str.replace(/(\s*)/g,"");
}
/**
 * 날짜포멧 01,02,11
 * @param month 날짜(월,일)
 */
function getFormattedPartTime(month){
	if(month < 10)
		return "0"+month;
	return month;
}
/**
 * 썸네일 이미지 출력 함수
 */
function previewImage(targetObj, previewId) {
	fileObj = targetObj.files[0];
    var preview = document.getElementById(previewId); //div id   
    var ua = window.navigator.userAgent;

    if (ua.indexOf("MSIE") > -1) {//ie일때

        targetObj.select();

        try {
            var src = document.selection.createRange().text; // get file full path 
            var ie_preview_error = document
                    .getElementById("ie_preview_error_" + previewId);

            if (ie_preview_error) {
                preview.removeChild(ie_preview_error); //error가 있으면 delete
            }

            var img = document.getElementById(previewId); //이미지가 뿌려질 곳 

            img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"
                    + src + "', sizingMethod='scale')"; //이미지 로딩, sizingMethod는 div에 맞춰서 사이즈를 자동조절 하는 역할
        } catch (e) {
            if (!document.getElementById("ie_preview_error_" + previewId)) {
                var info = document.createElement("<p>");
                info.id = "ie_preview_error_" + previewId;
                info.innerHTML = "a";
                preview.insertBefore(info, null);
            }
        }
    } else { //ie가 아닐때
        var files = targetObj.files;
        for ( var i = 0; i < files.length; i++) {

            var file = files[i];

            var imageType = /image.*/; //이미지 파일일경우만.. 뿌려준다.
            if (!file.type.match(imageType))
                continue;

            var prevImg = document.getElementById("prev_" + previewId); //이전에 미리보기가 있다면 삭제
            if (prevImg) {
                preview.removeChild(prevImg);
            }

            var img = document.createElement("img"); //크롬은 div에 이미지가 뿌려지지 않는다. 그래서 자식Element를 만든다.
            img.id = "prev_" + previewId;
            img.classList.add("obj");
            img.file = file;
            if(previewId == "previewId2"){
            	img.style.width = '338px'; //기본설정된 div의 안에 뿌려지는 효과를 주기 위해서 div크기와 같은 크기를 지정해준다.
            	img.style.height = '179px';
            	
            }else{
            	img.style.width = '150px'; //기본설정된 div의 안에 뿌려지는 효과를 주기 위해서 div크기와 같은 크기를 지정해준다.
            	img.style.height = '150px';
            }
            img.style.backgroundColor = "white";
            
            preview.appendChild(img);

            if (window.FileReader) { // FireFox, Chrome, Opera 확인.
                var reader = new FileReader();
                reader.onloadend = (function(aImg) {
                    return function(e) {
                        aImg.src = e.target.result;
                        tempImg = e.target.result;
                    };
                })(img);
                reader.readAsDataURL(file);
            } else { // safari is not supported FileReader
                if (!document.getElementById("sfr_preview_error_"
                        + previewId)) {
                    var info = document.createElement("p");
                    info.id = "sfr_preview_error_" + previewId;
                    info.innerHTML = "not supported FileReader";
                    preview.insertBefore(info, null);
                }
            }
        }
    }
}

/**
 * 페이징 함수
 * @param curPage
 */
function fnPaging(page)
{

	$("#searchForm input[name='page']").val(page);
	$("#searchForm").submit();
}

/**
 * input 속성(attr) vaild="true"속성인 값이 공백인지 체크.
 * @param form
 */
function validationCheck(form)
{	
	var returnFlag = true;
	var nameArr = [];
//	console.log($("#"+form+" input").eq(0).html());
	$("#"+form+" input[type='text']").each(function(idx,obj){
		if($(obj).val().replace(/(^\s*)|(\s*$)/gi, "")=="" && $(obj).attr("vaild")!="false"){
			$(obj).val("");
			returnFlag = false;
			$(obj).attr("placeholder","입력해주세요.");
			$(obj).addClass("vaild-fail");
			
			/*
			 * 이벤트 제거
			 */
			$(obj).on("focus",function(){
				$(this).removeAttr("placeholder");
				$(this).removeClass("vaild-fail");
			});
			
//			console.log(obj);
		}
	});
	/* 라디오 버튼 vaild 체크. 제외 없이 모두 체크 가장 마지막에 체크*/
	$("#"+form+" input[type='radio']").each(function(i,v){
		  var myname= this.name;
		  if( $.inArray( myname, arr ) < 0 ){
			  var chkval = $("#"+form+" input[name='"+myname+"']:checked").val();
			  if(typeof chkval == "undefined"){
//				 console.log("stop");
				 return false;
			  }else{
//			     console.log("ok");
			     nameArr.push(myname);
			  }
		  }
	});
	return returnFlag;
}
/**
 * jsonData 생성 함수
 * @param data list인 경우 object(form객체) 그 외의 경우 form.serialize된 str 
 * @param type list or ''
 */
function formSerializeToJsonStr(data,type)
{	
	var fcnt = 0;
	var jsonStr = "";
//		console.log($("#station-form").serialize());
	if(type=="list")
	{	
		jsonStr = "[";
		data.children("tr").each(function(i,v){
			if($(this).attr("chk")!="no"){
				jsonStr+=(jsonStr=="["?"{":",{");
				$(this).children("td").each(function(i,v){
					$(this).children("input").each(function(i,v){
						var name = $(this).attr("name");
						var value= $(this).val();
						jsonStr += (fcnt++<1?"":",")+"\""+name+"\""+":"+"\""+value+"\"";
					});
				
				});
				jsonStr+="}";
				fcnt=0;
			}
		});
		jsonStr += "]";
	}
	else if(type=="table")
	{
		var jsonStr = "[";
		$("#"+data+" tr").each(function(i,v){
			if($(this).attr("mody")=="mody" || $(this).attr("mody")=="new"){
				jsonStr += "{\"l_tmp3\":\""+$(this).attr("mody")+"\",";
				$(this).children("td[chk='true']").each(function(i,v){
					var obj  = "";
					if($(this).attr("type")=="input"){
						obj  = $(this).children("input");
//							alert(obj.val());
						jsonStr += "\""+obj.attr("name")+"\":\""+obj.val()+"\",";
					}else{
						obj = $(this);
						jsonStr += "\""+obj.attr("name")+"\":\""+obj.html()+"\",";
					}
				});
				jsonStr = jsonStr.substring(0,jsonStr.length-1);
				jsonStr += "},";
			}
		});
		jsonStr = jsonStr.substring(0,jsonStr.length-1);
		jsonStr += "]";
	}
	else
	{	
		/*한글 Encording*/
		data = decodeURIComponent((data+'').replace(/\+/g,'%20')).split("&");
		var jsonStr = "{";
		for(var i=0;i<data.length;i++)
		{
			var tmpData = data[i].split("=");
			jsonStr += "\""+tmpData[0]+"\""+":"+"\""+tmpData[1]+"\"";
			if((i+1)<data.length)
			{
				jsonStr+=",";
			}
		}
		jsonStr += "}";		
	}
	
	return jsonStr;
}

/**
 * 문자 LENGTH 만큼 지정된 문자로 채우기
 * @param input, length, string, type
 * input 대상 문자열
 * length 길이
 * string 채울 문자열
 * type 채울 문자 위치
 */
function str_pad(input, length, string, type) {
	if (input.length >= length) return input;	
	
	var string = string || '0', 
		input = input + '',
		type = type || 'STR_PAD_LEFT​';
		inputLength = input.length;
		pad = Array(length - inputLength + 1).join(string);
	switch (type) {
		case 'STR_PAD_LEFT​': 
			result = pad + input;
			break;
		case 'STR_PAD_RIGHT': 
			result = input + pad;
			break;
		case 'STR_PAD_BOTH': 
			var i = parseInt((length - inputLength) / 2);
			result = pad.substring(0,i) + input + pad.substring(i, length - i + 1);			
			break;
	}
	return result;

}

/**
 * 지도에서 상단 계산
 * @param top
 * top 좌표값을 이미지상의 값으로 변환
 */
function fnCalTop(targetlat)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	
	var seoulTop = 147;
	
	var dis1 = parseInt(calculateDistance(seoullat, seoullong, targetlat, seoullong)) * 1.01;
	var targetTop;
	
	if(seoullat > targetlat)
	{
		targetTop = seoulTop + dis1;
	}
	else
	{
		targetTop = seoulTop - dis1;
	}
	
	return targetTop;
}

/**
 * 지도에서 왼쪽 계산
 * @param left
 * left 좌표값을 이미지상의 값으로 변환
 */
function fnCalLeft(targetlong)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulLeft = 170;
	
	var dis2 = parseInt(calculateDistance(seoullat, seoullong, seoullat, targetlong)) * 1.009;
	var targetLeft;
	
	if(seoullong > targetlong)
	{
		targetLeft = seoulLeft - dis2;
	}
	else
	{
		targetLeft = seoulLeft + dis2;
	}
	
	return targetLeft;
}

function fnCalTopDistribution(targetlat)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulTop = 57;
	
	var dis1 = parseInt(calculateDistance(seoullat, seoullong, targetlat, seoullong)) * 1.345;
	var targetTop;
	
	if(seoullat > targetlat)
	{
		targetTop = seoulTop + dis1;
	}
	else
	{
		targetTop = seoulTop - dis1;
	}
	
	return targetTop;
}

function fnCalleftDistribution(targetlong)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulLeft = 155;
	
	var dis2 = parseInt(calculateDistance(seoullat, seoullong, seoullat, targetlong)) * 1.359;
	var targetLeft;
	
	if(seoullong > targetlong)
	{
		targetLeft = seoulLeft - dis2;
	}
	else
	{
		targetLeft = seoulLeft + dis2;
	}
	
	return targetLeft;
}

function fnCalTopRecevied(targetlat)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulTop = 116;
	
	var dis1 = parseInt(calculateDistance(seoullat, seoullong, targetlat, seoullong)) * 1.345;
	var targetTop;
	
	if(seoullat > targetlat)
	{
		targetTop = seoulTop + dis1;
	}
	else
	{
		targetTop = seoulTop - dis1;
	}
	
	return targetTop;
}

function fnCalleftRecevied(targetlong)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulLeft = 162;
	
	var dis2 = parseInt(calculateDistance(seoullat, seoullong, seoullat, targetlong)) * 1.359;
	var targetLeft;
	
	if(seoullong > targetlong)
	{
		targetLeft = seoulLeft - dis2;
	}
	else
	{
		targetLeft = seoulLeft + dis2;
	}
	
	return targetLeft;
}
function fnCalTopToPopupWave(targetlat)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulTop = 138; // 72
	var dis1 = parseInt(calculateDistance(seoullat, seoullong, targetlat, seoullong)) * 1.33;
	var targetTop;
	
	if(seoullat > targetlat)
	{
		targetTop = seoulTop + dis1;
	}
	else
	{
		targetTop = seoulTop - dis1;
	}
	
	return targetTop;
}

function fnCalleftToPopupWave(targetlong)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulLeft = 114;//114
	
	var dis2 = parseInt(calculateDistance(seoullat, seoullong, seoullat, targetlong)) * 0.255;
	var targetLeft;
	
	if(seoullong > targetlong)
	{
		targetLeft = seoulLeft - dis2;
	}
	else
	{
		targetLeft = seoulLeft + dis2;
	}
	
	return targetLeft;
}

function fnCalTopToSimpleWave(targetlat)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulTop = 16;
	var dis1 = parseInt(calculateDistance(seoullat, seoullong, targetlat, seoullong)) * 0.387;
	var targetTop;
	
	if(seoullat > targetlat)
	{
		targetTop = seoulTop + dis1;
	}
	else
	{
		targetTop = seoulTop - dis1;
	}
	
	return targetTop;
}

function fnCalleftToSimpleWave(targetlong)
{
	var seoullat = 37.566667; // 클 수록 위
	var seoullong = 126.978056; // 클 수록 왼쪽
	var seoulLeft = 165; //114
	
	var dis2 = parseInt(calculateDistance(seoullat, seoullong, seoullat, targetlong)) * 1.45;
	var targetLeft;
	
	if(seoullong > targetlong)
	{
		targetLeft = seoulLeft - dis2;
	}
	else
	{
		targetLeft = seoulLeft + dis2;
	}
	
	return targetLeft;
}
function fnSetDatePicker(selector)
{
	selector.datepicker({ 
		dateFormat: 'yy-mm-dd',
		weekHeader: 'Wk',
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
		changeYear: true, //년변경가능
		yearRange:'1988:+1', // 연도 셀렉트 박스 범위(현재와 같으면 1988~현재년)
		showMonthAfterYear: true, //년 뒤에 월 표시
		buttonImageOnly: false, //이미지표시  
		buttonText: '날짜를 선택하세요', 
		autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
		buttonImage: '/wtm/images/egovframework/wtm2/sub/bull_calendar.gif',
		showOn: "focus" //엘리먼트와 이미지 동시 사용
	});
}

Number.prototype.toRad = function() {
  return this * Math.PI / 180;
}

function calculateDistance(lat1, lon1, lat2, lon2) {
	var R = 6371; // km
	var dLat = (lat2-lat1).toRad();
	var dLon = (lon2-lon1).toRad(); 
	var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
			Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) * 
			Math.sin(dLon/2) * Math.sin(dLon/2); 
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
	var d = R * c;
	return d;
}

/**
 * 거리간의 방향 표기
 * @param lat1
 * @param lon1
 * @param lat2
 * @param lon2
 * @returns {String}
 */
function direction(lat1,lon1,lat2,lon2){
	 console.log("latlon1 : " + lat1+","+lon2 + " / latlon2 : " + lat2+","+lon2);
	 var Cur_Lat_radian = lat1 * (Math.PI / 180);
	 var Cur_Lon_radian = lon1 * (Math.PI / 180);
	 // 목표 위치 : 위도나 경도는 지구 중심을 기반으로 하는 각도이기 때문에
	 // 라디안 각도로 변환한다.
	 var Dest_Lat_radian = lat2 * (Math.PI / 180);
	 var Dest_Lon_radian = lon2 * (Math.PI / 180);
	 
	 console.log("Cur_latlon1 : " + Cur_Lat_radian+","+Cur_Lon_radian + " / Dest_latlon2 : " + Dest_Lat_radian+","+Dest_Lon_radian);
	 // radian distance
	 
	 var radian_distance = 0;
	 radian_distance = Math.acos(Math.sin(Cur_Lat_radian) * Math.sin(Dest_Lat_radian) + Math.cos(Cur_Lat_radian) * Math.cos(Dest_Lat_radian) * Math.cos(Cur_Lon_radian - Dest_Lon_radian));
	 // 목적지 이동 방향을 구한다.(현재 좌표에서 다음 좌표로 이동하기 위해서는 
	 //방향을 설정해야 한다. 라디안값이다.
	 var radian_bearing = Math.acos((Math.sin(Dest_Lat_radian) - Math.sin(Cur_Lat_radian) * Math.cos(radian_distance)) / (Math.cos(Cur_Lat_radian) * Math.sin(radian_distance)));
	 
	 console.log("radian : "+radian_distance+","+radian_bearing);
	 // acos의 인수로 주어지는 x는 360분법의 각도가 아닌 radian(호도)값이다.
	 var true_bearing = 0;
	 if (Math.sin(Dest_Lon_radian - Cur_Lon_radian) < 0) {
	  true_bearing = radian_bearing * (180 / Math.PI);
	  true_bearing = 360 - true_bearing;
	 } else {
	  true_bearing = radian_bearing * (180 / Math.PI);
	 }
	 var dir = Math.round(true_bearing);
	 console.log("dir : "+dir);
	 var dirArr = ["북","북북동","동북동","동남동","남남동","남남서","서남서","서북서","북북서"];
	 var dirArr2 = ["북","동","남","서","북"];
	 var returnTxt = "";
	 
	 if(dir%90<=0){
	 	returnTxt = dirArr2[dir/90];
	 }else{
		console.log((Math.floor(dir/45)));
		console.log((dir%45>0?1:0));
		returnTxt = dirArr[(Math.floor(dir/45))+(dir%45>0?1:0)];
	 }
	 
	 return returnTxt;
}

function fnSetDatePickerAndToDate(target)
{
	// datepicker 셋팅
	fnSetDatePicker(target);
	
	// 초기 날짜 셋팅( 한달 최대 31일)
	target.val(beforeDate(0));
}

/*******************************************************************************
* [ 설  명 ]
* 날짜 초기화(오늘 기준)
*
* [ 인  자 ]
* dayCnt  : 숫자 : 
*******************************************************************************/
function beforeDate(dayCnt){
	if(dayCnt == null || dayCnt == '' ){
		dayCnt = 0;
	}
	var now = new Date();			//오늘날짜
	
	var otherDay = now.getDate();
	now.setDate(otherDay + dayCnt);

	var year= now.getFullYear();
	var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
	var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
	var resetDay = year+'-'+mon+'-'+day;

	return resetDay;
}

/*******************************************************************************
* target 을 입력 받아서 datepicker 를 셋팅 하고 오늘 날짜로 자동 셋팅
*******************************************************************************/
function fnSetDatePickerAndToDate(target, day)
{
	// datepicker 셋팅
	fnSetDatePicker(target);
	
	// 초기 날짜 셋팅( 한달 최대 31일)
	target.val(beforeDate(day));
}

function fnSetDatePicker(selector)
{
	selector.datepicker({ 
		dateFormat: 'yy-mm-dd',
		weekHeader: 'Wk',
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
		changeYear: true, //년변경가능
		yearRange:'1988:+1', // 연도 셀렉트 박스 범위(현재와 같으면 1988~현재년)
		showMonthAfterYear: true, //년 뒤에 월 표시
		buttonImageOnly: false, //이미지표시  
		buttonText: '날짜를 선택하세요', 
		autoSize: false, //오토리사이즈(body등 상위태그의 설정에 따른다)
		buttonImage: '/img/bull_calendar.png',
		buttonImageOnly : true,
		showOn: "focus" //엘리먼트와 이미지 동시 사용
	});
}


/*******************************************************************************
* 
* [ 설  명 ]
* 이미지 맵에 z-index 부여 하기 위한 함수
* 
* [ 사  용 ]
* 
* 실시간 모니터링
* 	- 데이터 수신현황
* 	- 파형 모니터링
* 
* [ 인  자 ]
* sta - 관측소 id
*******************************************************************************/
function fnFindZindex(sta)
{
	var index = 0;
	
	switch (sta) {
	case "HC":
		index = 20;
		break;
	case "CC":
		index = 19;
		break;
	case "CB":
		index = 18;
		break;
	case "CP":
		index = 17;
		break;
	case "EA":
		index = 16;
		break;
	case "PD":
		index = 15;
		break;
	case "YY":
		index = 14;
		break;
	case "YC":
		index = 13;
		break;
	case "DA":
		index = 12;
		break;
	case "UA":
		index = 11;
		break;
	case "CS":
		index = 10;
		break;
	case "UA":
		index = 9;
		break;
	case "MJ":
		index = 8;
		break;
	case "WA":
		index = 7;
		break;
	case "YA":
		index = 6;
		break;
	case "SR":
		index = 5;
		break;
	case "SC":
		index = 4;
		break;
	case "KA":
		index = 3;
		break;
	case "BS":
		index = 2;
		break;
		

	default:
		
		break;
	}
	
	return index;
}

if (!Array.prototype.find) {
	Object.defineProperty(Array.prototype, 'find', {
		value: function(predicate) {
			if (this == null) {
				throw new TypeError('"this" is null or not defined');
			}

			var o = Object(this);
			var len = o.length >>> 0;
		
			if (typeof predicate !== 'function') {
				throw new TypeError('predicate must be a function');
			}
		
			var thisArg = arguments[1];
			var k = 0;
		
			while (k < len) {
				var kValue = o[k];
				if (predicate.call(thisArg, kValue, k, o)) {
					return kValue;
				}
				k++;
			}
	
			return undefined;
		}
	});
}

function quakeScale(val){
	if(val < 1){
		return 1;
	}else if(val >= 1 && val < 2){
		return 2;
	}else if(val >= 2 && val < 3){
		return 3;
	}else if(val >= 3 && val < 4){
		return 4;
	}else if(val >= 4 && val < 5){
		return 5;
	}else if(val >= 5 && val < 6){
		return 6;
	}else if(val >= 6 && val < 7){
		return 7;
	}else if(val >= 7){
		return 8;
	}
}


function Map() {
	this.elements = {};
	this.length = 0;
}


Map.prototype.put = function(key,value) {
	if(typeof this.elements[key] == "undefined" ){
		this.length++;
	}
	this.elements[key] = value;
}


Map.prototype.get = function(key) {
	return this.elements[key];
}
