package br.com.bytx.controller.cliente;

import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.dao.EnderecoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.cliente.Endereco;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/cliente/enderecos")
public class EnderecosClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO;
    private EnderecoDAO enderecoDAO;

    @Override
    public void init() throws ServletException {
        this.clienteDAO = new ClienteDAO();
        this.enderecoDAO = new EnderecoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null || !usuarioLogado.isCliente()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Buscar cliente com endereços
        Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
        if (cliente == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("cliente", cliente);
        request.getRequestDispatcher("/WEB-INF/view/cliente/enderecos.jsp").forward(request, response);
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

        if ("adicionar".equals(acao)) {
            adicionarEndereco(request, response, usuarioLogado);
        } else if ("definirPadrao".equals(acao)) {
            definirEnderecoPadrao(request, response, usuarioLogado);
        } else if ("remover".equals(acao)) {
            removerEndereco(request, response, usuarioLogado);
        } else if ("ativar".equals(acao)) {
            ativarEndereco(request, response, usuarioLogado);
        } else if ("desativar".equals(acao)) {
            desativarEndereco(request, response, usuarioLogado);
        } else {
            response.sendRedirect(request.getContextPath() + "/cliente/enderecos");
        }
    }

    private void adicionarEndereco(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String cep = request.getParameter("cep");
        String logradouro = request.getParameter("logradouro");
        String numero = request.getParameter("numero");
        String complemento = request.getParameter("complemento");
        String bairro = request.getParameter("bairro");
        String cidade = request.getParameter("cidade");
        String uf = request.getParameter("uf");
        boolean padrao = "on".equals(request.getParameter("padrao"));

        try {
            // Validar endereço
            if (!validarEndereco(request, cep, logradouro, numero, bairro, cidade, uf)) {
                doGet(request, response);
                return;
            }

            // Buscar cliente
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
            if (cliente == null) {
                request.setAttribute("erro", "Cliente não encontrado");
                doGet(request, response);
                return;
            }
            if (padrao) {
                List<Endereco> enderecos = cliente.getEnderecos();
                if (enderecos != null) {
                    for (Endereco enderecoExistente : enderecos) {
                        if (enderecoExistente != null &&
                                enderecoExistente.isPadrao() &&
                                "ENTREGA".equals(enderecoExistente.getTipo())) {
                            enderecoExistente.setPadrao(false);
                            enderecoDAO.atualizarEndereco(enderecoExistente);
                        }
                    }
                }
            }

            // Criar e inserir novo endereço
            Endereco novoEndereco = new Endereco("ENTREGA", cep, logradouro, numero, bairro, cidade, uf);
            novoEndereco.setComplemento(complemento);
            novoEndereco.setClienteId(cliente.getId());
            novoEndereco.setPadrao(padrao);

            if (enderecoDAO.inserirEndereco(novoEndereco)) {
                request.setAttribute("sucesso", "Endereço adicionado com sucesso!");
            } else {
                request.setAttribute("erro", "Erro ao salvar endereço no banco de dados");
            }

        } catch (Exception e) {
            System.out.println("Erro ao adicionar endereço: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
    }

    private void definirEnderecoPadrao(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String enderecoIdStr = request.getParameter("enderecoId");

        try {
            Long enderecoId = Long.parseLong(enderecoIdStr);

            // Buscar cliente
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
            if (cliente == null) {
                request.setAttribute("erro", "Cliente não encontrado");
                doGet(request, response);
                return;
            }

            // Verificar se endereço pertence ao cliente
            Endereco endereco = enderecoDAO.buscarPorId(enderecoId);
            if (endereco == null || !endereco.getClienteId().equals(cliente.getId())) {
                request.setAttribute("erro", "Endereço não encontrado");
                doGet(request, response);
                return;
            }

            if (!endereco.isAtivado()) {
                request.setAttribute("erro", "Não é possível definir um endereço desativado como padrão");
                doGet(request, response);
                return;
            }

            // Definir como padrão
            if (!enderecoDAO.definirEnderecoPadrao(enderecoId, cliente.getId())) {
                request.setAttribute("erro", "Erro ao definir endereço padrão");
                doGet(request, response);
                return;
            }

            request.setAttribute("sucesso", "Endereço definido como padrão!");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "ID do endereço inválido");
        } catch (Exception e) {
            System.out.println("Erro ao definir endereço padrão: " + e.getMessage());
            request.setAttribute("erro", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
    }

    private void removerEndereco(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String enderecoIdStr = request.getParameter("enderecoId");

        try {
            Long enderecoId = Long.parseLong(enderecoIdStr);

            // Buscar cliente
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
            if (cliente == null) {
                request.setAttribute("erro", "Cliente não encontrado");
                doGet(request, response);
                return;
            }

            // Verificar se endereço pertence ao cliente
            Endereco endereco = enderecoDAO.buscarPorId(enderecoId);
            if (endereco == null || !endereco.getClienteId().equals(cliente.getId())) {
                request.setAttribute("erro", "Endereço não encontrado");
                doGet(request, response);
                return;
            }

            // Não permitir remover endereço de faturamento
            if ("FATURAMENTO".equals(endereco.getTipo())) {
                request.setAttribute("erro", "Não é possível remover o endereço de faturamento");
                doGet(request, response);
                return;
            }

            // Não permitir remover se for o único endereço de entrega (versão segura)
            List<Endereco> enderecos = cliente.getEnderecos();
            long totalEnderecosEntrega = 0;

            if (enderecos != null) {
                totalEnderecosEntrega = enderecos.stream()
                        .filter(e -> e != null && "ENTREGA".equals(e.getTipo()))
                        .count();
            }

            if (totalEnderecosEntrega <= 1 && "ENTREGA".equals(endereco.getTipo())) {
                request.setAttribute("erro", "Não é possível remover o único endereço de entrega");
                doGet(request, response);
                return;
            }

            // Remover endereço
            if (!enderecoDAO.removerEndereco(enderecoId)) {
                request.setAttribute("erro", "Erro ao remover endereço");
                doGet(request, response);
                return;
            }

            request.setAttribute("sucesso", "Endereço removido com sucesso!");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "ID do endereço inválido");
        } catch (Exception e) {
            System.out.println("Erro ao remover endereço: " + e.getMessage());
            request.setAttribute("erro", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
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

    private void ativarEndereco(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String enderecoIdStr = request.getParameter("enderecoId");

        try {
            Long enderecoId = Long.parseLong(enderecoIdStr);

            // Buscar cliente
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
            if (cliente == null) {
                request.setAttribute("erro", "Cliente não encontrado");
                doGet(request, response);
                return;
            }

            // Verificar se endereço pertence ao cliente
            Endereco endereco = enderecoDAO.buscarPorId(enderecoId);
            if (endereco == null || !endereco.getClienteId().equals(cliente.getId())) {
                request.setAttribute("erro", "Endereço não encontrado");
                doGet(request, response);
                return;
            }

            // Ativar endereço
            if (!enderecoDAO.ativarEndereco(enderecoId)) {
                request.setAttribute("erro", "Erro ao ativar endereço");
                doGet(request, response);
                return;
            }

            request.setAttribute("sucesso", "Endereço ativado com sucesso!");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "ID do endereço inválido");
        } catch (Exception e) {
            System.out.println("Erro ao ativar endereço: " + e.getMessage());
            request.setAttribute("erro", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
    }

    private void desativarEndereco(HttpServletRequest request, HttpServletResponse response, Usuario usuarioLogado)
            throws ServletException, IOException {

        String enderecoIdStr = request.getParameter("enderecoId");

        try {
            Long enderecoId = Long.parseLong(enderecoIdStr);

            // Buscar cliente
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioLogado.getId());
            if (cliente == null) {
                request.setAttribute("erro", "Cliente não encontrado");
                doGet(request, response);
                return;
            }


            // Verificar se endereço pertence ao cliente
            Endereco endereco = enderecoDAO.buscarPorId(enderecoId);
            if (endereco == null || !endereco.getClienteId().equals(cliente.getId())) {
                request.setAttribute("erro", "Endereço não encontrado");
                doGet(request, response);
                return;
            }

            // Não permitir desativar endereço padrão
            if (endereco.isPadrao()) {
                request.setAttribute("erro", "Não é possível desativar o endereço padrão");
                doGet(request, response);
                return;
            }

            // Não permitir desativar se for o único endereço ativo de entrega
            List<Endereco> enderecos = cliente.getEnderecos();
            long totalEnderecosAtivosEntrega = 0;

            if (enderecos != null) {
                totalEnderecosAtivosEntrega = enderecos.stream()
                        .filter(e -> e != null &&
                                "ENTREGA".equals(e.getTipo()) &&
                                e.isAtivado())
                        .count();
            }

            if (totalEnderecosAtivosEntrega <= 1 && "ENTREGA".equals(endereco.getTipo()) && endereco.isAtivado()) {
                request.setAttribute("erro", "Não é possível desativar o único endereço de entrega ativo");
                doGet(request, response);
                return;
            }

            // Desativar endereço
            if (!enderecoDAO.desativarEndereco(enderecoId)) {
                request.setAttribute("erro", "Erro ao desativar endereço");
                doGet(request, response);
                return;
            }

            request.setAttribute("sucesso", "Endereço desativado com sucesso!");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "ID do endereço inválido");
        } catch (Exception e) {
            System.out.println("Erro ao desativar endereço: " + e.getMessage());
            request.setAttribute("erro", "Erro interno: " + e.getMessage());
        }

        doGet(request, response);
    }

}