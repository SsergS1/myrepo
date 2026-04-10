package knit.semit.psr.marketplace.servlet.authorization;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.http.HttpSession;
import knit.semit.psr.marketplace.entity.Role;
import knit.semit.psr.marketplace.entity.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    EntityManagerFactory emf = Persistence.createEntityManagerFactory("marketplacePU");
    EntityManager em = emf.createEntityManager();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String repeatPassword = request.getParameter("repeat_password");
        String roleName = request.getParameter("role");

        // Проверка на пустые поля
        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            String errorMessage = "Please fill in all fields";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("./Register.jsp").forward(request, response);
            return;
        }

        // Проверка, совпадают ли пароли
        if (!password.equals(repeatPassword)) {
            String errorMessage = "Passwords do not match. Please try again.";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("./Register.jsp").forward(request, response);
            return;
        }

        // Проверка, выбрана ли роль пользователя
        if (roleName == null || roleName.isEmpty()) {
            String errorMessage = "Please select the user role";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("./Register.jsp").forward(request, response);
            return;
        }

        EntityManager em = Persistence.createEntityManagerFactory("marketplacePU").createEntityManager();

        // Проверка на существующий email
        List<User> existingUsers = em.createQuery("SELECT u FROM User u WHERE u.userEmail = :email", User.class)
                .setParameter("email", email)
                .getResultList();
        if (!existingUsers.isEmpty()) {
            String errorMessage = "Sorry, this user is already registered, please provide a different email address.";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("./Register.jsp").forward(request, response);
            return;
        }

        // Создание нового пользователя
        User newUser = new User();
        newUser.setUserName(firstName);
        newUser.setUserLn(lastName);
        newUser.setUserEmail(email);
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        newUser.setUserPsw(hashedPassword);

        // Получение роли пользователя из параметров запроса
        Role role = em.createQuery("SELECT r FROM Role r WHERE r.roleName = :roleName", Role.class)
                .setParameter("roleName", roleName)
                .getSingleResult();
        newUser.setRole(role);

        // Сохранение нового пользователя в базе данных
        em.getTransaction().begin();
        em.persist(newUser);
        em.getTransaction().commit();
        em.close();

        // Авторизация пользователя после успешной регистрации
        User user = getUserFromDatabase(email, hashedPassword, emf);
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

        // Перенаправление на главную страницу
        response.sendRedirect("main_page.jsp");
    }

    private User getUserFromDatabase(String userEmail, String password, EntityManagerFactory emf) {
        EntityManager em = emf.createEntityManager();
        User user = em.createQuery("SELECT u FROM User u WHERE u.userEmail = :userEmail", User.class)
                .setParameter("userEmail", userEmail)
                .getResultStream()
                .findFirst()
                .orElse(null);
        em.close();
        return user;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Если пользователь обратился к сервлету методом GET, перенаправляем на страницу регистрации
        response.sendRedirect("Register.jsp");
    }
}
