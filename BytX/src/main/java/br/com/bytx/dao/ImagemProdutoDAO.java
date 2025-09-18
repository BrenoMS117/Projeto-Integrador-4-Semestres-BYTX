package br.com.bytx.dao;

import br.com.bytx.model.produto.ImagemProduto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ImagemProdutoDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    public void criarTabelaImagensProduto() {
        String SQL = "CREATE TABLE IF NOT EXISTS imagens_produto (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "produto_id INT NOT NULL, " +
                "nome_arquivo VARCHAR(255) NOT NULL, " +
                "caminho VARCHAR(500) NOT NULL, " +
                "principal BOOLEAN DEFAULT FALSE, " +
                "data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE" +
                ")";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.execute();
            System.out.println("Tabela 'imagens_produto' criada com sucesso!");
        } catch (Exception e) {
            System.out.println("Erro ao criar tabela 'imagens_produto': " + e.getMessage());
        }
        // NÃO CHAMAR imagemDAO.criarTabelaImagensProduto() aqui!
    }

    public boolean inserir(ImagemProduto imagem) {
        String SQL = "INSERT INTO imagens_produto (produto_id, nome_arquivo, caminho, principal) VALUES (?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, imagem.getProduto().getId());
            ps.setString(2, imagem.getNomeArquivo());
            ps.setString(3, imagem.getCaminho());
            ps.setBoolean(4, imagem.isPrincipal());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao inserir imagem: " + e.getMessage());
            return false;
        }
    }

    public List<ImagemProduto> buscarPorProdutoId(Long produtoId) {
        List<ImagemProduto> imagens = new ArrayList<>();
        String SQL = "SELECT * FROM imagens_produto WHERE produto_id = ? ORDER BY principal DESC, data_upload DESC";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            System.out.println("Buscando imagens para produto ID: " + produtoId);
            ps.setLong(1, produtoId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ImagemProduto imagem = new ImagemProduto();
                imagem.setId(rs.getLong("id"));
                imagem.setNomeArquivo(rs.getString("nome_arquivo"));
                imagem.setCaminho(rs.getString("caminho"));
                imagem.setPrincipal(rs.getBoolean("principal"));
                // Não setar o produto para evitar recursão
                imagens.add(imagem);
            }

            System.out.println("Total de imagens encontradas: " + imagens.size());

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagens: " + e.getMessage());
            e.printStackTrace();
        }

        return imagens;
    }

    public ImagemProduto buscarPrincipalPorProdutoId(Long produtoId) {
        String SQL = "SELECT * FROM imagens_produto WHERE produto_id = ? AND principal = TRUE";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, produtoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearImagem(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagem principal: " + e.getMessage());
        }

        return null;
    }

    public boolean definirComoPrincipal(Long imagemId, Long produtoId) {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            // Remover principal de todas as imagens do produto
            String SQLRemoverPrincipal = "UPDATE imagens_produto SET principal = FALSE WHERE produto_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(SQLRemoverPrincipal)) {
                ps.setLong(1, produtoId);
                ps.executeUpdate();
            }

            // Definir a imagem específica como principal
            String SQLDefinirPrincipal = "UPDATE imagens_produto SET principal = TRUE WHERE id = ? AND produto_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(SQLDefinirPrincipal)) {
                ps.setLong(1, imagemId);
                ps.setLong(2, produtoId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            }

        } catch (SQLException e) {
            try {
                if (connection != null) connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Erro no rollback: " + ex.getMessage());
            }
            System.out.println("Erro ao definir imagem principal: " + e.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                System.out.println("Erro ao fechar conexão: " + e.getMessage());
            }
        }
    }

    public boolean remover(Long imagemId) {
        String SQL = "DELETE FROM imagens_produto WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, imagemId);
            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao remover imagem: " + e.getMessage());
            return false;
        }
    }

    public boolean produtoTemImagens(Long produtoId) {
        String SQL = "SELECT COUNT(*) FROM imagens_produto WHERE produto_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, produtoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao verificar imagens: " + e.getMessage());
        }

        return false;
    }

    public int contarImagensPorProduto(Long produtoId) {
        String SQL = "SELECT COUNT(*) FROM imagens_produto WHERE produto_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, produtoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao contar imagens: " + e.getMessage());
        }

        return 0;
    }

    public ImagemProduto buscarPorId(Long imagemId) {
        String SQL = "SELECT * FROM imagens_produto WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setLong(1, imagemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearImagem(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagem: " + e.getMessage());
        }

        return null;
    }

    private ImagemProduto mapearImagem(ResultSet rs) throws SQLException {
        ImagemProduto imagem = new ImagemProduto();
        imagem.setId(rs.getLong("id"));

        // Para o produto, você precisaria buscar o objeto Produto completo
        // ou ajustar conforme sua estrutura
        // imagem.setProduto(produtoDAO.buscarPorId(rs.getLong("produto_id")));

        imagem.setNomeArquivo(rs.getString("nome_arquivo"));
        imagem.setCaminho(rs.getString("caminho"));
        imagem.setPrincipal(rs.getBoolean("principal"));
        imagem.setDataUpload(rs.getTimestamp("data_upload"));

        return imagem;
    }

    // Método para inicializar dados (se necessário)
    public void inserirDadosIniciais() {
        // Implementar se necessário para testes
    }
}