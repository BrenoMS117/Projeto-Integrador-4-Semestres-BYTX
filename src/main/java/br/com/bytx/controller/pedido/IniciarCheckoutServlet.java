package br.com.bytx.controller.pedido;

import br.com.bytx.model.Usuario;
import br.com.bytx.model.carrinho.Carrinho;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout/iniciar")
public class IniciarCheckoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");

        System.out.println("=== INICIANDO CHECKOUT ===");
        System.out.println("Usuário: " + (usuario != null ? usuario.getEmail() : "null"));
        System.out.println("Carrinho: " + (carrinho != null ? carrinho.getItens().size() + " itens" : "null"));

        // Verificar se carrinho está vazio
        if (carrinho == null || carrinho.estaVazio()) {
            System.out.println("❌ Carrinho vazio - redirecionando");
            response.sendRedirect(request.getContextPath() + "/carrinho?erro=Carrinho vazio");
            return;
        }

        // Se usuário não está logado, redirecionar para login
        if (usuario == null) {
            System.out.println("❌ Usuário não logado - redirecionando para login");
            session.setAttribute("redirectAfterLogin", "/checkout/iniciar");
            response.sendRedirect(request.getContextPath() + "/login?erro=Faça login para finalizar compra");
            return;
        }

        System.out.println("✅ Usuário logado - prosseguindo para endereço");

        // Usuário logado, prosseguir para seleção de endereço
        response.sendRedirect(request.getContextPath() + "/checkout/endereco");
    }
}