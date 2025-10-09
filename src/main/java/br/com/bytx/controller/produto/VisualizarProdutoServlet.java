package br.com.bytx.controller.produto;

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

@WebServlet("/produto/visualizar")  // ⬅️ MANTÉM a URL original
public class VisualizarProdutoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== INICIANDO VISUALIZAÇÃO DE PRODUTO ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        // ⬅️ REMOVER a verificação obrigatória de login
        // Deixa acessível para todos

        String id = request.getParameter("id");
        System.out.println("📋 ID recebido: " + id);

        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/?erro=ID do produto não especificado");
            return;
        }

        try {
            Long produtoId = Long.parseLong(id);
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = produtoDAO.buscarPorId(produtoId);

            System.out.println("🔍 Resultado da busca: " + produto);

            // ⬅️ Verificar se produto existe E está ativo (para usuários normais)
            if (produto == null || (!produto.isAtivo() && (usuario == null || !usuario.isAdministrador()))) {
                System.out.println("❌ Produto não encontrado ou inativo: " + produtoId);
                response.sendRedirect(request.getContextPath() + "/?erro=Produto não encontrado");
                return;
            }

            System.out.println("✅ Produto encontrado: " + produto.getNome());

            // Buscar imagens do produto
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            List<ImagemProduto> imagens = imagemDAO.buscarPorProdutoId(produtoId);
            System.out.println("🖼️ Imagens encontradas: " + (imagens != null ? imagens.size() : "null"));

            request.setAttribute("produto", produto);
            request.setAttribute("imagens", imagens);

            // ⬅️ Manter informação se é admin para a página adaptável
            if (usuario != null) {
                request.setAttribute("ehAdmin", usuario.isAdministrador());
            }

            System.out.println("✅ Encaminhando para visualizar.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/visualizar.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erro: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/?erro=Erro ao carregar produto");
        }
    }
}