package br.com.bytx.controller.estoque;

import br.com.bytx.model.Usuario;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/estoque/dashboard")
public class DashboardEstoqueServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?erro=Acesso negado");
            return;
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/estoque/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}