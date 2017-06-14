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
  <title>Messenger - In�cio</title>
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
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-envelope-o"></i>
              <span class="label label-success">12</span>
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
                        Manoel J�nior
                        <small><i class="fa fa-clock-o"></i> 5 mins</small>
                      </h4>
                      <p>Voc� � muito legal!</p>
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
              <li class="header text-center"><b>Solicita��es de amizade</b></li>
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
                        <i class="fa fa-circle text-success dropdown-toggle"></i>&nbsp;<span id="dropdown_title"> Online</span><span class="caret"></span></a>
                    <ul ID="divNewNotifications" class="dropdown-menu">
                            <li><a class="fa fa-circle text-success" href="#"> Online</a>
                            <li><a class="fa fa-circle text-danger" href="#"> Ocupado</a></li>       
                            <li><a class="fa fa-circle text-warning" href="#"> Ausente</a></li>      
                            <li><a class="fa fa-circle" href="#"> Invis�vel</a></li>  
                    </ul>
                </li>
            </ul>

      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">MENU</li>
        <li class="active">
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
	        <li><a href="#"><i class="fa fa-circle text-green"></i> <span>Danilo</span></a></li>
	        <li><a href="#"><i class="fa fa-circle text-red"></i> <span>Manoel</span></a></li>
	        <li><a href="#"><i class="fa fa-circle text-yellow"></i> <span>Kuaty</span></a></li>
	        <li><a href="#"><i class="fa fa-circle "></i> <span>Nhonho</span></a></li>
	        <%
	        	String user_status = "busy";
	        	for(int user_name=0; user_name<4; user_name++){
	        		if(user_status.equals("online"))
	        			out.println("<li><a href=\"#\"><i class=\"fa fa-circle text-green \"></i> <span>" + user_name + "</span></a></li>");
	        		if(user_status.equals("busy"))
	        			out.println("<li><a href=\"#\"><i class=\"fa fa-circle text-red \"></i> <span>" + user_name + "</span></a></li>");
	        		if(user_status.equals("away"))
	        			out.println("<li><a href=\"#\"><i class=\"fa fa-circle text-yellow \"></i> <span>" + user_name + "</span></a></li>");
	        		if(user_status.equals("invisible"))
	        			out.println("<li><a href=\"#\"><i class=\"fa fa-circle \"></i> <span>" + user_name + "</span></a></li>");
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
        In��cio
      </h1>
      <ol class="breadcrumb">
        <li><a href="inicio.jsp"><i class="fa fa-th"></i> In��cio</a></li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">


      <!-- =========================================================== -->

      <div class="col-md-6">
              <!-- USERS LIST -->
              <div class="box box-primary">
                <div class="box-header with-border">
                  <h3 class="box-title">Chats recentes</h3>

                  <div class="box-tools pull-right">
                    <span class="label label-success">8 novos membros</span>
                  </div>
                </div>
                <!-- /.box-header -->
                <div class="box-body no-padding">
                  <ul class="users-list clearfix">
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Alexander Pierce</a>
                      <span class="users-list-date">Today</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Norman</a>
                      <span class="users-list-date">Yesterday</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Jane</a>
                      <span class="users-list-date">12 Jan</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">John</a>
                      <span class="users-list-date">12 Jan</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Alexander</a>
                      <span class="users-list-date">13 Jan</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Sarah</a>
                      <span class="users-list-date">14 Jan</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Nora</a>
                      <span class="users-list-date">15 Jan</span>
                    </li>
                    <li>
                      <img src="img/default.jpg" alt="User Image">
                      <a class="users-list-name" href="#">Nadia</a>
                      <span class="users-list-date">15 Jan</span>
                    </li>
                  </ul>
                  <!-- /.users-list -->
                </div>
                <!-- /.box-body -->
                <div class="box-footer text-center">
                  <a href="javascript:void(0)" class="uppercase">View All Users</a>
                </div>
                <!-- /.box-footer -->
              </div>
              <!--/.box -->
            </div>
            <!-- /.col -->
          </div>
          <!-- /.row -->

      
      
    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-dark">
    <!-- Create the tabs -->
    <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
      <li><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
      <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
    </ul>
    <!-- Tab panes -->
    <div class="tab-content">
      <!-- Home tab content -->
      <div class="tab-pane" id="control-sidebar-home-tab">
        <h3 class="control-sidebar-heading">Recent Activity</h3>
        <ul class="control-sidebar-menu">
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-birthday-cake bg-red"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Langdon's Birthday</h4>

                <p>Will be 23 on April 24th</p>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-user bg-yellow"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Frodo Updated His Profile</h4>

                <p>New phone +1(800)555-1234</p>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-envelope-o bg-light-blue"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Nora Joined Mailing List</h4>

                <p>nora@example.com</p>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <i class="menu-icon fa fa-file-code-o bg-green"></i>

              <div class="menu-info">
                <h4 class="control-sidebar-subheading">Cron Job 254 Executed</h4>

                <p>Execution time 5 seconds</p>
              </div>
            </a>
          </li>
        </ul>
        <!-- /.control-sidebar-menu -->

        <h3 class="control-sidebar-heading">Tasks Progress</h3>
        <ul class="control-sidebar-menu">
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Custom Template Design
                <span class="label label-danger pull-right">70%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-danger" style="width: 70%"></div>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Update Resume
                <span class="label label-success pull-right">95%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-success" style="width: 95%"></div>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Laravel Integration
                <span class="label label-warning pull-right">50%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-warning" style="width: 50%"></div>
              </div>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)">
              <h4 class="control-sidebar-subheading">
                Back End Framework
                <span class="label label-primary pull-right">68%</span>
              </h4>

              <div class="progress progress-xxs">
                <div class="progress-bar progress-bar-primary" style="width: 68%"></div>
              </div>
            </a>
          </li>
        </ul>
        <!-- /.control-sidebar-menu -->

      </div>
      <!-- /.tab-pane -->
      <!-- Stats tab content -->
      <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div>
      <!-- /.tab-pane -->
      <!-- Settings tab content -->
      <div class="tab-pane" id="control-sidebar-settings-tab">
        <form method="post">
          <h3 class="control-sidebar-heading">General Settings</h3>

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Report panel usage
              <input type="checkbox" class="pull-right" checked>
            </label>

            <p>
              Some information about this general settings option
            </p>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Allow mail redirect
              <input type="checkbox" class="pull-right" checked>
            </label>

            <p>
              Other sets of options are available
            </p>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Expose author name in posts
              <input type="checkbox" class="pull-right" checked>
            </label>

            <p>
              Allow the user to show his name in blog posts
            </p>
          </div>
          <!-- /.form-group -->

          <h3 class="control-sidebar-heading">Chat Settings</h3>

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Show me as online
              <input type="checkbox" class="pull-right" checked>
            </label>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Turn off notifications
              <input type="checkbox" class="pull-right">
            </label>
          </div>
          <!-- /.form-group -->

          <div class="form-group">
            <label class="control-sidebar-subheading">
              Delete chat history
              <a href="javascript:void(0)" class="text-red pull-right"><i class="fa fa-trash-o"></i></a>
            </label>
          </div>
          <!-- /.form-group -->
        </form>
      </div>
      <!-- /.tab-pane -->
    </div>
  </aside>
  <!-- /.control-sidebar -->
  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

<script src="javascript/adminlte.min.js"></script>
</body>
<script>
  $('.dropdown-toggle').dropdown();


  $('#divNewNotifications li').on('click', function() {
      $('#dropdown_title').html($(this).find('a').html());
      });
</script>
</html>