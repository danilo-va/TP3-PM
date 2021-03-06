<%@ page import="dao.UserDao,
			models.User,
			models.ContactList,
			models.Message,
			dao.MessageDao,
			dao.ContactListDao,
			java.util.ArrayList,
			java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Messenger - Edit</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.7 -->
  <link rel="shortcut icon" href="img/m.png" >
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="css/_all-skins.min.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Google Font -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
</head>
<body class="hold-transition skin-blue sidebar-mini">
<%
	String userId = null;
	User loggedUser = null;
	Cookie[] cookies = request.getCookies();
	UserDao dao = new UserDao();
	if(cookies !=null){
		for(Cookie cookie : cookies){
			if(cookie.getName().equals("id")) userId = cookie.getValue();
		}
	}
	if(userId == null){
		response.sendRedirect("login.jsp");
	}else{ // Load user
		loggedUser = dao.getUser(Integer.parseInt(userId));
	}
%>
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="inicio.jsp" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>M</b></span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>Messenger</b></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>

      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <!-- Messages: style can be found in dropdown.less-->
          <li class="dropdown messages-menu">
            <%
	            MessageDao msgDao = new MessageDao();
	          	ArrayList<Message> unreadMessages = msgDao.getAllUnreadMessages(loggedUser.getId());
            %>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-envelope-o"></i>
              <span class="label label-success"><% out.print(unreadMessages.size()); %> </span>
            </a>
            <ul class="dropdown-menu">
              <li class="header text-center"><b>Conversas</b></li>
              <li>
                <!-- inner menu: contains the actual data -->
                <ul class="menu">
                  <%
                  	if(unreadMessages.size()!= 0)
	                  	for(Message message : unreadMessages){
	                  		User u = dao.getUser(message.getSenderId());
	                  		//System.out.println(message.getDelivery_time());
	                  		out.println("<li>");
	                  		out.println("<a href=chat.jsp?userId=" + loggedUser.getId() + "&contactId=" + u.getId() + ">");
	                        out.println("<div class=\"pull-left\">");
	                        out.println("<img src=\"img/" + u.getPhotoFile() + "\" class=\"img-circle\" alt=\"User Image\">");  
	                        out.println("</div>");    
	                        out.println("<h4>");
	                        out.println(u.getName());
	                        out.println("<small><i class=\"fa fa-clock-o\"></i>" + new SimpleDateFormat("dd/MM HH:mm").format(message.getDelivery_time().getTime()) + "</small>");  
	                        out.println("</h4>");    
	                        out.println("<p>" + message.getContent() + "</p>");    
	                        out.println("</a>");  
	                        out.println("</li>");
	                  	}
                  	else
                  		out.println("<p align=\"center\">N�o h� novas mensagens</p>");
                  %>
                </ul>
              </li>
              <!-- <li class="footer"><a href="#">Ver tudo</a></li> -->
            </ul>
          </li>

          <!-- Notifications: style can be found in dropdown.less -->
          <li class="dropdown messages-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-user-plus"></i>
              <%
              	ContactListDao clDao = new ContactListDao();
              	ArrayList<ContactList> requests = clDao.getContactListRequest(loggedUser.getId());
              %>
              <span class="label label-warning"><% out.print(requests.size()); %></span>
            </a>
            <ul class="dropdown-menu">
              <li class="header text-center"><b>Solicita��es de amizade</b></li>
              <li>
                <!-- inner menu: contains the actual data -->
                <ul class="menu">
                  <!-- ------------------------------------------- -->
                  <%                                  	  
              	  	if(requests.size()!=0)	  
                  		for(ContactList req : requests){
	                  		out.println("<li><!-- start message -->");
	                  		out.println("<a>");
	                  		out.println("<div class=\"pull-left\">");
	                  		out.println("<img src=\"img/" + dao.getUser(req.getUserId()).getPhotoFile() /*user.getPhotoFile()*/ + "\" class=\"img-circle\" alt=\"User Image\">");
	                  		out.println("</div>");
	                  		out.println("<h4>");
	                  		out.println(dao.getUser(req.getUserId()).getName() /*user.getName()*/);
	                  		out.println("<!-- <small><i class=\"fa fa-clock-o\"></i> 1 dia</small> -->");
	                  		out.println("</h4>");
	                  		out.println("<div class=\"col-md-5\">");
	                  		out.println("<form action=\"acceptContactRequest?reqId=" + req.getId() + "\" method=\"post\">");
	                  		out.println("<button type=\"submit\" name=\"accContact\" class=\"btn btn-block btn-success btn-xs\">Aceitar</button>");
	                  		out.println("</form>");
	                  		out.println("<form action=\"rejectContactRequest?reqId=" + req.getId() + "\"method=\"post\">");
	                  		out.println("<button type=\"submit\" name=\"rejContact\" class=\"btn btn-block btn-danger btn-xs\">Recusar</button>");
	                  		out.println("</form>");
	                  		out.println("</div>");
	                  		out.println("</a>");
	                  		out.println("</li>");                  
	                   }
              	  	else
	              		out.println("<p align=\"center\">N�o h� novas solicita��es</p>");
                  %>
                  <!-- ------------------------------------------- -->
                </ul>
              </li>
              	<!-- <li class="footer"><a href="#">Ver tudo</a></li> -->
            </ul>
          </li>
          <!-- Tasks: style can be found in dropdown.less -->
          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
				<%out.println("<img src=\"img/" + loggedUser.getPhotoFile() + "\" class=\"user-image\" alt=\"User Image\">");%>
            	<span class="hidden-xs"><% out.println(loggedUser.getName()); %></span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header">
                <%out.println("<img src=\"img/" + loggedUser.getPhotoFile() + "\" class=\"img-circle\" alt=\"User Image\">");%>
                <p>
                  <% out.println(loggedUser.getName()); %>
                  <small>Membro desde 
                  	<% 
                  		out.print(new SimpleDateFormat("MMM").format(loggedUser.getRegistrationDate()) + 
                  				" " + new SimpleDateFormat("YYYY").format(loggedUser.getRegistrationDate())); %>
                  </small>
                </p>
              </li>
              <li class="user-footer">
                <div class="pull-left">
                  <a href="editProfile.jsp" class="btn btn-default btn-flat">Editar perfil</a>
                </div>
                <div class="pull-right">
                  	<form action="LogoutServlet" method="post">
                		<button type="submit" class="btn btn-default btn-flat">Encerrar Sess�o</button>
                	</form>
                </div>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar user panel -->
      <div class="user-panel">
        <div class="pull-left image">
          <%out.println("<img src= img/" + loggedUser.getPhotoFile() + " class=\"img-circle\" alt=\"User Image\">");%>
        </div>
        <div class="pull-left info">
          <p><% out.println(loggedUser.getName());%></p>
          <i><% out.println(loggedUser.getUserName());%></i>
        </div>
      </div>

                <ul >
                <li class="dropdown active span8">
                    <a class="dropdown-toggle" id="inp_impact" data-toggle="dropdown">
                        <%
	                       	if(loggedUser.getStatus().equals("ONLINE"))
	                       		out.println("<i class=\"fa fa-circle text-success dropdown-toggle\"></i>&nbsp;<span id=\"dropdown_title\">" + loggedUser.getStatusString() + "</span><span class=\"caret\"></span></a>");
	                       	else if(loggedUser.getStatus().equals("BUSY"))
	                       		out.println("<i class=\"fa fa-circle text-red dropdown-toggle\"></i>&nbsp;<span id=\"dropdown_title\">" + loggedUser.getStatusString() + "</span><span class=\"caret\"></span></a>");
	                       	else if(loggedUser.getStatus().equals("AWAY"))
	                       		out.println("<i class=\"fa fa-circle text-yellow dropdown-toggle\"></i>&nbsp;<span id=\"dropdown_title\">" + loggedUser.getStatusString() + "</span><span class=\"caret\"></span></a>");
	                       	else if(loggedUser.getStatus().equals("INVISIBLE"))
	                       		out.println("<i class=\"fa fa-circle dropdown-toggle\"></i>&nbsp;<span id=\"dropdown_title\">" + loggedUser.getStatusString() + "</span><span class=\"caret\"></span></a>");                        
                        %>
                        
                    <ul ID="divNewNotifications" class="dropdown-menu">
                            <li><a class="fa fa-circle text-green" onClick="changeStatus('ONLINE', <% out.print(loggedUser.getId()); %> )"> Online</a>
                            <li><a class="fa fa-circle text-red" onClick="changeStatus('BUSY', <% out.print(loggedUser.getId()); %> )"> Ocupado</a>
                            <li><a class="fa fa-circle text-yellow" onClick="changeStatus('AWAY', <% out.print(loggedUser.getId()); %> )"> Ausente</a>
                            <li><a class="fa fa-circle" onClick="changeStatus('INVISIBLE', <% out.print(loggedUser.getId()); %> )"> Offline</a>
                    </ul>
                </li>
            </ul>

      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">MENU</li>
        <li>
          <a href="inicio.jsp">
            <i class="fa fa-th"></i> <span>In�cio</span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-users"></i> <span>Contatos</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
              <small class="label pull-right bg-green">+1</small>
            </span>
          </a>
          <ul class="treeview-menu"> <!-- COLOCAR OS CONTATOS ONLINE -->
	        <%
	        	ArrayList<User> contacts = clDao.getContacts(loggedUser.getId());
	        	//String user_status = "busy";
	        	if(contacts.size() != 0){
	        		for(User contact : contacts){
	        			//System.out.println(contact.getStatus());
	        			if(contact.getStatus().equals("ONLINE"))
		        			out.println("<li><a href=\"chat.jsp?userId=" + loggedUser.getId() + "&contactId=" + contact.getId() +"\"><i class=\"fa fa-circle text-green \"></i> <span>" + contact.getName() + "</span></a></li>");
		        		if(contact.getStatus().equals("BUSY"))
		        			out.println("<li><a href=\"chat.jsp?userId=" + loggedUser.getId() + "&contactId=" + contact.getId() +"\"><i class=\"fa fa-circle text-red \"></i> <span>" + contact.getName() + "</span></a></li>");
		        		if(contact.getStatus().equals("AWAY"))
		        			out.println("<li><a href=\"chat.jsp?userId=" + loggedUser.getId() + "&contactId=" + contact.getId() +"\"><i class=\"fa fa-circle text-yellow \"></i> <span>" + contact.getName() + "</span></a></li>");
		        		if(contact.getStatus().equals("INVISIBLE"))
		        			out.println("<li><a href=\"chat.jsp?userId=" + loggedUser.getId() + "&contactId=" + contact.getId() +"\"><i class=\"fa fa-circle \"></i> <span>" + contact.getName() + "</span></a></li>");
		        	}	
	        	}
	        %>
          </ul>
        </li>
        <li>
          <a href="addContact.jsp">
            <i class="fa fa-user-plus"></i><span>Adicionar contato</span>
          </a>
        </li>
        <li>
          <a href="removeContact.jsp">
            <i class="fa fa-user-times"></i><span>Remover contato</span>
          </a>
        </li>
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Editar perfil
        <small>personalize sua conta</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="inicio.jsp"><i class="fa fa-th"></i> In��cio</a></li>
        <li class="active">Perfil</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">

      <!-- Default box -->
      <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title"><% out.println(loggedUser.getName()); %></h3>
	
        </div>
        <div class="box-body">
        	<h4 class="box-title">Informa��es Pessoais</h4>
        	<form action="UpdateUserInfoServlet" method = "post" onsubmit="return validatePersonalInfoFields(this)">
        		<i>Nome completo:</i>
        		<input type="text" class="form-control" placeholder="Nome completo" name="newName" id="newName" value='<% out.print(loggedUser.getName()); %>'>
        		<i>Nome de usu�rio:</i>
        		<input type="Usu�rio" class="form-control" placeholder="Usu�rio" name="newUserName" id="newUserName" value='<% out.print(loggedUser.getUserName()); %>'>
        		<i>Email:</i>
        		<input type="E-mail" class="form-control" placeholder="E-mail" name="newEmail" id="newEmail" value='<% out.print(loggedUser.getEmail()); %>'> 
        		<br>
        		<button type="submit" class="btn btn-default btn-flat">Atualizar</button>
        	</form>
        	<hr>
        	<h4 class="box-title">Seguran�a</h4>
        	<form action="UpdateUserPasswordServlet" method="post" onsubmit="return validateSecurityFields(this)">
        		<input type="password" class="form-control" placeholder="Senha atual" name="currentPassword" id="currentPassword">
        		<input type="password" class="form-control" placeholder="Nova senha" name="newPassword" id="newPassword">
        		<input type="password" class="form-control" placeholder="Confirme a nova senha" name="newPasswordConfirmation" id="newPasswordConfirmation">
        		<br>
        		<button type="submit" class="btn btn-default btn-flat">Alterar senha</button> 
        	</form>
        	<hr>
        	<h4 class="box-title">Foto de perfil</h4>
        	<form action="upload" method="post" enctype="multipart/form-data">
			    <input type="file" name="file" />
			    <input type="submit" />
			</form>
        </div>
      </div>
      <!-- /.box -->

    </section>
    <!-- /.content -->

      
      
    </section>
    <!-- /.content -->
  </div>
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

