package knit.semit.psr.marketplace.servlet.profile;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Persistence;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import knit.semit.psr.marketplace.daohbn.UserDAO;
import knit.semit.psr.marketplace.entity.User;
import knit.semit.psr.marketplace.enums.MsgForUser;


import java.io.IOException;

@WebServlet("/update")
public class EditInfo extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String userIdParameter = request.getParameter("userId");

        if (userIdParameter != null && !userIdParameter.isEmpty()) {
            try {
                long userId = Long.parseLong(userIdParameter);
                String userName = request.getParameter("user_Name");
                String userLn = request.getParameter("user_Ln");
                String userEmail = request.getParameter("user_email");
                String userInfo = request.getParameter("user_info");

                EntityManagerFactory emf = Persistence.createEntityManagerFactory("marketplacePU");
                EntityManager em = emf.createEntityManager();

                // Проверяем, существует ли новый email
                try {
                    User existingUser = em.createQuery("SELECT u FROM User u WHERE u.userEmail = :userEmail AND u.userId != :userId", User.class)
                            .setParameter("userEmail", userEmail)
                            .setParameter("userId", userId)
                            .getSingleResult();

                    // Если запрос вернул результат, email уже используется
                    String errorMessage = "Sorry, this email address is already taken";
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("editprofile.jsp").forward(request, response);
                    em.close();
                    emf.close();
                    return;
                } catch (NoResultException e) {
                    // Если нет существующего пользователя с таким же email, продолжаем обновление
                }

                em.getTransaction().begin();
                User user = em.find(User.class, userId);

                user.setUserName(userName);
                user.setUserLn(userLn);
                user.setUserEmail(userEmail);
                if (userInfo != null) {
                    user.setUserInfo(userInfo);
                }

                em.getTransaction().commit();
                em.close();
                emf.close();

                HttpSession session = request.getSession();
                session.setAttribute("userName", userName);
                session.setAttribute("userLN", userLn);
                session.setAttribute("userEmail", userEmail);
                session.setAttribute("userInfo", userInfo);

                response.sendRedirect("Profile.jsp?userId=" + userId);
            } catch (NumberFormatException e) {
                response.getWriter().println("Invalid userId parameter");
                e.printStackTrace();
            }
        } else {
            response.getWriter().println("Missing userId parameter");
        }
    }
}