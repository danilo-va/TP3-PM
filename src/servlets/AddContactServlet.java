package servlets;

import java.io.IOException;
import java.io.PrintWriter;

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

@WebServlet("/AddContactServlet")
public class AddContactServlet extends HttpServlet{
	@Override
	/*
	 * This method connect an user with another, when one accept the friend request. Here also is verified if there is an user 
	 * with the username/email searched 
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userNameToAdd = request.getParameter("userNameToAdd");
		String userEmailToAdd = request.getParameter("userEmailToAdd");
		
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
    	UserDao userDao = new UserDao();
    	PrintWriter out= response.getWriter();
		if(userNameToAdd != null){			
			User contact = userDao.getUserByUserName(userNameToAdd);
			if(contact == null){
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Usuário não existe. Tente novamente.');");
		        out.println("location='addContact.jsp';");
		        out.println("</script>");
			}else{
				ContactList cl = new ContactList();
				cl.setUserId(userId);
				cl.setContactId(contact.getId());
				cl.setAccpeted(false);
				ContactListDao contactListDao = new ContactListDao();
				contactListDao.recordContactRequest(cl);
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Usuário adicionado com sucesso! Aguarde até que ele aceite sua solicitação.');");
		        out.println("location='inicio.jsp';");
		        out.println("</script>");
			}
		}else if(userEmailToAdd != null){
			//System.out.println(userEmailToAdd);
			User contact = userDao.getUserByEmail(userEmailToAdd);
			if(contact == null){
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Usuário não existe. Tente novamente.');");
		        out.println("location='addContact.jsp';");
		        out.println("</script>");
			}else{
				ContactList cl = new ContactList();
				cl.setUserId(userId);
				cl.setContactId(contact.getId());
				cl.setAccpeted(false);
				ContactListDao contactListDao = new ContactListDao();
				contactListDao.recordContactRequest(cl);
				out.println("<script type=\"text/javascript\">");
		        out.println("alert('Usuário adicionado com sucesso! Aguarde até que ele aceite sua solicitação.');");
		        out.println("location='inicio.jsp';");
		        out.println("</script>");
			}
		}
	}
}
