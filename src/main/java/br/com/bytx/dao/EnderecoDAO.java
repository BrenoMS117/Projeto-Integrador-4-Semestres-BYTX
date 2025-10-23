package br.com.bytx.dao;

import br.com.bytx.model.cliente.Endereco;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnderecoDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    // Inserir endereço
    public boolean inserirEndereco(Endereco endereco) {
        String SQL = "INSERT INTO enderecos_clientes (cliente_id, tipo, cep, logradouro, numero, complemento, bairro, cidade, uf, padrao) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, endereco.getClienteId());
            ps.setString(2, endereco.getTipo());
            ps.setString(3, endereco.getCep());
            ps.setString(4, endereco.getLogradouro());
            ps.setString(5, endereco.getNumero());
            ps.setString(6, endereco.getComplemento());
            ps.setString(7, endereco.getBairro());
            ps.setString(8, endereco.getCidade());
            ps.setString(9, endereco.getUf());
            ps.setBoolean(10, endereco.isPadrao());

            int result = ps.executeUpdate();

            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        endereco.setId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
            return false;

        } catch (SQLException e) {
            System.out.println("Erro ao inserir endereço: " + e.getMessage());
            return false;
        }
    }

    // Buscar endereços por cliente ID
    public List<Endereco> buscarPorClienteId(Long clienteId) {
        List<Endereco> enderecos = new ArrayList<>();
        String SQL = "SELECT * FROM enderecos_clientes WHERE cliente_id = ? ORDER BY padrao DESC, data_criacao DESC";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, clienteId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                enderecos.add(mapearEndereco(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar endereços: " + e.getMessage());
        }
        return enderecos;
    }

    // Buscar endereço por ID
    public Endereco buscarPorId(Long enderecoId) {
        String SQL = "SELECT * FROM enderecos_clientes WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, enderecoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearEndereco(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar endereço por ID: " + e.getMessage());
        }
        return null;
    }

    // Atualizar endereço
    public boolean atualizarEndereco(Endereco endereco) {
        String SQL = "UPDATE enderecos_clientes SET tipo = ?, cep = ?, logradouro = ?, numero = ?, " +
                "complemento = ?, bairro = ?, cidade = ?, uf = ?, padrao = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, endereco.getTipo());
            ps.setString(2, endereco.getCep());
            ps.setString(3, endereco.getLogradouro());
            ps.setString(4, endereco.getNumero());
            ps.setString(5, endereco.getComplemento());
            ps.setString(6, endereco.getBairro());
            ps.setString(7, endereco.getCidade());
            ps.setString(8, endereco.getUf());
            ps.setBoolean(9, endereco.isPadrao());
            ps.setLong(10, endereco.getId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar endereço: " + e.getMessage());
            return false;
        }
    }

    // Remover endereço
    public boolean removerEndereco(Long enderecoId) {
        String SQL = "DELETE FROM enderecos_clientes WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, enderecoId);
            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao remover endereço: " + e.getMessage());
            return false;
        }
    }

    // Definir endereço como padrão (e remover padrão dos outros)
    public boolean definirEnderecoPadrao(Long enderecoId, Long clienteId) {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            // Remover padrão de todos os endereços do cliente
            String SQL1 = "UPDATE enderecos_clientes SET padrao = FALSE WHERE cliente_id = ?";
            PreparedStatement ps1 = connection.prepareStatement(SQL1);
            ps1.setLong(1, clienteId);
            ps1.executeUpdate();

            // Definir novo endereço como padrão
            String SQL2 = "UPDATE enderecos_clientes SET padrao = TRUE WHERE id = ? AND cliente_id = ?";
            PreparedStatement ps2 = connection.prepareStatement(SQL2);
            ps2.setLong(1, enderecoId);
            ps2.setLong(2, clienteId);
            int result = ps2.executeUpdate();

            connection.commit();
            return result > 0;

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    System.out.println("Erro no rollback: " + ex.getMessage());
                }
            }
            System.out.println("Erro ao definir endereço padrão: " + e.getMessage());
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    System.out.println("Erro ao fechar conexão: " + e.getMessage());
                }
            }
        }
    }

    // Buscar endereço padrão do cliente
    public Endereco buscarEnderecoPadrao(Long clienteId) {
        String SQL = "SELECT * FROM enderecos_clientes WHERE cliente_id = ? AND padrao = TRUE";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, clienteId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearEndereco(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar endereço padrão: " + e.getMessage());
        }
        return null;
    }

    // Mapear ResultSet para Endereco
    private Endereco mapearEndereco(ResultSet rs) throws SQLException {
        Endereco endereco = new Endereco();
        endereco.setId(rs.getLong("id"));
        endereco.setClienteId(rs.getLong("cliente_id"));
        endereco.setTipo(rs.getString("tipo"));
        endereco.setCep(rs.getString("cep"));
        endereco.setLogradouro(rs.getString("logradouro"));
        endereco.setNumero(rs.getString("numero"));
        endereco.setComplemento(rs.getString("complemento"));
        endereco.setBairro(rs.getString("bairro"));
        endereco.setCidade(rs.getString("cidade"));
        endereco.setUf(rs.getString("uf"));
        endereco.setPadrao(rs.getBoolean("padrao"));

        Timestamp dataCriacao = rs.getTimestamp("data_criacao");
        if (dataCriacao != null) {
            endereco.setDataCriacao(dataCriacao.toLocalDateTime());
        }

        return endereco;
    }
}