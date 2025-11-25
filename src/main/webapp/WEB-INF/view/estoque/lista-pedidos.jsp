<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="br.com.bytx.model.Usuario" %>
<%
    if (session == null || session.getAttribute("usuarioLogado") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (!usuario.isEstoquista()) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?erro=Acesso negado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Pedidos - Estoquista BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Mantenha todo o CSS do dashboard que você já tem */
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
            background: linear-gradient(135deg, #28a745, #20c997);
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
            display: flex;
            align-items: center;
        }

        .sidebar-menu li.active {
            background: #f0f7ff;
            border-left: 4px solid #28a745;
            color: #28a745;
        }

        .sidebar-menu i {
            margin-right: 10px;
        }

        .main-content {
            flex: 1;
            padding: 30px;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 2rem;
            color: #28a745;
            margin-bottom: 10px;
        }

        .page-subtitle {
            color: #666;
            font-size: 1.1rem;
        }

        /* ESTILOS ESPECÍFICOS DA LISTA DE PEDIDOS */
        .pedidos-table {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .table-header {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr auto;
            gap: 15px;
            padding: 15px 20px;
            background: #28a745;
            color: white;
            font-weight: 600;
        }

        .pedido-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr auto;
            gap: 15px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }

        .pedido-row:hover {
            background: #f8f9fa;
        }

        .pedido-row:last-child {
            border-bottom: none;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            text-align: center;
        }

        .status-aguardando_pagamento {
            background: #fff3cd;
            color: #856404;
        }

        .status-pagamento_rejeitado {
            background: #f8d7da;
            color: #721c24;
        }

        .status-pagamento_sucesso {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-aguardando_retirada {
            background: #fff3cd;
            color: #856404;
        }

        .status-em_transito {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-entregue {
            background: #d4edda;
            color: #155724;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #28a745;
            color: white;
        }

        .btn-primary:hover {
            background: #218838;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <i class="fas fa-boxes"></i>
            <span>Sistema BytX - Estoquista</span>
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=<%= usuario.getNome() %>&background=28a745&color=fff" alt="User">
            <span><%= usuario.getNome() %> (Estoquista)</span>
            <form action="${pageContext.request.contextPath}/logout" method="get">
                <button type="submit" class="logout-btn">Sair <i class="fas fa-sign-out-alt"></i></button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/estoque/produtos" style="text-decoration: none; color: inherit;"><i class="fas fa-boxes"></i> Gerenciar Estoque</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/estoque/pedidos" style="text-decoration: none; color: inherit;"><i class="fas fa-clipboard-list"></i> Gerenciar Pedidos</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-clipboard-list"></i> Gerenciar Pedidos
                </h1>
                <p class="page-subtitle">Visualize e atualize o status dos pedidos</p>
            </div>

            <!-- Mensagens -->
            <c:if test="${not empty sucesso}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${sucesso}
                </div>
            </c:if>

            <c:if test="${not empty erro}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${erro}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty pedidos && !pedidos.isEmpty()}">
                    <div class="pedidos-table">
                        <!-- Cabeçalho da tabela -->
                        <div class="table-header">
                            <div>Data do Pedido</div>
                            <div>Número do Pedido</div>
                            <div>Valor Total</div>
                            <div>Status</div>
                            <div>Ações</div>
                        </div>

                        <!-- Linhas dos pedidos -->
                        <c:forEach var="pedido" items="${pedidos}">
                            <div class="pedido-row">
                                <div>
                                    <c:if test="${not empty pedido.dataCriacao}">
                                        <fmt:parseDate value="${pedido.dataCriacao}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                        <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:if>
                                </div>
                                <div><strong>#${pedido.numeroPedido}</strong></div>
                                <div>R$ <fmt:formatNumber value="${pedido.total}" pattern="#,##0.00"/></div>
                                <div>
                                    <span class="status-badge status-${pedido.status}">
                                        ${pedido.statusFormatado}
                                    </span>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/estoque/pedidos/editar?id=${pedido.id}" class="btn btn-primary">
                                        <i class="fas fa-edit"></i> Editar
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-clipboard-list"></i>
                        <h3>Nenhum pedido encontrado</h3>
                        <p>Não há pedidos para gerenciar no momento.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>