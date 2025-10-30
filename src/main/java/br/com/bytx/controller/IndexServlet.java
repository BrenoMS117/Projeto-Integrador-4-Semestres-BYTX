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
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet({"", "/", "/index"})
public class IndexServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String fullPath = request.getRequestURI();

        // Se a URL for /api/cep/xxxxx, processa como API CEP
        if (fullPath.contains("/api/cep/")) {
            tratarConsultaCEP(request, response);
            return;
        }

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
    private void tratarConsultaCEP(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        System.out.println("🎯 API CEP ACESSADA!");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String fullPath = request.getRequestURI();
            System.out.println("📁 URL completa: " + fullPath);

            // Método MELHORADO para extrair CEP
            String cep = "";

            // Dividir a URL por "/"
            String[] pathParts = fullPath.split("/");

            // Procurar pela parte "cep" e pegar o próximo valor
            for (int i = 0; i < pathParts.length; i++) {
                if ("cep".equals(pathParts[i]) && i + 1 < pathParts.length) {
                    cep = pathParts[i + 1];
                    break;
                }
            }

            // Se não encontrou, tentar método alternativo
            if (cep.isEmpty()) {
                cep = fullPath.substring(fullPath.lastIndexOf("/") + 1);
            }

            System.out.println("🔍 CEP extraído: '" + cep + "'");

            // Limpar CEP (só números)
            cep = cep.replaceAll("[^0-9]", "");
            System.out.println("🔍 CEP limpo: '" + cep + "'");

            if (cep.length() != 8) {
                System.out.println("❌ CEP inválido: " + cep);
                response.getWriter().write("{\"erro\": true, \"mensagem\": \"CEP deve ter 8 dígitos\"}");
                return;
            }

            // Consulta direta na ViaCEP
            String url = "https://viacep.com.br/ws/" + cep + "/json/";
            System.out.println("🌐 Consultando: " + url);

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(java.time.Duration.ofSeconds(10))
                    .build();

            HttpResponse<String> httpResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());

            System.out.println("✅ Resposta recebida: " + httpResponse.statusCode());
            System.out.println("📦 Dados: " + httpResponse.body());
            response.getWriter().write(httpResponse.body());

        } catch (Exception e) {
            System.out.println("❌ ERRO na API CEP: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"erro\": true, \"mensagem\": \"Erro ao consultar CEP\"}");
        }
    }
}