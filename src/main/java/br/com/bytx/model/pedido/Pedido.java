package br.com.bytx.model.pedido;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Pedido {
    private Long id;
    private String numeroPedido;
    private Long clienteId;
    private Long enderecoEntregaId;
    private String formaPagamento;
    private String detalhesPagamento;
    private String status; // aguardando_pagamento, pago, enviado, entregue, cancelado
    private BigDecimal subtotal;
    private BigDecimal frete;
    private BigDecimal total;
    private LocalDateTime dataCriacao;
    private List<ItemPedido> itens = new ArrayList<>();

    // Construtores
    public Pedido() {
        this.status = "aguardando_pagamento";
        this.dataCriacao = LocalDateTime.now();
    }

    // Getters e Setters COMPLETOS
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNumeroPedido() { return numeroPedido; }
    public void setNumeroPedido(String numeroPedido) { this.numeroPedido = numeroPedido; }

    public Long getClienteId() { return clienteId; }
    public void setClienteId(Long clienteId) { this.clienteId = clienteId; }

    public Long getEnderecoEntregaId() { return enderecoEntregaId; }
    public void setEnderecoEntregaId(Long enderecoEntregaId) { this.enderecoEntregaId = enderecoEntregaId; }

    public String getFormaPagamento() { return formaPagamento; }
    public void setFormaPagamento(String formaPagamento) { this.formaPagamento = formaPagamento; }

    public String getDetalhesPagamento() { return detalhesPagamento; }
    public void setDetalhesPagamento(String detalhesPagamento) { this.detalhesPagamento = detalhesPagamento; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getFrete() { return frete; }
    public void setFrete(BigDecimal frete) { this.frete = frete; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }

    public List<ItemPedido> getItens() { return itens; }
    public void setItens(List<ItemPedido> itens) { this.itens = itens; }

    // Métodos de negócio
    public void calcularTotal() {
        this.subtotal = BigDecimal.ZERO;
        if (itens != null) {
            for (ItemPedido item : itens) {
                if (item.getSubtotal() != null) {
                    this.subtotal = this.subtotal.add(item.getSubtotal());
                }
            }
        }
        this.total = this.subtotal.add(frete != null ? frete : BigDecimal.ZERO);
    }

    public boolean podeSerCancelado() {
        return "aguardando_pagamento".equals(status) || "pago".equals(status);
    }

    public String getStatusFormatado() {
        switch (status) {
            case "aguardando_pagamento": return "Aguardando Pagamento";
            case "pago": return "Pago";
            case "enviado": return "Enviado";
            case "entregue": return "Entregue";
            case "cancelado": return "Cancelado";
            default: return status;
        }
    }
}