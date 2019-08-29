var CookieUtil = {
    get: function (name){
        var cookieName = encodeURIComponent(name) + "=",
            cookieStart = document.cookie.indexOf(cookieName),
            cookieValue = null,
            cookieEnd;
            
        if (cookieStart > -1){
            cookieEnd = document.cookie.indexOf(";", cookieStart);
            if (cookieEnd == -1){
                cookieEnd = document.cookie.length;
            }
            cookieValue = decodeURIComponent(document.cookie.substring(cookieStart + cookieName.length, cookieEnd));
        } 

        return cookieValue;
    },
    
    set: function (name, value, path, domain, secure, expires) {
        var cookieText = encodeURIComponent(name) + "=" + encodeURIComponent(value);
    
        if (expires instanceof Date) {
            cookieText += "; expires=" + expires.toGMTString();
        }
        if (path) {
            cookieText += "; path=" + path;
        }
        if (domain) {
            cookieText += "; domain=" + domain;
        }
        if (secure) {
            cookieText += "; secure";
        }
        document.cookie = cookieText;
    },
    
    unset: function (name, path, domain, secure){
        this.set(name, "", new Date(0), path, domain, secure);
    }
};

$(document).ready(function(){
	var userId;
	
	if (typeof localStorage === "undefined") {
		userId = CookieUtil.get("userId");
	} else {
		locStorage = window.localStorage;
		userId     = locStorage.getItem("userId");
	}
	
	if (userId){
		$(".login-container [name='j_username']").val(userId);
		document.getElementById("keepid").checked = true;
	}
	
    $("#loginForm").validate({
        rules: 
        {
        	j_username:	{ required: true },
        	j_password:	{ required: true }
        },
        messages: 
		{
        	j_username:   { required: "* 아이디를 입력하세요."  },
        	j_password:   { required: "* 패스워드를 입력하세요." }
       	}, 
        submitHandler: function(form) {
        	$("#loginForm").ajaxSubmit();
        },
       	highlight: function(label) {
			$(label).closest('.control-group').removeClass('success').addClass('error');
		},
		success: function(label) {	
			if (($("#keepid").is(":checked")) && ($(".login-container [name='j_username']").val() != "") ) {
			    if (typeof sessionStorage === 'undefined')
			    	CookieUtil.set("userId", $(".login-container [name='j_username']").val());
			    else
			        locStorage.setItem("userId", $(".login-container [name='j_username']").val());
			}
			else if(!$("#keepid").is(":checked"))
			{
				if (typeof sessionStorage === 'undefined')
					CookieUtil.unset("userId");
				else
					locStorage.removeItem("userId");
			}
			
			$(label).addClass('valid').closest('.control-group').removeClass('error');
	  		$(label).remove();
		}
    });
});