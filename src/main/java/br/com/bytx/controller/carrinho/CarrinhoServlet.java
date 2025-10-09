package br.com.bytx.controller.carrinho;

import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.carrinho.Carrinho;
import br.com.bytx.model.carrinho.ItemCarrinho;
import br.com.bytx.model.produto.ImagemProduto;
import br.com.bytx.model.produto.Produto;
import br.com.bytx.dao.CarrinhoDAO;
import br.com.bytx.dao.ProdutoDAO;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/carrinho")
public class CarrinhoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ACESSANDO PÁGINA DO CARRINHO ===");

        HttpSession session = request.getSession();
        Carrinho carrinho = obterCarrinhoDaSessao(session);

        System.out.println("📦 Carrinho tem " + (carrinho != null ? carrinho.getItens().size() : 0) + " itens");

        // ⬅️ CARREGAR IMAGENS DOS PRODUTOS NO CARRINHO
        if (carrinho != null && !carrinho.estaVazio()) {
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            for (ItemCarrinho item : carrinho.getItens()) {
                if (item.getProduto() != null) {
                    System.out.println("🔍 Buscando imagem para produto: " + item.getProduto().getId() + " - " + item.getProduto().getNome());

                    // Buscar imagem principal do produto
                    ImagemProduto imagemPrincipal = imagemDAO.buscarImagemPrincipal(item.getProduto().getId());

                    if (imagemPrincipal != null) {
                        System.out.println("✅ Imagem encontrada: " + imagemPrincipal.getNomeArquivo());
                        item.getProduto().setImagemPrincipal(imagemPrincipal);
                    } else {
                        System.out.println("❌ Nenhuma imagem encontrada para o produto " + item.getProduto().getId());
                    }
                }
            }
        }

        request.setAttribute("carrinho", carrinho);
        request.setAttribute("frete", calcularFrete(carrinho));

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/carrinho/carrinho.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");
        System.out.println("Ação no carrinho: " + acao);

        if ("atualizar".equals(acao)) {
            atualizarQuantidades(request, response);
        } else if ("limpar".equals(acao)) {
            limparCarrinho(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/carrinho");
        }
    }

    private void atualizarQuantidades(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        Carrinho carrinho = obterCarrinhoDaSessao(session);

        // Processar todos os parâmetros de quantidade
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("quantidade_")) {
                Long produtoId = Long.parseLong(paramName.substring("quantidade_".length()));
                int novaQuantidade = Integer.parseInt(request.getParameter(paramName));

                carrinho.atualizarQuantidade(produtoId, novaQuantidade);
                System.out.println("Atualizado produto " + produtoId + " para quantidade: " + novaQuantidade);
            }
        }

        session.setAttribute("carrinho", carrinho);
        response.sendRedirect(request.getContextPath() + "/carrinho");
    }

    private void limparCarrinho(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        Carrinho carrinho = obterCarrinhoDaSessao(session);
        carrinho.limpar();

        session.setAttribute("carrinho", carrinho);
        response.sendRedirect(request.getContextPath() + "/carrinho");
    }

    // Método auxiliar para obter carrinho da sessão
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

    // Cálculo de frete fictício (3 opções)
    private BigDecimal calcularFrete(Carrinho carrinho) {
        if (carrinho.estaVazio()) {
            return BigDecimal.ZERO;
        }

        // Frete baseado na quantidade de itens
        int quantidadeItens = carrinho.getQuantidadeTotalItens();
        BigDecimal freteBase = new BigDecimal("15.00"); // Frete econômico

        if (quantidadeItens > 5) {
            freteBase = freteBase.add(new BigDecimal("5.00")); // +R$5 para mais de 5 itens
        }

        return freteBase;
    }
}