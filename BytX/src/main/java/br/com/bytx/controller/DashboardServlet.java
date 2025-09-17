package br.com.bytx.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard") //Servlet será chamado
public class DashboardServlet extends HttpServlet {
    //Painel administrativo, acesso somente ao usuário logado. (controlador de acesso)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Permite que seja executado quando é acessado via alguma URL via get.

        // Verificar se usuário está logado
        if (request.getSession().getAttribute("usuarioLogado") == null) {
            //Busca na sessão "usuarioLogado", caso a verificação seja null (ninguém logado, redireciona
            //para a página de Login.
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Correto: JSP está dentro de WEB-INF/views/
        request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
        //.forward - renderiza o dashboard - mantém os dados do request (dúvida). - É acessado
        //diretamente pelo servlet
    }
}