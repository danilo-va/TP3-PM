package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDao;
import models.User;

@WebServlet("/addUser")
public class addUserServlet extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// busca o writer
        PrintWriter out = response.getWriter();
        
        // Searching for parameters in the request
        String name = request.getParameter("name");
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Store the MD5 hash of the password for security reasons
        MessageDigest m = null;
		try {
			m = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		}
        m.update(password.getBytes(),0,password.length());
        
        // Build a new 'User' object
        User user = new User();
        user.setName(name);
        user.setUserName(userName);
        user.setEmail(email);
        user.setPasswordHash(new BigInteger(1,m.digest()).toString(16));
        
        // Use the 'User' DAO object to save the user
        UserDao dao = new UserDao();
        dao.addUser(user);
        
        out.println("<script type=\"text/javascript\">");
        out.println("alert('Cadastro realizado com sucesso! Bem vindo ao DRAMA.');");
        out.println("location='login.jsp';");
        out.println("</script>");    
	}
}
