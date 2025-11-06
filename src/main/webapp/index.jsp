<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loja BytX - Produtos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reset e configurações gerais */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header da página */
        .page-title {
            text-align: center;
            color: #3a7bd5;
            margin-bottom: 40px;
            font-size: 2.5rem;
            font-weight: 700;
        }

        .page-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            margin: 15px auto;
            border-radius: 2px;
        }

        /* Grid de produtos */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }

        /* Card do produto */
        .product-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
            position: relative;
            overflow: hidden;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            border-color: #3a7bd5;
        }

        /* Área da imagem */
        .product-image-container {
            position: relative;
            margin-bottom: 15px;
            border-radius: 8px;
            overflow: hidden;
            background: #f8f9fa;
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-image-placeholder {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            transition: all 0.3s ease;
        }

        .product-card:hover .product-image-placeholder {
            border-color: #3a7bd5;
            color: #3a7bd5;
        }

        .product-image-placeholder i {
            font-size: 3rem;
            margin-bottom: 10px;
        }

        /* Informações do produto */
        .product-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            line-height: 1.4;
            height: 3em;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #28a745;
            margin-bottom: 15px;
        }

        .product-price::before {
            content: 'R$ ';
            font-size: 1rem;
            font-weight: 600;
        }

        /* Status do estoque */
        .product-stock {
            margin-bottom: 15px;
            font-size: 0.9rem;
        }

        .stock-available {
            color: #28a745;
            font-weight: 600;
        }

        .stock-available i {
            margin-right: 5px;
        }

        .stock-unavailable {
            color: #dc3545;
            font-weight: 600;
        }

        .stock-unavailable i {
            margin-right: 5px;
        }

        /* Avaliação */
        .product-rating {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .rating-stars {
            color: #ffc107;
        }

        .rating-value {
            font-size: 0.9rem;
            color: #6c757d;
            margin-left: 5px;
        }

        /* Ações do produto */
        .product-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            cursor: pointer;
            flex: 1;
        }

        .btn i {
            margin-right: 6px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(58, 123, 213, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn-disabled {
            background: #6c757d;
            color: white;
            cursor: not-allowed;
            opacity: 0.6;
        }

        /* Estado quando não há produtos */
        .no-products {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .no-products i {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 20px;
        }

        .no-products h3 {
            color: #6c757d;
            margin-bottom: 10px;
            font-size: 1.5rem;
        }

        .no-products p {
            color: #868e96;
            font-size: 1.1rem;
        }

        /* Mensagens de alerta */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 4px solid;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        .alert-success {
            background: #d1edff;
            color: #004085;
            border-left-color: #3a7bd5;
        }

        .alert i {
            margin-right: 10px;
        }

        /* Info de debug (opcional - pode remover depois) */
        .debug-info {
            background: #f8f9fa;
            padding: 12px 16px;
            margin-bottom: 25px;
            border-radius: 8px;
            font-size: 0.85rem;
            color: #6c757d;
            border: 1px solid #e9ecef;
        }

        .debug-info strong {
            color: #495057;
        }

        /* Responsividade */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            .page-title {
                font-size: 2rem;
                margin-bottom: 30px;
            }

            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 20px;
            }

            .product-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
            }

            .page-title {
                font-size: 1.75rem;
            }
        }

        /* Badge para produtos novos (opcional) */
        .product-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            z-index: 2;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/shared/header.jsp" />

    <div class="container">
        <h1 class="page-title">🛍️ Nossos Produtos</h1>

        <c:if test="${not empty param.erro}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${param.erro}
            </div>
        </c:if>

        <c:if test="${not empty param.mensagem}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${param.mensagem}
            </div>
        </c:if>

        <!-- Debug Info (pode remover depois que estiver tudo funcionando) -->
        <div class="debug-info">
            <strong>Info:</strong> ${produtos.size()} produtos encontrados • ${imagensPrincipais.size()} com imagens
        </div>

        <div class="products-grid">
            <c:forEach var="produto" items="${produtos}">
                <div class="product-card">
                    <!-- Badge para produtos novos (exemplo) -->
                    <c:if test="${produto.dataCriacao ne null}">
                        <c:set var="dias" value="${(now.time - produto.dataCriacao.time) / (1000 * 60 * 60 * 24)}" />
                        <c:if test="${dias < 7}">
                            <span class="product-badge">Novo</span>
                        </c:if>
                    </c:if>

                    <c:set var="imagem" value="${imagensPrincipais[produto.id]}" />

                    <div class="product-image-container">
                        <c:choose>
                            <c:when test="${not empty imagem}">
                                <img src="${pageContext.request.contextPath}/produto/imagens/${imagem.nomeArquivo}"
                                     alt="${produto.nome}"
                                     class="product-image"
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/300x200?text=Imagem+Não+Encontrada'">
                            </c:when>
                            <c:otherwise>
                                <div class="product-image-placeholder">
                                    <i class="fas fa-image"></i>
                                    <span>Sem imagem</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h3 class="product-name">${produto.nome}</h3>

                    <div class="product-price">
                        <fmt:formatNumber value="${produto.preco}" pattern="#,##0.00"/>
                    </div>

                    <!-- Avaliação -->
                    <c:if test="${produto.avaliacao gt 0}">
                        <div class="product-rating">
                            <div class="rating-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i le produto.avaliacao}">
                                            <i class="fas fa-star"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <span class="rating-value">(<fmt:formatNumber value="${produto.avaliacao}" pattern="0.0"/>)</span>
                        </div>
                    </c:if>

                    <div class="product-stock">
                        <c:choose>
                            <c:when test="${produto.quantidadeEstoque > 0}">
                                <span class="stock-available">
                                    <i class="fas fa-check-circle"></i>
                                    Em estoque (${produto.quantidadeEstoque})
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock-unavailable">
                                    <i class="fas fa-times-circle"></i>
                                    Fora de estoque
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="product-actions">
                        <a href="${pageContext.request.contextPath}/produto/visualizar?id=${produto.id}"
                           class="btn btn-primary">
                            <i class="fas fa-eye"></i> Detalhes
                        </a>

                        <c:choose>
                            <c:when test="${produto.quantidadeEstoque > 0}">
                                <form action="${pageContext.request.contextPath}/carrinho/adicionar"
                                      method="post" style="display: contents;">
                                    <input type="hidden" name="produtoId" value="${produto.id}">
                                    <input type="hidden" name="quantidade" value="1">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-cart-plus"></i> Comprar
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-disabled" disabled>
                                    <i class="fas fa-cart-plus"></i> Indisponível
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty produtos}">
                <div class="no-products">
                    <i class="fas fa-box-open"></i>
                    <h3>Nenhum produto encontrado</h3>
                    <p>Não há produtos disponíveis no momento.</p>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Efeitos adicionais com JavaScript
        document.addEventListener('DOMContentLoaded', function() {
            // Adicionar loading nas imagens
            const images = document.querySelectorAll('.product-image');
            images.forEach(img => {
                img.addEventListener('load', function() {
                    this.style.opacity = '1';
                });

                // Efeito de fade-in
                img.style.opacity = '0';
                img.style.transition = 'opacity 0.3s ease';
            });

            // Feedback visual nos botões
            const buttons = document.querySelectorAll('.btn:not(.btn-disabled)');
            buttons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    if (this.classList.contains('btn-success')) {
                        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adicionando...';
                        setTimeout(() => {
                            this.innerHTML = '<i class="fas fa-check"></i> Adicionado!';
                        }, 1000);
                    }
                });
            });
        });
    </script>
</body>
</html>