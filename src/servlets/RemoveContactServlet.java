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
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userNameToRemove = request.getParameter("userNameToRemove");
		String userEmailToRemove = request.getParameter("userEmailToRemove");
		
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
    	
    	ContactListDao contactListDao = new ContactListDao();
    	ArrayList<User> contacts = new ArrayList<User>();
    	contacts = contactListDao.getContacts(userId);
    	
    	UserDao userDao = new UserDao();
    	PrintWriter out= response.getWriter();
    	
		if(userNameToRemove != null){			
			User contact = userDao.getUserByUserName(userNameToRemove);
			
			int flag = 0;
			int contactId = contact.getId();
			for(User aux : contacts){
				if(contactId == aux.getId()){
					flag = 1;
					break;
				}
			}
					
			if(flag == 0){
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Você não possui este contato. Tente novamente.');");
		        out.println("location='removeContact.jsp';");
		        out.println("</script>");
			}
			if(flag == 1)
			{	
				// FALTA REMOVER AQUI
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Usuário deletado com sucesso! ');");
		        out.println("location='inicio.jsp';");
		        out.println("</script>");
			}
		}else if(userEmailToRemove != null){
			User contact = userDao.getUserByEmail(userEmailToRemove);
			
			int flag = 0;
			int contactId = contact.getId();
			for(User aux : contacts){
				if(contactId == aux.getId()){
					flag = 1;
					break;
				}
			}
					
			if(flag == 0){
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Você não possui este contato. Tente novamente.');");
		        out.println("location='removeContact.jsp';");
		        out.println("</script>");
			}
			if(flag == 1)
			{	
				// FALTA REMOVER AQUI
				contacts.de
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Usuário deletado com sucesso! ');");
		        out.println("location='inicio.jsp';");
		        out.println("</script>");
			}
		}
	}
}
