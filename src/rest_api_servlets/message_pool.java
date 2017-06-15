package rest_api_servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MessageDao;

@WebServlet("/message_pool")
public class message_pool extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userId = Integer.parseInt(request.getParameter("userId"));
		int contactId = Integer.parseInt(request.getParameter("contactId"));
		String messagesJson = "{";
		
		ArrayList<String> messages = new ArrayList<String>();
		MessageDao dao = new MessageDao();
		messages = dao.getUnreadMessages(userId, contactId);
		for(int i=0; i<messages.size(); i++){
			if(i!=messages.size()-1)
				messagesJson += ("\"" + i + "\":\"" + messages.get(i) + "\",");
			else
				messagesJson += ("\"" + i + "\":\"" + messages.get(i) + "\"");
		}
		messagesJson += "}";
		//System.out.println(messagesJson);
		response.setContentType("application/json");
		response.getWriter().write(messagesJson);
	}
}
