<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedido Confirmado - BytX</title>
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

                .cart-layout {
                    display: grid;
                    grid-template-columns: 2fr 1fr;
                    gap: 30px;
                }

                @media (max-width: 768px) {
                    .cart-layout {
                        grid-template-columns: 1fr;
                    }
                }

                /* Lista de Itens */
                .cart-items {
                    background: white;
                    border-radius: 12px;
                    padding: 25px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                }

                .cart-item {
                    display: grid;
                    grid-template-columns: 100px 1fr auto auto;
                    gap: 15px;
                    padding: 20px 0;
                    border-bottom: 1px solid #eee;
                    align-items: center;
                }

                .cart-item:last-child {
                    border-bottom: none;
                }

                .item-image {
                    width: 80px;
                    height: 80px;
                    object-fit: cover;
                    border-radius: 8px;
                }

                .item-info {
                    flex: 1;
                }

                .item-name {
                    font-size: 1.1rem;
                    font-weight: 600;
                    color: #2c3e50;
                    margin-bottom: 5px;
                }

                .item-price {
                    font-size: 1rem;
                    color: #28a745;
                    font-weight: 500;
                }

                .quantity-controls {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .quantity-btn {
                    width: 35px;
                    height: 35px;
                    border: 1px solid #ddd;
                    background: white;
                    border-radius: 4px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.3s ease;
                }

                .quantity-btn:hover {
                    background: #f8f9fa;
                    border-color: #3a7bd5;
                }

                .quantity-input {
                    width: 60px;
                    height: 35px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    text-align: center;
                    font-weight: 500;
                }

                .item-subtotal {
                    font-size: 1.1rem;
                    font-weight: 600;
                    color: #2c3e50;
                    min-width: 100px;
                    text-align: right;
                }

                .remove-btn {
                    background: #dc3545;
                    color: white;
                    border: none;
                    width: 35px;
                    height: 35px;
                    border-radius: 4px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.3s ease;
                }

                .remove-btn:hover {
                    background: #c82333;
                }

                /* Resumo do Pedido */
                .order-summary {
                    background: white;
                    border-radius: 12px;
                    padding: 25px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    height: fit-content;
                    position: sticky;
                    top: 20px;
                }

                .summary-title {
                    font-size: 1.3rem;
                    font-weight: 600;
                    color: #2c3e50;
                    margin-bottom: 20px;
                    padding-bottom: 15px;
                    border-bottom: 2px solid #f8f9fa;
                }

                .summary-row {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 12px;
                    padding: 8px 0;
                }

                .summary-label {
                    color: #666;
                }

                .summary-value {
                    font-weight: 500;
                    color: #2c3e50;
                }

                .summary-total {
                    border-top: 2px solid #eee;
                    padding-top: 15px;
                    margin-top: 15px;
                    font-size: 1.2rem;
                    font-weight: 700;
                    color: #28a745;
                }

                /* Frete */
                .shipping-section {
                    margin: 20px 0;
                    padding: 15px;
                    background: #f8f9fa;
                    border-radius: 8px;
                }

                .shipping-title {
                    font-size: 1rem;
                    font-weight: 600;
                    margin-bottom: 10px;
                    color: #2c3e50;
                }

                .shipping-options {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }

                .shipping-option {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 8px;
                    border-radius: 4px;
                    cursor: pointer;
                    transition: background 0.3s ease;
                }

                .shipping-option:hover {
                    background: #e9ecef;
                }

                .shipping-option input[type="radio"] {
                    margin: 0;
                }

                .shipping-info {
                    flex: 1;
                }

                .shipping-type {
                    font-weight: 500;
                    color: #2c3e50;
                }

                .shipping-price {
                    font-weight: 600;
                    color: #28a745;
                }

                .shipping-time {
                    font-size: 0.8rem;
                    color: #666;
                }

                /* Botões */
                .cart-actions {
                    display: flex;
                    gap: 15px;
                    margin-top: 25px;
                    flex-wrap: wrap;
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
                    flex: 1;
                }

                .btn-primary {
                    background: #3a7bd5;
                    color: white;
                }

                .btn-primary:hover {
                    background: #2d62b3;
                }

                .btn-success {
                    background: #28a745;
                    color: white;
                }

                .btn-success:hover {
                    background: #218838;
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

                .btn-danger {
                    background: #dc3545;
                    color: white;
                }

                .btn-danger:hover {
                    background: #c82333;
                }

                /* Carrinho Vazio */
                .empty-cart {
                    text-align: center;
                    padding: 60px 20px;
                    color: #666;
                }

                .empty-cart-icon {
                    font-size: 4rem;
                    color: #ddd;
                    margin-bottom: 20px;
                }

                .empty-cart-title {
                    font-size: 1.5rem;
                    margin-bottom: 10px;
                    color: #2c3e50;
                }

                .empty-cart-message {
                    margin-bottom: 30px;
                }

                /* Mensagens */
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
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
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

            .checkout-steps {
                display: flex;
                justify-content: center;
                margin-bottom: 30px;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .step {
                display: flex;
                align-items: center;
                margin: 0 20px;
                color: #666;
            }

            .step.active {
                color: #3a7bd5;
                font-weight: 600;
            }

            .step-number {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                background: #ddd;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
            }

            .step.active .step-number {
                background: #3a7bd5;
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

            .btn-primary {
                background: #28a745;
                color: white;
            }

            .btn-primary:hover {
                background: #218838;
            }

            .btn-outline {
                background: transparent;
                color: #3a7bd5;
                border: 2px solid #3a7bd5;
            }

            .cart-actions {
                display: flex;
                gap: 15px;
                margin-top: 25px;
                flex-wrap: wrap;
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
                color: #28a745;
                font-weight: 500;
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
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .success-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin-bottom: 30px;
        }

        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 20px;
        }

        .success-title {
            font-size: 2rem;
            color: #28a745;
            margin-bottom: 15px;
        }

        .order-number {
            font-size: 1.5rem;
            color: #3a7bd5;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .order-details {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            margin: 25px 0;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
        }

        .detail-label {
            color: #666;
            font-weight: 500;
        }

        .detail-value {
            font-weight: 600;
            color: #2c3e50;
        }

        .total-row {
            border-top: 2px solid #dee2e6;
            padding-top: 15px;
            margin-top: 15px;
            font-size: 1.2rem;
            font-weight: 700;
            color: #28a745;
        }

        .next-steps {
            background: #f0f7ff;
            padding: 20px;
            border-radius: 8px;
            margin: 25px 0;
            text-align: left;
        }

        .steps-title {
            color: #3a7bd5;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .step {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            gap: 12px;
        }

        .step-number {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #3a7bd5;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            flex-shrink: 0;
        }

        .step-content {
            flex: 1;
        }

        .step-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .step-description {
            color: #666;
            font-size: 0.9rem;
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
            margin: 5px;
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
            border: 2px solid #3a7bd5;
        }

        .btn-outline:hover {
            background: #3a7bd5;
            color: white;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/shared/header.jsp" />

    <div class="container">
        <div class="success-card">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>

            <h1 class="success-title">Pedido Confirmado!</h1>

            <div class="order-number">
                Nº do Pedido: ${pedido.numeroPedido}
            </div>

            <p style="color: #666; margin-bottom: 30px; font-size: 1.1rem;">
                Obrigado por comprar na BytX! Seu pedido foi recebido e está sendo processado.
            </p>

            <!-- Detalhes do Pedido -->
            <div class="order-details">
                <div class="detail-row">
                    <span class="detail-label">Data do Pedido:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty dataCriacaoFormatada}">
                                    <fmt:formatDate value="${dataCriacaoFormatada}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </c:otherwise>
                            </c:choose>
                        </span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Forma de Pagamento:</span>
                    <span class="detail-value">
                        <c:choose>
                            <c:when test="${pedido.formaPagamento == 'cartao'}">
                                💳 Cartão de Crédito
                            </c:when>
                            <c:when test="${pedido.formaPagamento == 'boleto'}">
                                📄 Boleto Bancário
                            </c:when>
                            <c:otherwise>
                                ${pedido.formaPagamento}
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span class="detail-value" style="color: #ffc107; font-weight: 600;">
                        ⏳ ${pedido.statusFormatado}
                    </span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Subtotal:</span>
                    <span class="detail-value">
                        R$ <fmt:formatNumber value="${pedido.subtotal}" pattern="#,##0.00"/>
                    </span>
                </div>

                <div class="detail-row">
                    <span class="detail-label">Frete:</span>
                    <span class="detail-value">
                        R$ <fmt:formatNumber value="${pedido.frete}" pattern="#,##0.00"/>
                    </span>
                </div>

                <div class="detail-row total-row">
                    <span>Total:</span>
                    <span>R$ <fmt:formatNumber value="${pedido.total}" pattern="#,##0.00"/></span>
                </div>
            </div>

            <!-- Próximos Passos -->
            <div class="next-steps">
                <h3 class="steps-title">
                    <i class="fas fa-list-alt"></i> Próximos Passos
                </h3>

                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <div class="step-title">Confirmação do Pagamento</div>
                        <div class="step-description">
                            <c:choose>
                                <c:when test="${pedido.formaPagamento == 'boleto'}">
                                    Boleto gerado - vencimento em 3 dias úteis
                                </c:when>
                                <c:otherwise>
                                    Aguardando confirmação da operadora
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <div class="step-title">Preparação do Pedido</div>
                        <div class="step-description">
                            Seus produtos serão separados e embalados com cuidado
                        </div>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <div class="step-title">Envio e Entrega</div>
                        <div class="step-description">
                            Acompanhe o status da entrega em "Meus Pedidos"
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ações -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/checkout/meus-pedidos" class="btn btn-primary">
                    <i class="fas fa-clipboard-list"></i> Ver Meus Pedidos
                </a>

                <a href="${pageContext.request.contextPath}/" class="btn btn-outline">
                    <i class="fas fa-store"></i> Continuar Comprando
                </a>
            </div>
        </div>
    </div>

    <script>
        // Adicionar efeito de confetti (opcional)
        setTimeout(() => {
            // Efeito visual simples
            document.querySelector('.success-icon').style.transform = 'scale(1.1)';
            setTimeout(() => {
                document.querySelector('.success-icon').style.transform = 'scale(1)';
            }, 300);
        }, 500);
    </script>
</body>
</html>