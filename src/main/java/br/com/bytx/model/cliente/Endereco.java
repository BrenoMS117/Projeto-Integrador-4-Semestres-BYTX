package br.com.bytx.model.cliente;

import java.time.LocalDateTime;

public class Endereco {
    private Long id;
    private Long clienteId;
    private String tipo; // FATURAMENTO ou ENTREGA
    private String cep;
    private String logradouro;
    private String numero;
    private String complemento;
    private String bairro;
    private String cidade;
    private String uf;
    private boolean padrao;
    private boolean ativado;
    private LocalDateTime dataCriacao;

    // Construtores
    public Endereco() {}

    public Endereco(String tipo, String cep, String logradouro, String numero,
                    String bairro, String cidade, String uf) {
        this.tipo = tipo;
        this.cep = cep;
        this.logradouro = logradouro;
        this.numero = numero;
        this.bairro = bairro;
        this.cidade = cidade;
        this.uf = uf;
        this.padrao = false;
        this.ativado = true;
        this.dataCriacao = LocalDateTime.now();
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getClienteId() { return clienteId; }
    public void setClienteId(Long clienteId) { this.clienteId = clienteId; }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getLogradouro() { return logradouro; }
    public void setLogradouro(String logradouro) { this.logradouro = logradouro; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public String getComplemento() { return complemento; }
    public void setComplemento(String complemento) { this.complemento = complemento; }

    public String getBairro() { return bairro; }
    public void setBairro(String bairro) { this.bairro = bairro; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getUf() { return uf; }
    public void setUf(String uf) { this.uf = uf; }

    public boolean isPadrao() { return padrao; }
    public void setPadrao(boolean padrao) { this.padrao = padrao; }

    public boolean isAtivado() { return ativado; }
    public void setAtivado(boolean ativado) { this.ativado = ativado; }

    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }

    @Override
    public String toString() {
        return String.format("%s, %s - %s, %s - %s", logradouro, numero, bairro, cidade, uf);
    }
}