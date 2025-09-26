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

            if (id != null && !id.isEmpty()) {
                produto.setId(Long.parseLong(id));
                System.out.println("Atualizando produto existente - ID: " + id);
                sucesso = produtoDAO.atualizar(produto);
            } else {
                System.out.println("Inserindo novo produto");
                sucesso = produtoDAO.inserir(produto);
            }

            System.out.println("Produto salvo: " + sucesso);

            // 🔥 CORREÇÃO PRINCIPAL: Redirecionamento correto
            if (sucesso) {
                String mensagem = (id != null && !id.isEmpty()) ?
                        "Produto atualizado com sucesso!" : "Produto criado com sucesso!";

                // Se for edição, redireciona para a página de edição
                if (id != null && !id.isEmpty()) {
                    String redirectURL = request.getContextPath() + "/produto/gerenciar?id=" +
                            id + "&acao=editar&mensagem=" +
                            java.net.URLEncoder.encode(mensagem, "UTF-8");
                    System.out.println("Redirecionando para: " + redirectURL);
                    response.sendRedirect(redirectURL);
                } else {
                    // Se for novo produto, busca o ID gerado
                    if (produto.getId() != null) {
                        String redirectURL = request.getContextPath() + "/produto/gerenciar?id=" +
                                produto.getId() + "&acao=editar&mensagem=" +
                                java.net.URLEncoder.encode(mensagem, "UTF-8");
                        response.sendRedirect(redirectURL);
                    } else {
                        String redirectURL = request.getContextPath() + "/produto/listar?mensagem=" +
                                java.net.URLEncoder.encode(mensagem, "UTF-8");
                        response.sendRedirect(redirectURL);
                    }
                }
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
}