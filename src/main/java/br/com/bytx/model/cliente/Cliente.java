package br.com.bytx.model.cliente;

import br.com.bytx.model.cliente.Endereco;;
import br.com.bytx.model.Usuario;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Cliente {
    private Long id;
    private Long usuarioId;
    private Usuario usuario;
    private LocalDate dataNascimento;
    private String genero;
    private LocalDateTime dataCadastro;
    private List<Endereco> enderecos = new ArrayList<>();

    // Construtores
    public Cliente() {}

    public Cliente(Usuario usuario, LocalDate dataNascimento, String genero) {
        this.usuario = usuario;
        this.dataNascimento = dataNascimento;
        this.genero = genero;
        this.dataCadastro = LocalDateTime.now();
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public LocalDate getDataNascimento() { return dataNascimento; }
    public void setDataNascimento(LocalDate dataNascimento) { this.dataNascimento = dataNascimento; }

    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }

    public List<Endereco> getEnderecos() { return enderecos; }
    public void setEnderecos(List<Endereco> enderecos) { this.enderecos = enderecos; }

    // Métodos auxiliares
    public Endereco getEnderecoFaturamento() {
        return enderecos.stream()
                .filter(e -> "FATURAMENTO".equals(e.getTipo()))
                .findFirst()
                .orElse(null);
    }

    public Endereco getEnderecoEntregaPadrao() {
        return enderecos.stream()
                .filter(e -> "ENTREGA".equals(e.getTipo()) && e.isPadrao())
                .findFirst()
                .orElse(null);
    }
}