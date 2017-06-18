package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDao;
import models.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	@Override
	/*
	 * This method check if the username and the password are correct to someone connect into the Messenger
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get request parameters received from the login form
		String userNameProvided = request.getParameter("user");
		String passwordProvided = request.getParameter("password");
		User userAuthenticated;
		
		UserDao dao = new UserDao();
        userAuthenticated = dao.authUser(userNameProvided, passwordProvided);
        		
		if(userAuthenticated != null){
			dao.updateUserStatus(userAuthenticated.getId(), "ONLINE");
			Cookie loginCookie = new Cookie("id", String.valueOf(userAuthenticated.getId()));
			//setting cookie to expire in 120 mins
			loginCookie.setMaxAge(120*60);
			response.addCookie(loginCookie);
			response.sendRedirect("inicio.jsp");
		}else{
			PrintWriter out= response.getWriter();
			out.println("<script type=\"text/javascript\">");
	        out.println("alert('Usuário e/ou senha incorretos. Por favor tente novamente.');");
	        out.println("location='login.jsp';");
	        out.println("</script>");
		}
	}
}
