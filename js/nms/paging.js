/*
divId : 페이징 태그가 그려질 div
pageIndx : 현재 페이지 위치가 저장될 input 태그 id
recordCount : 페이지당 레코드 수
totalCount : 전체 조회 건수 
eventName : 페이징 하단의 숫자 등의 버튼이 클릭되었을 때 호출될 함수 이름
*/
var gfv_pageIndex = null;
var gfv_eventName = null;

function gfn_renderPaging(params){
	var divId = params.divId; //페이징이 그려질 div id
	gfv_pageIndex = params.pageIndex; //현재 위치가 저장될 input 태그
	var totalCount = params.totalCount; //전체 조회 건수
	var currentIndex = $("#"+params.pageIndex).val(); //현재 위치
	var indexCount = params.indexCount;
	if (typeof indexCount == "undefined"){
		indexCount = 5;
	}
	
	if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
		currentIndex = 1;
	}
	
	if(totalCount == 0)
	{
		$("#"+params.pageIndex).val(1);
	}
	
	var recordCount = params.recordCount; //페이지당 레코드 수
	if(gfn_isNull(recordCount) == true){
		recordCount = 20;
	}
	var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 인덱스 수
	gfv_eventName = params.eventName;
	
	$("#"+divId).html('');
	$("#"+divId).empty();
	var preStr = "";
	var postStr = "";
	var str = "";
	
	var first = (parseInt((currentIndex-1) / indexCount) * indexCount) + 1;
	var last = (parseInt(totalIndexCount/indexCount) == parseInt((currentIndex-1)/indexCount)) ? totalIndexCount%indexCount : indexCount;
	var prev = (parseInt((currentIndex-1)/indexCount)*indexCount) - (indexCount - 1) > 0 ? (parseInt((currentIndex-1)/indexCount)*indexCount) - (indexCount - 1) : 1; 
	var next = (parseInt((currentIndex-1)/indexCount)+1) * indexCount + 1 < totalIndexCount ? (parseInt((currentIndex-1)/indexCount)+1) * indexCount + 1 : totalIndexCount;
	var lastpagecount = first + last;
	preStr = "<li class='prev'>";
	
	if(totalIndexCount > indexCount){ //전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
		preStr += "<p class='btt_prev1'><a href='#this' onclick='_movePage(1)'>firstprev</a></p>" +
				"<p class='btt_prev2'><a href='#this' onclick='_movePage("+prev+")'>prev</a></p>";
	}
	else if(totalIndexCount <= indexCount && totalIndexCount > 0){ //전체 인덱스가 10보다 작을경우, 맨앞 태그 작성
		preStr += "<p class='btt_prev1'><a href='#this' onclick='_movePage(1)'>firstprev</a></p>";
	}
	
	preStr += "</li>";
	
	str = "<li class='page'>";
	
	if((first+last) > totalIndexCount ){
		lastpagecount = totalIndexCount +1;
	}
//	console.log(lastpagecount);
	for(var i=first; i<lastpagecount; i++){
		if(i != currentIndex){
			str += "<p><a href='#this' onclick='_movePage("+i+")'>"+i+"</a></p>";
		}
		else{
			str += "<p class='dconone'><a href='#this' class='on' onclick='_movePage("+i+")'>"+i+"</a></p>";
		}
	}
	
	str += "</li>";
	
	postStr = "<li class='next'>";
	if(totalIndexCount > indexCount){ //전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
		postStr += "<p class='btt_next1'><a href='#this' onclick='_movePage("+next+")'>next</a></p>" +
					"<p class='btt_next2'><a href='#this' onclick='_movePage("+totalIndexCount+")'>last next</a></p>";
	}
	else if(totalIndexCount <= indexCount && totalIndexCount > 0){ //전체 인덱스가 10보다 작을경우, 맨뒤 태그 작성
		postStr += "<p class='btt_next2'><a href='#this' onclick='_movePage("+totalIndexCount+")'>last next</a></p>";
	}
	postStr += "</li>";
	
	$("#"+divId).append(preStr + str + postStr);
}

/* <ul class="pagebox">
<li class="prev">
	<p class="btt_prev1"><a href="">firstprev</a></p>
	<p class="btt_prev2"><a href="">prev</a></p>
</li>
<li class="page">
	<p class="dconone"><a class="on" >1</a></p>
	<p><a >2</a></p>
	<p><a >3</a></p>
	<p><a >4</a></p>
	<p><a >5</a></p>
</li>
<li class="next">
	<p class="btt_next1"><a href="">next</a></p>
	<p class="btt_next2"><a href="">last next</a></p>
</li>
</ul> */
 
function _movePage(value){
	$("#"+gfv_pageIndex).val(value);
	if(typeof(gfv_eventName) == "function"){
		gfv_eventName(value);
	}
	else {
		eval(gfv_eventName + "(value);");
	}
}

function gfn_isNull(data)
{
	if(data == null || data =='')
	{
		return true;
	}
	else
	{
		return false;
	}
}