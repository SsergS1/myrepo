package knit.semit.psr.marketplace.Filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import knit.semit.psr.marketplace.entity.User;

public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Инициализация фильтра, если требуется
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                String role = user.getRole().getRoleName();
                if (isAccessAllowed(path, role)) {
                    chain.doFilter(request, response);
                } else {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/notAuthorized.jsp");
                }
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            }
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }

    private boolean isAccessAllowed(String path, String role) {
        switch (path) {
            case "/addproduct":
                return "Seller".equals(role);
            case "/approveproducts":
            case "/submitAuction":
            case "/loadProductList":
            case "/reject":
            case "/approve":
                return "Admin".equals(role);
            case "/orderList":
                return !"Seller".equals(role);
            case "/payOrder":
            case "/purchasedItems":
                return "Buyer".equals(role);
            case "/update":
                return true; // Authenticated user
            case "/listproduct":
                return "Seller".equals(role);
            default:
                return false;
        }
    }

    @Override
    public void destroy() {
        // Очистка ресурсов, если требуется
    }
}
