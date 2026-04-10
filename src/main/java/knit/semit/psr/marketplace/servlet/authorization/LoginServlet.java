package knit.semit.psr.marketplace.servlet.authorization;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import knit.semit.psr.marketplace.entity.User;
import jakarta.persistence.EntityManagerFactory;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userEmail = request.getParameter("userEmail");
        String password = request.getParameter("password");

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("marketplacePU");

        if (userEmail.isEmpty() || password.isEmpty()) {
            String errorMessage = "Please fill in all the fields";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("./login.jsp").forward(request, response);
            return;
        }

        User user = getUserFromDatabase(userEmail, password, emf);

        if (user != null && BCrypt.checkpw(password, user.getUserPsw())) {
            if (user.getIsbanned() == 1) {
                String errorMessage = "This account has been banned";
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("loginSuccess", true);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userName", user.getUserName());
                session.setAttribute("userLN", user.getUserLn());
                session.setAttribute("userRole", user.getRole().getRoleName());
                session.setAttribute("userEmail", user.getUserEmail());
                session.setAttribute("userInfo", user.getUserInfo());
                request.getRequestDispatcher("main_page.jsp").forward(request, response);
            }
        } else {
            String errorMessage = "Invalid Email or Password";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

        emf.close();
    }

    private User getUserFromDatabase(String userEmail, String password, EntityManagerFactory emf) {
        EntityManager em = emf.createEntityManager();
        User user = null;
        try {
            user = em.createQuery("SELECT u FROM User u WHERE u.userEmail = :userEmail", User.class)
                    .setParameter("userEmail", userEmail)
                    .getSingleResult();
        } catch (NoResultException e) {
            // User not found, return null
        }
        em.close();
        return user;
    }
}
