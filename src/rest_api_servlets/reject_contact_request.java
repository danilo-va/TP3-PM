package rest_api_servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ContactListDao;

@WebServlet("/rejectContactRequest")
public class reject_contact_request extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int requestID = Integer.parseInt(request.getParameter("reqId"));
		PrintWriter out= response.getWriter();
		
		ContactListDao clDao = new ContactListDao();
		clDao.deleteContactRequest(requestID);
		out.println("<script type=\"text/javascript\">");
        out.println("alert('Solicitação removida.');");
        out.println("location='inicio.jsp';");
        out.println("</script>");
	}
}
