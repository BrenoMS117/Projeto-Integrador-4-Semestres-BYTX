package br.com.bytx.controller.estoque;

import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;
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

@WebServlet("/estoque/produtos")
public class ListarProdutosEstoqueServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ACESSO ESTOQUISTA - LISTAR PRODUTOS ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        // Verificar se usuário está logado e é estoquista
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?erro=Acesso negado");
            return;
        }

        try {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            List<Produto> produtos;

            // Buscar produtos (ordenados por data decrescente)
            String searchTerm = request.getParameter("search");
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                produtos = produtoDAO.buscarPorNome(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm.trim());
            } else {
                produtos = produtoDAO.listarTodosOrdenadosPorData();
            }

            request.setAttribute("produtos", produtos);
            request.setAttribute("ehEstoquista", true);

            System.out.println("📦 Produtos carregados: " + produtos.size() + " para estoquista: " + usuario.getNome());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/estoque/listar-produtos.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=Erro ao carregar produtos");
        }
    }
}