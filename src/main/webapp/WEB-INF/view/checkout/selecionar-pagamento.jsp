<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagamento - Checkout BytX</title>
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

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
            background: #3a7bd5;
            color: white;
        }

        .btn-outline {
            background: transparent;
            color: #3a7bd5;
            border: 2px solid #3a7bd5;
        }

        /* ESTILOS ESPECÍFICOS DO PAGAMENTO */
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

        .payment-option {
            border: 2px solid #e1e5e9;
            padding: 20px;
            margin: 15px 0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .payment-option:hover {
            border-color: #3a7bd5;
        }

        .payment-option.selected {
            border-color: #3a7bd5;
            background: #f0f7ff;
        }

        .payment-option input {
            margin-right: 15px;
            transform: scale(1.2);
        }

        .card-form {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
            display: none;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #3a7bd5;
            box-shadow: 0 0 0 3px rgba(58, 123, 213, 0.1);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
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
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/shared/header.jsp" />

    <div class="container">
        <!-- Steps do Checkout -->
        <div class="checkout-steps">
            <div class="step">
                <div class="step-number">1</div>
                <span>Endereço</span>
            </div>
            <div class="step active">
                <div class="step-number">2</div>
                <span>Pagamento</span>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <span>Revisão</span>
            </div>
            <div class="step">
                <div class="step-number">4</div>
                <span>Confirmação</span>
            </div>
        </div>

        <div class="content-layout">
            <!-- Forma de Pagamento -->
            <div class="card">
                <h3 class="card-title">
                    <i class="fas fa-credit-card"></i> Forma de Pagamento
                </h3>

                <c:if test="${not empty erro}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${erro}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/checkout/pagamento">
                    <!-- Opção Cartão de Crédito -->
                    <label class="payment-option">
                        <input type="radio" name="formaPagamento" value="cartao" required
                               onchange="toggleCardForm(true)">
                        <div>
                            <strong><i class="fas fa-credit-card"></i> Cartão de Crédito</strong>
                            <div style="color: #666; font-size: 0.9rem; margin-top: 5px;">
                                Parcele em até 12x
                            </div>
                        </div>
                    </label>

                    <!-- Formulário do Cartão (aparece quando selecionado) -->
                    <div id="cardForm" class="card-form">
                        <div class="form-group">
                            <label>Número do Cartão</label>
                            <input type="text" name="numeroCartao" placeholder="0000 0000 0000 0000"
                                   maxlength="19" oninput="formatCardNumber(this)">
                        </div>

                        <div class="form-group">
                            <label>Nome no Cartão</label>
                            <input type="text" name="nomeCartao" placeholder="Como está no cartão">
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label>Validade</label>
                                <input type="text" name="validadeCartao" placeholder="MM/AA"
                                       maxlength="5" oninput="formatExpiry(this)">
                            </div>
                            <div class="form-group">
                                <label>CVV</label>
                                <input type="text" name="cvvCartao" placeholder="000"
                                       maxlength="3" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Parcelas</label>
                            <select name="parcelas">
                                <c:set var="totalComFrete" value="${carrinho.subtotal + 15}" />
                                <option value="1">1x de R$ <fmt:formatNumber value="${totalComFrete}" pattern="#,##0.00"/></option>
                                <option value="2">2x de R$ <fmt:formatNumber value="${totalComFrete / 2}" pattern="#,##0.00"/></option>
                                <option value="3">3x de R$ <fmt:formatNumber value="${totalComFrete / 3}" pattern="#,##0.00"/></option>
                                <option value="4">4x de R$ <fmt:formatNumber value="${totalComFrete / 4}" pattern="#,##0.00"/></option>
                                <option value="5">5x de R$ <fmt:formatNumber value="${totalComFrete / 5}" pattern="#,##0.00"/></option>
                                <option value="6">6x de R$ <fmt:formatNumber value="${totalComFrete / 6}" pattern="#,##0.00"/></option>
                            </select>
                        </div>
                    </div>

                    <!-- Opção Boleto -->
                    <label class="payment-option">
                        <input type="radio" name="formaPagamento" value="boleto"
                               onchange="toggleCardForm(false)">
                        <div>
                            <strong><i class="fas fa-barcode"></i> Boleto Bancário</strong>
                            <div style="color: #666; font-size: 0.9rem; margin-top: 5px;">
                                Vencimento em 3 dias úteis
                            </div>
                        </div>
                    </label>

                    <div class="cart-actions" style="margin-top: 30px;">
                        <a href="${pageContext.request.contextPath}/checkout/endereco" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Voltar
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-arrow-right"></i> Revisar Pedido
                        </button>
                    </div>
                </form>
            </div>

            <!-- Resumo do Pedido -->
            <div class="card">
                <h3 class="card-title">
                    <i class="fas fa-receipt"></i> Resumo do Pedido
                </h3>

                <div class="summary-row">
                    <span>Subtotal:</span>
                    <span>R$ <fmt:formatNumber value="${carrinho.subtotal}" pattern="#,##0.00"/></span>
                </div>

                <div class="summary-row">
                    <span>Frete:</span>
                    <span>R$ 15,00</span>
                </div>

                <div class="summary-row summary-total">
                    <span>Total:</span>
                    <span>R$ <fmt:formatNumber value="${carrinho.subtotal + 15}" pattern="#,##0.00"/></span>
                </div>

                <!-- Endereço Selecionado -->
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                    <strong>Endereço de Entrega:</strong>
                    <div style="margin-top: 10px; color: #666;">
                        <c:if test="${not empty enderecoSelecionado}">
                            ${enderecoSelecionado.logradouro}, ${enderecoSelecionado.numero}<br>
                            <c:if test="${not empty enderecoSelecionado.complemento}">
                                ${enderecoSelecionado.complemento}<br>
                            </c:if>
                            ${enderecoSelecionado.bairro} - ${enderecoSelecionado.cidade}/${enderecoSelecionado.uf}
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleCardForm(show) {
            document.getElementById('cardForm').style.display = show ? 'block' : 'none';

            // Limpar campos se esconder
            if (!show) {
                document.querySelectorAll('#cardForm input').forEach(input => input.value = '');
            }
        }

        function formatCardNumber(input) {
            let value = input.value.replace(/\D/g, '');
            if (value.length > 16) value = value.slice(0, 16);

            // Formatar como 0000 0000 0000 0000
            let formatted = '';
            for (let i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) formatted += ' ';
                formatted += value[i];
            }
            input.value = formatted;
        }

        function formatExpiry(input) {
            let value = input.value.replace(/\D/g, '');
            if (value.length > 4) value = value.slice(0, 4);

            if (value.length >= 2) {
                input.value = value.slice(0, 2) + '/' + value.slice(2);
            } else {
                input.value = value;
            }
        }

        // Validar antes do submit
        document.querySelector('form').addEventListener('submit', function(e) {
            const formaPagamento = document.querySelector('input[name="formaPagamento"]:checked');
            if (!formaPagamento) {
                e.preventDefault();
                alert('Selecione uma forma de pagamento');
                return;
            }

            if (formaPagamento.value === 'cartao') {
                const numeroCartao = document.querySelector('input[name="numeroCartao"]').value.replace(/\s/g, '');
                if (numeroCartao.length !== 16) {
                    e.preventDefault();
                    alert('Número do cartão deve ter 16 dígitos');
                    return;
                }

                const cvv = document.querySelector('input[name="cvvCartao"]').value;
                if (cvv.length !== 3) {
                    e.preventDefault();
                    alert('CVV deve ter 3 dígitos');
                    return;
                }
            }
        });
    </script>
</body>
</html>