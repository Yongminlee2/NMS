// GNB
jQuery(function($){
	// main menu
	var gnb = $('div#gnb');
	var mainLi = $('div#mainMenu>ul>li');
	var sub = $('div#subMenu');
	var divSub = $('div#subMenu>.sub');

	function show_menu(){
		t = $(this);	
		for (var i=0; i<mainLi.length; i++){
			//mainLi.find('>a>img').get(i).src = mainLi.find('>a>img').get(i).src.replace("_ov.gif",".gif");
			var thisLi = t.parent('li').index();
		}
		//t.find('>img').get(0).src = t.find('>img').get(0).src.replace(".gif","_ov.gif");
		t.stop().animate({
			backgroundPosition: '0 -55px' /*size of button*/
		});
		mainLi.find('>a').not(this).stop().animate({
			backgroundPosition: '0 0'
		});

		if(t.parent('li').hasClass('active')){
			return false;
		}else{
			mainLi.removeClass('active');
			t.parent('li').addClass('active');
			divSub.hide().eq(thisLi).show();
			divSub.find('a').hide();
			divSub.eq(thisLi).find('a').fadeIn();
		}
	}
	mainLi.find('>a').mouseenter(show_menu).focus(show_menu);

	function hide_menu(){
		/*for (var i=0; i<mainLi.length; i++){
			mainLi.find('>a>img').get(i).src = mainLi.find('>a>img').get(i).src.replace("_ov.gif",".gif");
		}*/
		mainLi.find('>a').stop().animate({
			backgroundPosition: '0 0'
		});
		mainLi.removeClass('active');
		divSub.hide().find('a').hide();
	}
	gnb.mouseleave(hide_menu).blur(hide_menu);

	// 2depth mouse over event
	var objC = divSub.find('ul>li');

	function mOver(){
		if($(this).find(">a").hasClass('on')){
			return false;
		}else{
			//$(this).find(">img").get(0).src = $(this).find(">img").get(0).src.replace(".gif","_ov.gif");
			$(this).find(">a").addClass('on');
		}
	};
	objC.find(">a").mouseenter(mOver).focus(mOver);
	
	function mOut(){
		//$(this).find(">img").get(0).src = $(this).find(">img").get(0).src.replace("_ov.gif",".gif");
		$(this).find(">a").removeClass('on');	
	};
	objC.find(">a").mouseleave(mOut).blur(mOut);
});

//메인 썸네일 스크립트

// 메인페이지 하단 슬라이드 배너
jQuery(function($){
	var ani = $('.animateMe');
	var aniUl = $('.animateMe>ul');
	var aniLi = $('.animateMe>ul>li');
	var move = 0;
	var num = 1;

	for(var i=1;i<=aniLi.length;i++){
		aniUl.css('width',aniLi.width() * i + 'px');
	}

	var size = ani.width() - aniUl.width();

	function slideLeft(){
		if(move <= size){
			move = 0;
		}else{
			move = move - aniLi.width() * num;
		}
		ani.each(function(){
			ani.find('>ul').animate({left: move},1000);
		});
		return false;
	}
	$('.sbtn').find('>.next').click(slideLeft);

	function slideRight(){
		if(move >= 0){
			move = size;
		}else{
			move = move + aniLi.width() * num;
		}
		ani.each(function(){
			ani.find('>ul').animate({left: move},1000);
		});
		return false;
	}
	$('.sbtn').find('>.prev').click(slideRight);
});


// page change
function sel_chg()
{
	var n = document.goalum.alb.selectedIndex;
	var selval;
	selval = document.goalum.alb.options[n].value;
	if (selval == "no") {
		alert("올바르게 선택해주세요. ");
		return false;
	}
	location.href=document.goalum.alb.options[n].value;
}

// frame resize
function frameResize(iframeObj){
	var innerBody = iframeObj.contentWindow.document.body;
	oldEvent = innerBody.onclick;
	innerBody.onclick = function(){
	resizeFrame(iframeObj, 1);
	oldEvent;
};
	var innerHeight = innerBody.scrollHeight + (innerBody.offsetHeight - innerBody.clientHeight);
		iframeObj.style.height = innerHeight;
	var innerWidth = innerBody.scrollWidth + (innerBody.offsetWidth - innerBody.clientWidth);
		iframeObj.style.width = innerWidth;
	if( !arguments[1] )
	/* 특정 이벤트로 인한 호출시 스크롤을 그냥 둔다. */
	this.scrollTo(1,1);
}

// menu tab
function Khc_Tab(m_id){
	bg_class = "k1"
	var cName = document.getElementById(m_id).className + " " + bg_class
	document.getElementById(m_id).className = cName
	var tList = document.getElementById(m_id).getElementsByTagName("a");
	
	for (i=0;i<tList.length;i++) {
		TabPlay = function() {
			for (y=0;y<tList.length;y++) { 
			tList[y].className = "";
			document.getElementById(m_id + "_sub" + (y+1)).style.display = "none";
			if(this==tList[y]){x=y+1}
			}
			this.className = this.className + "on";
			document.getElementById(m_id + "_sub" + x).style.display = "block";			
			document.getElementById(m_id).className = cName.replace(bg_class,"k" + x);
		}
		tList[i].onclick = TabPlay;
		if(arguments[1]=="Mover"){tList[i].onmouseover = TabPlay;}
	}
}


// mouse over Event
function mouseOver(id){
	var objC = $("#"+id);

	objC.find("a").bind("mouseover",function(){
		var cnt = objC.find("a").index($(this));		
		var newTab = objC.find("a").eq(cnt);	
		var newTabImg = newTab.find(">img").get(0);
		newTabImg.src = newTabImg.src.replace(".gif","_ov.gif");	
	});
	
	objC.find("a").bind("mouseout",function(){
		var cnt = objC.find("a").index($(this));
		var oldTab = objC.find("a").eq(cnt);	
		var oldTabImg = oldTab.find(">img").get(0);
		oldTabImg.src = oldTabImg.src.replace("_ov.gif",".gif");
	});
}


jQuery(function($){
	// 탑메뉴활성화
	var topList = $('#topMenu > li');
	function show_txt(){
		t = $(this);
		t.next('span').show();
	}
	topList.find('>a').click(show_txt).mouseover(show_txt).focus(show_txt);

	function hide_txt(){
		topList.find('span').hide();
	}
	topList.find('>a').mouseleave(hide_txt);

	// 배너선택 빨간박스활성화
	var banList = $('.conBtm > .ban > li');
	function show_qual(){
		t = $(this);
		t.find('>span').show();
	}
	banList.find('>a').mouseover(show_qual).focus(show_qual);

	function hide_qual(){
		banList.find('>a>span').hide();
	}
	banList.find('>a>span').mouseleave(hide_qual);
});

function ViewAns(smenuid, si) 
{
	if(eval("document.all." + smenuid + ".style.display == 'none'")) 
	{
		eval("document.all." + smenuid + ".style.display = '';"); 
	} 
	else 
	{
		eval("document.all." + smenuid + ".style.display = 'none';"); 
	}	
}

function ViewlayerPop(){
	document.getElementById("sitemap").style.display='inline';
}

function CloselayerPop(){
	document.getElementById("sitemap").style.display='none';
}

// On Off Layer
function popupLayer() {
	if(document.getElementById("popupArea").style.display == 'none') {
		$("#popupArea").fadeIn();
	} else if(document.getElementById("popupArea").style.display = 'block') {
		$("#popupArea").fadeOut();
	}
}
