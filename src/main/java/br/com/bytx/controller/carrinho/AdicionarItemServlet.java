package br.com.bytx.controller.carrinho;

import br.com.bytx.model.Usuario;
import br.com.bytx.model.carrinho.Carrinho;
import br.com.bytx.model.carrinho.ItemCarrinho;
import br.com.bytx.model.produto.Produto;
import br.com.bytx.dao.ProdutoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/carrinho/adicionar")
public class AdicionarItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ADICIONANDO ITEM AO CARRINHO ===");

        HttpSession session = request.getSession();

        // Obter parâmetros
        String produtoIdStr = request.getParameter("produtoId");
        String quantidadeStr = request.getParameter("quantidade");
        String redirect = request.getParameter("redirect"); // "carrinho" ou "continuar"

        if (produtoIdStr == null || produtoIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Produto não especificado");
            return;
        }

        try {
            Long produtoId = Long.parseLong(produtoIdStr);
            int quantidade = quantidadeStr != null ? Integer.parseInt(quantidadeStr) : 1;

            // Buscar produto
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = produtoDAO.buscarPorId(produtoId);

            if (produto == null) {
                response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Produto não encontrado");
                return;
            }

            if (!produto.isAtivo() || produto.getQuantidadeEstoque() <= 0) {
                response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Produto indisponível");
                return;
            }

            // Obter carrinho da sessão
            Carrinho carrinho = obterCarrinhoDaSessao(session);

            // Criar e adicionar item
            ItemCarrinho item = new ItemCarrinho(produto, quantidade);
            carrinho.adicionarItem(item);

            // Atualizar sessão
            session.setAttribute("carrinho", carrinho);
            session.setAttribute("mensagemSucesso", "Produto adicionado ao carrinho!");

            System.out.println("Produto adicionado: " + produto.getNome() + " - Quantidade: " + quantidade);
            System.out.println("Total de itens no carrinho: " + carrinho.getQuantidadeTotalItens());

            // Redirecionar conforme parâmetro
            if ("carrinho".equals(redirect)) {
                response.sendRedirect(request.getContextPath() + "/carrinho");
            } else {
                // "continuar" ou padrão - voltar para página anterior
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(request.getContextPath() + "/produto/listar");
                }
            }

        } catch (NumberFormatException e) {
            System.out.println("Erro ao converter ID do produto: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=ID do produto inválido");
        } catch (Exception e) {
            System.out.println("Erro ao adicionar item ao carrinho: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Erro ao adicionar produto ao carrinho");
        }
    }

    private Carrinho obterCarrinhoDaSessao(HttpSession session) {
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new Carrinho();
            if (session.getAttribute("usuarioLogado") != null) {
                Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
                carrinho.setUsuarioId(usuario.getId());
            } else {
                carrinho.setSessionId(session.getId());
            }
            session.setAttribute("carrinho", carrinho);
        }
        return carrinho;
    }
}