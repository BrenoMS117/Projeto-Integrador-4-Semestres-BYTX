package br.com.bytx.controller.pedido;

import br.com.bytx.dao.PedidoDAO;
import br.com.bytx.model.pedido.Pedido;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

@WebServlet("/checkout/confirmacao")
public class ConfirmacaoPedidoServlet extends HttpServlet {

    private PedidoDAO pedidoDAO;

    @Override
    public void init() throws ServletException {
        this.pedidoDAO = new PedidoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String numeroPedido = request.getParameter("numero");

        if (numeroPedido == null || numeroPedido.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            // Buscar pedido pelo número
            Pedido pedido = pedidoDAO.buscarPorNumero(numeroPedido);

            if (pedido == null) {
                response.sendRedirect(request.getContextPath() + "/?erro=Pedido não encontrado");
                return;
            }

            System.out.println("✅ Pedido encontrado para confirmação:");
            System.out.println("   Número: " + pedido.getNumeroPedido());
            System.out.println("   Data Criação: " + pedido.getDataCriacao());
            System.out.println("   Status: " + pedido.getStatus());
            System.out.println("   Total: " + pedido.getTotal());

            // ✅ CONVERTER LocalDateTime para Date para o JSP
            if (pedido.getDataCriacao() != null) {
                Date dataCriacao = java.sql.Timestamp.valueOf(pedido.getDataCriacao());
                request.setAttribute("dataCriacaoFormatada", dataCriacao);
            } else {
                request.setAttribute("dataCriacaoFormatada", new Date());
            }

            request.setAttribute("pedido", pedido);
            request.getRequestDispatcher("/WEB-INF/view/checkout/confirmacao-pedido.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erro na confirmação do pedido: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/?erro=Erro ao carregar confirmação");
        }
    }
}