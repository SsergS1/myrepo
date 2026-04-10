package knit.semit.psr.marketplace.servlet.additional;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import knit.semit.psr.marketplace.entity.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/updatePassword")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdParameter = request.getParameter("userId");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (userIdParameter != null && !userIdParameter.isEmpty()) {
            try {
                long userId = Long.parseLong(userIdParameter);

                if (newPassword != null && confirmPassword != null && newPassword.equals(confirmPassword)) {
                    EntityManagerFactory emf = Persistence.createEntityManagerFactory("marketplacePU");
                    EntityManager em = emf.createEntityManager();

                    em.getTransaction().begin();
                    User user = em.find(User.class, userId);

                    if (user != null) {
                        user.setUserPsw(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
                        em.getTransaction().commit();
                    } else {
                        em.getTransaction().rollback();
                        request.setAttribute("errorMessage", "User not found.");
                        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                        return;
                    }

                    em.close();
                    emf.close();

                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Password changed successfully.");
                    response.sendRedirect("Profile.jsp?userId=" + userId);
                } else {
                    request.setAttribute("errorMessage", "Passwords do not match.");
                    request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                response.getWriter().println("Invalid userId parameter");
                e.printStackTrace();
            }
        } else {
            response.getWriter().println("Missing userId parameter");
        }
    }
}
