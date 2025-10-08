package br.com.bytx.controller.estoque;

import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.produto.Produto;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/estoque/editar")
public class EditarEstoqueServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ESTOQUISTA EDITANDO ESTOQUE ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        // Verificar se é estoquista
        if (usuario == null || !usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        System.out.println("Estoquista editando estoque do produto ID: " + id);

        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=ID do produto não especificado");
            return;
        }

        try {
            Long produtoId = Long.parseLong(id);
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = produtoDAO.buscarPorId(produtoId);

            if (produto == null) {
                response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=Produto não encontrado");
                return;
            }

            request.setAttribute("produto", produto);
            request.setAttribute("ehEstoquista", true);

            System.out.println("Encaminhando para edição de estoque");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/estoque/editar-estoque.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=ID do produto inválido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=Erro ao carregar produto");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== ESTOQUISTA SALVANDO ESTOQUE ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !usuario.isEstoquista()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String id = request.getParameter("id");
        String quantidadeStr = request.getParameter("quantidadeEstoque");

        System.out.println("Salvando estoque - Produto ID: " + id + ", Quantidade: " + quantidadeStr);

        if (id == null || id.isEmpty() || quantidadeStr == null || quantidadeStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/estoque/produtos?erro=Dados incompletos");
            return;
        }

        try {
            Long produtoId = Long.parseLong(id);
            Integer quantidade = Integer.parseInt(quantidadeStr);

            // Validar quantidade
            if (quantidade < 0) {
                response.sendRedirect(request.getContextPath() + "/estoque/editar?id=" + id + "&erro=Quantidade não pode ser negativa");
                return;
            }

            ProdutoDAO produtoDAO = new ProdutoDAO();

            // Atualizar apenas o estoque
            boolean sucesso = produtoDAO.atualizarEstoque(produtoId, quantidade);

            if (sucesso) {
                System.out.println("Estoque atualizado com sucesso!");
                response.sendRedirect(request.getContextPath() + "/estoque/produtos?mensagem=Estoque atualizado com sucesso");
            } else {
                response.sendRedirect(request.getContextPath() + "/estoque/editar?id=" + id + "&erro=Erro ao atualizar estoque");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/estoque/editar?id=" + id + "&erro=Quantidade inválida");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/estoque/editar?id=" + id + "&erro=Erro ao salvar estoque");
        }
    }
}