package br.com.bytx.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

//@WebFilter("/*")
public class AuthFilter implements Filter {

    public void init(FilterConfig config) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        System.out.println("Acessando URL: " + path);

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