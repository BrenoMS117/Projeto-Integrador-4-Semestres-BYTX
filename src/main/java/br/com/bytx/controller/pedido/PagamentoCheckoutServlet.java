package br.com.bytx.controller.pedido;

import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.carrinho.Carrinho;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout/pagamento")
public class PagamentoCheckoutServlet extends HttpServlet {

    private ClienteDAO clienteDAO;

    @Override
    public void init() throws ServletException {
        this.clienteDAO = new ClienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        Long enderecoId = (Long) session.getAttribute("enderecoEntregaId");

        // Verificações de segurança
        if (usuario == null || carrinho == null || carrinho.estaVazio() || enderecoId == null) {
            response.sendRedirect(request.getContextPath() + "/checkout/endereco");
            return;
        }

        // Buscar endereço selecionado
        Cliente cliente = clienteDAO.buscarPorUsuarioId(usuario.getId());
        request.setAttribute("cliente", cliente);
        request.setAttribute("carrinho", carrinho);
        request.setAttribute("enderecoSelecionado", cliente.getEnderecos().stream()
                .filter(e -> e.getId().equals(enderecoId))
                .findFirst()
                .orElse(null));

        request.getRequestDispatcher("/WEB-INF/view/checkout/selecionar-pagamento.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formaPagamento = request.getParameter("formaPagamento");
        String numeroCartao = request.getParameter("numeroCartao");
        String nomeCartao = request.getParameter("nomeCartao");
        String validadeCartao = request.getParameter("validadeCartao");
        String cvvCartao = request.getParameter("cvvCartao");
        String parcelas = request.getParameter("parcelas");

        HttpSession session = request.getSession();

        // Validar forma de pagamento
        if (formaPagamento == null || formaPagamento.isEmpty()) {
            request.setAttribute("erro", "Selecione uma forma de pagamento");
            doGet(request, response);
            return;
        }

        // Validar dados do cartão se necessário
        if ("cartao".equals(formaPagamento)) {
            if (numeroCartao == null || numeroCartao.replaceAll("\\s", "").length() != 16) {
                request.setAttribute("erro", "Número do cartão inválido");
                doGet(request, response);
                return;
            }
            // ... outras validações do cartão
        }

        // Salvar dados de pagamento na sessão
        session.setAttribute("formaPagamento", formaPagamento);
        session.setAttribute("detalhesPagamento", criarDetalhesPagamento(
                formaPagamento, numeroCartao, nomeCartao, validadeCartao, cvvCartao, parcelas));

        response.sendRedirect(request.getContextPath() + "/checkout/revisao");
    }

    private String criarDetalhesPagamento(String forma, String numero, String nome,
                                          String validade, String cvv, String parcelas) {
        if ("boleto".equals(forma)) {
            return "Boleto Bancário - Vencimento em 3 dias";
        } else if ("cartao".equals(forma)) {
            return String.format("Cartão %s - %s parcelas - %s",
                    numero != null ? "****" + numero.substring(12) : "",
                    parcelas, nome);
        }
        return forma;
    }
}