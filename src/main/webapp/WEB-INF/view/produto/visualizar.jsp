<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="br.com.bytx.model.Usuario" %>
<%
    // Verificar se o usuário está logado
    if (session == null || session.getAttribute("usuarioLogado") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualizar Produto - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
        }

        .header {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .logo i {
            margin-right: 10px;
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid white;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            margin-left: 15px;
            cursor: pointer;
        }

        .container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 250px;
            background: white;
            padding: 20px 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            padding: 15px 20px;
            border-left: 4px solid transparent;
            cursor: pointer;
        }

        .sidebar-menu li.active {
            background: #f0f7ff;
            border-left: 4px solid #3a7bd5;
            color: #3a7bd5;
        }

        .sidebar-menu i {
            margin-right: 10px;
        }

        .main-content {
            flex: 1;
            padding: 30px;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .btn-primary {
            background: #3a7bd5;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            margin: 5px;
        }

        .btn-submit {
            background: #3a7bd5;
            color: white;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .product-view-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .product-header {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
        }

        .product-image-section {
            flex: 1;
        }

        .main-image {
            width: 100%;
            max-width: 400px;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .product-info-section {
            flex: 2;
        }

        .product-title {
            font-size: 24px;
            color: #3a7bd5;
            margin-bottom: 10px;
        }

        .product-price {
            font-size: 28px;
            color: #28a745;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .product-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .meta-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
        }

        .meta-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .meta-value {
            font-size: 16px;
            font-weight: 500;
        }

        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 10px;
        }

        .debug-info {
            background: #fff3cd;
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
            border: 1px solid #ffc107;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <i class="fas fa-rocket"></i>
            <span>Sistema BytX</span>
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=<%= usuario.getNome() %>&background=3a7bd5&color=fff" alt="User">
            <span><%= usuario.getNome() %></span>
            <form action="${pageContext.request.contextPath}/logout" method="get" style="display: inline;">
                <button type="submit" class="logout-btn">Sair <i class="fas fa-sign-out-alt"></i></button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" style="text-decoration: none; color: inherit;"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><i class="fas fa-chart-bar"></i> Relatórios</li>
                <li class="active"><i class="fas fa-tag"></i> Produtos</li>
                <li><a href="${pageContext.request.contextPath}/admin/usuarios" style="text-decoration: none; color: inherit;"><i class="fas fa-users"></i> Gerenciar Usuários</a></li>
                <li><i class="fas fa-cog"></i> Configurações</li>
            </ul>
        </div>

        <div class="main-content">
            <div class="content-header">
                <h1>Visualizar Produto</h1>
                <a href="${pageContext.request.contextPath}/produto/listar" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Voltar para Lista
                </a>
            </div>

            <c:if test="${produto == null}">
                <div style="background: #f8d7da; color: #721c24; padding: 20px; border-radius: 5px; text-align: center;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Produto não encontrado</h3>
                    <p>O produto solicitado não foi encontrado no sistema.</p>
                    <a href="${pageContext.request.contextPath}/produto/listar" class="btn btn-cancel">
                        Voltar para a Lista
                    </a>
                </div>
            </c:if>

            <c:if test="${produto != null}">
                <div class="product-view-container">
                    <div class="product-header">
                        <div class="product-image-section">
                            <c:choose>
                                <c:when test="${not empty imagemPrincipal}">
                                    <img src="${pageContext.request.contextPath}${imagemPrincipal.caminho}/${imagemPrincipal.nomeArquivo}"
                                         alt="${produto.nome}" class="main-image"
                                         onerror="this.src='https://via.placeholder.com/400x300?text=Imagem+Não+Encontrada'">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/400x300?text=Sem+Imagem"
                                         alt="${produto.nome}" class="main-image">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="product-info-section">
                            <h1 class="product-title">${produto.nome}</h1>
                            <div class="product-price">R$ <fmt:formatNumber value="${produto.preco}" pattern="#,##0.00"/></div>

                            <div class="product-meta">
                                <div class="meta-item">
                                    <div class="meta-label">Código</div>
                                    <div class="meta-value">#${produto.id}</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Estoque</div>
                                    <div class="meta-value">${produto.quantidadeEstoque} unidades</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Status</div>
                                    <div class="meta-value">
                                        <span style="color: ${produto.ativo ? '#28a745' : '#dc3545'};">
                                            ${produto.ativo ? 'Ativo' : 'Inativo'}
                                        </span>
                                    </div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Avaliação</div>
                                    <div class="meta-value">${produto.avaliacao}/5</div>
                                </div>
                            </div>

                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/produto/gerenciar?id=${produto.id}&acao=editar"
                                   class="btn btn-submit">
                                    <i class="fas fa-edit"></i> Editar
                                </a>
                                <a href="${pageContext.request.contextPath}/produto/listar"
                                   class="btn btn-cancel">
                                    <i class="fas fa-list"></i> Voltar à Lista
                                </a>
                            </div>
                        </div>
                    </div>

                    <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                        <h3>Descrição do Produto</h3>
                        <p style="margin-top: 10px; line-height: 1.6;">
                            <c:choose>
                                <c:when test="${not empty produto.descricao}">
                                    ${produto.descricao}
                                </c:when>
                                <c:otherwise>
                                    <em>Nenhuma descrição fornecida.</em>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>