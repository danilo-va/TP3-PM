package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDao;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet{
	@Override
	/*
	 * This method logout the person from the Messenger, so his status turns to 'invisible'
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
    	Cookie loginCookie = null;
    	Cookie[] cookies = request.getCookies();
    	if(cookies != null){
    	for(Cookie cookie : cookies){
    		if(cookie.getName().equals("id")){
    			loginCookie = cookie;
    			break;
    		}
    	}
    	}
    	if(loginCookie != null){
    		UserDao dao = new UserDao();
    		dao.updateUserStatus(Integer.parseInt(loginCookie.getValue()), "INVISIBLE");
    		loginCookie.setMaxAge(0);
        	response.addCookie(loginCookie);
    	}
    	response.sendRedirect("login.jsp");
	}
}
