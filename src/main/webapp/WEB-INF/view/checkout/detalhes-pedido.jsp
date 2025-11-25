<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalhes do Pedido #${pedido.numeroPedido} - BytX</title>
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

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
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

        .card-title {
            font-size: 1.3rem;
            color: #3a7bd5;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f7ff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .content-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        @media (max-width: 768px) {
            .content-layout {
                grid-template-columns: 1fr;
            }
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-outline {
            background: transparent;
            color: #3a7bd5;
            border: 2px solid #3a7bd5;
        }

        .btn-outline:hover {
            background: #3a7bd5;
            color: white;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding: 8px 0;
        }

        .summary-total {
            border-top: 2px solid #eee;
            padding-top: 15px;
            margin-top: 15px;
            font-size: 1.2rem;
            font-weight: 700;
            color: #28a745;
        }

        .order-item {
            display: flex;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            align-items: center;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
        }

        .item-details {
            flex: 1;
        }

        .item-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .item-price {
            color: #666;
            font-size: 0.9rem;
        }

        .item-quantity {
            color: #28a745;
            font-weight: 500;
        }

        .item-subtotal {
            font-weight: 600;
            color: #2c3e50;
            min-width: 100px;
            text-align: right;
        }

        .info-section {
            margin-bottom: 25px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .info-title {
            font-weight: 600;
            color: #3a7bd5;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 10px;
        }

        .status-aguardando_pagamento {
            background: #fff3cd;
            color: #856404;
        }

        .status-pago {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-enviado {
            background: #d4edda;
            color: #155724;
        }

        .status-entregue {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-cancelado {
            background: #f8d7da;
            color: #721c24;
        }

        .order-info-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f7ff;
        }

        .order-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: #3a7bd5;
        }

        .order-date {
            color: #666;
            font-size: 0.9rem;
        }

        .nav-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/shared/header.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-clipboard-list"></i> Detalhes do Pedido
            </h1>
            <p class="page-subtitle">Visualize todas as informações do seu pedido</p>
        </div>

        <!-- Mensagens -->
        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${erro}
            </div>
        </c:if>

        <div class="content-layout">
            <!-- Detalhes do Pedido -->
            <div class="card">
                <!-- Cabeçalho com número e status do pedido -->
                <div class="order-info-header">
                    <div>
                        <div class="order-number">Pedido #${pedido.numeroPedido}</div>
                        <div class="order-date">
                            <c:if test="${not empty pedido.dataCriacao}">
                                <fmt:parseDate value="${pedido.dataCriacao}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                Realizado em <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                            </c:if>
                        </div>
                    </div>
                    <div class="status-badge status-${pedido.status}">
                        ${pedido.statusFormatado}
                    </div>
                </div>

                <h3 class="card-title">
                    <i class="fas fa-shopping-bag"></i> Itens do Pedido
                </h3>

                <c:forEach var="item" items="${pedido.itens}">
                    <div class="order-item">
                      

                        <div class="item-details">
                            <div class="item-name">${item.produto.nome}</div>
                            <div class="item-price">
                                <span class="item-quantity">${item.quantidade}x</span>
                                R$ <fmt:formatNumber value="${item.precoUnitario}" pattern="#,##0.00"/> cada
                            </div>
                        </div>

                        <div class="item-subtotal">
                            R$ <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                        </div>
                    </div>
                </c:forEach>

                <!-- Informações de Entrega -->
                <div class="info-section">
                    <div class="info-title">
                        <i class="fas fa-truck"></i> Endereço de Entrega
                    </div>
                    <c:if test="${not empty enderecoEntrega}">
                        <div>
                            <strong>${enderecoEntrega.logradouro}, ${enderecoEntrega.numero}</strong>
                            <c:if test="${not empty enderecoEntrega.complemento}">
                                - ${enderecoEntrega.complemento}
                            </c:if>
                            <br>
                            ${enderecoEntrega.bairro} - ${enderecoEntrega.cidade}/${enderecoEntrega.uf}
                            <br>
                            CEP: ${enderecoEntrega.cep}
                        </div>
                    </c:if>
                </div>

                <!-- Informações de Pagamento -->
                <div class="info-section">
                    <div class="info-title">
                        <i class="fas fa-credit-card"></i> Forma de Pagamento
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${pedido.formaPagamento == 'cartao'}">
                                <strong>Cartão de Crédito</strong>
                                <c:if test="${not empty pedido.detalhesPagamento}">
                                    <br>${pedido.detalhesPagamento}
                                </c:if>
                            </c:when>
                            <c:when test="${pedido.formaPagamento == 'boleto'}">
                                <strong>Boleto Bancário</strong>
                            </c:when>
                            <c:when test="${pedido.formaPagamento == 'pix'}">
                                <strong>PIX</strong>
                            </c:when>
                            <c:otherwise>
                                ${pedido.formaPagamento}
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Ações -->
                <div class="nav-actions">
                    <a href="${pageContext.request.contextPath}/checkout/meus-pedidos" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Voltar para Meus Pedidos
                    </a>
                </div>
            </div>

            <!-- Resumo do Pedido -->
            <div class="card">
                <h3 class="card-title">
                    <i class="fas fa-receipt"></i> Resumo do Pedido
                </h3>

                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span>R$ <fmt:formatNumber value="${pedido.subtotal}" pattern="#,##0.00"/></span>
                </div>

                <div class="summary-row">
                    <span>Frete:</span>
                    <span>R$ <fmt:formatNumber value="${pedido.frete}" pattern="#,##0.00"/></span>
                </div>

                <div class="summary-row summary-total">
                    <span>Total do Pedido:</span>
                    <span>R$ <fmt:formatNumber value="${pedido.total}" pattern="#,##0.00"/></span>
                </div>

                <!-- Informações de Entrega -->
                <c:if test="${not empty pedido.dataCriacao}">
                    <div style="margin-top: 20px; padding: 15px; background: #f0fff4; border-radius: 6px; border-left: 4px solid #28a745;">
                        <div style="font-weight: 600; color: #28a745; margin-bottom: 5px;">
                            <i class="fas fa-calendar-check"></i> Data do Pedido
                        </div>
                        <div style="color: #666; font-size: 0.9rem;">
                            <fmt:parseDate value="${pedido.dataCriacao}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                            <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>