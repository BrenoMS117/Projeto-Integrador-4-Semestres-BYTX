package br.com.bytx.controller.clientes;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.util.ValidadorCPF;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cadastro-cliente")
public class CadastroClienteServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar se já está logado
        if (request.getSession().getAttribute("usuarioLogado") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        System.out.println("=== TENTATIVA DE CADASTRO DE CLIENTE ===");
        System.out.println("Nome: " + nome);
        System.out.println("Email: " + email);

        try {
            // Validações
            if (nome == null || nome.trim().isEmpty()) {
                request.setAttribute("erro", "Nome é obrigatório");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
                return;
            }

            if (!ValidadorCPF.validar(cpf)) {
                request.setAttribute("erro", "CPF inválido");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
                return;
            }

            if (senha == null || senha.length() < 6) {
                request.setAttribute("erro", "Senha deve ter pelo menos 6 caracteres");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
                return;
            }

            if (!senha.equals(confirmarSenha)) {
                request.setAttribute("erro", "Senhas não conferem");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
                return;
            }

            // Verificar se email já existe
            if (usuarioDAO.emailExiste(email)) {
                request.setAttribute("erro", "Este email já está cadastrado");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
                return;
            }

            // Verificar se CPF já existe
            if (usuarioDAO.cpfExiste(cpf)) {
                request.setAttribute("erro", "Este CPF já está cadastrado");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
                return;
            }

            // Criar usuário do tipo CLIENTE
            Usuario cliente = new Usuario(nome, cpf, email, senha, "CLIENTE");

            if (usuarioDAO.inserirUsuario(cliente)) {
                System.out.println("Cliente cadastrado com sucesso: " + email);

                // Logar automaticamente após cadastro
                Usuario usuarioLogado = usuarioDAO.verificarLogin(email, senha);
                if (usuarioLogado != null) {
                    request.getSession().setAttribute("usuarioLogado", usuarioLogado);
                    request.getSession().setAttribute("grupoUsuario", "CLIENTE");
                }

                response.sendRedirect(request.getContextPath() + "/?mensagem=Cadastro realizado com sucesso!");
            } else {
                request.setAttribute("erro", "Erro ao cadastrar. Tente novamente.");
                request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Erro no cadastro: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro no sistema: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/clientes/cadastro.jsp").forward(request, response);
        }
    }
}