var ChatEngine=function(){
     var userName=" ";
     var contactName=" ";
     var i = null;
     //var msg="";
     var chatZone=document.getElementById("chatZone");
     //var oldata ="";
     var sevr=" ";
     var xhr=" ";
     //initialzation
     this.init=function(){
        var obj = {};
		$.getJSON('http://localhost:8080/messenger/getUserInfo?userID=40', function(data) {
    		$.each(data, function(i,val) {
	        	console.log(i);
	        	console.log(val);
	        	obj[i] = val;
	        });
		});
		console.log(obj);
		/*if(EventSource){
        	this.setName();
         	this.initSevr(); 
        }else{
         	alert("Chat engine started");
        }*/
        // Load previous messages
        //alert("Chat engine started.");
     };
     
     //For sending message
     this.sendMsg=function(){ 
          msg=document.getElementById("message").value;
          console.log(msg);
          //chatZone.innerHTML+='<div class="chatmsg"><b>'+name+'</b>: '+msg+'<br/></div>';
          chatZone.innerHTML += 
          	'<div class="direct-chat-msg right">' +
			  '<div class="direct-chat-info clearfix">' +
			    '<span class="direct-chat-name pull-right">Manoel</span>'  +
			    '<span class="direct-chat-timestamp pull-left">27 Mai 14:31</span>' +
			  '</div>' +
			  '<!-- /.direct-chat-info -->' +
			  '<img class="direct-chat-img" src= "img/manoel.jpg" alt="Message User Image"><!-- /.direct-chat-img -->' +
			  '<div class="direct-chat-text col-md-5 pull-right">' +
			    '<i class = "pull-right">' + msg + '</i>' +
			  '</div>' +
			  '<!-- /.direct-chat-text -->' +
			'</div>';
		  document.getElementById("message").value = '';
          //oldata='<div class="chatmsg"><b>'+name+'</b>: '+msg+'<br/></div>';          
          //this.ajaxSent();  
          return false;
     };
     //sending message to server
     /*this.ajaxSent=function(){
          try{
               xhr=new XMLHttpRequest();
          }
          catch(err){
               alert(err);
          }
          xhr.open('GET','chatprocess.php?msg='+msg+'&name='+name,false);
          xhr.onreadystatechange = function(){
               if(xhr.readyState == 4) {
                    if(xhr.status == 200) {
                         msg.value="";
                    }
               }     
          };
          xhr.send();
     };*/
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