package br.com.bytx.listener;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.dao.ImagemProdutoDAO;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Iniciando aplicação BytX");
        System.out.println("=========================================");

        System.out.println("Criando tabelas e inserindo dados");

        // 1. Tabelas de usuários (já existente)
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuarioDAO.criarTabelaUsuario();
        usuarioDAO.criarTabelaGrupos();
        usuarioDAO.inserirDadosIniciais();

        // 2. Tabelas de produtos (NOVO)
        ProdutoDAO produtoDAO = new ProdutoDAO();
        produtoDAO.criarTabelaProdutos();
        produtoDAO.inserirDadosIniciais(); // Insere produtos de exemplo

        // 3. Tabelas de imagens (NOVO)
        ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
        imagemDAO.criarTabelaImagensProduto();

        System.out.println("Configuração inicial concluída!");
        System.out.println("=========================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("Encerrando aplicação BytX...");
    }
}