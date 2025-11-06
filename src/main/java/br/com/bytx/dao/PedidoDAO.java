package br.com.bytx.dao;

import br.com.bytx.model.pedido.Pedido;
import br.com.bytx.model.pedido.ItemPedido;
import br.com.bytx.model.produto.Produto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    public void criarTabelasPedido() {
        String SQL_PEDIDOS = "CREATE TABLE IF NOT EXISTS pedidos (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "numero_pedido VARCHAR(30) UNIQUE NOT NULL, " +
                "cliente_id INT NOT NULL, " +
                "endereco_entrega_id INT NOT NULL, " +
                "forma_pagamento VARCHAR(50) NOT NULL, " +
                "detalhes_pagamento TEXT, " +
                "status VARCHAR(50) DEFAULT 'aguardando_pagamento', " +
                "subtotal DECIMAL(10,2) NOT NULL, " +
                "frete DECIMAL(10,2) NOT NULL, " +
                "total DECIMAL(10,2) NOT NULL, " +
                "data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (cliente_id) REFERENCES clientes(id), " +
                "FOREIGN KEY (endereco_entrega_id) REFERENCES enderecos_clientes(id)" +
                ")";

        String SQL_ITENS_PEDIDO = "CREATE TABLE IF NOT EXISTS itens_pedido (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "pedido_id INT NOT NULL, " +
                "produto_id INT NOT NULL, " +
                "quantidade INT NOT NULL, " +
                "preco_unitario DECIMAL(10,2) NOT NULL, " +
                "subtotal DECIMAL(10,2) NOT NULL, " +
                "FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE, " +
                "FOREIGN KEY (produto_id) REFERENCES produtos(id)" +
                ")";

        try (Connection connection = getConnection();
             PreparedStatement ps1 = connection.prepareStatement(SQL_PEDIDOS);
             PreparedStatement ps2 = connection.prepareStatement(SQL_ITENS_PEDIDO)) {

            ps1.execute();
            ps2.execute();
            System.out.println("✅ Tabelas de pedidos criadas com sucesso!");

        } catch (Exception e) {
            System.out.println("❌ Erro ao criar tabelas de pedidos: " + e.getMessage());
        }
    }

    public boolean salvarPedido(Pedido pedido) {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            System.out.println("💾 Iniciando salvamento do pedido:");
            System.out.println("   Cliente ID: " + pedido.getClienteId());
            System.out.println("   Subtotal: " + pedido.getSubtotal());
            System.out.println("   Total: " + pedido.getTotal());
            System.out.println("   Itens: " + pedido.getItens().size());

            // Gerar número do pedido
            String numeroPedido = gerarNumeroPedido(connection);

            // Inserir pedido
            String SQL_PEDIDO = "INSERT INTO pedidos (numero_pedido, cliente_id, endereco_entrega_id, " +
                    "forma_pagamento, detalhes_pagamento, status, subtotal, frete, total) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = connection.prepareStatement(SQL_PEDIDO, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, numeroPedido);
                ps.setLong(2, pedido.getClienteId());
                ps.setLong(3, pedido.getEnderecoEntregaId());
                ps.setString(4, pedido.getFormaPagamento());
                ps.setString(5, pedido.getDetalhesPagamento());
                ps.setString(6, pedido.getStatus());
                ps.setBigDecimal(7, pedido.getSubtotal());
                ps.setBigDecimal(8, pedido.getFrete());
                ps.setBigDecimal(9, pedido.getTotal());

                int result = ps.executeUpdate();
                if (result == 0) {
                    connection.rollback();
                    return false;
                }

                // Obter ID do pedido
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        pedido.setId(generatedKeys.getLong(1));
                        pedido.setNumeroPedido(numeroPedido);
                    }
                }
            }

            // Inserir itens do pedido
            if (!salvarItensPedido(connection, pedido)) {
                connection.rollback();
                return false;
            }

            connection.commit();
            System.out.println("✅ Pedido salvo com sucesso: " + numeroPedido);
            return true;

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    System.out.println("❌ Erro no rollback: " + ex.getMessage());
                }
            }
            System.out.println("❌ Erro ao salvar pedido: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    System.out.println("❌ Erro ao fechar conexão: " + e.getMessage());
                }
            }
        }
    }

    private String gerarNumeroPedido(Connection connection) throws SQLException {
        // ✅ VERSÃO MAIS CURTA - apenas timestamp (13 dígitos) + sequencial (4 dígitos)
        String timestamp = String.valueOf(System.currentTimeMillis());

        // Pegar apenas os últimos 9 dígitos do timestamp para ficar menor
        String timestampCurto = timestamp.length() > 9 ? timestamp.substring(timestamp.length() - 9) : timestamp;

        // Buscar sequencial do dia
        String SQL = "SELECT COUNT(*) + 1 FROM pedidos WHERE CAST(data_criacao AS DATE) = CURRENT_DATE";

        try (PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int sequencial = rs.getInt(1);
                String numero = "B" + timestampCurto + String.format("%04d", sequencial);
                System.out.println("✅ Número do pedido gerado: " + numero + " (" + numero.length() + " chars)");
                return numero;
            }
        }

        // Fallback
        String fallback = "B" + timestampCurto + "0001";
        System.out.println("⚠️  Usando fallback: " + fallback + " (" + fallback.length() + " chars)");
        return fallback;
    }

    private boolean salvarItensPedido(Connection connection, Pedido pedido) throws SQLException {
        String SQL_ITEM = "INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario, subtotal) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(SQL_ITEM)) {
            for (ItemPedido item : pedido.getItens()) {
                ps.setLong(1, pedido.getId());
                ps.setLong(2, item.getProdutoId());
                ps.setInt(3, item.getQuantidade());
                ps.setBigDecimal(4, item.getPrecoUnitario());
                ps.setBigDecimal(5, item.getSubtotal());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        }
    }

    public List<Pedido> listarPorClienteId(Long clienteId) {
        List<Pedido> pedidos = new ArrayList<>();
        String SQL = "SELECT p.* FROM pedidos p WHERE p.cliente_id = ? ORDER BY p.data_criacao DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setLong(1, clienteId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Pedido pedido = mapearPedido(rs);
                pedidos.add(pedido);
            }

            System.out.println("✅ " + pedidos.size() + " pedidos encontrados para cliente: " + clienteId);

        } catch (SQLException e) {
            System.out.println("❌ Erro ao listar pedidos: " + e.getMessage());
            e.printStackTrace();
        }
        return pedidos;
    }

    public Pedido buscarPorId(Long pedidoId) {
        String SQL = "SELECT p.* FROM pedidos p WHERE p.id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setLong(1, pedidoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Pedido pedido = mapearPedido(rs);
                System.out.println("✅ Pedido encontrado: " + pedido.getNumeroPedido());
                return pedido;
            }

        } catch (SQLException e) {
            System.out.println("❌ Erro ao buscar pedido: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Pedido buscarPorNumero(String numeroPedido) {
        String SQL = "SELECT p.* FROM pedidos p WHERE p.numero_pedido = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, numeroPedido);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearPedido(rs);
            }

        } catch (SQLException e) {
            System.out.println("❌ Erro ao buscar pedido por número: " + e.getMessage());
        }
        return null;
    }

    private Pedido mapearPedido(ResultSet rs) throws SQLException {
        Pedido pedido = new Pedido();
        pedido.setId(rs.getLong("id"));
        pedido.setNumeroPedido(rs.getString("numero_pedido"));
        pedido.setClienteId(rs.getLong("cliente_id"));
        pedido.setEnderecoEntregaId(rs.getLong("endereco_entrega_id"));
        pedido.setFormaPagamento(rs.getString("forma_pagamento"));
        pedido.setDetalhesPagamento(rs.getString("detalhes_pagamento"));
        pedido.setStatus(rs.getString("status"));
        pedido.setSubtotal(rs.getBigDecimal("subtotal"));
        pedido.setFrete(rs.getBigDecimal("frete"));
        pedido.setTotal(rs.getBigDecimal("total"));

        Timestamp dataCriacao = rs.getTimestamp("data_criacao");
        if (dataCriacao != null) {
            pedido.setDataCriacao(dataCriacao.toLocalDateTime());
        } else {
            // ✅ SE FOR NULL, usar data atual
            pedido.setDataCriacao(java.time.LocalDateTime.now());
            System.out.println("⚠️  Data de criação null, usando data atual");
        }

        // Carregar itens do pedido
        carregarItensPedido(pedido);

        return pedido;
    }

    private void carregarItensPedido(Pedido pedido) {
        String SQL = "SELECT ip.*, p.nome, p.descricao " +
                "FROM itens_pedido ip " +
                "INNER JOIN produtos p ON ip.produto_id = p.id " +
                "WHERE ip.pedido_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setLong(1, pedido.getId());
            ResultSet rs = ps.executeQuery();

            List<ItemPedido> itens = new ArrayList<>();
            while (rs.next()) {
                ItemPedido item = mapearItemPedido(rs);
                itens.add(item);
            }

            pedido.setItens(itens);
            System.out.println("✅ " + itens.size() + " itens carregados para pedido: " + pedido.getNumeroPedido());

        } catch (SQLException e) {
            System.out.println("❌ Erro ao carregar itens do pedido: " + e.getMessage());
        }
    }

    private ItemPedido mapearItemPedido(ResultSet rs) throws SQLException {
        ItemPedido item = new ItemPedido();
        item.setId(rs.getLong("id"));
        item.setPedidoId(rs.getLong("pedido_id"));
        item.setProdutoId(rs.getLong("produto_id"));
        item.setQuantidade(rs.getInt("quantidade"));
        item.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));

        // Carregar dados básicos do produto
        Produto produto = new Produto();
        produto.setId(rs.getLong("produto_id"));
        produto.setNome(rs.getString("nome"));
        produto.setDescricao(rs.getString("descricao"));
        item.setProduto(produto);

        return item;
    }

    public boolean atualizarStatus(Long pedidoId, String novoStatus) {
        String SQL = "UPDATE pedidos SET status = ?, data_atualizacao = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {

            ps.setString(1, novoStatus);
            ps.setLong(2, pedidoId);

            int result = ps.executeUpdate();
            System.out.println("✅ Status do pedido " + pedidoId + " atualizado para: " + novoStatus);
            return result > 0;

        } catch (SQLException e) {
            System.out.println("❌ Erro ao atualizar status do pedido: " + e.getMessage());
            return false;
        }
    }

    public List<Pedido> listarTodos() {
        List<Pedido> pedidos = new ArrayList<>();
        String SQL = "SELECT p.* FROM pedidos p ORDER BY p.data_criacao DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                pedidos.add(mapearPedido(rs));
            }

            System.out.println("✅ " + pedidos.size() + " pedidos encontrados no total");

        } catch (SQLException e) {
            System.out.println("❌ Erro ao listar todos os pedidos: " + e.getMessage());
        }
        return pedidos;
    }
}