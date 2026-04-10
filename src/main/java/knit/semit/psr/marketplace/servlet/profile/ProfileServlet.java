package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import knit.semit.psr.marketplace.entity.User;


import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("notAuthorized.jsp");
            return;
        }
        // Получаем userId из запроса
        String userId = request.getParameter("userId");

        // Передаем userId как атрибут запроса
        request.setAttribute("userId", userId);

        // Перенаправляем запрос на страницу профиля
        request.getRequestDispatcher("/Profile.jsp").forward(request, response);
    }
}



