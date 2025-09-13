package br.com.bytx.model;

public class Usuario {
    private Long id;
    private String nome;
    private String cpf;
    private String email;
    private String senha;
    private String grupo; // "ADMIN" ou "ESTOQUISTA"
    private boolean ativo;

    // Construtores
    public Usuario() {}

    public Usuario(String nome, String cpf, String email, String senha, String grupo) {
        this.nome = nome;
        this.cpf = cpf;
        this.email = email;
        this.senha = senha;
        this.grupo = grupo;
        this.ativo = true;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public String getGrupo() { return grupo; }
    public void setGrupo(String grupo) { this.grupo = grupo; }

    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }

    public boolean isAdministrador() {
        return "ADMIN".equalsIgnoreCase(this.grupo);
    }

    public boolean isEstoquista() {
        return "ESTOQUISTA".equalsIgnoreCase(this.grupo);
    }

    @Override
    public String toString() {
        return "Usuario [id=" + id + ", nome=" + nome + ", email=" + email + ", grupo=" + grupo + ", ativo=" + ativo + "]";
    }
}