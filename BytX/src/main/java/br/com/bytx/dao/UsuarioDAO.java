package br.com.bytx.dao;

import br.com.bytx.model.Usuario;
import br.com.bytx.util.CriptografiaUtil;
import br.com.bytx.util.ValidadorCPF;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

//Centralizar toda a comunicação com o banco de dados
public class UsuarioDAO {

    //Iniciando conexão com o banco de dados
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }
    //Criação de tabelas
    public void criarTabelaUsuario() {
        String SQL = "CREATE TABLE IF NOT EXISTS usuarios (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "nome VARCHAR(100) NOT NULL, " +
                "cpf VARCHAR(11) NOT NULL, " +
                "email VARCHAR(100) NOT NULL, " +
                "senha VARCHAR(100) NOT NULL, " +
                "grupo VARCHAR(20) NOT NULL, " +
                "ativo BOOLEAN DEFAULT TRUE, " +
                "data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.execute();
            System.out.println("Tabela 'usuarios' criada com sucesso!");
        } catch (Exception e) {
            System.out.println("Erro ao criar tabela 'usuarios': " + e.getMessage());
        }
    }

    public void criarTabelaGrupos() {
        String SQL = "CREATE TABLE IF NOT EXISTS grupos (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "nome VARCHAR(20) NOT NULL UNIQUE" +
                ")";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.execute();
            System.out.println("Tabela 'grupos' criada com sucesso!");
        } catch (Exception e) {
            System.out.println("Erro ao criar tabela 'grupos': " + e.getMessage());
        }
    }

    public void inserirDadosIniciais() {
        // GERAR HASH BCrypt VÁLIDO
        String hashAdmin = CriptografiaUtil.criptografarSenha("admin123");
        System.out.println("Hash admin gerado: " + hashAdmin);

        // Inserir grupos
        String SQLGrupos = "MERGE INTO grupos (id, nome) KEY (nome) VALUES (1, 'ADMIN'), (2, 'ESTOQUISTA')";

        // Inserir usuário admin com hash VÁLIDO
        String SQLAdmin = "MERGE INTO usuarios (id, nome, cpf, email, senha, grupo, ativo) " +
                "KEY (email) VALUES (1, 'Administrador', '12345678901', 'admin@bytX.com', " +
                "'" + hashAdmin + "', 'ADMIN', TRUE)";

        try (Connection connection = getConnection();
             PreparedStatement psGrupos = connection.prepareStatement(SQLGrupos);
             PreparedStatement psAdmin = connection.prepareStatement(SQLAdmin)) {

            psGrupos.execute();
            System.out.println("Grupos inseridos com sucesso!");

            psAdmin.execute();
            System.out.println("Usuário admin inserido com sucesso!");
            System.out.println("Admin: admin@bytX.com / senha: admin123");

        } catch (Exception e) {
            System.out.println("Dados já existem ou erro ao inserir: " + e.getMessage());
        }
    }

    public boolean inserirUsuario(Usuario usuario) {
        System.out.println("=== TENTANDO INSERIR USUÁRIO NO BANCO ===");
        System.out.println("Nome: " + usuario.getNome());
        System.out.println("Email: " + usuario.getEmail());
        System.out.println("CPF: " + usuario.getCpf());
        System.out.println("Grupo: " + usuario.getGrupo());

        if (!ValidadorCPF.validar(usuario.getCpf())) {
            System.out.println("CPF inválido: " + usuario.getCpf());
            return false;
        }

        String SQL = "INSERT INTO usuarios (nome, cpf, email, senha, grupo, ativo) VALUES (?, ?, ?, ?, ?, ?)";
        System.out.println("SQL: " + SQL);

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, usuario.getNome());
            ps.setString(2, ValidadorCPF.removerFormatacao(usuario.getCpf()));
            ps.setString(3, usuario.getEmail());

            String senhaCriptografada = CriptografiaUtil.criptografarSenha(usuario.getSenha());
            System.out.println("Senha criptografada: " + senhaCriptografada);
            ps.setString(4, senhaCriptografada);

            ps.setString(5, usuario.getGrupo());
            ps.setBoolean(6, usuario.isAtivo());

            int result = ps.executeUpdate();
            System.out.println("Linhas afetadas: " + result);
            return result > 0;

        } catch (SQLException e) {
            System.out.println("ERRO SQL: " + e.getMessage());
            System.out.println("Código do erro: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }

    // CRUD - READ (Todos os usuários)
    public List<Usuario> listarTodosUsuarios() {//Para cada linha chama "mapearUsuario"
        List<Usuario> usuarios = new ArrayList<>();
        String SQL = "SELECT * FROM usuarios ORDER BY nome";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar usuários: " + e.getMessage());
        }

        return usuarios;
    }

    // CRUD - READ (Por email)
    public Usuario buscarUsuarioPorEmail(String email) {
        String SQL = "SELECT * FROM usuarios WHERE email = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearUsuario(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar usuário: " + e.getMessage());
        }

        return null;
    }

    public boolean atualizarUsuario(Usuario usuario) {
        System.out.println("=== TENTANDO ATUALIZAR USUÁRIO ===");
        System.out.println("ID: " + usuario.getId());
        System.out.println("Nome: " + usuario.getNome());
        System.out.println("CPF: " + usuario.getCpf());
        System.out.println("Grupo: " + usuario.getGrupo());

        String SQL = "UPDATE usuarios SET nome = ?, cpf = ?, grupo = ?, ativo = ? WHERE id = ?";
        System.out.println("SQL: " + SQL);

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, usuario.getNome());
            ps.setString(2, ValidadorCPF.removerFormatacao(usuario.getCpf()));
            ps.setString(3, usuario.getGrupo());
            ps.setBoolean(4, usuario.isAtivo());
            ps.setLong(5, usuario.getId());

            int linhasAfetadas = ps.executeUpdate();
            System.out.println("Linhas afetadas: " + linhasAfetadas);
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("ERRO SQL: " + e.getMessage());
            System.out.println("Código do erro: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }

    // CRUD - UPDATE (Senha)
    public boolean atualizarSenha(Long id, String novaSenha) {
        String SQL = "UPDATE usuarios SET senha = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, CriptografiaUtil.criptografarSenha(novaSenha));
            ps.setLong(2, id);

            int linhasAfetadas = ps.executeUpdate();
            System.out.println("Senha atualizada para usuário ID: " + id);
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar senha: " + e.getMessage());
            return false;
        }
    }

    // CRUD - UPDATE (Status)
    public boolean alterarStatusUsuario(Long id, boolean ativo) {
        String SQL = "UPDATE usuarios SET ativo = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setBoolean(1, ativo);
            ps.setLong(2, id);

            int linhasAfetadas = ps.executeUpdate();
            System.out.println("Status alterado para usuário ID: " + id + " -> " + (ativo ? "ATIVO" : "INATIVO"));
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao alterar status: " + e.getMessage());
            return false;
        }
    }

    // CRUD - DELETE (Lógico - desativar)
    public boolean desativarUsuario(Long id) {
        return alterarStatusUsuario(id, false);
    }

    // CRUD - DELETE (Lógico - ativar)
    public boolean ativarUsuario(Long id) {
        return alterarStatusUsuario(id, true);
    }

    // Método auxiliar para mapear ResultSet para objeto Usuario
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        //Transforma a linha do banco em um objeto usuário
        Usuario usuario = new Usuario();
        usuario.setId(rs.getLong("id"));
        usuario.setNome(rs.getString("nome"));
        usuario.setCpf(rs.getString("cpf"));
        usuario.setEmail(rs.getString("email"));
        usuario.setSenha(rs.getString("senha"));
        usuario.setGrupo(rs.getString("grupo"));
        usuario.setAtivo(rs.getBoolean("ativo"));
        return usuario;
    }

    public Usuario verificarLogin(String email, String senha) {
        System.out.println("=== VERIFICANDO LOGIN ===");
        System.out.println("Email: " + email);

        try {
            Usuario usuario = buscarUsuarioPorEmail(email);

            if (usuario == null) {
                System.out.println("USUÁRIO NÃO ENCONTRADO no banco de dados");
                return null;
            }

            System.out.println("Usuário encontrado: " + usuario.getEmail());
            System.out.println("Hash no banco: " + usuario.getSenha());

            if (!usuario.isAtivo()) {
                System.out.println("USUÁRIO INATIVO");
                return null;
            }

            System.out.println("Verificando senha com BCrypt...");

            // Verificar se o hash é BCrypt válido
            if (!usuario.getSenha().startsWith("$2a$")) {
                System.out.println("Hash não é BCrypt válido - atualizando automaticamente");

                // Gerar novo hash BCrypt
                String novoSenhaHash = CriptografiaUtil.criptografarSenha(senha);

                // Atualizar no banco
                if (atualizarSenha(usuario.getId(), senha)) {
                    System.out.println("Hash atualizado com sucesso");
                    usuario.setSenha(novoSenhaHash);
                } else {
                    System.out.println("Falha ao atualizar hash no banco");
                    return null;
                }
            }

            // Agora verificar a senha
            boolean senhaValida = CriptografiaUtil.verificarSenha(senha, usuario.getSenha());
            System.out.println("Senha válida: " + senhaValida);

            if (senhaValida) {
                System.out.println("LOGIN BEM-SUCEDIDO");
                return usuario;
            } else {
                System.out.println("SENHA INVÁLIDA");
                return null;
            }

        } catch (Exception e) {
            System.out.println("ERRO EXCEÇÃO: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    // Verificar se email já existe
    public boolean emailExiste(String email) {
        return buscarUsuarioPorEmail(email) != null;
    }

    // Verificar se CPF já existe
    public boolean cpfExiste(String cpf) {
        String SQL = "SELECT * FROM usuarios WHERE cpf = ?";
        String cpfLimpo = ValidadorCPF.removerFormatacao(cpf);

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, cpfLimpo);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.out.println("Erro ao verificar CPF: " + e.getMessage());
            return false;
        }
    }
}