package br.com.bytx.controller;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//Servlet puro

@WebServlet("/admin/usuarios/alterar-status")
//Permite que os administradores determinem ativo ou inativo de cada usuário.
public class AlterarStatusUsuarioServlet extends HttpServlet {
    //Como há herança é possível permitir que a classe sobrescreva métodos como doGet, doPost.
    //Foco principal dessa classe é Post, pois há alterações de dados do usuário.
    private UsuarioDAO usuarioDAO; //Atributo declarado para acessar o banco de dados de usuários.

    @Override
    public void init() throws ServletException {
        //Criação da instância DAO, garantia para o servlet receber as requisições.
        this.usuarioDAO = new UsuarioDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        /*sobrescrevendo o método Post que trata neste caso as requisições(os dados enviados pelos clientes
         e a permissão de enviar respostas*/

        System.out.println("=== ALTERAR STATUS - INICIANDO ==="); //Depuração

        // Verificar se é ADMIN
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        //Acesso à sessão do usuário logado para verificação
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            System.out.println("ACESSO NEGADO - Não é ADMIN");
            response.sendRedirect(request.getContextPath() + "/login");
            return; //Interromper a execução caso "se não"
        }

        //Requisição de parâmetros do usuário que irão ser alterados
        String email = request.getParameter("email");
        String acao = request.getParameter("acao"); //Ativo ou inativo

        System.out.println("Dados recebidos:");
        System.out.println("Email: " + email);
        System.out.println("Ação: " + acao);

        //Validação da requisição de parâmetros
        if (email != null && acao != null) {
            Usuario usuario = usuarioDAO.buscarUsuarioPorEmail(email);
            //Busca de usuário
            if (usuario != null && !usuario.getEmail().equals(usuarioLogado.getEmail())) {
                boolean novoStatus = "ativar".equals(acao);
                System.out.println("Alterando status para: " + (novoStatus ? "ATIVO" : "INATIVO"));
                //DAO faz as alterações da situação.
                boolean sucesso = usuarioDAO.alterarStatusUsuario(usuario.getId(), novoStatus);
                System.out.println("Resultado: " + sucesso);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }
}