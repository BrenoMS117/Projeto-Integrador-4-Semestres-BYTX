package br.com.bytx.controller.usuarios;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.util.CriptografiaUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/testar-cliente")
public class TestarClienteServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        // Testar login do cliente
        Usuario cliente = usuarioDAO.verificarLogin("cliente@bytX.com", "cliente123");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h1>Teste do Usuário Cliente</h1>");

        if (cliente != null) {
            out.println("<p style='color: green;'>✅ LOGIN BEM-SUCEDIDO!</p>");
            out.println("<p>Nome: " + cliente.getNome() + "</p>");
            out.println("<p>Email: " + cliente.getEmail() + "</p>");
            out.println("<p>Grupo: " + cliente.getGrupo() + "</p>");
            out.println("<p>ID: " + cliente.getId() + "</p>");
        } else {
            out.println("<p style='color: red;'>❌ LOGIN FALHOU!</p>");
            out.println("<p>Verifique se o usuário cliente foi criado.</p>");

            // Tentar criar o cliente novamente
            usuarioDAO.criarUsuarioClientePadrao();
        }

        out.println("</body></html>");
    }
}
