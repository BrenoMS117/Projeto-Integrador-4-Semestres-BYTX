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
        border-radius: 4px;
        transition: background-color 0.3s;
    }
    .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
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
        padding: 8px;
        border-radius: 4px;
        transition: background-color 0.3s;
    }
    .cart-icon:hover {
        background-color: rgba(255, 255, 255, 0.1);
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
    .user-menu {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .user-name {
        color: white;
        font-weight: 500;
    }
    .logout-btn {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.3);
        padding: 6px 12px;
        border-radius: 4px;
        cursor: pointer;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.3s;
    }
    .logout-btn:hover {
        background: rgba(255, 255, 255, 0.3);
    }
    .account-btn {
        background: rgba(255, 255, 255, 0.1);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 6px 12px;
        border-radius: 4px;
        cursor: pointer;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.3s;
    }
    .account-btn:hover {
        background: rgba(255, 255, 255, 0.2);
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
                    <div class="user-menu">
                        <span class="user-name">
                            <i class="fas fa-user"></i> Olá, <%= usuario.getNome() %>
                        </span>

                        <!-- Botão Minha Conta (só para clientes) -->
                        <c:if test="<%= usuario.isCliente() %>">
                            <a href="${pageContext.request.contextPath}/cliente/perfil" class="account-btn">
                                <i class="fas fa-cog"></i> Minha Conta
                            </a>
                        </c:if>

                        <!-- Botão Logout -->
                        <a href="${pageContext.request.contextPath}/logout"
                           class="logout-btn"
                           onclick="return confirm('Tem certeza que deseja sair?')">
                            <i class="fas fa-sign-out-alt"></i> Sair
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Usuário não logado -->
                    <a href="${pageContext.request.contextPath}/login" class="nav-link">
                        <i class="fas fa-sign-in-alt"></i> Entrar
                    </a>
                    <a href="${pageContext.request.contextPath}/cadastro-cliente" class="nav-link">
                        <i class="fas fa-user-plus"></i> Cadastrar
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>