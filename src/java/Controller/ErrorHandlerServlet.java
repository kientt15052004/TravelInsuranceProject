package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ErrorHandlerServlet", urlPatterns = {"/error-handler"})
public class ErrorHandlerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward directly to home.jsp (not through servlet) to avoid redirect loop
        // This prevents infinite redirect: error -> error-handler -> home.jsp (not /home servlet)
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward directly to home.jsp (not through servlet) to avoid redirect loop
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}

