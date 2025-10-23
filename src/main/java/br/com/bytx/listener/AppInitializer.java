package br.com.bytx.listener;

import br.com.bytx.dao.UsuarioDAO;
import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.model.Usuario;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

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

        usuarioDAO.criarTabelaClientes();
        usuarioDAO.criarTabelaEnderecosClientes();

        criarClienteForcado(usuarioDAO);
        usuarioDAO.inserirDadosIniciais();

        // 2. Tabelas de produtos
        ProdutoDAO produtoDAO = new ProdutoDAO();
        produtoDAO.criarTabelaProdutos();
        produtoDAO.inserirDadosIniciais();

        // 3. Tabelas de imagens
        ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
        imagemDAO.criarTabelaImagensProduto();

        System.out.println("Configuração inicial concluída!");
        System.out.println("=========================================");

    }

    // ⬅️ MÉTODO CORRIGIDO - sem problemas de importação
    private void criarClienteForcado(UsuarioDAO usuarioDAO) {
        try {
            // Primeiro tenta deletar se existir
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
            PreparedStatement ps = connection.prepareStatement("DELETE FROM usuarios WHERE email = 'cliente@bytX.com'");
            ps.execute();
            ps.close();
            connection.close();
            System.out.println("🗑️  Cliente anterior removido (se existia)");
        } catch (Exception e) {
            System.out.println("ℹ️  Nenhum cliente anterior para remover: " + e.getMessage());
        }

        // Agora cria o cliente
        usuarioDAO.criarUsuarioClientePadrao();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("Encerrando aplicação BytX...");
    }
}