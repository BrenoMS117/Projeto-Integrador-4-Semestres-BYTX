package br.com.bytx.controller.produto;

import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/produto/status")
public class StatusProdutoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Permite acesso via GET também
        processarRequisicao(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processarRequisicao(request, response);
    }

    private void processarRequisicao(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        // Verificar se usuário está logado e é admin
        if (usuario == null || !usuario.isAdministrador()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        String acao = request.getParameter("acao");

        System.out.println("Alterando status - ID: " + id + ", Ação: " + acao);

        if (id != null && acao != null) {
            try {
                ProdutoDAO produtoDAO = new ProdutoDAO();
                boolean sucesso;

                if ("ativar".equals(acao)) {
                    sucesso = produtoDAO.ativar(Long.parseLong(id));
                    System.out.println("Ativando produto ID: " + id + ", Sucesso: " + sucesso);
                } else if ("desativar".equals(acao)) {
                    sucesso = produtoDAO.desativar(Long.parseLong(id));
                    System.out.println("Desativando produto ID: " + id + ", Sucesso: " + sucesso);
                } else {
                    response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Ação inválida");
                    return;
                }

                if (sucesso) {
                    response.sendRedirect(request.getContextPath() + "/produto/listar?mensagem=Status alterado com sucesso");
                } else {
                    response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao alterar status");
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/produto/listar?erro=ID inválido");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao processar solicitação");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Parâmetros inválidos");
        }
    }
}