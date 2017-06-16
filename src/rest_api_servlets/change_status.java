package rest_api_servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDao;

@WebServlet("/change_status")
public class change_status extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userID = Integer.parseInt(request.getParameter("userId"));
		String newStatus = request.getParameter("status");
		
		UserDao dao = new UserDao();
		try{
			dao.updateUserStatus(userID, newStatus);
			response.setStatus(200);
		}catch(RuntimeException e){
			response.setStatus(400);
		}
	}
}
