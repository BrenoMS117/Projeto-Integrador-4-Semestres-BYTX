package br.com.bytx.controller;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.util.ValidadorCPF;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/usuarios/editar")
public class EditarUsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
    }

    // === NOVO MÉTODO GET === //
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ACESSANDO EDIÇÃO VIA GET ===");

        // Verificar se é ADMIN
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = request.getParameter("email");
        System.out.println("Email recebido: " + email);

        if (email == null || email.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
            return;
        }

        Usuario usuario = usuarioDAO.buscarUsuarioPorEmail(email);

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
            return;
        }

        request.setAttribute("usuario", usuario);
        request.getRequestDispatcher("/WEB-INF/view/admin/editar-usuario.jsp").forward(request, response);
    }

    // === MÉTODO POST (JÁ EXISTENTE) === //
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== INICIANDO EDIÇÃO DE USUÁRIO ===");

        // Verificar se é ADMIN
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            System.out.println("❌ ACESSO NEGADO - Não é ADMIN");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Obter parâmetros
        String emailParam = request.getParameter("email");
        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        String grupo = request.getParameter("grupo");
        String alterarSenha = request.getParameter("alterarSenha");
        String novaSenha = request.getParameter("novaSenha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        System.out.println("📋 Dados recebidos:");
        System.out.println("Email: " + emailParam);
        System.out.println("Nome: " + nome);
        System.out.println("CPF: " + cpf);
        System.out.println("Grupo: " + grupo);
        System.out.println("Alterar senha: " + alterarSenha);

        // Buscar usuário
        Usuario usuario = usuarioDAO.buscarUsuarioPorEmail(emailParam);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios");
            return;
        }

        // Validar dados
        if (!validarDadosEdicao(request, nome, cpf, grupo, alterarSenha, novaSenha, confirmarSenha, usuario, emailParam)) {
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/WEB-INF/view/admin/editar-usuario.jsp").forward(request, response);
            return;
        }

        // Atualizar usuário
        usuario.setNome(nome);
        usuario.setCpf(ValidadorCPF.removerFormatacao(cpf));

        // Só permite alterar grupo se não for o próprio usuário
        if (!usuario.getEmail().equals(usuarioLogado.getEmail())) {
            usuario.setGrupo(grupo);
            System.out.println("✅ Grupo alterado para: " + grupo);

            // OBTER STATUS (apenas se não for o próprio usuário)
            String ativoParam = request.getParameter("usuarioAtivo");
            boolean novoStatus = "on".equals(ativoParam);
            usuario.setAtivo(novoStatus);
            System.out.println("✅ Status alterado para: " + (novoStatus ? "ATIVO" : "INATIVO"));
        } else {
            System.out.println("ℹ️ Mantendo grupo e status originais (é o próprio usuário)");
        }

        // Atualizar senha se solicitado
        if ("on".equals(alterarSenha) && novaSenha != null && !novaSenha.trim().isEmpty()) {
            usuarioDAO.atualizarSenha(usuario.getId(), novaSenha);
        }

        if (usuarioDAO.atualizarUsuario(usuario)) {
            // Redireciona para evitar problema de F5
            response.sendRedirect(request.getContextPath() + "/admin/usuarios/editar?email=" + usuario.getEmail() + "&sucesso=Operação concluída com sucesso!");
            return;
        } else {
            // Em caso de erro, mostra a página de edição
            request.setAttribute("usuario", usuario);
            request.setAttribute("mensagemErro", "Erro ao atualizar usuário.");
            request.getRequestDispatcher("/WEB-INF/view/admin/editar-usuario.jsp").forward(request, response);
        }
    }

    private boolean validarDadosEdicao(HttpServletRequest request, String nome, String cpf, String grupo,
                                       String alterarSenha, String novaSenha, String confirmarSenha,
                                       Usuario usuario, String emailParam) {

        boolean valido = true;

        // Validar nome
        if (nome == null || nome.trim().isEmpty()) {
            request.setAttribute("erroNome", "Nome é obrigatório");
            valido = false;
        }

        // Validar CPF
        if (cpf == null || cpf.trim().isEmpty()) {
            request.setAttribute("erroCpf", "CPF é obrigatório");
            valido = false;
        } else if (!ValidadorCPF.validar(cpf)) {
            request.setAttribute("erroCpf", "CPF inválido");
            valido = false;
        } else {
            // Verificar se CPF já existe em outro usuário
            String cpfLimpo = ValidadorCPF.removerFormatacao(cpf);
            if (!cpfLimpo.equals(usuario.getCpf()) && usuarioDAO.cpfExiste(cpf)) {
                request.setAttribute("erroCpf", "CPF já cadastrado em outro usuário");
                valido = false;
            }
        }

        // Validar grupo
        if (grupo == null || (!"ADMIN".equals(grupo) && !"ESTOQUISTA".equals(grupo))) {
            request.setAttribute("erroGrupo", "Grupo inválido");
            valido = false;
        }

        // Validar senha se for alterar
        if ("on".equals(alterarSenha)) {
            if (novaSenha == null || novaSenha.trim().isEmpty()) {
                request.setAttribute("erroSenha", "Nova senha é obrigatória");
                valido = false;
            } else if (novaSenha.length() < 6) {
                request.setAttribute("erroSenha", "Senha deve ter pelo menos 6 caracteres");
                valido = false;
            } else if (!novaSenha.equals(confirmarSenha)) {
                request.setAttribute("erroSenha", "Senhas não coincidem");
                valido = false;
            }
        }

        // Manter dados preenchidos em caso de erro
        if (!valido) {
            request.setAttribute("nome", nome);
            request.setAttribute("cpf", cpf);
            request.setAttribute("grupo", grupo);
            request.setAttribute("alterarSenha", alterarSenha);
        }

        return valido;
    }
}