package br.com.bytx.dao;

import br.com.bytx.model.carrinho.Carrinho;
import br.com.bytx.model.carrinho.ItemCarrinho;
import br.com.bytx.model.produto.Produto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarrinhoDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    public void criarTabelasCarrinho() {
        String SQL_CARRINHO = "CREATE TABLE IF NOT EXISTS carrinho (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "usuario_id INT NULL, " +
                "session_id VARCHAR(100) NULL, " +
                "data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";

        String SQL_ITENS_CARRINHO = "CREATE TABLE IF NOT EXISTS itens_carrinho (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "carrinho_id INT NOT NULL, " +
                "produto_id INT NOT NULL, " +
                "quantidade INT NOT NULL DEFAULT 1, " +
                "preco_unitario DECIMAL(10,2) NOT NULL, " +
                "data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (carrinho_id) REFERENCES carrinho(id) ON DELETE CASCADE, " +
                "FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE, " +
                "UNIQUE(carrinho_id, produto_id)" +
                ")";

        try (Connection connection = getConnection();
             PreparedStatement ps1 = connection.prepareStatement(SQL_CARRINHO);
             PreparedStatement ps2 = connection.prepareStatement(SQL_ITENS_CARRINHO)) {

            ps1.execute();
            ps2.execute();
            System.out.println("Tabelas do carrinho criadas com sucesso!");

        } catch (Exception e) {
            System.out.println("Erro ao criar tabelas do carrinho: " + e.getMessage());
        }
    }

    // Buscar carrinho por usuário ID
    public Carrinho buscarPorUsuarioId(Long usuarioId) {
        String sql = "SELECT c.* FROM carrinho c WHERE c.usuario_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, usuarioId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Carrinho carrinho = mapearCarrinho(rs);
                carregarItensCarrinho(carrinho);
                return carrinho;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar carrinho por usuário ID: " + e.getMessage());
        }
        return null;
    }

    // Buscar carrinho por session ID
    public Carrinho buscarPorSessionId(String sessionId) {
        String sql = "SELECT c.* FROM carrinho c WHERE c.session_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, sessionId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Carrinho carrinho = mapearCarrinho(rs);
                carregarItensCarrinho(carrinho);
                return carrinho;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar carrinho por session ID: " + e.getMessage());
        }
        return null;
    }

    // Criar novo carrinho
    public boolean salvar(Carrinho carrinho) {
        String sql = "INSERT INTO carrinho (usuario_id, session_id) VALUES (?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (carrinho.getUsuarioId() != null) {
                stmt.setLong(1, carrinho.getUsuarioId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setString(2, carrinho.getSessionId());

            int result = stmt.executeUpdate();

            if (result > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        carrinho.setId(generatedKeys.getLong(1));
                        salvarItensCarrinho(carrinho);
                        return true;
                    }
                }
            }

            return false;

        } catch (SQLException e) {
            System.out.println("Erro ao salvar carrinho: " + e.getMessage());
            return false;
        }
    }

    // Atualizar carrinho existente
    public boolean atualizar(Carrinho carrinho) {
        if (carrinho.getId() == null) {
            return salvar(carrinho);
        }

        // Primeiro remove todos os itens antigos
        if (!limparItensCarrinho(carrinho.getId())) {
            return false;
        }

        // Depois adiciona os novos itens
        return salvarItensCarrinho(carrinho);
    }

    // Adicionar item ao carrinho
    public boolean adicionarItem(Long carrinhoId, ItemCarrinho item) {
        String sql = "INSERT INTO itens_carrinho (carrinho_id, produto_id, quantidade, preco_unitario) " +
                "VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE quantidade = quantidade + VALUES(quantidade)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, carrinhoId);
            stmt.setLong(2, item.getProduto().getId());
            stmt.setInt(3, item.getQuantidade());
            stmt.setBigDecimal(4, item.getPrecoUnitario());

            int result = stmt.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao adicionar item ao carrinho: " + e.getMessage());
            return false;
        }
    }

    // Remover item do carrinho
    public boolean removerItem(Long carrinhoId, Long produtoId) {
        String sql = "DELETE FROM itens_carrinho WHERE carrinho_id = ? AND produto_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, carrinhoId);
            stmt.setLong(2, produtoId);

            int result = stmt.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao remover item do carrinho: " + e.getMessage());
            return false;
        }
    }

    // Atualizar quantidade do item
    public boolean atualizarQuantidadeItem(Long carrinhoId, Long produtoId, int quantidade) {
        if (quantidade <= 0) {
            return removerItem(carrinhoId, produtoId);
        }

        String sql = "UPDATE itens_carrinho SET quantidade = ? WHERE carrinho_id = ? AND produto_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantidade);
            stmt.setLong(2, carrinhoId);
            stmt.setLong(3, produtoId);

            int result = stmt.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar quantidade do item: " + e.getMessage());
            return false;
        }
    }

    // Métodos auxiliares privados
    private Carrinho mapearCarrinho(ResultSet rs) throws SQLException {
        Carrinho carrinho = new Carrinho();
        carrinho.setId(rs.getLong("id"));

        Long usuarioId = rs.getLong("usuario_id");
        if (!rs.wasNull()) {
            carrinho.setUsuarioId(usuarioId);
        }

        carrinho.setSessionId(rs.getString("session_id"));
        return carrinho;
    }

    private void carregarItensCarrinho(Carrinho carrinho) throws SQLException {
        String sql = "SELECT ic.*, p.nome, p.descricao, p.ativo " +
                "FROM itens_carrinho ic " +
                "INNER JOIN produtos p ON ic.produto_id = p.id " +
                "WHERE ic.carrinho_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, carrinho.getId());
            ResultSet rs = stmt.executeQuery();

            List<ItemCarrinho> itens = new ArrayList<>();
            ProdutoDAO produtoDAO = new ProdutoDAO();

            while (rs.next()) {
                ItemCarrinho item = new ItemCarrinho();
                item.setId(rs.getLong("id"));

                // Buscar produto completo
                Produto produto = produtoDAO.buscarPorId(rs.getLong("produto_id"));
                item.setProduto(produto);

                item.setQuantidade(rs.getInt("quantidade"));
                item.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));

                itens.add(item);
            }

            carrinho.setItens(itens);
        }
    }

    private boolean salvarItensCarrinho(Carrinho carrinho) {
        if (carrinho.getId() == null) return false;

        String sql = "INSERT INTO itens_carrinho (carrinho_id, produto_id, quantidade, preco_unitario) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (ItemCarrinho item : carrinho.getItens()) {
                if (item.getProduto() != null) {
                    stmt.setLong(1, carrinho.getId());
                    stmt.setLong(2, item.getProduto().getId());
                    stmt.setInt(3, item.getQuantidade());
                    stmt.setBigDecimal(4, item.getPrecoUnitario());
                    stmt.addBatch();
                }
            }

            int[] results = stmt.executeBatch();
            return results.length > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao salvar itens do carrinho: " + e.getMessage());
            return false;
        }
    }

    private boolean limparItensCarrinho(Long carrinhoId) {
        String sql = "DELETE FROM itens_carrinho WHERE carrinho_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, carrinhoId);
            int result = stmt.executeUpdate();
            return true; // Sempre retorna true, mesmo se não houver itens

        } catch (SQLException e) {
            System.out.println("Erro ao limpar itens do carrinho: " + e.getMessage());
            return false;
        }
    }

    // Limpar carrinho expirado (para sessões antigas)
    public boolean limparCarrinhoExpirado(int diasExpiracao) {
        String sql = "DELETE FROM carrinho WHERE data_atualizacao < DATE_SUB(NOW(), INTERVAL ? DAY) " +
                "AND usuario_id IS NULL";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, diasExpiracao);
            int result = stmt.executeUpdate();
            System.out.println("Carrinhos expirados removidos: " + result);
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao limpar carrinhos expirados: " + e.getMessage());
            return false;
        }
    }
}