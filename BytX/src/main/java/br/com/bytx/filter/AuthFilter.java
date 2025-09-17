package br.com.bytx.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

//@WebFilter("/*")

//Filter usado para o controle de acesso e logs.
public class AuthFilter implements Filter {

    //incluir configuração
    public void init(FilterConfig config) throws ServletException {} //executado ao inicializar

    //Método principal da classe
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        //converte o valor destinado
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        //Retorno da url completa e remove o contexto da aplicação "/bytx".
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        System.out.println("Acessando URL: " + path);

        //Caminhos que não é necessário ter login de acesso
        if (path.equals("/login") ||
                path.startsWith("/console") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/teste") ||
                path.equals("/acesso-livre.jsp") ||
                path.equals("/index.jsp") ||
                path.equals("/")) {

            System.out.println("✅ URL pública, permitindo acesso: " + path);
            chain.doFilter(request, response);
            return;
        }

    }
    public void destroy() {}
}