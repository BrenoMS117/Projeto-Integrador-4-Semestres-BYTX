package br.com.bytx.model.carrinho;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class Carrinho {
    private Long id;
    private Long usuarioId; // null para usuários não logados
    private List<ItemCarrinho> itens;
    private String sessionId; // para usuários não logados

    // Construtores
    public Carrinho() {
        this.itens = new ArrayList<>();
    }

    public Carrinho(Long usuarioId) {
        this();
        this.usuarioId = usuarioId;
    }

    public Carrinho(String sessionId) {
        this();
        this.sessionId = sessionId;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public List<ItemCarrinho> getItens() { return itens; }
    public void setItens(List<ItemCarrinho> itens) { this.itens = itens; }

    // Métodos de negócio
    public void adicionarItem(ItemCarrinho novoItem) {
        Optional<ItemCarrinho> itemExistente = itens.stream()
                .filter(item -> item.equals(novoItem))
                .findFirst();

        if (itemExistente.isPresent()) {
            itemExistente.get().incrementarQuantidade(novoItem.getQuantidade());
        } else {
            itens.add(novoItem);
        }
    }

    public void removerItem(Long produtoId) {
        itens.removeIf(item ->
                item.getProduto() != null &&
                        produtoId.equals(item.getProduto().getId())
        );
    }

    public void atualizarQuantidade(Long produtoId, int novaQuantidade) {
        itens.stream()
                .filter(item -> item.getProduto() != null &&
                        produtoId.equals(item.getProduto().getId()))
                .findFirst()
                .ifPresent(item -> {
                    if (novaQuantidade <= 0) {
                        removerItem(produtoId);
                    } else {
                        item.setQuantidade(novaQuantidade);
                    }
                });
    }

    public void incrementarQuantidade(Long produtoId) {
        itens.stream()
                .filter(item -> item.getProduto() != null &&
                        produtoId.equals(item.getProduto().getId()))
                .findFirst()
                .ifPresent(ItemCarrinho::incrementarQuantidade);
    }

    public void decrementarQuantidade(Long produtoId) {
        itens.stream()
                .filter(item -> item.getProduto() != null &&
                        produtoId.equals(item.getProduto().getId()))
                .findFirst()
                .ifPresent(item -> {
                    if (item.getQuantidade() > 1) {
                        item.decrementarQuantidade();
                    } else {
                        removerItem(produtoId);
                    }
                });
    }

    public int getQuantidadeTotalItens() {
        return itens.stream()
                .mapToInt(ItemCarrinho::getQuantidade)
                .sum();
    }

    public BigDecimal getSubtotal() {
        return itens.stream()
                .map(ItemCarrinho::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal getTotalComFrete(BigDecimal frete) {
        if (frete == null) {
            return getSubtotal();
        }
        return getSubtotal().add(frete);
    }

    public boolean estaVazio() {
        return itens.isEmpty();
    }

    public void limpar() {
        itens.clear();
    }

    public ItemCarrinho getItemPorProdutoId(Long produtoId) {
        return itens.stream()
                .filter(item -> item.getProduto() != null &&
                        produtoId.equals(item.getProduto().getId()))
                .findFirst()
                .orElse(null);
    }

    public boolean contemProduto(Long produtoId) {
        return itens.stream()
                .anyMatch(item -> item.getProduto() != null &&
                        produtoId.equals(item.getProduto().getId()));
    }
}