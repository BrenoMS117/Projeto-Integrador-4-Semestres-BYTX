package br.com.bytx.listener;

import br.com.bytx.dao.UsuarioDAO;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
//Inicialização de aplicação (deploy)
public class AppInitializer implements ServletContextListener {

    @Override
    //garantia que ao iniciar o sistema, já haja um usuário cadastrado
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
    //Aplicação removida de deploy
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("Encerrando aplicação BytX...");
    }
}