<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrinho de Compras - BytX</title>
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
    </style>
</head>
<body>
    <jsp:include page="../shared/header.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">🛒 Meu Carrinho</h1>
        </div>

        <!-- Mensagens -->
        <c:if test="${not empty mensagemSucesso}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${mensagemSucesso}
            </div>
        </c:if>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${erro}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${carrinho != null && !carrinho.estaVazio()}">
                <form action="${pageContext.request.contextPath}/carrinho" method="post" id="cartForm">
                    <input type="hidden" name="acao" value="atualizar">

                    <div class="cart-layout">
                        <!-- Lista de Itens -->
                        <div class="cart-items">
                            <c:forEach var="item" items="${carrinho.itens}">
                                <div class="cart-item">
                                    <!-- Imagem -->
                                    <c:choose>
                                        <c:when test="${not empty item.produto.imagemPrincipal and not empty item.produto.imagemPrincipal.nomeArquivo}">
                                            <img src="${pageContext.request.contextPath}/produto/imagens/${item.produto.imagemPrincipal.nomeArquivo}"
                                                 alt="${item.produto.nome}"
                                                 class="item-image"
                                                 onerror="this.onerror=null; this.src='https://via.placeholder.com/80x80?text=Erro+Imagem'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/80x80?text=Sem+Imagem"
                                                 alt="${item.produto.nome}"
                                                 class="item-image">
                                            <div style="font-size: 8px; color: #666; text-align: center;">Sem imagem</div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Informações -->
                                    <div class="item-info">
                                        <h3 class="item-name">${item.produto.nome}</h3>
                                        <div class="item-price">
                                            R$ <fmt:formatNumber value="${item.precoUnitario}" pattern="#,##0.00"/> cada
                                        </div>
                                    </div>

                                    <!-- Controles de Quantidade -->
                                    <div class="quantity-controls">

                                        <input type="number"
                                               name="quantidade_${item.produto.id}"
                                               value="${item.quantidade}"
                                               min="1"
                                               max="${item.produto.quantidadeEstoque}"
                                               class="quantity-input"
                                               onchange="updateQuantity(${item.produto.id}, this.value)">
                                    </div>

                                    <!-- Subtotal -->
                                    <div class="item-subtotal">
                                        R$ <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                    </div>

                                    <!-- Remover - AGORA FORA DO FORM PRINCIPAL -->
                                    <button type="button" class="remove-btn"
                                            onclick="removerItem(${item.produto.id})"
                                            title="Remover produto">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </c:forEach>

                            <!-- Ações do Carrinho -->
                            <div class="cart-actions">
                                <a href="${pageContext.request.contextPath}/" class="btn btn-outline">
                                    <i class="fas fa-arrow-left"></i> Continuar Comprando
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-sync-alt"></i> Atualizar Carrinho
                                </button>
                                <button type="button" onclick="limparCarrinho()" class="btn btn-danger">
                                    <i class="fas fa-trash"></i> Limpar Carrinho
                                </button>
                            </div>
                        </div>

                        <!-- Resumo do Pedido -->
                        <div class="order-summary">
                            <h3 class="summary-title">Resumo do Pedido</h3>

                            <div class="summary-row">
                                <span class="summary-label">Subtotal:</span>
                                <span class="summary-value">
                                    R$ <fmt:formatNumber value="${carrinho.subtotal}" pattern="#,##0.00"/>
                                </span>
                            </div>

                            <!-- Seção de Frete -->
                            <div class="shipping-section">
                                <div class="shipping-title">Opções de Frete</div>
                                <div class="shipping-options">
                                    <label class="shipping-option">
                                        <input type="radio" name="frete" value="15.00" checked onchange="calcularTotal()">
                                        <div class="shipping-info">
                                            <div class="shipping-type">Entrega Econômica</div>
                                            <div class="shipping-price">R$ 15,00</div>
                                            <div class="shipping-time">5-7 dias úteis</div>
                                        </div>
                                    </label>

                                    <label class="shipping-option">
                                        <input type="radio" name="frete" value="25.00" onchange="calcularTotal()">
                                        <div class="shipping-info">
                                            <div class="shipping-type">Entrega Padrão</div>
                                            <div class="shipping-price">R$ 25,00</div>
                                            <div class="shipping-time">3-5 dias úteis</div>
                                        </div>
                                    </label>

                                    <label class="shipping-option">
                                        <input type="radio" name="frete" value="40.00" onchange="calcularTotal()">
                                        <div class="shipping-info">
                                            <div class="shipping-type">Entrega Expressa</div>
                                            <div class="shipping-price">R$ 40,00</div>
                                            <div class="shipping-time">1-2 dias úteis</div>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div class="summary-row">
                                <span class="summary-label">Frete:</span>
                                <span class="summary-value" id="freteValue">R$ 15,00</span>
                            </div>

                            <div class="summary-row summary-total">
                                <span>Total:</span>
                                <span id="totalValue">
                                    R$ <fmt:formatNumber value="${carrinho.subtotal + 15}" pattern="#,##0.00"/>
                                </span>
                            </div>

                            <a href="#" class="btn btn-success" style="margin-top: 20px; width: 100%;">
                                <i class="fas fa-lock"></i> Finalizar Compra
                            </a>
                        </div>
                    </div>
                </form>
            </c:when>

            <c:otherwise>
                <!-- Carrinho Vazio -->
                <div class="empty-cart">
                    <div class="empty-cart-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h2 class="empty-cart-title">Seu carrinho está vazio</h2>
                    <p class="empty-cart-message">Adicione alguns produtos incríveis ao seu carrinho!</p>

                    <!-- ⬅️ BOTÃO CORRIGIDO - vai para a index (/) em vez de login -->
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                        <i class="fas fa-store"></i> Começar a Comprar
                    </a>

                    <!-- ⬅️ BOTÃO ALTERNATIVO para usuários logados -->
                    <c:if test="${sessionScope.usuarioLogado != null}">
                        <div style="margin-top: 10px;">
                            <a href="${pageContext.request.contextPath}/produto/listar" class="btn btn-outline">
                                <i class="fas fa-list"></i> Ver Todos os Produtos
                            </a>
                        </div>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // Funções para controle de quantidade
        function incrementQuantity(produtoId) {
            const input = document.querySelector(`input[name="quantidade_${produtoId}"]`);
            if (parseInt(input.value) < parseInt(input.max)) {
                input.value = parseInt(input.value) + 1;
                updateQuantity(produtoId, input.value);
            }
        }

        function decrementQuantity(produtoId) {
            const input = document.querySelector(`input[name="quantidade_${produtoId}"]`);
            if (parseInt(input.value) > 1) {
                input.value = parseInt(input.value) - 1;
                updateQuantity(produtoId, input.value);
            }
        }

        function updateQuantity(produtoId, quantidade) {
            // Enviar form de atualização
            document.getElementById('cartForm').submit();
        }

        // ⬅️ NOVA FUNÇÃO PARA REMOVER ITEM
        function removerItem(produtoId) {
            if (confirm('Tem certeza que deseja remover este produto do carrinho?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/carrinho/remover';

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'produtoId';
                input.value = produtoId;

                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // ⬅️ FUNÇÃO PARA LIMPAR CARRINHO
        function limparCarrinho() {
            if (confirm('Tem certeza que deseja limpar todo o carrinho?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/carrinho';

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'acao';
                input.value = 'limpar';

                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Cálculo dinâmico do total com frete
        function calcularTotal() {
            const freteSelecionado = document.querySelector('input[name="frete"]:checked');
            const subtotal = ${carrinho != null ? carrinho.subtotal : 0};

            if (freteSelecionado) {
                const frete = parseFloat(freteSelecionado.value);
                const total = subtotal + frete;

                // Atualizar exibição
                document.getElementById('freteValue').textContent = 'R$ ' + frete.toFixed(2).replace('.', ',');
                document.getElementById('totalValue').textContent = 'R$ ' + total.toFixed(2).replace('.', ',');
            }
        }

        // Inicializar cálculos
        document.addEventListener('DOMContentLoaded', function() {
            calcularTotal();
        });
    </script>
</body>
</html>