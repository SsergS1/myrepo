package knit.semit.psr.marketplace.servlet.additional;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.UserDAO;

import java.io.IOException;

@WebServlet("/unbanUser")
public class UnbanUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        System.out.println("Received request to unban user with ID: " + userIdStr);

        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdStr);
                UserDAO.unbanUser(userId);
                System.out.println("Successfully unbanned user with ID: " + userId);
                response.setStatus(HttpServletResponse.SC_OK);
            } catch (NumberFormatException e) {
                System.out.println("Invalid user ID: " + userIdStr);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
            } catch (Exception e) {
                System.out.println("Error unbanning user: " + e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error unbanning user");
            }
        } else {
            System.out.println("User ID is missing");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is missing");
        }
    }
}