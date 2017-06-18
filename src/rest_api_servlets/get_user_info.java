package rest_api_servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDao;
import models.User;

@WebServlet("/getUserInfo")
public class get_user_info extends HttpServlet{
	@Override
	/*
	 * This method gets user's information
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userID = Integer.parseInt(request.getParameter("userID"));
		PrintWriter out = response.getWriter();
		UserDao dao = new UserDao();
		User user = dao.getUser(userID);
		String jsonUser = "{\"id\":\"" + user.getId() + "\",\"name\":\"" + user.getName() + "\",\"userName\":\"" + user.getUserName() + "\",\"email\":\"" + user.getEmail() + "\",\"registrationDate\":\"" + user.getRegistrationDate() + "\",\"photoFile\":\"" + user.getPhotoFile() + "\",\"status\":\"" + user.getStatus() + "\"}";
		response.setContentType("application/json");
		response.getWriter().write(jsonUser);
	}
}
