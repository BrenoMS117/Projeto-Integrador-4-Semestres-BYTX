package br.com.bytx.controller;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/usuarios")
//Carregamento de todos os usuários salvos no banco
public class ListarUsuariosServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException { //Servlet iniciado
        this.usuarioDAO = new UsuarioDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar se usuário está logado e é ADMIN
        //Repetindo variás vezes essa mesmo método de verificação
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null || !"ADMIN".equals(usuarioLogado.getGrupo())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String mensagemSucesso = request.getParameter("sucesso");
        //redireciona após o cadastro "/admin/usuarios?sucesso=Usuário criado com sucesso".
        if (mensagemSucesso != null) {
            request.setAttribute("mensagemSucesso", mensagemSucesso);
        }

        // Responsável por buscar todos os usuários
        List<Usuario> usuarios = usuarioDAO.listarTodosUsuarios();

        // Filtrar por nome se existir parâmetro
        String filtroNome = request.getParameter("filtroNome");
        if (filtroNome != null && !filtroNome.trim().isEmpty()) {
            usuarios = filtrarPorNome(usuarios, filtroNome);
        }

        // Enviar dados para a JSP
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("filtroNome", filtroNome);
        request.getRequestDispatcher("/WEB-INF/view/admin/listar-usuarios.jsp").forward(request, response);
    }

    //filtro utilizando o JavaSteams
    private List<Usuario> filtrarPorNome(List<Usuario> usuarios, String filtro) {
        return usuarios.stream() //Esse exemplo de filtro é feito na memória, após a busca pelos usuários.
                .filter(u -> u.getNome().toLowerCase().contains(filtro.toLowerCase()))
                .collect(java.util.stream.Collectors.toList());
    }
}