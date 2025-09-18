<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalhes do Produto - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* MANTER TODO O STYLE DA DASHBOARD E ADICIONAR: */

        .product-details {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
        }

        .product-image {
            width: 300px;
            height: 250px;
            object-fit: cover;
            border-radius: 8px;
        }

        .product-info {
            flex: 1;
            margin-left: 30px;
        }

        .product-title {
            font-size: 28px;
            color: #3a7bd5;
            margin-bottom: 10px;
        }

        .product-price {
            font-size: 24px;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 15px;
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

        .product-description {
            margin-top: 30px;
        }

        .description-title {
            font-size: 18px;
            color: #3a7bd5;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .description-content {
            line-height: 1.6;
            color: #333;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .rating-star {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <%-- Código de verificação de sessão igual ao listar.jsp --%>

    <div class="header">
        <%-- Cabeçalho igual ao listar.jsp --%>
    </div>

    <div class="container">
        <div class="sidebar">
            <%-- Menu igual ao listar.jsp --%>
        </div>

        <div class="main-content">
            <div class="content-header">
                <h1>Detalhes do Produto</h1>
                <a href="${pageContext.request.contextPath}/produto/listar" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Voltar
                </a>
            </div>

            <div class="product-details">
                <div class="product-header">
                    <img src="${imagemPrincipal != null ? imagemPrincipal.caminho + '/' + imagemPrincipal.nomeArquivo : 'https://via.placeholder.com/300x250?text=Sem+Imagem'}"
                         alt="${produto.nome}" class="product-image"
                         onerror="this.src='https://via.placeholder.com/300x250?text=Imagem+Não+Encontrada'">

                    <div class="product-info">
                        <h1 class="product-title">${produto.nome}</h1>
                        <div class="product-price">R$ ${produto.preco}</div>

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
                                <div class="meta-value ${produto.ativo ? 'status-ativo' : 'status-inativo'}">
                                    ${produto.ativo ? 'Ativo' : 'Inativo'}
                                </div>
                            </div>

                            <div class="meta-item">
                                <div class="meta-label">Avaliação</div>
                                <div class="meta-value rating-display">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star rating-star ${i <= produto.avaliacao ? 'active' : ''}"></i>
                                    </c:forEach>
                                    <span>(${produto.avaliacao}/5)</span>
                                </div>
                            </div>

                            <div class="meta-item">
                                <div class="meta-label">Data de Cadastro</div>
                                <div class="meta-value">
                                    <fmt:formatDate value="${produto.dataCriacao}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <div class="btn-group">
                            <a href="${pageContext.request.contextPath}/produto/gerenciar?id=${produto.id}&acao=editar"
                               class="btn btn-submit">
                                <i class="fas fa-edit"></i> Editar Produto
                            </a>
                            <a href="${pageContext.request.contextPath}/produto/imagens?id=${produto.id}"
                               class="btn btn-cancel">
                                <i class="fas fa-images"></i> Gerenciar Imagens
                            </a>
                        </div>
                    </div>
                </div>

                <div class="product-description">
                    <h3 class="description-title">Descrição Detalhada</h3>
                    <div class="description-content">
                        ${empty produto.descricao ? 'Nenhuma descrição fornecida.' : produto.descricao}
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>