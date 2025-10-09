package br.com.bytx.model.carrinho;

import br.com.bytx.model.produto.Produto;
import java.math.BigDecimal;

public class ItemCarrinho {
    private Long id;
    private Produto produto;
    private int quantidade;
    private BigDecimal precoUnitario;

    // Construtores
    public ItemCarrinho() {}

    public ItemCarrinho(Produto produto, int quantidade) {
        this.produto = produto;
        this.quantidade = quantidade;
        this.precoUnitario = produto.getPreco();
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Produto getProduto() { return produto; }
    public void setProduto(Produto produto) {
        this.produto = produto;
        if (produto != null && this.precoUnitario == null) {
            this.precoUnitario = produto.getPreco();
        }
    }

    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public BigDecimal getPrecoUnitario() { return precoUnitario; }
    public void setPrecoUnitario(BigDecimal precoUnitario) {
        this.precoUnitario = precoUnitario;
    }

    // Métodos de negócio
    public BigDecimal getSubtotal() {
        if (precoUnitario == null || quantidade == 0) {
            return BigDecimal.ZERO;
        }
        return precoUnitario.multiply(new BigDecimal(quantidade));
    }

    public void incrementarQuantidade() {
        this.quantidade++;
    }

    public void incrementarQuantidade(int quantidade) {
        this.quantidade += quantidade;
    }

    public void decrementarQuantidade() {
        if (this.quantidade > 1) {
            this.quantidade--;
        }
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        ItemCarrinho that = (ItemCarrinho) obj;
        return produto != null && produto.getId() != null &&
                produto.getId().equals(that.getProduto().getId());
    }

    @Override
    public int hashCode() {
        return produto != null && produto.getId() != null ?
                produto.getId().hashCode() : 0;
    }
}