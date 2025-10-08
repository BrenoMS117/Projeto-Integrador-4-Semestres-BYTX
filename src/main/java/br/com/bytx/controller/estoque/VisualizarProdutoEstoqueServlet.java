package br.com.bytx.controller.estoque;

import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.produto.ImagemProduto;
import br.com.bytx.model.produto.Produto;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/estoque/visualizar")
public class VisualizarProdutoEstoqueServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ESTOQUISTA VISUALIZANDO PRODUTO ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        // Verificar se é estoquista
        if (usuario == null || !usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        System.out.println("Estoquista visualizando produto ID: " + id);

        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=ID do produto não especificado");
            return;
        }

        try {
            Long produtoId = Long.parseLong(id);
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = produtoDAO.buscarPorId(produtoId);

            if (produto == null) {
                response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=Produto não encontrado");
                return;
            }

            // Buscar imagens do produto
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            List<ImagemProduto> imagens = imagemDAO.buscarPorProdutoId(produtoId);
            ImagemProduto imagemPrincipal = imagemDAO.buscarImagemPrincipal(produtoId);

            request.setAttribute("produto", produto);
            request.setAttribute("imagens", imagens);
            request.setAttribute("imagemPrincipal", imagemPrincipal);
            request.setAttribute("ehEstoquista", true);

            System.out.println("Encaminhando para visualização do estoquista");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/estoque/visualizar-produto.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=ID do produto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=Erro ao carregar produto");
        }
    }
}