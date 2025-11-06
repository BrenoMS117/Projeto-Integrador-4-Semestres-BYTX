<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Pedidos - BytX</title>
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
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .page-title {
            font-size: 2.2rem;
            color: #3a7bd5;
            margin-bottom: 10px;
        }

        .page-subtitle {
            color: #666;
            font-size: 1.1rem;
        }

        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-card {
            border: 2px solid #f0f7ff;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
            background: white;
        }

        .order-card:hover {
            border-color: #3a7bd5;
            box-shadow: 0 4px 12px rgba(58, 123, 213, 0.1);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .order-info {
            flex: 1;
        }

        .order-number {
            font-size: 1.2rem;
            font-weight: 700;
            color: #3a7bd5;
            margin-bottom: 5px;
        }

        .order-date {
            color: #666;
            font-size: 0.9rem;
        }

        .order-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-aguardando_pagamento {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-pago {
            background: #d1edff;
            color: #004085;
            border: 1px solid #b3d7ff;
        }

        .status-enviado {
            background: #d1f2eb;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-entregue {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-cancelado {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .order-details {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 15px;
            align-items: center;
        }

        @media (max-width: 768px) {
            .order-details {
                grid-template-columns: 1fr;
                gap: 10px;
            }
        }

        .order-items {
            color: #666;
        }

        .order-total {
            text-align: right;
            font-weight: 700;
            color: #28a745;
            font-size: 1.1rem;
        }

        .order-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            flex-wrap: wrap;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .btn-primary {
            background: #3a7bd5;
            color: white;
        }

        .btn-primary:hover {
            background: #2d62b3;
        }

        .btn-outline {
            background: transparent;
            color: #3a7bd5;
            border: 1px solid #3a7bd5;
        }

        .btn-outline:hover {
            background: #3a7bd5;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .empty-icon {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/shared/header.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-clipboard-list"></i> Meus Pedidos
            </h1>
            <p class="page-subtitle">Acompanhe o histórico e status dos seus pedidos</p>
        </div>

        <!-- Mensagens -->
        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${erro}
            </div>
        </c:if>

        <c:if test="${not empty mensagemSucesso}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${mensagemSucesso}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty pedidos && !pedidos.isEmpty()}">
                <div class="orders-list">
                    <c:forEach var="pedido" items="${pedidos}">
                        <div class="order-card">
                            <div class="order-header">
                                <div class="order-info">
                                    <div class="order-number">Pedido #${pedido.numeroPedido}</div>
                                    <div class="order-date">
                                        <c:if test="${not empty pedido.dataCriacao}">
                                            <fmt:parseDate value="${pedido.dataCriacao}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                            <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                        </c:if>
                                        <c:if test="${empty pedido.dataCriacao}">
                                            Data não disponível
                                        </c:if>
                                    </div>
                                </div>

                                <div class="order-status status-${pedido.status}">
                                    ${pedido.statusFormatado}
                                </div>
                            </div>

                            <div class="order-details">
                                <div class="order-items">
                                    <strong>Itens:</strong> ${pedido.itens.size()} produto(s)
                                    <div style="font-size: 0.9rem; color: #888; margin-top: 5px;">
                                        <c:forEach var="item" items="${pedido.itens}" varStatus="status">
                                            ${item.produto.nome}<c:if test="${!status.last}">, </c:if>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="order-total">
                                    R$ <fmt:formatNumber value="${pedido.total}" pattern="#,##0.00"/>
                                </div>

                                <div class="order-actions">
                                    <a href="#" class="btn btn-outline">
                                        <i class="fas fa-eye"></i> Detalhes
                                    </a>

                                    <c:if test="${pedido.podeSerCancelado()}">
                                        <button class="btn btn-outline"
                                                onclick="cancelarPedido(${pedido.id}, '${pedido.numeroPedido}')"
                                                style="color: #dc3545; border-color: #dc3545;">
                                            <i class="fas fa-times"></i> Cancelar
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <h3 class="empty-title">Nenhum pedido encontrado</h3>
                    <p>Você ainda não fez nenhum pedido em nossa loja.</p>

                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                            <i class="fas fa-store"></i> Fazer Minha Primeira Compra
                        </a>

                        <a href="${pageContext.request.contextPath}/cliente/perfil" class="btn btn-outline">
                            <i class="fas fa-user"></i> Meu Perfil
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function cancelarPedido(pedidoId, numeroPedido) {
            if (confirm('Tem certeza que deseja cancelar o pedido #' + numeroPedido + '?')) {
                alert('Funcionalidade de cancelamento será implementada em breve!');
            }
        }
    </script>
</body>
</html>