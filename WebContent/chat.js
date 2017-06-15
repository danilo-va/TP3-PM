var ChatEngine=function(){
     var loggedUserName=" ";
     var loggedUserProfilePic=" ";
     var contactId = " ";

     var contactName=" ";     
     var contactProfilePic=" ";
     var userId = "  ";

     //var msg="";
     var chatZone=document.getElementById("chatZone");
     //var oldata ="";
     var sevr=" ";
     var xhr=" ";
     //initialzation
     this.init=function(){
     	contactId = getUrlParameter('contactId');
     	userId = getUrlParameter('userId');
        // Set parameters for user
        $.getJSON("http://localhost:8080/messenger/getUserInfo?userID=" + userId, callbackLoggedUser);
        // Set parameters for contact
        $.getJSON("http://localhost:8080/messenger/getUserInfo?userID=" + contactId, callbackContact);
        receiveMessages();
        var objDiv = document.getElementById("chatZone");
		objDiv.scrollTop = objDiv.scrollHeight;
     };
     
	 function callbackLoggedUser(data){
		loggedUserName = data['name'];
		loggedUserProfilePic = data['photoFile'];
	 }

	 function callbackContact(data){
		contactName = data['name'];
		contactProfilePic = data['photoFile'];
		console.log(contactProfilePic);
	 }

	 var getUrlParameter = function getUrlParameter(sParam) {
	    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
	        sURLVariables = sPageURL.split('&'),
	        sParameterName,
	        i;

	    for (i = 0; i < sURLVariables.length; i++) {
	        sParameterName = sURLVariables[i].split('=');

	        if (sParameterName[0] === sParam) {
	            return sParameterName[1] === undefined ? true : sParameterName[1];
	        }
	    }
	 };

     //For sending message
     this.sendMsg=function(){ 
          msg=document.getElementById("message").value;
          //console.log(msg);
          //chatZone.innerHTML+='<div class="chatmsg"><b>'+name+'</b>: '+msg+'<br/></div>';
          chatZone.innerHTML += 
          	'<div class="direct-chat-msg right">' +
			  '<div class="direct-chat-info clearfix">' +
			    '<span class="direct-chat-name pull-right">' + loggedUserName + '</span>'  +
			    //'<span class="direct-chat-timestamp pull-left">27 Mai 14:31</span>' +
			  '</div>' +
			  '<!-- /.direct-chat-info -->' +
			  '<img class="direct-chat-img" src= "img/' + loggedUserProfilePic + '" alt="Message User Image"><!-- /.direct-chat-img -->' +
			  '<div class="direct-chat-text col-md-5 pull-right">' +
			    msg +
			  '</div>' +
			  '<!-- /.direct-chat-text -->' +
			'</div>';
		  document.getElementById("message").value = '';
		  //oldata='<div class="chatmsg"><b>'+name+'</b>: '+msg+'<br/></div>';        
		  

			var objDiv = document.getElementById("chatZone");
			objDiv.scrollTop = objDiv.scrollHeight;
		  
          this.ajaxSent();  
          return false;
     };
     //sending message to server
     this.ajaxSent=function(){
          //console.log('localhost:8080/messenger/chat_process?msg="'+msg+'"&userId='+userId+'&contactId='+contactId);
          try{
               xhr=new XMLHttpRequest();
          }
          catch(err){
               alert(err);
          }
          xhr.open('GET','http://localhost:8080/messenger/chat_process?msg="'+msg+'"&userId='+userId+'&contactId='+contactId,false);
          xhr.onreadystatechange = function(){
               if(xhr.readyState == 4) {
                    if(xhr.status == 200) {
                         msg.value="";
                    }
               }     
          };
          xhr.send();
     };
     //HTML5 SSE(Server Sent Event) initilization
     /*this.initSevr=function(){
          sevr = new EventSource('chatprocess.php');
          sevr.onmessage = function(e){ 
          if(oldata!=e.data){
               chatZone.innerHTML+=e.data;
               oldata = e.data;
          }
          };     
     };*/

    
	window.setInterval(function(){
		receiveMessages();
	}, 1000);

	function receiveMessages(){
		$.getJSON("http://localhost:8080/messenger/message_pool?userId=" + userId + "&contactId=" + contactId, callbackReceiveMessages);
	}

	function callbackReceiveMessages(data){
		//console.log(data);
		$.each (data, function (key, value) {
				chatZone.innerHTML += 
		          	'<div class="direct-chat-msg">' +
					  '<div class="direct-chat-info clearfix">' +
					    '<span class="direct-chat-name pull-left">' + contactName + '</span>'  +
					    //'<span class="direct-chat-timestamp pull-right">27 Mai 14:31</span>' +
					  '</div>' +
					  '<!-- /.direct-chat-info -->' +
					  '<img class="direct-chat-img" src= "img/' + contactProfilePic + '" alt="Message User Image"><!-- /.direct-chat-img -->' +
					  '<div class="direct-chat-text col-md-5">' +
					    value +
					  '</div>' +
					  '<!-- /.direct-chat-text -->' +
					'</div>';
				var objDiv = document.getElementById("chatZone");
				objDiv.scrollTop = objDiv.scrollHeight;
		});
	}

    this.getJSONP=function(url, success) {
	    var ud = '_' + +new Date,
	        script = document.createElement('script'),
	        head = document.getElementsByTagName('head')[0] 
	               || document.documentElement;

	    window[ud] = function(data) {
	        head.removeChild(script);
	        success && success(data);
	    };

	    script.src = url.replace('callback=?', 'callback=' + ud);
	    head.appendChild(script);

	}
};
// Createing Object for Chat Engine
var chat= new ChatEngine();
chat.init();