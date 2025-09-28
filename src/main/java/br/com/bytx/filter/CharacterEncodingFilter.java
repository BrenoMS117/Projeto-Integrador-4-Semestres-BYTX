package br.com.bytx.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null) {
            encoding = encodingParam;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        // Configurar encoding antes de qualquer processamento
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        response.setContentType("text/html; charset=" + encoding);

        System.out.println("🔤 CharacterEncodingFilter aplicado - UTF-8");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup
    }
}