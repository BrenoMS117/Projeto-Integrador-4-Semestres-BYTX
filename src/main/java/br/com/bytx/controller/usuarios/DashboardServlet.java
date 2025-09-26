package br.com.bytx.controller.usuarios;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar se usuário está logado
        if (request.getSession().getAttribute("usuarioLogado") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Correto: JSP está dentro de WEB-INF/views/
        request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
    }
}