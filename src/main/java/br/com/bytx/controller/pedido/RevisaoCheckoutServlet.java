package br.com.bytx.controller.pedido;

import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.dao.EnderecoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.cliente.Endereco;
import br.com.bytx.model.carrinho.Carrinho;
import br.com.bytx.model.pedido.Pedido;
import br.com.bytx.model.pedido.ItemPedido;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/checkout/revisao")
public class RevisaoCheckoutServlet extends HttpServlet {

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
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        Long enderecoId = (Long) session.getAttribute("enderecoEntregaId");
        String formaPagamento = (String) session.getAttribute("formaPagamento");
        String detalhesPagamento = (String) session.getAttribute("detalhesPagamento");

        System.out.println("=== REVISÃO DO PEDIDO ===");
        System.out.println("🛒 Carrinho subtotal: " + (carrinho != null ? carrinho.getSubtotal() : "null"));
        System.out.println("🛒 Carrinho itens: " + (carrinho != null ? carrinho.getItens().size() : "null"));

        if (carrinho != null && !carrinho.getItens().isEmpty()) {
            for (br.com.bytx.model.carrinho.ItemCarrinho item : carrinho.getItens()) {
                System.out.println("   - " + item.getProduto().getNome() +
                        " | Qtd: " + item.getQuantidade() +
                        " | Preço: " + item.getPrecoUnitario() +
                        " | Subtotal: " + item.getSubtotal());
            }
        }

        try {
            // Buscar dados completos
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuario.getId());
            Endereco enderecoEntrega = enderecoDAO.buscarPorId(enderecoId);

            // Criar objeto Pedido para exibição
            Pedido pedidoRevisao = criarPedidoRevisao(carrinho, cliente.getId(), enderecoId, formaPagamento, detalhesPagamento);

            request.setAttribute("cliente", cliente);
            request.setAttribute("pedido", pedidoRevisao);
            request.setAttribute("enderecoEntrega", enderecoEntrega);
            request.setAttribute("carrinho", carrinho);

            request.getRequestDispatcher("/WEB-INF/view/checkout/revisao-pedido.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erro na revisão do pedido: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/checkout/pagamento?erro=Erro ao carregar revisão");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Usuário confirmou o pedido, finalizar compra
        response.sendRedirect(request.getContextPath() + "/checkout/finalizar");
    }

    private Pedido criarPedidoRevisao(Carrinho carrinho, Long clienteId, Long enderecoId,
                                      String formaPagamento, String detalhesPagamento) {
        Pedido pedido = new Pedido();
        pedido.setClienteId(clienteId);
        pedido.setEnderecoEntregaId(enderecoId);
        pedido.setFormaPagamento(formaPagamento);
        pedido.setDetalhesPagamento(detalhesPagamento);

        // ✅ CORREÇÃO: Calcular subtotal baseado nos itens
        BigDecimal subtotal = BigDecimal.ZERO;

        // Converter itens do carrinho para itens do pedido
        for (br.com.bytx.model.carrinho.ItemCarrinho itemCarrinho : carrinho.getItens()) {
            ItemPedido itemPedido = new ItemPedido();
            itemPedido.setProdutoId(itemCarrinho.getProduto().getId());
            itemPedido.setProduto(itemCarrinho.getProduto());
            itemPedido.setQuantidade(itemCarrinho.getQuantidade());

            // ✅ GARANTIR que o preço unitário não seja null
            BigDecimal precoUnitario = itemCarrinho.getPrecoUnitario();
            if (precoUnitario == null) {
                precoUnitario = itemCarrinho.getProduto().getPreco();
                System.out.println("⚠️  Preço unitário null, usando preço do produto: " + precoUnitario);
            }

            itemPedido.setPrecoUnitario(precoUnitario);

            // ✅ CALCULAR subtotal do item
            BigDecimal itemSubtotal = precoUnitario.multiply(new BigDecimal(itemCarrinho.getQuantidade()));
            itemPedido.setSubtotal(itemSubtotal);

            subtotal = subtotal.add(itemSubtotal);
            pedido.getItens().add(itemPedido);

            System.out.println("📦 Item revisão: " + itemCarrinho.getProduto().getNome() +
                    " | Qtd: " + itemPedido.getQuantidade() +
                    " | Preço: " + itemPedido.getPrecoUnitario() +
                    " | Subtotal: " + itemPedido.getSubtotal());
        }

        pedido.setSubtotal(subtotal);
        pedido.setFrete(new BigDecimal("15.00"));
        pedido.calcularTotal();

        System.out.println("✅ Pedido revisão criado:");
        System.out.println("   Subtotal: " + pedido.getSubtotal());
        System.out.println("   Frete: " + pedido.getFrete());
        System.out.println("   Total: " + pedido.getTotal());
        System.out.println("   Itens: " + pedido.getItens().size());

        return pedido;
    }
}