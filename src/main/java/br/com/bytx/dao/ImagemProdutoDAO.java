package br.com.bytx.dao;

import br.com.bytx.model.produto.ImagemProduto;
import br.com.bytx.model.produto.Produto;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImagemProdutoDAO {

    // Método para obter conexão com o banco
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
    }

    // Criar tabela de imagens
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
    }

    // Inserir nova imagem
    public boolean inserir(ImagemProduto imagem) {
        String SQL = "INSERT INTO imagens_produto (produto_id, nome_arquivo, caminho, principal) VALUES (?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, imagem.getProduto().getId());
            ps.setString(2, imagem.getNomeArquivo());
            ps.setString(3, imagem.getCaminho());
            ps.setBoolean(4, imagem.isPrincipal());

            int result = ps.executeUpdate();

            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        imagem.setId(generatedKeys.getLong(1));
                    }
                }
                return true;
            }

            return false;

        } catch (SQLException e) {
            System.out.println("Erro ao inserir imagem: " + e.getMessage());
            return false;
        }
    }

    // Método ATUALIZAR corrigido
    public boolean atualizar(ImagemProduto imagem) {
        String SQL = "UPDATE imagens_produto SET principal = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL)) {

            stmt.setBoolean(1, imagem.isPrincipal());
            stmt.setLong(2, imagem.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao atualizar imagem: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Buscar imagem por ID
    public ImagemProduto buscarPorId(Long id) {
        String sql = "SELECT * FROM imagens_produto WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearImagem(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagem por ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Buscar imagem principal do produto
    public ImagemProduto buscarImagemPrincipal(Long produtoId) {
        String sql = "SELECT * FROM imagens_produto WHERE produto_id = ? AND principal = TRUE";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, produtoId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapearImagem(rs);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagem principal: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Buscar imagem por nome do arquivo
    public ImagemProduto buscarPorNomeArquivo(String nomeArquivo) {
        String sql = "SELECT ip.*, p.ativo FROM imagens_produto ip " +
                "INNER JOIN produtos p ON ip.produto_id = p.id " +
                "WHERE ip.nome_arquivo = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nomeArquivo);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                ImagemProduto imagem = mapearImagem(rs);

                // Carregar o produto completo
                Produto produto = new Produto();
                produto.setId(rs.getLong("produto_id"));
                produto.setAtivo(rs.getBoolean("ativo"));
                imagem.setProduto(produto);

                return imagem;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagem por nome do arquivo: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Buscar todas as imagens do produto
    public List<ImagemProduto> buscarPorProdutoId(Long produtoId) {
        List<ImagemProduto> imagens = new ArrayList<>();
        String sql = "SELECT * FROM imagens_produto WHERE produto_id = ? ORDER BY principal DESC, data_upload DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, produtoId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                imagens.add(mapearImagem(rs));
            }

        } catch (SQLException e) {
            System.out.println("Erro ao buscar imagens do produto: " + e.getMessage());
            e.printStackTrace();
        }
        return imagens;
    }

    // Deletar imagem
    public boolean deletar(Long imagemId) {
        String sql = "DELETE FROM imagens_produto WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, imagemId);
            int rowsAffected = stmt.executeUpdate();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao deletar imagem: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Remover status de principal de todas as imagens do produto
    public boolean removerPrincipalDoProduto(Long produtoId) {
        String SQL = "UPDATE imagens_produto SET principal = false WHERE produto_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SQL)) {

            stmt.setLong(1, produtoId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao remover status principal: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Mapear ResultSet para objeto ImagemProduto
    private ImagemProduto mapearImagem(ResultSet rs) throws SQLException {
        ImagemProduto imagem = new ImagemProduto();
        imagem.setId(rs.getLong("id"));

        Produto produto = new Produto();
        produto.setId(rs.getLong("produto_id"));
        imagem.setProduto(produto);

        imagem.setNomeArquivo(rs.getString("nome_arquivo"));
        imagem.setCaminho(rs.getString("caminho"));
        imagem.setPrincipal(rs.getBoolean("principal"));
        imagem.setDataUpload(rs.getTimestamp("data_upload"));

        return imagem;
    }

    // Contar imagens do produto
    public int contarImagensPorProduto(Long produtoId) {
        String sql = "SELECT COUNT(*) FROM imagens_produto WHERE produto_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, produtoId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao contar imagens: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Verificar se produto tem imagem principal
    public boolean temImagemPrincipal(Long produtoId) {
        String sql = "SELECT COUNT(*) FROM imagens_produto WHERE produto_id = ? AND principal = TRUE";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, produtoId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("Erro ao verificar imagem principal: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}