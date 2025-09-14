package br.com.bytx.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class ConexaoH2 {

    private static final String URL = "jdbc:h2:~/test"; // Database que você está usando
    private static final String USER = "sa";
    private static final String PASSWORD = "sa";

    private static Connection conexao;

    static {
        inicializarBanco();
    }

    private static void inicializarBanco() {
        try {
            Class.forName("org.h2.Driver");
            conexao = DriverManager.getConnection(URL, USER, PASSWORD);
            criarTabelas();
            System.out.println("Conexão com H2 estabelecida com sucesso!");
            System.out.println("Database: " + URL);
        } catch (Exception e) {
            System.err.println("Erro ao conectar com H2: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConexao() {
        try {
            if (conexao == null || conexao.isClosed()) {
                conexao = DriverManager.getConnection(URL, USER, PASSWORD);
            }
            return conexao;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao conectar com H2: " + e.getMessage(), e);
        }
    }

    private static void criarTabelas() {
        System.out.println("🛠️ Criando tabelas...");

        try (Statement stmt = conexao.createStatement()) {

            // Tabela de usuários
            stmt.execute("CREATE TABLE IF NOT EXISTS usuarios (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "nome VARCHAR(100) NOT NULL, " +
                    "cpf VARCHAR(11) NOT NULL UNIQUE, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "senha VARCHAR(100) NOT NULL, " +
                    "grupo VARCHAR(20) NOT NULL, " +
                    "ativo BOOLEAN DEFAULT TRUE, " +
                    "data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")");

            // Tabela de grupos
            stmt.execute("CREATE TABLE IF NOT EXISTS grupos (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "nome VARCHAR(20) NOT NULL UNIQUE" +
                    ")");

            // Inserir grupos se não existirem
            stmt.execute("MERGE INTO grupos (id, nome) KEY (nome) VALUES (1, 'ADMIN')");
            stmt.execute("MERGE INTO grupos (id, nome) KEY (nome) VALUES (2, 'ESTOQUISTA')");

            // Inserir usuário admin (senha: admin123)
            stmt.execute("MERGE INTO usuarios (id, nome, cpf, email, senha, grupo, ativo) " +
                    "KEY (email) VALUES (1, 'Administrador', '12345678901', 'admin@bytX.com', " +
                    "'$2a$12$Y9y4WqT7WU6uQ5p5V5z5Nu5V5z5Nu5V5z5Nu5V5z5Nu5V5z5Nu5V5a', 'ADMIN', TRUE)");

            System.out.println("Tabelas criadas/verificadas com sucesso!");
            System.out.println("Usuário admin: admin@bytX.com / senha: admin123");

        } catch (SQLException e) {
            System.err.println("Erro ao criar tabelas: " + e.getMessage());
        }
    }

    public static void fecharConexao() {
        try {
            if (conexao != null && !conexao.isClosed()) {
                conexao.close();
                System.out.println("Conexão fechada com sucesso!");
            }
        } catch (SQLException e) {
            System.err.println("Erro ao fechar conexão: " + e.getMessage());
        }
    }
}