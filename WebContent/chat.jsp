<%@ page import="dao.UserDao,
			models.User,
			models.ContactList,
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
  <title>Messenger - Chat</title>
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
		dao = new UserDao();
		loggedUser = dao.getUser(Integer.parseInt(userId));
	}
	
	//Chat related objects
	int contactId = Integer.parseInt(request.getParameter("contactId"));
	User contactUser = dao.getUser(contactId);
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
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-envelope-o"></i>
              <span class="label label-success">1</span>
            </a>
            <ul class="dropdown-menu">
              <li class="header text-center"><b>Conversas</b></li>
              <li>
                <!-- inner menu: contains the actual data -->
                <ul class="menu">
                  <li><!-- start message -->
                    <a href="chat.jsp">
                      <div class="pull-left">
                        <img src="img/manoel.jpg" class="img-circle" alt="User Image">
                      </div>
                      <h4>
                        <% out.println(loggedUser.getName()); %>
                        <small><i class="fa fa-clock-o"></i> 5 mins</small>
                      </h4>
                      <p>Você é muito legal!</p>
                    </a>
                  </li>
                </ul>
              </li>
              <li class="footer"><a href="#">Ver tudo</a></li>
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
              <li class="header text-center"><b>Solicitações de amizade</b></li>
              <li>
                <!-- inner menu: contains the actual data -->
                <ul class="menu">
                  <!-- ------------------------------------------- -->
                  <%                                  	  
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
                  %>
                  <!-- ------------------------------------------- -->
                </ul>
              </li>
              <li class="footer"><a href="#">Ver tudo</a></li>
            </ul>
          </li>
          <!-- Tasks: style can be found in dropdown.less -->
          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              
              <%out.println("<img src=\"img/" + loggedUser.getPhotoFile() + "\" class=\"user-image\" alt=\"User Image\">");%>
              <span class="hidden-xs"><% out.println(loggedUser.getName());%></span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header">
                <%out.println("<img src=\"img/" + loggedUser.getPhotoFile() + "\" class=\"img-circle\" alt=\"User Image\">");%>
                <p>
                  <% out.println(loggedUser.getName());%>
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
                		<button type="submit" class="btn btn-default btn-flat">Encerrar Sessão</button>
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
                        <i class="fa fa-circle text-success dropdown-toggle"></i>&nbsp;<span id="dropdown_title"> Online</span><span class="caret"></span></a>
                    <ul ID="divNewNotifications" class="dropdown-menu">
                            <li><a class="fa fa-circle text-success" href="#"> Online</a>
                            <li><a class="fa fa-circle text-danger" href="#"> Ocupado</a></li>       
                            <li><a class="fa fa-circle text-warning" href="#"> Ausente</a></li>      
                            <li><a class="fa fa-circle" href="#"> Invisível</a></li>  
                    </ul>
                </li>
            </ul>

      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">MENU</li>
        <li>
          <a href="inicio.jsp">
            <i class="fa fa-th"></i> <span>Início</span>
          </a>
        </li>
        <li class="active">
          <a>
            <i class="fa fa-edit"></i> <span>Chat</span>
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
	        			System.out.println(contact.getStatus());
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
        Chat
      </h1>
      <ol class="breadcrumb">
        <li><a href="inicio.jsp"><i class="fa fa-th"></i> Início</a></li>
        <li class="active">Chat</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content" style="height:80vh">


      <!-- =========================================================== -->

      <!-- Direct Chat -->
      <div class="row" style="height:80vh">
        <div class="col-md-12" style="height:80vh">
          <!-- DIRECT CHAT PRIMARY -->
          <div class="box box-primary direct-chat direct-chat-primary" style="height:80vh">
            <div class="box-header with-border">
              <h3 class="box-title"> <% out.print(contactUser.getName()); %> </h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body" style="height:70vh">
              <!-- Conversations are loaded here -->
              <div id="chatZone" class="direct-chat-messages" style="height:70vh">
                <!-- Message. Default to the left -->
                <!--<div class="direct-chat-msg">
                  <div class="direct-chat-info clearfix">
                    <span class="direct-chat-name pull-left"> NOME </span>
                    <span class="direct-chat-timestamp pull-right">27 Mai 14:30</span>
                  </div>
                  
                  <img class="direct-chat-img" src= 'img/imagem' alt="Message User Image">
                  <div class="direct-chat-text col-md-5">
                    Você é muito legal!
                  </div>
                  
                </div> -->
                

                <!-- Message to the right -->
                <!-- ><div class="direct-chat-msg right">
                  <div class="direct-chat-info clearfix">
                    <span class="direct-chat-name pull-right">NOME</span>
                    <span class="direct-chat-timestamp pull-left">27 Mai 14:31</span>
                  </div>
                  <img class="direct-chat-img" src= 'img/IMAGEM' alt="Message User Image">
                  <div class="direct-chat-text col-md-5 pull-right">
                    <i class = "pull-right">Obrigado!</i>
                  </div>
                </div>-->
                <!-- /.direct-chat-msg -->
              </div>
              <!--/.direct-chat-messages-->

             
              <!-- /.direct-chat-pane -->
            </div>
            <!-- /.box-body -->
            <div class="box-footer">
              <form onsubmit="return chat.sendMsg()">
                <div class="input-group">
                  <input type="text" name="message" id="message" placeholder="Type Message ..." class="form-control">
                      <span class="input-group-btn">
                        <!-- <button type="submit" class="btn btn-primary btn-flat">Send</button> -->
                      	<input type="button" class="btn btn-primary btn-flat" value="Submit" onclick="chat.sendMsg(); return false;"/>
                      </span>
                </div>
              </form>
            </div>
            <!-- /.box-footer-->
          </div>
          <!--/.direct-chat -->
        </div>
      </div>
      <!-- /.row -->

      
      
    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
</div>
<!-- ./wrapper -->

<script src="javascript/adminlte.min.js"></script>
</body>
<script type="text/javascript" src="chat.js"></script>
</html>
<script>
  $('.dropdown-toggle').dropdown();


  $('#divNewNotifications li').on('click', function() {
      $('#dropdown_title').html($(this).find('a').html());
      });
</script>
