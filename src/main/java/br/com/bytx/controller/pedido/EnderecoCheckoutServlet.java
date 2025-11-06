package br.com.bytx.controller.pedido;

import br.com.bytx.dao.ClienteDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.carrinho.Carrinho;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout/endereco")
public class EnderecoCheckoutServlet extends HttpServlet {

    private ClienteDAO clienteDAO;

    @Override
    public void init() throws ServletException {
        this.clienteDAO = new ClienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");

        // Verificações de segurança
        if (usuario == null || carrinho == null || carrinho.estaVazio()) {
            response.sendRedirect(request.getContextPath() + "/carrinho");
            return;
        }

        // Buscar cliente com endereços
        Cliente cliente = clienteDAO.buscarPorUsuarioId(usuario.getId());
        if (cliente == null || cliente.getEnderecos().isEmpty()) {
            request.setAttribute("erro", "Cadastre um endereço de entrega para continuar");
        }

        request.setAttribute("cliente", cliente);
        request.setAttribute("carrinho", carrinho);
        request.getRequestDispatcher("/WEB-INF/view/checkout/selecionar-endereco.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enderecoId = request.getParameter("enderecoId");

        if (enderecoId == null || enderecoId.isEmpty()) {
            request.setAttribute("erro", "Selecione um endereço de entrega");
            doGet(request, response);
            return;
        }

        // Salvar endereço selecionado na sessão
        HttpSession session = request.getSession();
        session.setAttribute("enderecoEntregaId", Long.parseLong(enderecoId));

        response.sendRedirect(request.getContextPath() + "/checkout/pagamento");
    }
}