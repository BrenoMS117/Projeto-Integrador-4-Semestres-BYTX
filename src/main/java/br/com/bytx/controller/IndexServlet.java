package br.com.bytx.controller;

import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.model.produto.Produto;
import br.com.bytx.model.produto.ImagemProduto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet({"", "/", "/index"})
public class IndexServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== INDEX SERVLET INICIADO ===");

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();

            // Buscar apenas produtos ATIVOS para a loja
            List<Produto> produtos = produtoDAO.listarAtivos();
            System.out.println("📦 Produtos ativos encontrados: " + produtos.size());

            // Map para armazenar as imagens principais
            Map<Long, ImagemProduto> imagensPrincipais = new HashMap<>();
            int imagensEncontradas = 0;

            for (Produto produto : produtos) {
                ImagemProduto imagemPrincipal = imagemDAO.buscarImagemPrincipal(produto.getId());

                if (imagemPrincipal != null) {
                    imagensPrincipais.put(produto.getId(), imagemPrincipal);
                    imagensEncontradas++;
                    System.out.println("✅ Imagem para " + produto.getNome() + ": " + imagemPrincipal.getNomeArquivo());
                } else {
                    System.out.println("❌ Sem imagem para: " + produto.getNome());
                }
            }

            System.out.println("🎯 Resumo: " + imagensEncontradas + " imagens de " + produtos.size() + " produtos");

            request.setAttribute("produtos", produtos);
            request.setAttribute("imagensPrincipais", imagensPrincipais);

            System.out.println("🚀 Encaminhando para index.jsp");
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ ERRO no IndexServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao carregar produtos");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}