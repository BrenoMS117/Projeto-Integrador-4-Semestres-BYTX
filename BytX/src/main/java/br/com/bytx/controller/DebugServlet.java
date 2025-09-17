package br.com.bytx.controller;

import br.com.bytx.util.CriptografiaUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/debug")//Acessar via url
//Criada para um modo de debug
//Ferramenta de suporte
public class DebugServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        //Resposta em HTML e caracteres especiais apareçam corretamente
        request.setCharacterEncoding("UTF-8");

        System.out.println("=== MODO DEBUG ATIVADO ==="); //Log

        // Encaminhar para a página de debug (requisição)
        request.getRequestDispatcher("/WEB-INF/view/debug.jsp").forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Qualquer requisição feita é direcionada ao doGet.
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        doGet(request, response);
    }
}