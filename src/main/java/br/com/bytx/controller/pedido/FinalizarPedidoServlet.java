package br.com.bytx.controller.pedido;

import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.dao.PedidoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.carrinho.Carrinho;
import br.com.bytx.model.cliente.Cliente;
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

@WebServlet("/checkout/finalizar")
public class FinalizarPedidoServlet extends HttpServlet {

    private PedidoDAO pedidoDAO;

    @Override
    public void init() throws ServletException {
        this.pedidoDAO = new PedidoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        Long enderecoId = (Long) session.getAttribute("enderecoEntregaId");
        String formaPagamento = (String) session.getAttribute("formaPagamento");
        String detalhesPagamento = (String) session.getAttribute("detalhesPagamento");

        System.out.println("=== FINALIZANDO PEDIDO ===");
        System.out.println("Usuário ID: " + (usuario != null ? usuario.getId() : "null"));
        System.out.println("Usuário Email: " + (usuario != null ? usuario.getEmail() : "null"));
        System.out.println("Carrinho: " + (carrinho != null ? carrinho.getItens().size() + " itens" : "null"));
        System.out.println("Subtotal carrinho: " + (carrinho != null ? carrinho.getSubtotal() : "null"));
        System.out.println("Endereço ID: " + enderecoId);
        System.out.println("Forma pagamento: " + formaPagamento);

        // ✅ VERIFICAR SE CLIENTE EXISTE
        if (usuario != null) {
            ClienteDAO clienteDAO = new ClienteDAO();
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuario.getId());
            System.out.println("Cliente encontrado: " + (cliente != null ? "SIM, ID: " + cliente.getId() : "NÃO"));
        }

        // Verificações finais
        if (usuario == null || carrinho == null || carrinho.estaVazio() ||
                enderecoId == null || formaPagamento == null) {
            System.out.println("❌ Dados incompletos para finalizar pedido");
            response.sendRedirect(request.getContextPath() + "/carrinho");
            return;
        }

        try {
            // Criar pedido final
            Pedido pedido = criarPedidoFinal(carrinho, usuario.getId(), enderecoId, formaPagamento, detalhesPagamento);
            // Salvar no banco
            System.out.println("💾 Salvando pedido no banco...");
            boolean sucesso = pedidoDAO.salvarPedido(pedido);

            if (sucesso) {
                System.out.println("✅ Pedido salvo com sucesso: " + pedido.getNumeroPedido());

                // Limpar sessão do checkout
                session.removeAttribute("enderecoEntregaId");
                session.removeAttribute("formaPagamento");
                session.removeAttribute("detalhesPagamento");

                // Limpar carrinho
                carrinho.limpar();
                session.setAttribute("carrinho", carrinho);

                // Redirecionar para confirmação
                response.sendRedirect(request.getContextPath() + "/checkout/confirmacao?numero=" + pedido.getNumeroPedido());
            } else {
                System.out.println("❌ Erro ao salvar pedido no banco");
                response.sendRedirect(request.getContextPath() + "/checkout/revisao?erro=Erro ao processar pedido");
            }

        } catch (Exception e) {
            System.out.println("❌ Erro ao finalizar pedido: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/checkout/revisao?erro=Erro ao processar pedido: " + e.getMessage());
        }
    }

    // NO FinalizarPedidoServlet, substitua o método criarPedidoFinal por:

    private Pedido criarPedidoFinal(Carrinho carrinho, Long usuarioId, Long enderecoId,
                                    String formaPagamento, String detalhesPagamento) {

        // ✅ PRIMEIRO: Buscar o ID do cliente baseado no ID do usuário
        ClienteDAO clienteDAO = new ClienteDAO();
        Cliente cliente = clienteDAO.buscarPorUsuarioId(usuarioId);

        if (cliente == null) {
            throw new RuntimeException("Cliente não encontrado para o usuário ID: " + usuarioId);
        }

        Pedido pedido = new Pedido();
        pedido.setClienteId(cliente.getId()); // ✅ Usar ID do CLIENTE, não do USUÁRIO
        pedido.setEnderecoEntregaId(enderecoId);
        pedido.setFormaPagamento(formaPagamento);
        pedido.setDetalhesPagamento(detalhesPagamento);

        // ✅ CORREÇÃO: Calcular subtotal baseado nos itens reais
        BigDecimal subtotal = BigDecimal.ZERO;

        // Converter itens do carrinho para itens do pedido
        for (br.com.bytx.model.carrinho.ItemCarrinho itemCarrinho : carrinho.getItens()) {
            ItemPedido itemPedido = new ItemPedido();
            itemPedido.setProdutoId(itemCarrinho.getProduto().getId());
            itemPedido.setQuantidade(itemCarrinho.getQuantidade());

            // ✅ GARANTIR que o preço unitário não seja null
            BigDecimal precoUnitario = itemCarrinho.getPrecoUnitario();
            if (precoUnitario == null) {
                precoUnitario = itemCarrinho.getProduto().getPreco(); // Usar preço do produto
                System.out.println("⚠️  Preço unitário null, usando preço do produto: " + precoUnitario);
            }

            itemPedido.setPrecoUnitario(precoUnitario);
            itemPedido.calcularSubtotal();

            subtotal = subtotal.add(itemPedido.getSubtotal());
            pedido.getItens().add(itemPedido);

            System.out.println("   Item: " + itemCarrinho.getProduto().getNome() +
                    " | Qtd: " + itemPedido.getQuantidade() +
                    " | Preço: " + itemPedido.getPrecoUnitario() +
                    " | Subtotal: " + itemPedido.getSubtotal());
        }

        pedido.setSubtotal(subtotal);
        pedido.setFrete(new BigDecimal("15.00"));
        pedido.calcularTotal();

        System.out.println("✅ Pedido final criado:");
        System.out.println("   Cliente ID: " + pedido.getClienteId());
        System.out.println("   Subtotal: " + pedido.getSubtotal());
        System.out.println("   Frete: " + pedido.getFrete());
        System.out.println("   Total: " + pedido.getTotal());
        System.out.println("   Itens: " + pedido.getItens().size());

        return pedido;
    }
}