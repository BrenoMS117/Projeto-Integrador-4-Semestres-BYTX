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

@WebServlet("/admin/usuarios/cadastrar")
//Servlet que permite a criação de novos usuários no sistema.
//Função responsável somente a administradores
public class CadastroUsuarioServlet extends HttpServlet {
//Irá funcionar para ambos toGet e toPost, para exibir e processar envio.
    private UsuarioDAO usuarioDAO; //Acessar banco de dados

    @Override //Polimorfismo sobrescrever
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
        //Permitindo que o DAO esteja pronto para qualquer requisição. Requisição -
        // (Mensagem enviada do navegador para o servidor).
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Exibição para o cadastro de usuários (Os parâmetros se repetem, seja um método doGet ou doPost).
        //Os dados são vistos na URL, ficam gravados no histórico do navegador.

        // Verificar se é ADMIN
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/admin/cadastrar-usuario.jsp").forward(request, response);
        //.forward - renderizar JSP sem ter mudanças na própria URL(navegador).
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Processo e envio do que foi exibido no método doGet. (doPost, altera dados).
        //Os parâmetros vão no corpo da requisição, que seriam a mensagem de envio que geralmente é vista na
        //Url quando se utiliza  doGet.

        System.out.println("=== INICIANDO CADASTRO DE USUÁRIO ===");

        // Verificar se é ADMIN
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            System.out.println("ACESSO NEGADO - Usuário não é ADMIN");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Obter parâmetros do formulário
        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        String grupo = request.getParameter("grupo");
        //Validações feitas antes de dar continuidade no processo de cadastro.

        System.out.println("Dados recebidos:");
        System.out.println("Nome: " + nome);
        System.out.println("CPF: " + cpf);
        System.out.println("Email: " + email);
        System.out.println("Grupo: " + grupo);
        System.out.println("Senha preenchida: " + (senha != null && !senha.isEmpty()));
        //Visualização de senha, não exibida para segurança para quem pode estar visualizando.
        System.out.println("Confirmar Senha preenchida: " + (confirmarSenha != null && !confirmarSenha.isEmpty()));

        // Validar dados
        //Chamada de método e caso haja algum problema retorna para a área de cadastro.
        if (!validarDados(request, nome, cpf, email, senha, confirmarSenha, grupo)) {
            System.out.println("VALIDAÇÃO FALHOU - Redirecionando para formulário");
            request.getRequestDispatcher("/WEB-INF/view/admin/cadastrar-usuario.jsp").forward(request, response);
            return;
        }

        System.out.println("Validação passou - Criando usuário...");

        // Criar e salvar usuário(objeto)
        Usuario novoUsuario = new Usuario();
        novoUsuario.setNome(nome);
        novoUsuario.setCpf(ValidadorCPF.removerFormatacao(cpf));
        novoUsuario.setEmail(email);
        novoUsuario.setSenha(senha);
        novoUsuario.setGrupo(grupo);
        novoUsuario.setAtivo(true); //(Padrão)

        System.out.println("👤 Usuário criado: " + novoUsuario.getEmail());

        try {
            boolean sucesso = usuarioDAO.inserirUsuario(novoUsuario);
            //Inserir usuário usando DAO.
            System.out.println("Resultado do insert: " + sucesso);

            if (sucesso) {
                request.setAttribute("mensagemSucesso", "Usuário cadastrado com sucesso!");
                System.out.println(" USUÁRIO SALVO NO BANCO");
            } else {
                request.setAttribute("mensagemErro", "Erro ao cadastrar usuário. Tente novamente.");
                System.out.println("FALHA AO SALVAR NO BANCO");
            }
        } catch (Exception e) {
            System.out.println("ERRO EXCEÇÃO: " + e.getMessage());
            e.printStackTrace(); //Motivo desse exception.
            request.setAttribute("mensagemErro", "Erro interno: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/view/admin/cadastrar-usuario.jsp").forward(request, response);
        //Exibição do formulário novamente, porém com a informação de sucesso ou erro.
    }

    //Criação de um método auxiliar.
    private boolean validarDados(HttpServletRequest request, String nome, String cpf,
                                 String email, String senha, String confirmarSenha, String grupo) {

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
        } else if (usuarioDAO.cpfExiste(cpf)) {
            request.setAttribute("erroCpf", "CPF já cadastrado");
            valido = false;
        }

        // Validar email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("erroEmail", "Email é obrigatório");
            valido = false;
        } else if (usuarioDAO.emailExiste(email)) {
            request.setAttribute("erroEmail", "Email já cadastrado");
            valido = false;
        }

        // Validar senha
        if (senha == null || senha.trim().isEmpty()) {
            request.setAttribute("erroSenha", "Senha é obrigatória");
            valido = false;
        } else if (senha.length() < 6) {
            request.setAttribute("erroSenha", "Senha deve ter pelo menos 6 caracteres");
            valido = false;
        } else if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erroSenha", "Senhas não coincidem");
            valido = false;
        }

        // Validar grupo
        if (grupo == null || (!"ADMIN".equals(grupo) && !"ESTOQUISTA".equals(grupo))) {
            request.setAttribute("erroGrupo", "Grupo inválido");
            valido = false;
        }

        // Manter dados preenchidos em caso de erro
        if (!valido) {
            request.setAttribute("nome", nome);
            request.setAttribute("cpf", cpf);
            request.setAttribute("email", email);
            request.setAttribute("grupo", grupo);
        }

        return valido;
    }
}