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
    <title>${produto.nome} - Sistema BytX</title>
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
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        /* ESTILOS DA PÁGINA DO PRODUTO */
        .product-page {
            max-width: 1200px;
            margin: 0 auto;
        }

        .product-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .product-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            padding: 40px;
        }

        @media (max-width: 768px) {
            .product-layout {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px;
            }
        }

        /* CARROSSEL DE IMAGENS */
        .image-carousel {
            position: relative;
        }

        .main-image-container {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            background: #f8f9fa;
            height: 400px;
        }

        .main-image {
            width: 100%;
            height: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .carousel-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
            transform: translateY(-50%);
            padding: 0 20px;
        }

        .carousel-btn {
            background: rgba(255,255,255,0.9);
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .carousel-btn:hover {
            background: white;
            transform: scale(1.1);
        }

        .carousel-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .thumbnail-container {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            overflow-x: auto;
            padding: 10px 0;
        }

        .thumbnail {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .thumbnail:hover {
            border-color: #3a7bd5;
            transform: scale(1.05);
        }

        .thumbnail.active {
            border-color: #3a7bd5;
        }

        /* INFORMAÇÕES DO PRODUTO */
        .product-info {
            padding: 20px 0;
        }

        .product-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
            line-height: 1.2;
        }

        .product-rating {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .stars {
            display: flex;
            gap: 2px;
        }

        .star {
            color: #ffc107;
            font-size: 18px;
        }

        .star.empty {
            color: #ddd;
        }

        .rating-text {
            color: #666;
            font-size: 14px;
        }

        .product-price {
            font-size: 32px;
            font-weight: 700;
            color: #28a745;
            margin-bottom: 20px;
        }

        .stock-info {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 25px;
            padding: 12px 16px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #28a745;
        }

        .stock-info.out-of-stock {
            border-left-color: #dc3545;
            background: #f8d7da;
        }

        .stock-icon {
            font-size: 16px;
        }

        .in-stock {
            color: #28a745;
        }

        .out-of-stock {
            color: #dc3545;
        }

        .stock-text {
            font-weight: 500;
        }

        /* BOTÃO DE COMPRA */
        .buy-section {
            margin: 30px 0;
        }

        .buy-btn {
            background: #28a745;
            color: white;
            padding: 16px 32px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            border: none;
        }

        .buy-btn:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .buy-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .buy-btn:disabled:hover {
            background: #6c757d;
            transform: none;
        }

        .product-description {
            margin: 30px 0;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #3a7bd5;
        }

        .description-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .description-text {
            line-height: 1.6;
            color: #555;
            font-size: 15px;
        }

        .description-text:empty::before {
            content: "Nenhuma descrição fornecida.";
            color: #999;
            font-style: italic;
        }

        /* BOTÃO VOLTAR */
        .back-section {
            margin-top: 30px;
            text-align: center;
        }

        .back-btn {
            background: #6c757d;
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-1px);
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
                <div class="product-page">
                    <div class="product-container">
                        <div class="product-layout">
                            <!-- SEÇÃO DE IMAGENS -->
                            <div class="image-carousel">
                                <div class="main-image-container">
                                    <c:choose>
                                        <c:when test="${not empty imagens}">
                                            <img id="mainImage" src="${pageContext.request.contextPath}${imagens[0].caminho}/${imagens[0].nomeArquivo}"
                                                 alt="${produto.nome}" class="main-image"
                                                 onerror="this.src='https://via.placeholder.com/600x400?text=Imagem+Não+Encontrada'">
                                        </c:when>
                                        <c:otherwise>
                                            <img id="mainImage" src="https://via.placeholder.com/600x400?text=Sem+Imagem"
                                                 alt="${produto.nome}" class="main-image">
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="carousel-nav">
                                        <button class="carousel-btn" onclick="previousImage()" id="prevBtn">
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                        <button class="carousel-btn" onclick="nextImage()" id="nextBtn">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                </div>

                                <c:if test="${not empty imagens && imagens.size() > 1}">
                                    <div class="thumbnail-container">
                                        <c:forEach var="imagem" items="${imagens}" varStatus="status">
                                            <img src="${pageContext.request.contextPath}${imagem.caminho}/${imagem.nomeArquivo}"
                                                 alt="Thumbnail ${status.index + 1}"
                                                 class="thumbnail ${status.index == 0 ? 'active' : ''}"
                                                 onclick="changeImage(${status.index})"
                                                 onerror="this.src='https://via.placeholder.com/80x80?text=Imagem'">
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>

                            <!-- SEÇÃO DE INFORMAÇÕES -->
                            <div class="product-info">
                                <h1 class="product-title">${produto.nome}</h1>

                                <div class="product-rating">
                                    <div class="stars" id="ratingStars">
                                        <!-- As estrelas serão geradas via JavaScript -->
                                    </div>
                                    <span class="rating-text">${produto.avaliacao}/5.0</span>
                                </div>

                                <div class="product-price">
                                    R$ <fmt:formatNumber value="${produto.preco}" pattern="#,##0.00"/>
                                </div>

                                <!-- INFORMAÇÃO DE ESTOQUE -->
                                <div class="stock-info ${produto.quantidadeEstoque <= 0 ? 'out-of-stock' : ''}">
                                    <i class="fas ${produto.quantidadeEstoque > 0 ? 'fa-check in-stock' : 'fa-times out-of-stock'} stock-icon"></i>
                                    <span class="stock-text">
                                        <c:choose>
                                            <c:when test="${produto.quantidadeEstoque > 0}">
                                                Em estoque - ${produto.quantidadeEstoque} unidades disponíveis
                                            </c:when>
                                            <c:otherwise>
                                                Produto esgotado
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <!-- BOTÃO DE COMPRA -->
                                <div class="buy-section">
                                    <button class="buy-btn" ${produto.quantidadeEstoque <= 0 ? 'disabled' : ''}>
                                        <i class="fas fa-shopping-cart"></i>
                                        <c:choose>
                                            <c:when test="${produto.quantidadeEstoque > 0}">
                                                COMPRAR AGORA
                                            </c:when>
                                            <c:otherwise>
                                                PRODUTO ESGOTADO
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>

                                <!-- DESCRIÇÃO DO PRODUTO -->
                                <div class="product-description">
                                    <h3 class="description-title">
                                        <i class="fas fa-align-left"></i> Descrição do Produto
                                    </h3>
                                    <div class="description-text">
                                        <c:choose>
                                            <c:when test="${not empty produto.descricao}">
                                                ${produto.descricao}
                                            </c:when>
                                            <c:otherwise>
                                                Nenhuma descrição fornecida.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- BOTÃO VOLTAR (apenas para admin) -->
                    <div class="back-section">
                        <a href="${pageContext.request.contextPath}/produto/listar" class="back-btn">
                            <i class="fas fa-arrow-left"></i> Voltar para Lista de Produtos
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Sistema de carrossel de imagens
        let currentImageIndex = 0;
        const images = [
            <c:forEach var="imagem" items="${imagens}" varStatus="status">
            {
                src: '${pageContext.request.contextPath}${imagem.caminho}/${imagem.nomeArquivo}',
                alt: '${produto.nome} - Imagem ${status.index + 1}'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        function updateCarousel() {
            const mainImage = document.getElementById('mainImage');
            const thumbnails = document.querySelectorAll('.thumbnail');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');

            if (images.length > 0) {
                mainImage.src = images[currentImageIndex].src;
                mainImage.alt = images[currentImageIndex].alt;
            }

            // Atualizar thumbnails ativos
            thumbnails.forEach((thumb, index) => {
                thumb.classList.toggle('active', index === currentImageIndex);
            });

            // Atualizar botões de navegação
            if (prevBtn) prevBtn.disabled = currentImageIndex === 0;
            if (nextBtn) nextBtn.disabled = currentImageIndex === images.length - 1;
        }

        function changeImage(index) {
            currentImageIndex = index;
            updateCarousel();
        }

        function nextImage() {
            if (currentImageIndex < images.length - 1) {
                currentImageIndex++;
                updateCarousel();
            }
        }

        function previousImage() {
            if (currentImageIndex > 0) {
                currentImageIndex--;
                updateCarousel();
            }
        }

        // Sistema de avaliação por estrelas
        function renderStars(rating) {
            const starsContainer = document.getElementById('ratingStars');
            starsContainer.innerHTML = '';

            const fullStars = Math.floor(rating);
            const hasHalfStar = rating % 1 >= 0.5;

            // Estrelas cheias
            for (let i = 0; i < fullStars; i++) {
                const star = document.createElement('i');
                star.className = 'fas fa-star star';
                starsContainer.appendChild(star);
            }

            // Meia estrela
            if (hasHalfStar) {
                const star = document.createElement('i');
                star.className = 'fas fa-star-half-alt star';
                starsContainer.appendChild(star);
            }

            // Estrelas vazias
            const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
            for (let i = 0; i < emptyStars; i++) {
                const star = document.createElement('i');
                star.className = 'far fa-star star empty';
                starsContainer.appendChild(star);
            }
        }

        // Inicializar
        document.addEventListener('DOMContentLoaded', function() {
            // Renderizar estrelas
            const rating = ${produto.avaliacao != null ? produto.avaliacao : 0};
            renderStars(rating);

            // Inicializar carrossel se houver imagens
            if (images.length > 0) {
                updateCarousel();
            }

            // Adicionar navegação por teclado
            document.addEventListener('keydown', function(e) {
                if (e.key === 'ArrowLeft') {
                    previousImage();
                } else if (e.key === 'ArrowRight') {
                    nextImage();
                }
            });

            // Botão de compra (apenas visual)
            const buyBtn = document.querySelector('.buy-btn');
            if (buyBtn) {
                buyBtn.addEventListener('click', function(e) {
                    if (!this.disabled) {
                        e.preventDefault();
                        alert('Esta é uma visualização administrativa. O botão de compra está desativado.');
                    }
                });
            }
        });
    </script>
</body>
</html>