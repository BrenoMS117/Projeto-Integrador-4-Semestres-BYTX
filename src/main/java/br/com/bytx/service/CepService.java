package br.com.bytx.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class CepService {

    private static final String[] API_URLS = {
            "https://viacep.com.br/ws/%s/json/",
            "https://brasilapi.com.br/api/cep/v1/%s",
            "https://ws.apicep.com/cep/%s.json"
    };

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public CepService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    public EnderecoViaCep buscarEnderecoPorCep(String cep) {
        String cepLimpo = cep.replaceAll("[^0-9]", "");

        if (cepLimpo.length() != 8) {
            throw new IllegalArgumentException("CEP deve conter 8 dígitos");
        }

        // Tentar cada API até uma funcionar
        for (String apiUrl : API_URLS) {
            try {
                EnderecoViaCep endereco = consultarApi(apiUrl, cepLimpo);
                if (endereco != null && endereco.isValido()) {
                    return endereco;
                }
            } catch (Exception e) {
                System.out.println("Falha na API " + apiUrl + ": " + e.getMessage());
                // Continua para a próxima API
            }
        }

        throw new RuntimeException("Não foi possível consultar o CEP em nenhuma API");
    }

    private EnderecoViaCep consultarApi(String apiUrl, String cep) throws Exception {
        String url = String.format(apiUrl, cep);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(5))
                .header("Accept", "application/json")
                .GET()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            return null;
        }

        return objectMapper.readValue(response.body(), EnderecoViaCep.class);
    }
}