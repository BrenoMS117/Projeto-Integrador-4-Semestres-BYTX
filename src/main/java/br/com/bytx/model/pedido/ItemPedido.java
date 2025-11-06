package br.com.bytx.model.pedido;

import br.com.bytx.model.produto.Produto;
import java.math.BigDecimal;

public class ItemPedido {
    private Long id;
    private Long pedidoId;
    private Long produtoId;
    private Produto produto;
    private int quantidade;
    private BigDecimal precoUnitario;
    private BigDecimal subtotal;

    // Construtores
    public ItemPedido() {}

    public ItemPedido(Long produtoId, int quantidade, BigDecimal precoUnitario) {
        this.produtoId = produtoId;
        this.quantidade = quantidade;
        this.precoUnitario = precoUnitario;
        calcularSubtotal();
    }

    // Getters e Setters COMPLETOS
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getPedidoId() { return pedidoId; }
    public void setPedidoId(Long pedidoId) { this.pedidoId = pedidoId; }

    public Long getProdutoId() { return produtoId; }
    public void setProdutoId(Long produtoId) { this.produtoId = produtoId; }

    public Produto getProduto() { return produto; }
    public void setProduto(Produto produto) { this.produto = produto; }

    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
        calcularSubtotal();
    }

    public BigDecimal getPrecoUnitario() { return precoUnitario; }
    public void setPrecoUnitario(BigDecimal precoUnitario) {
        this.precoUnitario = precoUnitario;
        calcularSubtotal();
    }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    // Métodos de negócio
    public void calcularSubtotal() {
        if (precoUnitario != null && quantidade > 0) {
            this.subtotal = precoUnitario.multiply(new BigDecimal(quantidade));
        } else {
            this.subtotal = BigDecimal.ZERO;
        }
    }
}