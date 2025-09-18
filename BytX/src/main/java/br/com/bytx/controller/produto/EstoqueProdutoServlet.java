package br.com.bytx.controller.produto;

import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/produto/estoque")
public class EstoqueProdutoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        // Apenas estoquistas podem acessar
        if (usuario == null || !usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        String quantidade = request.getParameter("quantidade");

        if (id != null && quantidade != null) {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            boolean sucesso = produtoDAO.atualizarEstoque(
                    Long.parseLong(id),
                    Integer.parseInt(quantidade)
            );

            if (sucesso) {
                response.sendRedirect(request.getContextPath() + "/produto/listar?mensagem=Estoque atualizado com sucesso");
            } else {
                response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao atualizar estoque");
            }
        }
    }
}