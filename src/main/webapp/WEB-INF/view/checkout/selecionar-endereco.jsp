<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Selecionar Endereço - Checkout BytX</title>
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
                    max-width: 1000px;
                    margin: 0 auto;
                    padding: 20px;
                }

                .header {
                    background: linear-gradient(135deg, #3a7bd5, #00d2ff);
                    color: white;
                    padding: 30px;
                    border-radius: 12px;
                    margin-bottom: 30px;
                }

                .header h1 {
                    font-size: 2rem;
                    margin-bottom: 10px;
                }

                .content-layout {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 30px;
                }

                @media (max-width: 768px) {
                    .content-layout {
                        grid-template-columns: 1fr;
                    }
                }

                .card {
                    background: white;
                    border-radius: 12px;
                    padding: 25px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
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

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 500;
                    color: #333;
                }

                .required::after {
                    content: " *";
                    color: #dc3545;
                }

                input, select {
                    width: 100%;
                    padding: 12px 15px;
                    border: 2px solid #e1e5e9;
                    border-radius: 8px;
                    font-size: 16px;
                    transition: all 0.3s ease;
                }

                input:focus, select:focus {
                    outline: none;
                    border-color: #3a7bd5;
                    box-shadow: 0 0 0 3px rgba(58, 123, 213, 0.1);
                }

                .btn {
                    padding: 12px 24px;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    text-decoration: none;
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

                .btn-sm {
                    padding: 8px 16px;
                    font-size: 14px;
                }

                .alert {
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    border-left: 4px solid;
                }

                .alert-success {
                    background: #d4edda;
                    color: #155724;
                    border-left-color: #28a745;
                }

                .alert-error {
                    background: #f8d7da;
                    color: #721c24;
                    border-left-color: #dc3545;
                }

                .address-list {
                    max-height: 500px;
                    overflow-y: auto;
                }

                .address-item {
                    background: #f8f9fa;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 15px;
                    border-left: 4px solid #3a7bd5;
                    position: relative;
                }

                .address-item.padrao {
                    border-left-color: #28a745;
                    background: #f0fff4;
                }

                .address-badge {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                    background: #28a745;
                    color: white;
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: 500;
                }

                .address-type {
                    font-size: 12px;
                    color: #666;
                    margin-bottom: 5px;
                    text-transform: uppercase;
                    font-weight: 500;
                }

                .address-content {
                    line-height: 1.5;
                    margin-bottom: 10px;
                }

                .address-actions {
                    display: flex;
                    gap: 10px;
                    flex-wrap: wrap;
                }

                .checkbox-group {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    margin: 15px 0;
                }

                .checkbox-group input[type="checkbox"] {
                    width: auto;
                }

                .nav-links {
                    display: flex;
                    gap: 15px;
                    margin-top: 25px;
                    flex-wrap: wrap;
                }

                .empty-state {
                    text-align: center;
                    padding: 40px 20px;
                    color: #666;
                }

                .empty-state i {
                    font-size: 3rem;
                    color: #ddd;
                    margin-bottom: 15px;
                }

        .address-option {
            border: 2px solid #e1e5e9;
            padding: 20px;
            margin: 15px 0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }
        .address-option:hover {
            border-color: #3a7bd5;
            background: #f8f9fa;
        }
        .address-option.selected {
            border-color: #3a7bd5;
            background: #f0f7ff;
            box-shadow: 0 0 0 3px rgba(58, 123, 213, 0.1);
        }
        .address-option input {
            margin-right: 15px;
            transform: scale(1.2);
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
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/shared/header.jsp" />

    <div class="container">
        <!-- Steps do Checkout -->
        <div class="checkout-steps">
            <div class="step active">
                <div class="step-number">1</div>
                <span>Endereço</span>
            </div>
            <div class="step">
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

        <div class="card">
            <h3 class="card-title">
                <i class="fas fa-map-marker-alt"></i> Selecione o Endereço de Entrega
            </h3>

            <c:if test="${not empty erro}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${erro}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/checkout/endereco">
                <c:choose>
                    <c:when test="${not empty cliente.enderecos}">
                        <c:forEach var="endereco" items="${cliente.enderecos}">
                            <c:if test="${endereco.tipo == 'ENTREGA'}">
                                <label class="address-option ${endereco.padrao ? 'selected' : ''}">
                                    <input type="radio" name="enderecoId" value="${endereco.id}"
                                           ${endereco.padrao ? 'checked' : ''} required>
                                    <div style="flex: 1;">
                                        <div class="address-content">
                                            <strong>${endereco.logradouro}, ${endereco.numero}</strong>
                                            <c:if test="${not empty endereco.complemento}">
                                                - ${endereco.complemento}
                                            </c:if>
                                            <br>
                                            ${endereco.bairro} - ${endereco.cidade}/${endereco.uf}<br>
                                            CEP: ${endereco.cep}
                                        </div>
                                        <c:if test="${endereco.padrao}">
                                            <div style="color: #28a745; margin-top: 5px;">
                                                <i class="fas fa-star"></i> Endereço Padrão
                                            </div>
                                        </c:if>
                                    </div>
                                </label>
                            </c:if>
                        </c:forEach>

                        <div class="cart-actions" style="margin-top: 30px;">
                            <a href="${pageContext.request.contextPath}/cliente/enderecos?origemCheckout=true"
                               class="btn btn-outline">
                                <i class="fas fa-plus"></i> Adicionar Novo Endereço
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-arrow-right"></i> Continuar para Pagamento
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-map-marker-alt"></i>
                            <h3>Nenhum endereço de entrega cadastrado</h3>
                            <p>Você precisa cadastrar um endereço para continuar com a compra.</p>
                            <a href="${pageContext.request.contextPath}/cliente/enderecos?origemCheckout=true"
                               class="btn btn-primary">
                                <i class="fas fa-plus"></i> Cadastrar Endereço
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>
    </div>
</body>
</html>