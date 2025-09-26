package br.com.bytx.controller.usuarios;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/usuarios/alterar-status")
public class AlterarStatusUsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ALTERAR STATUS - INICIANDO ===");

        // Verificar se é ADMIN
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            System.out.println("❌ ACESSO NEGADO - Não é ADMIN");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = request.getParameter("email");
        String acao = request.getParameter("acao");

        System.out.println("📋 Dados recebidos:");
        System.out.println("Email: " + email);
        System.out.println("Ação: " + acao);

        if (email != null && acao != null) {
            Usuario usuario = usuarioDAO.buscarUsuarioPorEmail(email);

            if (usuario != null && !usuario.getEmail().equals(usuarioLogado.getEmail())) {
                boolean novoStatus = "ativar".equals(acao);
                System.out.println("✅ Alterando status para: " + (novoStatus ? "ATIVO" : "INATIVO"));

                boolean sucesso = usuarioDAO.alterarStatusUsuario(usuario.getId(), novoStatus);
                System.out.println("✅ Resultado: " + sucesso);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }
}