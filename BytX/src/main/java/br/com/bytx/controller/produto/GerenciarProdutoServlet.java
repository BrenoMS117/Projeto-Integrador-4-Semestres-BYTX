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
import java.util.List;
import javax.servlet.http.Part;

@WebServlet("/produto/gerenciar")
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

        System.out.println("=== CARREGANDO PRODUTO PARA EDIÇÃO ===");
        System.out.println("ID: " + id);
        System.out.println("Ação: " + acao);

        try {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = null;

            if (id != null && !id.isEmpty()) {
                produto = produtoDAO.buscarPorId(Long.parseLong(id));
                System.out.println("Produto encontrado: " + (produto != null ? produto.getNome() : "null"));

                // CARREGAR IMAGENS DO PRODUTO
                try {
                    ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
                    List<ImagemProduto> imagens = imagemDAO.buscarPorProdutoId(Long.parseLong(id));
                    System.out.println("Imagens encontradas: " + (imagens != null ? imagens.size() : "null"));
                    request.setAttribute("imagens", imagens);
                } catch (Exception e) {
                    System.out.println("ERRO ao carregar imagens: " + e.getMessage());
                    e.printStackTrace();
                    // Continua mesmo com erro nas imagens
                    request.setAttribute("imagens", new ArrayList<ImagemProduto>());
                }
            }

            request.setAttribute("produto", produto);
            request.setAttribute("acao", acao);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/formulario.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("ERRO GERAL ao carregar produto: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao carregar produto: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String id = request.getParameter("id");
            Produto produto = new Produto();

            // Preencher dados do produto
            produto.setNome(request.getParameter("nome"));
            produto.setDescricao(request.getParameter("descricao"));
            produto.setPreco(new BigDecimal(request.getParameter("preco")));
            produto.setQuantidadeEstoque(Integer.parseInt(request.getParameter("quantidadeEstoque")));

            // Avaliação pode ser null se não foi selecionada
            String avaliacaoStr = request.getParameter("avaliacao");
            if (avaliacaoStr != null && !avaliacaoStr.isEmpty()) {
                produto.setAvaliacao(new BigDecimal(avaliacaoStr));
            } else {
                produto.setAvaliacao(BigDecimal.ZERO);
            }

            ProdutoDAO produtoDAO = new ProdutoDAO();
            boolean sucesso;

            if (id != null && !id.isEmpty()) {
                produto.setId(Long.parseLong(id));
                sucesso = produtoDAO.atualizar(produto);
            } else {
                sucesso = produtoDAO.inserir(produto);
            }

            // SE O PRODUTO FOI SALVO COM SUCESSO, PROCESSAR IMAGENS
            if (sucesso) {
                // Processar upload de imagem se existir
                try {
                    Part filePart = request.getPart("novaImagem");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = extractFileName(filePart);
                        if (fileName != null && !fileName.isEmpty()) {
                            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
                            ImagemProduto imagem = new ImagemProduto();
                            imagem.setProduto(produto);
                            imagem.setNomeArquivo(fileName);
                            imagem.setCaminho("/uploads/produtos");

                            // Verificar se é imagem principal
                            String imagemPrincipal = request.getParameter("imagemPrincipal");
                            imagem.setPrincipal(imagemPrincipal != null && imagemPrincipal.equals("on"));

                            if (imagemDAO.inserir(imagem)) {
                                System.out.println("Imagem salva com sucesso: " + fileName);
                                // saveFile(filePart, imagem.getCaminho(), fileName); // Implementar se necessário
                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Erro no upload de imagem: " + e.getMessage());
                    // Não redireciona por erro de imagem, só loga o erro
                }

                // Redirecionar para LISTA de produtos com mensagem de sucesso
                response.sendRedirect(request.getContextPath() + "/produto/listar?mensagem=Produto salvo com sucesso");

            } else {
                request.setAttribute("erro", "Erro ao salvar produto");
                request.setAttribute("produto", produto);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/formulario.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao salvar produto");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}