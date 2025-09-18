package br.com.bytx.controller.produto;

import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.produto.Produto;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/produto/listar")
public class ListarProdutosServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            List<Produto> produtos; // AGORA FUNCIONA

            // Verificar se há parâmetro de busca
            String searchTerm = request.getParameter("search");
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                // Fazer busca por nome
                produtos = produtoDAO.buscarPorNome(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm.trim());
            } else {
                // Listar todos ordenados por data
                produtos = produtoDAO.listarTodosOrdenadosPorData();
            }

            request.setAttribute("produtos", produtos);
            request.setAttribute("ehAdmin", usuario.isAdministrador());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/listar.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?erro=Erro ao carregar produtos");
        }
    }
}