package br.com.bytx.dao;

import br.com.bytx.model.produto.Produto;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    public void criarTabelaProdutos() {
        String SQL = "CREATE TABLE IF NOT EXISTS produtos (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "nome VARCHAR(200) NOT NULL, " +
                "descricao VARCHAR(2000), " +
                "preco DECIMAL(10,2) NOT NULL, " +
                "quantidade_estoque INT NOT NULL, " +
                "avaliacao DECIMAL(2,1) DEFAULT 0.0, " +
                "ativo BOOLEAN DEFAULT TRUE, " +
                "data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.execute();
            System.out.println("Tabela 'produtos' criada com sucesso!");
        } catch (Exception e) {
            System.out.println("Erro ao criar tabela 'produtos': " + e.getMessage());
        }
    }

    public boolean inserir(Produto produto) {
        String SQL = "INSERT INTO produtos (nome, descricao, preco, quantidade_estoque, avaliacao, ativo) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, produto.getNome());
            ps.setString(2, produto.getDescricao());
            ps.setBigDecimal(3, produto.getPreco());
            ps.setInt(4, produto.getQuantidadeEstoque());
            ps.setBigDecimal(5, produto.getAvaliacao());
            ps.setBoolean(6, produto.isAtivo());

            int result = ps.executeUpdate();

            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        produto.setId(generatedKeys.getLong(1));
                    }
                }
                return true;
            }

            return false;

        } catch (SQLException e) {
            System.out.println("Erro ao inserir produto: " + e.getMessage());
            return false;
        }
    }

    public boolean atualizar(Produto produto) {
        String SQL = "UPDATE produtos SET nome = ?, descricao = ?, preco = ?, quantidade_estoque = ?, avaliacao = ?, ativo = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, produto.getNome());
            ps.setString(2, produto.getDescricao());
            ps.setBigDecimal(3, produto.getPreco());
            ps.setInt(4, produto.getQuantidadeEstoque());
            ps.setBigDecimal(5, produto.getAvaliacao());
            ps.setBoolean(6, produto.isAtivo());
            ps.setLong(7, produto.getId());

            int linhasAfetadas = ps.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar produto: " + e.getMessage());
            return false;
        }
    }

    public List<Produto> listarTodos() {
        List<Produto> produtos = new ArrayList<>();
        String SQL = "SELECT * FROM produtos ORDER BY nome";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                produtos.add(mapearProduto(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar produtos: " + e.getMessage());
        }

        return produtos;
    }

    public List<Produto> listarAtivos() {
        List<Produto> produtos = new ArrayList<>();
        String SQL = "SELECT * FROM produtos WHERE ativo = TRUE ORDER BY nome";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                produtos.add(mapearProduto(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar produtos ativos: " + e.getMessage());
        }

        return produtos;
    }

    public List<Produto> listarTodosOrdenadosPorData() {
        List<Produto> produtos = new ArrayList<>();
        String SQL = "SELECT * FROM produtos ORDER BY data_criacao DESC";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                produtos.add(mapearProduto(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar produtos: " + e.getMessage());
        }

        return produtos;
    }

    public Produto buscarPorId(Long id) {
        String sql = "SELECT * FROM produtos WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearProduto(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar produto por ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean alterarStatus(Long id, boolean ativo) {
        String SQL = "UPDATE produtos SET ativo = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setBoolean(1, ativo);
            ps.setLong(2, id);

            int linhasAfetadas = ps.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao alterar status: " + e.getMessage());
            return false;
        }
    }

    public boolean ativar(Long id) {
        return alterarStatus(id, true);
    }

    public boolean desativar(Long id) {
        return alterarStatus(id, false);
    }

    public boolean atualizarEstoque(Long id, Integer quantidade) {
        String SQL = "UPDATE produtos SET quantidade_estoque = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setInt(1, quantidade);
            ps.setLong(2, id);

            int linhasAfetadas = ps.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar estoque: " + e.getMessage());
            return false;
        }
    }

    public List<Produto> buscarPorNome(String nome) {
        List<Produto> produtos = new ArrayList<>();
        String SQL = "SELECT * FROM produtos WHERE LOWER(nome) LIKE LOWER(?) ORDER BY nome";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, "%" + nome + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                produtos.add(mapearProduto(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar produtos por nome: " + e.getMessage());
        }

        return produtos;
    }

    public int contarProdutosAtivos() {
        String SQL = "SELECT COUNT(*) FROM produtos WHERE ativo = TRUE";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao contar produtos ativos: " + e.getMessage());
        }

        return 0;
    }

    public int contarTotalProdutos() {
        String SQL = "SELECT COUNT(*) FROM produtos";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao contar total de produtos: " + e.getMessage());
        }

        return 0;
    }

    public boolean existeProdutoComNome(String nome) {
        String SQL = "SELECT COUNT(*) FROM produtos WHERE LOWER(nome) = LOWER(?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, nome);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao verificar nome do produto: " + e.getMessage());
        }

        return false;
    }

    public boolean existeProdutoComNomeEIdDiferente(String nome, Long id) {
        String SQL = "SELECT COUNT(*) FROM produtos WHERE LOWER(nome) = LOWER(?) AND id != ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setString(1, nome);
            ps.setLong(2, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao verificar nome do produto: " + e.getMessage());
        }

        return false;
    }

    // MÉTODO MAPEARPRODUTO CORRETO PARA BIGDECIMAL
    private Produto mapearProduto(ResultSet rs) throws SQLException {
        Produto produto = new Produto();
        produto.setId(rs.getLong("id"));
        produto.setNome(rs.getString("nome"));
        produto.setDescricao(rs.getString("descricao"));
        produto.setPreco(rs.getBigDecimal("preco"));
        produto.setQuantidadeEstoque(rs.getInt("quantidade_estoque"));
        produto.setAvaliacao(rs.getBigDecimal("avaliacao"));
        produto.setAtivo(rs.getBoolean("ativo"));
        produto.setDataCriacao(rs.getTimestamp("data_criacao"));

        return produto;
    }

    // Método para inicializar dados de teste
    public void inserirDadosIniciais() {
        try {
            // Verificar se já existem produtos para não duplicar
            if (contarTotalProdutos() == 0) {
                Produto produto1 = new Produto();
                produto1.setNome("Smartphone Galaxy S23");
                produto1.setDescricao("Smartphone flagship com câmera de 200MP e processador Snapdragon 8 Gen 2");
                produto1.setPreco(new BigDecimal("3999.99"));
                produto1.setQuantidadeEstoque(50);
                produto1.setAvaliacao(new BigDecimal("4.5"));
                produto1.setAtivo(true);
                inserir(produto1);

                Produto produto2 = new Produto();
                produto2.setNome("Notebook Dell Inspiron 15");
                produto2.setDescricao("Notebook com processador Intel i7, 16GB RAM e SSD 512GB");
                produto2.setPreco(new BigDecimal("3299.00"));
                produto2.setQuantidadeEstoque(25);
                produto2.setAvaliacao(new BigDecimal("4.2"));
                produto2.setAtivo(true);
                inserir(produto2);

                Produto produto3 = new Produto();
                produto3.setNome("Fone de Ouvido Sony WH-1000XM5");
                produto3.setDescricao("Fone over-ear com cancelamento de ruído ativo e 30h de bateria");
                produto3.setPreco(new BigDecimal("1499.90"));
                produto3.setQuantidadeEstoque(100);
                produto3.setAvaliacao(new BigDecimal("4.8"));
                produto3.setAtivo(false);
                inserir(produto3);

                System.out.println("Dados iniciais de produtos inseridos com sucesso!");
            } else {
                System.out.println("Produtos já existem no banco, pulando inserção de dados iniciais.");
            }

        } catch (Exception e) {
            System.out.println("Erro ao inserir dados iniciais: " + e.getMessage());
        }
    }

    // Método para buscar produtos com estoque baixo
    public List<Produto> buscarComEstoqueBaixo(int limite) {
        List<Produto> produtos = new ArrayList<>();
        String SQL = "SELECT * FROM produtos WHERE quantidade_estoque <= ? AND ativo = TRUE ORDER BY quantidade_estoque ASC";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                produtos.add(mapearProduto(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar produtos com estoque baixo: " + e.getMessage());
        }

        return produtos;
    }

    // Método para atualizar apenas a avaliação
    public boolean atualizarAvaliacao(Long id, BigDecimal avaliacao) {
        String SQL = "UPDATE produtos SET avaliacao = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setBigDecimal(1, avaliacao);
            ps.setLong(2, id);

            int linhasAfetadas = ps.executeUpdate();
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar avaliação: " + e.getMessage());
            return false;
        }
    }
}