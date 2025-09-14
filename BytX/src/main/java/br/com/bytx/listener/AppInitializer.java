package br.com.bytx.listener;

import br.com.bytx.dao.UsuarioDAO;

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

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuarioDAO.criarTabelaUsuario();
        usuarioDAO.criarTabelaGrupos();
        usuarioDAO.inserirDadosIniciais();

        System.out.println("Configuração inicial concluída!");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("Encerrando aplicação BytX...");
    }
}