package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ContactListDao;
import dao.UserDao;
import models.ContactList;
import models.User;

@WebServlet("/RemoveContactServlet")
public class RemoveContactServlet extends HttpServlet{
	@Override
	/*
	 * This method remove the friendship between an user with another, when requested. Here also is verified if there is an user 
	 * with the username/email searched 
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userNameToRemove = request.getParameter("userNameToRemove");
		
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
    	int userId = Integer.parseInt(loginCookie.getValue());
    	
    	ContactListDao clDao = new ContactListDao();
    	UserDao userDao = new UserDao();
    	ArrayList<User> contacts = clDao.getContacts(userId);
    	boolean contactFound = false;
    	
    	for(User u : contacts){
    		if(u.getUserName().equals(userNameToRemove)){
    			contactFound = true;
    			clDao.deleteContact(userId, u.getId());
    		}
    	}
    			
    	PrintWriter out= response.getWriter();
		if(contactFound){
			out.println("<script type=\"text/javascript\">");
	        out.println("alert('Usuário deletado com sucesso! ');");
	        out.println("location='inicio.jsp';");
	        out.println("</script>");
		}else{
			out.println("<script type=\"text/javascript\">");
	        out.println("alert('Você não possui este contato. Tente novamente.');");
	        out.println("location='removeContact.jsp';");
	        out.println("</script>");
		}	
		
	}
}
