package br.com.bytx.controller.cliente;

import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.util.CriptografiaUtil;
import br.com.bytx.util.ValidadorCliente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/cliente/perfil")
public class PerfilClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.clienteDAO = new ClienteDAO();
        this.usuarioDAO = new UsuarioDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null || !usuarioLogado.isCliente()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Buscar dados completos do cliente
        Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
        if (cliente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("cliente", cliente);
        request.getRequestDispatcher("/WEB-INF/view/cliente/perfil.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null || !usuarioLogado.isCliente()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String acao = request.getParameter("acao");

        if ("atualizarDados".equals(acao)) {
            atualizarDadosPessoais(request, response, usuarioLogado);
        } else if ("alterarSenha".equals(acao)) {
            alterarSenha(request, response, usuarioLogado);
        } else {
            response.sendRedirect(request.getContextPath() + "/cliente/perfil");
        }
    }

    private void atualizarDadosPessoais(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String nome = request.getParameter("nome");
        String dataNascimentoStr = request.getParameter("dataNascimento");
        String genero = request.getParameter("genero");
        String telefone = request.getParameter("telefone");

        try {
            // Validar nome
            if (!ValidadorCliente.validarNome(nome)) {
                request.setAttribute("erro", "Nome deve conter pelo menos 2 palavras com mínimo 3 letras cada");
                doGet(request, response);
                return;
            }

            // Converter data de nascimento
            LocalDate dataNascimento = null;
            if (dataNascimentoStr != null && !dataNascimentoStr.isEmpty()) {
                try {
                    dataNascimento = LocalDate.parse(dataNascimentoStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                } catch (Exception e) {
                    request.setAttribute("erro", "Data de nascimento inválida");
                    doGet(request, response);
                    return;
                }
            }

            // Buscar cliente
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
            if (cliente == null) {
                request.setAttribute("erro", "Cliente não encontrado");
                doGet(request, response);
                return;
            }

            // Atualizar usuário (nome)
            usuarioLogado.setNome(nome);
            if (!usuarioDAO.atualizarUsuario(usuarioLogado)) {
                request.setAttribute("erro", "Erro ao atualizar nome");
                doGet(request, response);
                return;
            }

            // Atualizar cliente
            cliente.setDataNascimento(dataNascimento);
            cliente.setGenero(genero);
            cliente.setTelefone(telefone);

            if (!clienteDAO.atualizarCliente(cliente)) {
                request.setAttribute("erro", "Erro ao atualizar dados pessoais");
                doGet(request, response);
                return;
            }

            // Atualizar sessão
            request.getSession().setAttribute("usuarioLogado", usuarioLogado);
            request.setAttribute("sucesso", "Dados atualizados com sucesso!");

        } catch (Exception e) {
            System.out.println("Erro ao atualizar dados pessoais: " + e.getMessage());
            request.setAttribute("erro", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
    }

    private void alterarSenha(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String senhaAtual = request.getParameter("senhaAtual");
        String novaSenha = request.getParameter("novaSenha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        try {
            // Validar senhas
            if (novaSenha == null || novaSenha.length() < 6) {
                request.setAttribute("erroSenha", "Nova senha deve ter pelo menos 6 caracteres");
                doGet(request, response);
                return;
            }

            if (!novaSenha.equals(confirmarSenha)) {
                request.setAttribute("erroSenha", "Senhas não conferem");
                doGet(request, response);
                return;
            }

            // Verificar senha atual
            Usuario usuarioCompleto = usuarioDAO.buscarUsuarioPorEmail(usuarioLogado.getEmail());
            if (!CriptografiaUtil.verificarSenha(senhaAtual, usuarioCompleto.getSenha())) {
                request.setAttribute("erroSenha", "Senha atual incorreta");
                doGet(request, response);
                return;
            }

            // Atualizar senha
            if (!usuarioDAO.atualizarSenha(usuarioLogado.getId(), novaSenha)) {
                request.setAttribute("erroSenha", "Erro ao alterar senha");
                doGet(request, response);
                return;
            }

            request.setAttribute("sucesso", "Senha alterada com sucesso!");

        } catch (Exception e) {
            System.out.println("Erro ao alterar senha: " + e.getMessage());
            request.setAttribute("erroSenha", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
    }
}