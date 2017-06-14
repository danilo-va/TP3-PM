package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDao;
import models.User;
import security.Hashing;

@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// busca o writer
        PrintWriter out = response.getWriter();
        
        // Searching for parameters in the request
        String name = request.getParameter("name");
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Build a new 'User' object
        User user = new User();
        user.setName(name);
        user.setUserName(userName);
        user.setEmail(email);
        user.setRegistrationDate(new Date());
        // Store the MD5 hash of the password for security reasons
        user.setPasswordHash(Hashing.getMD5Hash(password));
        
        // Use the 'User' DAO object to save the user
        UserDao dao = new UserDao();
        dao.addUser(user);
        
        out.println("<script type=\"text/javascript\">");
        out.println("alert('Cadastro realizado com sucesso! Bem vindo ao Messenger.');");
        out.println("location='login.jsp';");
        out.println("</script>");    
	}
}
