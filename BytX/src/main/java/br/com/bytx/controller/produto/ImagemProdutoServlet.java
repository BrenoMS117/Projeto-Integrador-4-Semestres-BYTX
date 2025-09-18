package br.com.bytx.controller.produto;

import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.produto.ImagemProduto;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/produto/imagens")
public class ImagemProdutoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Listar imagens do produto
        String produtoId = request.getParameter("id");

        if (produtoId != null) {
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            request.setAttribute("imagens", imagemDAO.buscarPorProdutoId(Long.parseLong(produtoId)));
            request.setAttribute("produtoId", produtoId);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/gerenciar-imagens.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !usuario.isAdministrador()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String acao = request.getParameter("acao");
        String produtoId = request.getParameter("produtoId");

        try {
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();

            if ("setPrincipal".equals(acao)) {
                String imagemId = request.getParameter("imagemId");
                boolean sucesso = imagemDAO.definirComoPrincipal(
                        Long.parseLong(imagemId),
                        Long.parseLong(produtoId)
                );

                if (sucesso) {
                    response.sendRedirect(request.getContextPath() + "/produto/imagens?id=" + produtoId + "&mensagem=Imagem principal definida");
                } else {
                    response.sendRedirect(request.getContextPath() + "/produto/imagens?id=" + produtoId + "&erro=Erro ao definir imagem principal");
                }

            } else if ("remover".equals(acao)) {
                String imagemId = request.getParameter("imagemId");
                boolean sucesso = imagemDAO.remover(Long.parseLong(imagemId));

                if (sucesso) {
                    response.sendRedirect(request.getContextPath() + "/produto/imagens?id=" + produtoId + "&mensagem=Imagem removida");
                } else {
                    response.sendRedirect(request.getContextPath() + "/produto/imagens?id=" + produtoId + "&erro=Erro ao remover imagem");
                }

            } else {
                // Lógica de upload de imagem (implementar depois)
                response.sendRedirect(request.getContextPath() + "/produto/imagens?id=" + produtoId + "&erro=Funcionalidade em desenvolvimento");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/imagens?id=" + produtoId + "&erro=Erro ao processar solicitação");
        }
    }
}