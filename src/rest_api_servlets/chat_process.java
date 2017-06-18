package rest_api_servlets;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MessageDao;
import models.Message;

@WebServlet("/chat_process")
public class chat_process extends HttpServlet{
	@Override
	/*
	 * This method saves the messages on the database
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String senderId = request.getParameter("userId");
		String recipientId = request.getParameter("contactId");
		String content = request.getParameter("msg");
		
		// Remove quotation marks from message content
		StringBuilder sb = new StringBuilder(content);
		sb.deleteCharAt(content.length()-1);
		sb.deleteCharAt(0);
		String cleanedContent = sb.toString();
		//cleanedContent.replace("\"", "\\\"");
		
		Message m = new Message();
		m.setSenderId(Integer.parseInt(senderId));
		m.setRecipientId(Integer.parseInt(recipientId));
		m.setContent(cleanedContent);
		m.setDelivery_time(new Date());
		
		MessageDao dao = new MessageDao();
		dao.recordMessage(m);
		
		response.setStatus(200);
	}
}
