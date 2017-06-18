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

@WebServlet("/UpdateUserInfoServlet")
public class UpdateUserInfoServlet extends HttpServlet{
	@Override
	/*
	 * Update the user's information
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// busca o writer
        PrintWriter out = response.getWriter();
        
        // Searching for parameters in the request
        String newName = request.getParameter("newName");
        String newUserName = request.getParameter("newUserName");
        String newEmail = request.getParameter("newEmail");
        int userID = 0;
        
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
    	if(loginCookie != null)
    		userID = Integer.parseInt(loginCookie.getValue());
    	
    	// Build new user with updated info
    	UserDao dao = new UserDao();
    	User user = dao.getUser(userID);
    	user.setName(newName);
    	user.setUserName(newUserName);
    	user.setEmail(newEmail);
    	
    	dao.updateUserInfo(user);
    	
    	out.println("<script type=\"text/javascript\">");
        out.println("alert('Informações atualizadas');");
        out.println("location='editProfile.jsp';");
        out.println("</script>");
	}
}
