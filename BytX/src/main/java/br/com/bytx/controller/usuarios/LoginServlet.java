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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
        // Corrigir o hash ao iniciar o servlet
        corrigirHashAdmin();
    }

    private void corrigirHashAdmin() {
        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            String novoSenhaHash = CriptografiaUtil.criptografarSenha("admin123");
            System.out.println("Novo hash BCrypt: " + novoSenhaHash);

            String sql = "UPDATE usuarios SET senha = ? WHERE email = 'admin@bytX.com'";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, novoSenhaHash);
            int linhas = ps.executeUpdate();

            if (linhas > 0) {
                System.out.println("Hash do admin atualizado com sucesso!");
            } else {
                System.out.println("Admin não encontrado para atualizar hash");
            }

            ps.close();
            connection.close();

        } catch (Exception e) {
            System.out.println("Erro ao corrigir hash: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("GET /login - Context Path: " + request.getContextPath());

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioLogado") != null) {
            response.sendRedirect(request.getContextPath() + "../WEB_INF/view/admin/dashboard");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DEBUG INICIADO ===");

        String senhaTeste = "admin123";
        String hashTeste = CriptografiaUtil.criptografarSenha(senhaTeste);
        System.out.println("Novo hash gerado: " + hashTeste);

        boolean testeValido = CriptografiaUtil.verificarSenha(senhaTeste, hashTeste);
        System.out.println("Teste com novo hash: " + testeValido);

        String hashDoBanco = "$2a$12$r4A6aU6wz6q6q6q6q6q6qO6q6q6q6q6q6q6q6q6q6q6q6q6q6q6";
        boolean bancoValido = CriptografiaUtil.verificarSenha(senhaTeste, hashDoBanco);
        System.out.println("Teste com hash do banco: " + bancoValido);

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        System.out.println("POST /login - Tentativa: " + email);

        try {
            Usuario usuario = usuarioDAO.verificarLogin(email, senha);

            if (usuario != null) {
                System.out.println("Usuário encontrado: " + usuario.getEmail());

                if (!usuario.isAdministrador() && !usuario.isEstoquista()) {
                    request.setAttribute("erro", "Acesso permitido apenas para administradores e estoquistas");
                    request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                session.setAttribute("grupoUsuario", usuario.getGrupo());

                System.out.println("Login bem-sucedido! Redirecionando...");

                // Redirecionar conforme o grupo
                if (usuario.isAdministrador()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if (usuario.isEstoquista()) {
                    response.sendRedirect(request.getContextPath() + "/estoque/dashboard.jsp");
                }

            } else {
                System.out.println("Login falhou - usuário não encontrado ou senha inválida");
                request.setAttribute("erro", "Email ou senha inválidos");
                request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Erro no login: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro no sistema: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }
}