package br.com.bytx.controller.pedido;

import br.com.bytx.dao.PedidoDAO;
import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.pedido.Pedido;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout/meus-pedidos")
public class MeusPedidosServlet extends HttpServlet {

    private PedidoDAO pedidoDAO;
    private ClienteDAO clienteDAO;

    @Override
    public void init() throws ServletException {
        this.pedidoDAO = new PedidoDAO();
        this.clienteDAO = new ClienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🎯 MEUS PEDIDOS SERVLET CHAMADO!");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=pedidos/meus-pedidos");
            return;
        }

        try {
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuario.getId());

            if (cliente == null) {
                response.sendRedirect(request.getContextPath() + "/login?erro=Cliente não encontrado");
                return;
            }

            List<Pedido> pedidos = pedidoDAO.listarPorClienteId(cliente.getId());

            System.out.println("✅ " + pedidos.size() + " pedidos encontrados");

            request.setAttribute("cliente", cliente);
            request.setAttribute("pedidos", pedidos);

            System.out.println("📊 Dados para a JSP:");
            System.out.println("   Cliente: " + (cliente != null ? cliente.getId() : "null"));
            System.out.println("   Pedidos: " + (pedidos != null ? pedidos.size() : "null"));
            if (pedidos != null && !pedidos.isEmpty()) {
                for (Pedido p : pedidos) {
                    System.out.println("   - Pedido: " + p.getNumeroPedido() + " | Total: " + p.getTotal());
                }
            }

            // ✅✅✅ CORREÇÃO: Mude para checkout/meus-pedidos.jsp
            System.out.println("📁 Encaminhando para: /WEB-INF/view/checkout/meus-pedidos.jsp");
            request.getRequestDispatcher("/WEB-INF/view/checkout/meus-pedidos.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("💥 ERRO: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/?erro=Erro ao carregar pedidos");
        }
    }
}