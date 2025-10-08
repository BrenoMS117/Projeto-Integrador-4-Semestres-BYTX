package br.com.bytx.controller.produto;

import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.produto.ImagemProduto;
import br.com.bytx.model.produto.Produto;
import br.com.bytx.model.Usuario;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Arrays;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/produto/gerenciar")
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 5,      // 5 MB
        maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class GerenciarProdutoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        String acao = request.getParameter("acao");

        System.out.println("Ação: " + acao + ", ID: " + id);

        // Se for visualização, redirecionar para o servlet de visualização
        if ("visualizar".equals(acao)) {
            response.sendRedirect(request.getContextPath() + "/produto/visualizar?id=" + id);
            return;
        }

        // Resto do código permanece para edição/novo
        try {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = null;

            if (id != null && !id.isEmpty()) {
                produto = produtoDAO.buscarPorId(Long.parseLong(id));
                System.out.println("Produto encontrado: " + (produto != null ? produto.getNome() : "null"));

                ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
                List<ImagemProduto> imagens = imagemDAO.buscarPorProdutoId(Long.parseLong(id));
                request.setAttribute("imagens", imagens);
            } else {
                request.setAttribute("imagens", new ArrayList<ImagemProduto>());
            }

            request.setAttribute("produto", produto);
            request.setAttribute("acao", acao);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/formulario.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("ERRO GERAL ao carregar produto: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao carregar produto");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CONFIGURAR ENCODING
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        System.out.println("=== SALVANDO PRODUTO ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // DEBUG: Mostrar parâmetros
        System.out.println("Parâmetros recebidos:");
        java.util.Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String paramName = params.nextElement();
            System.out.println(paramName + ": " + request.getParameter(paramName));
        }

        try {
            String id = request.getParameter("id");
            System.out.println("ID do produto: " + id);

            // VALIDAÇÃO DO NOME
            String nome = request.getParameter("nome");
            if (nome == null || nome.trim().isEmpty()) {
                String erroMsg = "Nome do produto é obrigatório";
                String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                        java.net.URLEncoder.encode(erroMsg, "UTF-8");
                response.sendRedirect(redirectURL);
                return;
            }

            Produto produto = new Produto();
            produto.setNome(nome.trim());
            produto.setDescricao(request.getParameter("descricao"));
            produto.setAtivo(true);

            // PREÇO
            String precoStr = request.getParameter("preco");
            if (precoStr != null && !precoStr.trim().isEmpty()) {
                try {
                    String precoFormatado = precoStr.replace(",", ".");
                    produto.setPreco(new BigDecimal(precoFormatado));
                } catch (NumberFormatException e) {
                    String erroMsg = "Preço inválido";
                    String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                            java.net.URLEncoder.encode(erroMsg, "UTF-8");
                    response.sendRedirect(redirectURL);
                    return;
                }
            } else {
                String erroMsg = "Preço é obrigatório";
                String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                        java.net.URLEncoder.encode(erroMsg, "UTF-8");
                response.sendRedirect(redirectURL);
                return;
            }

            // ESTOQUE
            String estoqueStr = request.getParameter("quantidadeEstoque");
            if (estoqueStr != null && !estoqueStr.trim().isEmpty()) {
                try {
                    produto.setQuantidadeEstoque(Integer.parseInt(estoqueStr.trim()));
                } catch (NumberFormatException e) {
                    String erroMsg = "Estoque inválido";
                    String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                            java.net.URLEncoder.encode(erroMsg, "UTF-8");
                    response.sendRedirect(redirectURL);
                    return;
                }
            } else {
                String erroMsg = "Estoque é obrigatório";
                String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                        java.net.URLEncoder.encode(erroMsg, "UTF-8");
                response.sendRedirect(redirectURL);
                return;
            }

            // AVALIAÇÃO
            String avaliacaoStr = request.getParameter("avaliacao");
            if (avaliacaoStr != null && !avaliacaoStr.trim().isEmpty()) {
                try {
                    String avaliacaoFormatada = avaliacaoStr.replace(",", ".");
                    produto.setAvaliacao(new BigDecimal(avaliacaoFormatada));
                } catch (NumberFormatException e) {
                    produto.setAvaliacao(BigDecimal.ZERO);
                }
            } else {
                produto.setAvaliacao(BigDecimal.ZERO);
            }

            ProdutoDAO produtoDAO = new ProdutoDAO();
            boolean sucesso;
            Long produtoIdSalvo = null;

            if (id != null && !id.isEmpty()) {
                produto.setId(Long.parseLong(id));
                System.out.println("Atualizando produto existente - ID: " + id);
                sucesso = produtoDAO.atualizar(produto);
                produtoIdSalvo = produto.getId();
            } else {
                System.out.println("Inserindo novo produto");
                sucesso = produtoDAO.inserir(produto);
                if (sucesso) {
                    // Buscar o ID do produto recém-criado
                    produtoIdSalvo = produtoDAO.obterUltimoIdInserido();
                    System.out.println("Novo produto criado com ID: " + produtoIdSalvo);
                }
            }

            System.out.println("Produto salvo: " + sucesso);

            if (sucesso) {
                // PROCESSAR UPLOAD DE IMAGENS PARA NOVO PRODUTO
                if (produtoIdSalvo != null) {
                    processarUploadImagens(request, produtoIdSalvo);
                }

                String mensagem = (id != null && !id.isEmpty()) ?
                        "Produto atualizado com sucesso!" : "Produto criado com sucesso!";

                String redirectURL = request.getContextPath() + "/produto/gerenciar?id=" +
                        produtoIdSalvo + "&acao=editar&mensagem=" +
                        java.net.URLEncoder.encode(mensagem, "UTF-8");
                response.sendRedirect(redirectURL);

            } else {
                String erroMsg = "Erro ao salvar produto no banco de dados";
                if (id != null && !id.isEmpty()) {
                    String redirectURL = request.getContextPath() + "/produto/gerenciar?id=" +
                            id + "&acao=editar&erro=" +
                            java.net.URLEncoder.encode(erroMsg, "UTF-8");
                    response.sendRedirect(redirectURL);
                } else {
                    String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                            java.net.URLEncoder.encode(erroMsg, "UTF-8");
                    response.sendRedirect(redirectURL);
                }
            }

        } catch (Exception e) {
            System.out.println("ERRO GERAL no salvamento: " + e.getMessage());
            e.printStackTrace();
            String erroMsg = "Erro ao salvar produto: " + e.getMessage();
            String redirectURL = request.getContextPath() + "/produto/listar?erro=" +
                    java.net.URLEncoder.encode(erroMsg, "UTF-8");
            response.sendRedirect(redirectURL);
        }
    }

    private void processarUploadImagens(HttpServletRequest request, Long produtoId) {
        try {
            // Verificar se há imagens para upload
            Collection<Part> parts = request.getParts();
            int imageIndex = 0;
            boolean primeiraComoPrincipal = "on".equals(request.getParameter("imagemPrincipalIndex"));

            for (Part part : parts) {
                if (part.getName() != null && part.getName().equals("imagens") && part.getSize() > 0) {
                    // Processar cada imagem
                    processarUmaImagem(part, produtoId, imageIndex, primeiraComoPrincipal);
                    imageIndex++;
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao processar upload de imagens: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void processarUmaImagem(Part filePart, Long produtoId, int index, boolean primeiraComoPrincipal) {
        try {
            String fileName = getFileName(filePart);
            if (fileName == null || fileName.isEmpty()) {
                System.out.println("Nome do arquivo vazio para imagem " + index);
                return;
            }

            System.out.println("Processando imagem " + index + ": " + fileName);

            // Validar extensão
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp").contains(fileExtension)) {
                System.out.println("Extensão inválida: " + fileExtension);
                return;
            }

            // Criar diretório
            String uploadPath = getServletContext().getRealPath("/uploads/imagens");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
                System.out.println("Diretório criado: " + uploadPath);
            }

            // Gerar nome único
            String uniqueFileName = System.currentTimeMillis() + "_" + index + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Salvar arquivo
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Arquivo salvo em: " + filePath);
            }

            // Salvar no banco
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = produtoDAO.buscarPorId(produtoId);

            if (produto == null) {
                System.out.println("Produto não encontrado para ID: " + produtoId);
                return;
            }

            boolean isPrincipal = (primeiraComoPrincipal && index == 0);

            if (isPrincipal) {
                imagemDAO.removerPrincipalDoProduto(produtoId);
            }

            ImagemProduto novaImagem = new ImagemProduto();
            novaImagem.setProduto(produto);
            novaImagem.setNomeArquivo(uniqueFileName);
            novaImagem.setCaminho("/uploads/imagens");
            novaImagem.setPrincipal(isPrincipal);

            boolean imagemSalva = imagemDAO.inserir(novaImagem);
            System.out.println("Imagem " + index + " salva no banco: " + imagemSalva + " para produto " + produtoId);

        } catch (Exception e) {
            System.out.println("Erro ao processar imagem " + index + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Método auxiliar para obter nome do arquivo
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                token = token.trim();
                if (token.startsWith("filename")) {
                    String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                    if (fileName.contains("\\")) {
                        fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
                    } else if (fileName.contains("/")) {
                        fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
                    }
                    return fileName;
                }
            }
        }
        return null;
    }
}