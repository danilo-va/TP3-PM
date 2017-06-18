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
import security.Hashing;

@WebServlet("/UpdateUserPasswordServlet")
public class UpdateUserPasswordServlet extends HttpServlet{
	@Override
	/*
	 * Update the password when the user request
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// busca o writer
        PrintWriter out = response.getWriter();
        
        // Searching for parameters in the request
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String newPasswordConfirmation = request.getParameter("newPasswordConfirmation");
        int userId = 0;
        
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
    		userId = Integer.parseInt(loginCookie.getValue());
    	
    	// Retreive user information
    	UserDao dao = new UserDao();
    	User user = dao.getUser(userId);
    	if(Hashing.getMD5Hash(currentPassword).equals(user.getPasswordHash())){
    		user.setPasswordHash(Hashing.getMD5Hash(newPassword));
    		dao.updateUserPassword(user);
    		out.println("<script type=\"text/javascript\">");
            out.println("alert('Senha alterada com sucesso!');");
            out.println("location='editProfile.jsp';");
            out.println("</script>");
    	}else{
    		out.println("<script type=\"text/javascript\">");
            out.println("alert('Senha atual incorreta. Tente novamente.');");
            out.println("location='editProfile.jsp';");
            out.println("</script>");
    	}
	}
}
