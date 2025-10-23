package br.com.bytx.dao;

import br.com.bytx.model.Usuario;
import br.com.bytx.model.cliente.Cliente;
import br.com.bytx.model.cliente.Endereco;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    // Inserir cliente
    public boolean inserirCliente(Cliente cliente) {
        String SQL = "INSERT INTO clientes (usuario_id, data_nascimento, genero, telefone) VALUES (?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, cliente.getUsuario().getId());

            if (cliente.getDataNascimento() != null) {
                ps.setDate(2, Date.valueOf(cliente.getDataNascimento()));
            } else {
                ps.setNull(2, Types.DATE);
            }

            ps.setString(3, cliente.getGenero());
            ps.setString(4, cliente.getTelefone());

            int result = ps.executeUpdate();

            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        cliente.setId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
            return false;

        } catch (SQLException e) {
            System.out.println("Erro ao inserir cliente: " + e.getMessage());
            return false;
        }
    }

    // Buscar cliente por ID do usuário
    public Cliente buscarPorUsuarioId(Long usuarioId) {
        String SQL = "SELECT c.*, u.nome, u.email, u.cpf, u.ativo " +
                "FROM clientes c " +
                "INNER JOIN usuarios u ON c.usuario_id = u.id " +
                "WHERE c.usuario_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, usuarioId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearClienteCompleto(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar cliente por usuário ID: " + e.getMessage());
        }
        return null;
    }

    // Buscar cliente por ID
    public Cliente buscarPorId(Long clienteId) {
        String SQL = "SELECT c.*, u.nome, u.email, u.cpf, u.ativo " +
                "FROM clientes c " +
                "INNER JOIN usuarios u ON c.usuario_id = u.id " +
                "WHERE c.id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, clienteId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearClienteCompleto(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar cliente por ID: " + e.getMessage());
        }
        return null;
    }

    // Atualizar dados do cliente
    public boolean atualizarCliente(Cliente cliente) {
        String SQL = "UPDATE clientes SET data_nascimento = ?, genero = ?, telefone = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            if (cliente.getDataNascimento() != null) {
                ps.setDate(1, Date.valueOf(cliente.getDataNascimento()));
            } else {
                ps.setNull(1, Types.DATE);
            }

            ps.setString(2, cliente.getGenero());
            ps.setString(3, cliente.getTelefone());
            ps.setLong(4, cliente.getId());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar cliente: " + e.getMessage());
            return false;
        }
    }

    // Verificar se usuário já é cliente
    public boolean isCliente(Long usuarioId) {
        String SQL = "SELECT COUNT(*) FROM clientes WHERE usuario_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, usuarioId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao verificar se é cliente: " + e.getMessage());
        }
        return false;
    }

    // Mapear ResultSet para Cliente
    private Cliente mapearClienteCompleto(ResultSet rs) throws SQLException {
        Cliente cliente = new Cliente();
        cliente.setId(rs.getLong("id"));
        cliente.setUsuarioId(rs.getLong("usuario_id"));

        // Criar objeto Usuario
        Usuario usuario = new Usuario();
        usuario.setId(rs.getLong("usuario_id"));
        usuario.setNome(rs.getString("nome"));
        usuario.setEmail(rs.getString("email"));
        usuario.setCpf(rs.getString("cpf"));
        usuario.setAtivo(rs.getBoolean("ativo"));
        usuario.setGrupo("CLIENTE");

        cliente.setUsuario(usuario);

        // Data de nascimento
        Date dataNascimento = rs.getDate("data_nascimento");
        if (dataNascimento != null) {
            cliente.setDataNascimento(dataNascimento.toLocalDate());
        }

        cliente.setGenero(rs.getString("genero"));
        cliente.setTelefone(rs.getString("telefone"));

        // Carregar endereços
        carregarEnderecos(cliente);

        return cliente;
    }

    // Carregar endereços do cliente
    // Carregar endereços do cliente
    private void carregarEnderecos(Cliente cliente) {
        EnderecoDAO enderecoDAO = new EnderecoDAO();
        List<Endereco> enderecos = enderecoDAO.buscarPorClienteId(cliente.getId());

        if (enderecos != null) {
            cliente.setEnderecos(enderecos);
        } else {
            cliente.setEnderecos(new ArrayList<>()); // Lista vazia se não houver endereços
        }
    }
}