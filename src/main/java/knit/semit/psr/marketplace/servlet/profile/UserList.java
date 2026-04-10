package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import knit.semit.psr.marketplace.daohbn.UserDAO;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/userlist")
public class UserList extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> userlist = UserDAO.getAllUsers();
        request.setAttribute("users", userlist);
        request.getRequestDispatcher("listusers.jsp").forward(request,response);
    }
}