<script src="javascript/adminlte.min.js"></script>
</body>

<script language="javascript">
	function validateSecurityFields(){		
		var valid = true;
		if(document.getElementById('currentPassword').value == "" || 
	   	document.getElementById('newPassword').value == "" ||
	   	document.getElementById('newPasswordConfirmation').value == ""){
	   		valid = false;
			alert("Todos os campos s�o obrigat�rios!");
		}
		
		if(document.getElementById('newPassword').value !=
				document.getElementById('newPasswordConfirmation').value){
			valid = false;
			alert("Senhas n�o coincidem! Por favor, tente novamente.");
		}
		return valid;
	}
	
	function validatePersonalInfoFields(){		
		var valid = true;
		if(document.getElementById('newName').value == "" || 
	   	document.getElementById('newUserName').value == "" ||
	   	document.getElementById('newEmail').value == ""){
	   		valid = false;
			alert("Todos os campos s�o obrigat�rios!");
		}
		return valid;
	}
</script>
<script>
	function changeStatus(status, userId){
		$.ajax({
	        url:("http://localhost:8080/messenger/change_status?userId=" + userId + "&status=" + status),
	        type: 'post',
	        success:function(response){
	        	alert("Status alterado com sucesso.");
	        }
	    });
	}

  $('.dropdown-toggle').dropdown();


  $('#divNewNotifications li').on('click', function() {
      $('#dropdown_title').html($(this).find('a').html());
      });
</script>
</html>
