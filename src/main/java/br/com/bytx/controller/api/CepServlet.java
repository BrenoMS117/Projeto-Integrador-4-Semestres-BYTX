package br.com.bytx.controller.api;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@WebServlet("/cep-api/*")
public class CepServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ CepServlet INICIALIZADO com sucesso!");
        System.out.println("✅ Mapeado para: /cep-api/*");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🎯 CepServlet ACESSADO! URL: " + request.getRequestURL());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String pathInfo = request.getPathInfo();
            System.out.println("📞 PathInfo: " + pathInfo);

            if (pathInfo == null || pathInfo.length() < 2) {
                System.out.println("❌ CEP não informado");
                response.getWriter().write("{\"erro\": true, \"mensagem\": \"CEP não informado\"}");
                return;
            }

            String cep = pathInfo.substring(1);
            System.out.println("🔍 Consultando CEP: " + cep);

            // Consulta direta na ViaCEP
            String url = "https://viacep.com.br/ws/" + cep + "/json/";
            System.out.println("🌐 Fazendo request para: " + url);

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .build();

            HttpResponse<String> httpResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());

            System.out.println("✅ Resposta recebida: " + httpResponse.body());
            response.getWriter().write(httpResponse.body());

        } catch (Exception e) {
            System.out.println("❌ ERRO no CepServlet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"erro\": true, \"mensagem\": \"Erro: " + e.getMessage() + "\"}");
        }
    }
}