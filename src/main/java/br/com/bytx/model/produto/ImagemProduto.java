package br.com.bytx.model.produto;

import java.util.Date;

public class ImagemProduto {
    private Long id;
    private Produto produto;
    private String nomeArquivo;
    private String caminho;
    private boolean principal;
    private Date dataUpload;

    // Construtores
    public ImagemProduto() {
        this.principal = false;
        this.dataUpload = new Date();
    }

    public ImagemProduto(Produto produto, String nomeArquivo, String caminho, boolean principal) {
        this();
        this.produto = produto;
        this.nomeArquivo = nomeArquivo;
        this.caminho = caminho;
        this.principal = principal;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Produto getProduto() { return produto; }
    public void setProduto(Produto produto) { this.produto = produto; }

    public String getNomeArquivo() { return nomeArquivo; }
    public void setNomeArquivo(String nomeArquivo) { this.nomeArquivo = nomeArquivo; }

    public String getCaminho() { return caminho; }
    public void setCaminho(String caminho) { this.caminho = caminho; }

    public boolean isPrincipal() { return principal; }
    public void setPrincipal(boolean principal) { this.principal = principal; }

    public Date getDataUpload() { return dataUpload; }
    public void setDataUpload(Date dataUpload) { this.dataUpload = dataUpload; }

    // Métodos auxiliares
    public String getCaminhoCompleto() {
        return caminho + "/" + nomeArquivo;
    }

    public String getTipoArquivo() {
        if (nomeArquivo != null && nomeArquivo.contains(".")) {
            return nomeArquivo.substring(nomeArquivo.lastIndexOf(".") + 1).toLowerCase();
        }
        return "";
    }

    public boolean isImagem() {
        String tipo = getTipoArquivo();
        return tipo.equals("jpg") || tipo.equals("jpeg") || tipo.equals("png") ||
                tipo.equals("gif") || tipo.equals("bmp") || tipo.equals("webp");
    }

    @Override
    public String toString() {
        return "ImagemProduto [id=" + id + ", nomeArquivo=" + nomeArquivo +
                ", principal=" + principal + ", produtoId=" + (produto != null ? produto.getId() : "null") + "]";
    }
}