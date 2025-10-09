<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="br.com.bytx.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    boolean isAdmin = usuario != null && usuario.isAdministrador();
    br.com.bytx.model.carrinho.Carrinho carrinho = (br.com.bytx.model.carrinho.Carrinho) session.getAttribute("carrinho");
    int quantidadeItens = carrinho != null ? carrinho.getQuantidadeTotalItens() : 0;
%>

<style>
    /* COLE AQUI O CSS SIMPLES QUE JÁ FUNCIONOU */
    .header {
        background: linear-gradient(135deg, #3a7bd5, #00d2ff);
        color: white;
        padding: 15px 0;
    }
    .header-container {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;
    }
    .logo {
        display: flex;
        align-items: center;
        gap: 10px;
        text-decoration: none;
        color: white;
        font-size: 24px;
        font-weight: bold;
    }
    .nav-links {
        display: flex;
        gap: 20px;
    }
    .nav-link {
        color: white;
        text-decoration: none;
        padding: 8px 16px;
    }
    .user-section {
        display: flex;
        align-items: center;
        gap: 15px;
    }
    .cart-icon {
        color: white;
        text-decoration: none;
        position: relative;
    }
    .cart-count {
        background: #ff4757;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 12px;
        position: absolute;
        top: -8px;
        right: -8px;
    }
</style>

<header class="header">
    <div class="header-container">
        <a href="${pageContext.request.contextPath}/" class="logo">
            <i class="fas fa-rocket"></i>
            <span>BytX Store</span>
        </a>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/" class="nav-link">
                <i class="fas fa-home"></i> Início
            </a>
            <a href="${pageContext.request.contextPath}/" class="nav-link">
                <i class="fas fa-store"></i> Loja
            </a>
        </nav>

        <div class="user-section">
            <a href="${pageContext.request.contextPath}/carrinho" class="cart-icon">
                <i class="fas fa-shopping-cart"></i>
                <c:if test="<%= quantidadeItens > 0 %>">
                    <span class="cart-count"><%= quantidadeItens %></span>
                </c:if>
            </a>

            <c:choose>
                <c:when test="<%= usuario != null %>">
                    <span><%= usuario.getNome() %></span>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="nav-link">
                        <i class="fas fa-user"></i> Login
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>