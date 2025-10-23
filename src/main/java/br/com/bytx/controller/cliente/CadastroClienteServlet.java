package br.com.bytx.controller.cliente;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.dao.EnderecoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.cliente.Endereco;
import br.com.bytx.util.CriptografiaUtil;
import br.com.bytx.util.ValidadorCPF;
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

@WebServlet("/cadastro-cliente")
public class CadastroClienteServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private ClienteDAO clienteDAO;
    private EnderecoDAO enderecoDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
        this.clienteDAO = new ClienteDAO();
        this.enderecoDAO = new EnderecoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Exibir formulário de cadastro
        request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== PROCESSANDO CADASTRO DE CLIENTE ===");

        // Obter parâmetros do formulário
        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        String dataNascimentoStr = request.getParameter("dataNascimento");
        String genero = request.getParameter("genero");
        String telefone = request.getParameter("telefone");

        // Dados do endereço de faturamento (obrigatório)
        String cep = request.getParameter("cep");
        String logradouro = request.getParameter("logradouro");
        String numero = request.getParameter("numero");
        String complemento = request.getParameter("complemento");
        String bairro = request.getParameter("bairro");
        String cidade = request.getParameter("cidade");
        String uf = request.getParameter("uf");

        // Endereço de entrega (pode ser o mesmo)
        boolean mesmoEnderecoEntrega = "on".equals(request.getParameter("mesmoEndereco"));

        try {
            // 1. VALIDAÇÕES BÁSICAS
            if (!validarDadosBasicos(request, nome, cpf, email, senha, confirmarSenha)) {
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 2. VALIDAR NOME (2 palavras, mínimo 3 letras cada)
            if (!ValidadorCliente.validarNome(nome)) {
                request.setAttribute("erroNome", "Nome deve conter pelo menos 2 palavras com mínimo 3 letras cada");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 3. VERIFICAR SE EMAIL JÁ EXISTE
            if (usuarioDAO.emailExiste(email)) {
                request.setAttribute("erroEmail", "Este email já está cadastrado");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 4. VERIFICAR SE CPF JÁ EXISTE
            if (usuarioDAO.cpfExiste(cpf)) {
                request.setAttribute("erroCpf", "Este CPF já está cadastrado");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 5. VALIDAR ENDEREÇO
            if (!validarEndereco(request, cep, logradouro, numero, bairro, cidade, uf)) {
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 6. CONVERTER DATA DE NASCIMENTO
            LocalDate dataNascimento = null;
            if (dataNascimentoStr != null && !dataNascimentoStr.isEmpty()) {
                try {
                    dataNascimento = LocalDate.parse(dataNascimentoStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                } catch (Exception e) {
                    request.setAttribute("erroDataNascimento", "Data de nascimento inválida");
                    request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                    return;
                }
            }

            // 7. CRIAR USUÁRIO
            Usuario usuario = new Usuario(nome, cpf, email, senha, "CLIENTE");
            usuario.setAtivo(true);

            if (!usuarioDAO.inserirUsuario(usuario)) {
                request.setAttribute("erroGeral", "Erro ao criar usuário. Tente novamente.");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 8. BUSCAR USUÁRIO CRIADO (para obter o ID)
            Usuario usuarioCriado = usuarioDAO.buscarUsuarioPorEmail(email);
            if (usuarioCriado == null) {
                request.setAttribute("erroGeral", "Erro ao recuperar usuário criado.");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 9. CRIAR CLIENTE
            Cliente cliente = new Cliente(usuarioCriado, dataNascimento, genero);
            cliente.setTelefone(telefone);

            if (!clienteDAO.inserirCliente(cliente)) {
                request.setAttribute("erroGeral", "Erro ao criar perfil do cliente.");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 10. BUSCAR CLIENTE CRIADO
            Cliente clienteCriado = clienteDAO.buscarPorUsuarioId(usuarioCriado.getId());

            // 11. CRIAR ENDEREÇO DE FATURAMENTO
            Endereco enderecoFaturamento = new Endereco("FATURAMENTO", cep, logradouro, numero, bairro, cidade, uf);
            enderecoFaturamento.setComplemento(complemento);
            enderecoFaturamento.setClienteId(clienteCriado.getId());

            if (!enderecoDAO.inserirEndereco(enderecoFaturamento)) {
                request.setAttribute("erroGeral", "Erro ao salvar endereço de faturamento.");
                request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                return;
            }

            // 12. CRIAR ENDEREÇO DE ENTREGA
            if (mesmoEnderecoEntrega) {
                // Usar mesmo endereço para entrega
                Endereco enderecoEntrega = new Endereco("ENTREGA", cep, logradouro, numero, bairro, cidade, uf);
                enderecoEntrega.setComplemento(complemento);
                enderecoEntrega.setClienteId(clienteCriado.getId());
                enderecoEntrega.setPadrao(true);

                if (!enderecoDAO.inserirEndereco(enderecoEntrega)) {
                    request.setAttribute("erroGeral", "Erro ao salvar endereço de entrega.");
                    request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
                    return;
                }
            }

            // 13. LOGIN AUTOMÁTICO - Fazer login automaticamente
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuarioCriado);
            session.setAttribute("grupoUsuario", "CLIENTE");
            session.setAttribute("mensagemSucesso", "Cadastro realizado com sucesso! Você já está logado.");

// Redirecionar para a página inicial (loja)
            response.sendRedirect(request.getContextPath() + "/");

        } catch (Exception e) {
            System.out.println("Erro no cadastro de cliente: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erroGeral", "Erro interno no sistema: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/cliente/cadastro-cliente.jsp").forward(request, response);
        }
    }

    private boolean validarDadosBasicos(HttpServletRequest request, String nome, String cpf, String email,
                                        String senha, String confirmarSenha) {
        boolean valido = true;

        if (nome == null || nome.trim().isEmpty()) {
            request.setAttribute("erroNome", "Nome é obrigatório");
            valido = false;
        }

        if (cpf == null || cpf.trim().isEmpty() || !ValidadorCPF.validar(cpf)) {
            request.setAttribute("erroCpf", "CPF inválido");
            valido = false;
        }

        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            request.setAttribute("erroEmail", "Email inválido");
            valido = false;
        }

        if (senha == null || senha.length() < 6) {
            request.setAttribute("erroSenha", "Senha deve ter pelo menos 6 caracteres");
            valido = false;
        }

        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erroConfirmarSenha", "Senhas não conferem");
            valido = false;
        }

        return valido;
    }

    private boolean validarEndereco(HttpServletRequest request, String cep, String logradouro,
                                    String numero, String bairro, String cidade, String uf) {
        boolean valido = true;

        if (cep == null || cep.replace("-", "").length() != 8) {
            request.setAttribute("erroCep", "CEP inválido");
            valido = false;
        }

        if (logradouro == null || logradouro.trim().isEmpty()) {
            request.setAttribute("erroLogradouro", "Logradouro é obrigatório");
            valido = false;
        }

        if (numero == null || numero.trim().isEmpty()) {
            request.setAttribute("erroNumero", "Número é obrigatório");
            valido = false;
        }

        if (bairro == null || bairro.trim().isEmpty()) {
            request.setAttribute("erroBairro", "Bairro é obrigatório");
            valido = false;
        }

        if (cidade == null || cidade.trim().isEmpty()) {
            request.setAttribute("erroCidade", "Cidade é obrigatória");
            valido = false;
        }

        if (uf == null || uf.length() != 2) {
            request.setAttribute("erroUf", "UF inválida");
            valido = false;
        }

        return valido;
    }
}