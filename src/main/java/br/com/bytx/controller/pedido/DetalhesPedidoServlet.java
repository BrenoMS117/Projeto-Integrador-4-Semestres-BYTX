package br.com.bytx.controller.pedido;

import br.com.bytx.dao.PedidoDAO;
import br.com.bytx.dao.EnderecoDAO;
import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.cliente.Endereco;
import br.com.bytx.model.pedido.Pedido;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/pedidos/detalhes")
public class DetalhesPedidoServlet extends HttpServlet {

    private PedidoDAO pedidoDAO;
    private EnderecoDAO enderecoDAO;
    private ClienteDAO clienteDAO;

    @Override
    public void init() throws ServletException {
        this.pedidoDAO = new PedidoDAO();
        this.enderecoDAO = new EnderecoDAO();
        this.clienteDAO = new ClienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String numeroPedido = request.getParameter("numero");

        try {
            // Buscar pedido pelo número
            Pedido pedido = pedidoDAO.buscarPorNumero(numeroPedido);

            if (pedido == null) {
                request.setAttribute("erro", "Pedido não encontrado");
                // ✅ CORREÇÃO: Caminho correto
                request.getRequestDispatcher("/WEB-INF/view/checkout/detalhes-pedido.jsp").forward(request, response);
                return;
            }

            // Verificar se o pedido pertence ao usuário logado
            Cliente cliente = clienteDAO.buscarPorUsuarioId(usuario.getId());
            if (!pedido.getClienteId().equals(cliente.getId())) {
                request.setAttribute("erro", "Acesso não autorizado");
                // ✅ CORREÇÃO: Caminho correto
                request.getRequestDispatcher("/WEB-INF/view/checkout/detalhes-pedido.jsp").forward(request, response);
                return;
            }

            // Buscar endereço de entrega
            Endereco enderecoEntrega = enderecoDAO.buscarPorId(pedido.getEnderecoEntregaId());

            request.setAttribute("pedido", pedido);
            request.setAttribute("enderecoEntrega", enderecoEntrega);

            // ✅ CORREÇÃO: Caminho correto - checkout/detalhes-pedido.jsp
            System.out.println("📁 Encaminhando para: /WEB-INF/view/checkout/detalhes-pedido.jsp");
            request.getRequestDispatcher("/WEB-INF/view/checkout/detalhes-pedido.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar detalhes do pedido: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao carregar detalhes do pedido");
            // ✅ CORREÇÃO: Caminho correto
            request.getRequestDispatcher("/WEB-INF/view/checkout/detalhes-pedido.jsp").forward(request, response);
        }
    }
}