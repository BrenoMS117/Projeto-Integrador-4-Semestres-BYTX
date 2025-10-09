package br.com.bytx.controller.carrinho;

import br.com.bytx.model.Usuario;
import br.com.bytx.model.carrinho.Carrinho;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/carrinho/remover")
public class RemoverItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== REMOVENDO ITEM DO CARRINHO ===");

        HttpSession session = request.getSession();
        String produtoIdStr = request.getParameter("produtoId");

        if (produtoIdStr == null || produtoIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/carrinho?erro=Produto não especificado");
            return;
        }

        try {
            Long produtoId = Long.parseLong(produtoIdStr);

            Carrinho carrinho = obterCarrinhoDaSessao(session);
            carrinho.removerItem(produtoId);

            session.setAttribute("carrinho", carrinho);
            session.setAttribute("mensagemSucesso", "Produto removido do carrinho!");

            System.out.println("Produto removido: " + produtoId);
            System.out.println("Total de itens no carrinho: " + carrinho.getQuantidadeTotalItens());

            response.sendRedirect(request.getContextPath() + "/carrinho");

        } catch (NumberFormatException e) {
            System.out.println("Erro ao converter ID do produto: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/carrinho?erro=ID do produto inválido");
        } catch (Exception e) {
            System.out.println("Erro ao remover item do carrinho: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/carrinho?erro=Erro ao remover produto do carrinho");
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