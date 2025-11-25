package br.com.bytx.controller.estoque;

import br.com.bytx.dao.PedidoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.pedido.Pedido;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/estoque/pedidos")
public class ListaPedidosEstoqueServlet extends HttpServlet {

    private PedidoDAO pedidoDAO;

    @Override
    public void init() throws ServletException {
        this.pedidoDAO = new PedidoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Buscar todos os pedidos ordenados por data (mais recentes primeiro)
            List<Pedido> pedidos = pedidoDAO.listarTodos();

            request.setAttribute("pedidos", pedidos);
            request.getRequestDispatcher("/WEB-INF/view/estoque/lista-pedidos.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar pedidos: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao carregar lista de pedidos");
            request.getRequestDispatcher("/WEB-INF/view/estoque/lista-pedidos.jsp").forward(request, response);
        }
    }
}