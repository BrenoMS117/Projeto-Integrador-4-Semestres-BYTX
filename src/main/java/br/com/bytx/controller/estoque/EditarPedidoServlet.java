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

@WebServlet("/estoque/pedidos/editar")
public class EditarPedidoServlet extends HttpServlet {

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

        String pedidoIdStr = request.getParameter("id");

        try {
            Long pedidoId = Long.parseLong(pedidoIdStr);
            Pedido pedido = pedidoDAO.buscarPorId(pedidoId);

            if (pedido == null) {
                request.setAttribute("erro", "Pedido não encontrado");
                response.sendRedirect(request.getContextPath() + "/estoque/pedidos");
                return;
            }

            request.setAttribute("pedido", pedido);
            request.getRequestDispatcher("/WEB-INF/view/estoque/editar-pedido.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "ID do pedido inválido");
            response.sendRedirect(request.getContextPath() + "/estoque/pedidos");
        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar pedido para edição: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao carregar pedido");
            response.sendRedirect(request.getContextPath() + "/estoque/pedidos");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pedidoIdStr = request.getParameter("pedidoId");
        String novoStatus = request.getParameter("status");

        try {
            Long pedidoId = Long.parseLong(pedidoIdStr);

            // Validar status
            if (!isStatusValido(novoStatus)) {
                request.setAttribute("erro", "Status inválido");
                response.sendRedirect(request.getContextPath() + "/estoque/pedidos/editar?id=" + pedidoId);
                return;
            }

            // Atualizar status no banco
            if (pedidoDAO.atualizarStatus(pedidoId, novoStatus)) {
                System.out.println("✅ Status do pedido " + pedidoId + " atualizado para: " + novoStatus);
                request.setAttribute("sucesso", "Status do pedido atualizado com sucesso!");
            } else {
                request.setAttribute("erro", "Erro ao atualizar status do pedido");
            }

            response.sendRedirect(request.getContextPath() + "/estoque/pedidos");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "ID do pedido inválido");
            response.sendRedirect(request.getContextPath() + "/estoque/pedidos");
        } catch (Exception e) {
            System.out.println("❌ Erro ao atualizar status do pedido: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao atualizar status do pedido");
            response.sendRedirect(request.getContextPath() + "/estoque/pedidos");
        }
    }

    private boolean isStatusValido(String status) {
        return status != null && (
                status.equals("aguardando_pagamento") ||
                        status.equals("pagamento_rejeitado") ||
                        status.equals("pagamento_sucesso") ||
                        status.equals("aguardando_retirada") ||
                        status.equals("em_transito") ||
                        status.equals("entregue")
        );
    }
}