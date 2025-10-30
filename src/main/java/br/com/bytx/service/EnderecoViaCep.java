package br.com.bytx.service;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EnderecoViaCep {

    private String cep;
    private String logradouro;
    private String complemento;
    private String bairro;
    private String localidade;
    private String uf;

    @JsonProperty("estado")
    private String estado;

    @JsonProperty("cidade")
    private String cidade;

    @JsonProperty("street")
    private String street;

    @JsonProperty("neighborhood")
    private String neighborhood;

    @JsonProperty("city")
    private String city;

    @JsonProperty("state")
    private String state;

    private boolean erro;

    // Getters e Setters
    public String getCep() {
        return cep != null ? cep.replaceAll("[^0-9-]", "") : null;
    }
    public void setCep(String cep) { this.cep = cep; }

    public String getLogradouro() {
        if (logradouro != null) return logradouro;
        if (street != null) return street;
        return null;
    }
    public void setLogradouro(String logradouro) { this.logradouro = logradouro; }

    public String getComplemento() { return complemento; }
    public void setComplemento(String complemento) { this.complemento = complemento; }

    public String getBairro() {
        if (bairro != null) return bairro;
        if (neighborhood != null) return neighborhood;
        return null;
    }
    public void setBairro(String bairro) { this.bairro = bairro; }

    public String getLocalidade() {
        if (localidade != null) return localidade;
        if (cidade != null) return cidade;
        if (city != null) return city;
        return null;
    }
    public void setLocalidade(String localidade) { this.localidade = localidade; }

    public String getUf() {
        if (uf != null) return uf;
        if (estado != null) return estado;
        if (state != null) return state;
        return null;
    }
    public void setUf(String uf) { this.uf = uf; }

    public boolean isErro() { return erro; }
    public void setErro(boolean erro) { this.erro = erro; }

    // Método para verificar se o endereço é válido
    public boolean isValido() {
        return getLogradouro() != null &&
                getBairro() != null &&
                getLocalidade() != null &&
                getUf() != null;
    }

    @Override
    public String toString() {
        return "EnderecoViaCep{" +
                "cep='" + getCep() + '\'' +
                ", logradouro='" + getLogradouro() + '\'' +
                ", bairro='" + getBairro() + '\'' +
                ", cidade='" + getLocalidade() + '\'' +
                ", uf='" + getUf() + '\'' +
                '}';
    }
}