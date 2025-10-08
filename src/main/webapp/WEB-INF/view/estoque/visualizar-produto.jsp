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
    <title>Visualizar Produto - Estoquista - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* INCLUIR AQUI O MESMO CSS COMPLETO DO listar-produtos.jsp */
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

        .header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .btn-primary {
            background: #28a745;
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
        }

        .btn-submit {
            background: #28a745;
            color: white;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        /* ESTILOS ESPECÍFICOS DA VISUALIZAÇÃO */
        .product-view-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .product-header {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
        }

        .product-image-section {
            flex: 1;
        }

        .main-image {
            width: 100%;
            max-width: 400px;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .product-info-section {
            flex: 2;
        }

        .product-title {
            font-size: 24px;
            color: #28a745;
            margin-bottom: 10px;
        }

        .product-price {
            font-size: 28px;
            color: #28a745;
            font-weight: bold;
            margin-bottom: 20px;
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

        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 10px;
        }

        .info-box {
            background: #e9f7ef;
            border: 1px solid #28a745;
            border-radius: 6px;
            padding: 15px;
            margin: 20px 0;
        }

        .info-box i {
            color: #28a745;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <i class="fas fa-boxes"></i>
            <span>Visualizar Produto - Estoquista</span>
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=<%= usuario.getNome() %>&background=28a745&color=fff" alt="User">
            <span><%= usuario.getNome() %> (Estoquista)</span>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/estoque/dashboard" style="text-decoration: none; color: inherit;">
                    <i class="fas fa-home"></i> Dashboard</a>
                </li>
                <li><a href="${pageContext.request.contextPath}/estoque/produtos" style="text-decoration: none; color: inherit;">
                    <i class="fas fa-boxes"></i> Gerenciar Estoque</a>
                </li>
                <li class="active"><i class="fas fa-eye"></i> Visualizar Produto</li>
            </ul>
        </div>

        <div class="main-content">
            <div class="content-header">
                <h1><i class="fas fa-eye"></i> Visualização do Produto</h1>
                <a href="${pageContext.request.contextPath}/estoque/produtos" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Voltar ao Estoque
                </a>
            </div>

            <!-- Caixa de Informação para Estoquista -->
            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                <strong>Modo de Visualização - Estoquista:</strong> Você pode visualizar todos os dados do produto,
                mas apenas o estoque pode ser alterado.
            </div>

            <c:if test="${produto == null}">
                <div style="background: #f8d7da; color: #721c24; padding: 20px; border-radius: 5px; text-align: center;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Produto não encontrado</h3>
                    <a href="${pageContext.request.contextPath}/estoque/produtos" class="btn btn-cancel">
                        Voltar ao Estoque
                    </a>
                </div>
            </c:if>

            <c:if test="${produto != null}">
                <div class="product-view-container">
                    <div class="product-header">
                        <div class="product-image-section">
                            <c:choose>
                                <c:when test="${not empty imagemPrincipal}">
                                    <img src="${pageContext.request.contextPath}${imagemPrincipal.caminho}/${imagemPrincipal.nomeArquivo}"
                                         alt="${produto.nome}" class="main-image"
                                         onerror="this.src='https://via.placeholder.com/400x300?text=Imagem+Não+Encontrada'">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/400x300?text=Sem+Imagem"
                                         alt="${produto.nome}" class="main-image">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="product-info-section">
                            <h1 class="product-title">${produto.nome}</h1>
                            <div class="product-price">R$ <fmt:formatNumber value="${produto.preco}" pattern="#,##0.00"/></div>

                            <div class="product-meta">
                                <div class="meta-item">
                                    <div class="meta-label">Código do Produto</div>
                                    <div class="meta-value">#${produto.id}</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Estoque Disponível</div>
                                    <div class="meta-value">
                                        <span style="font-weight: bold; color: ${produto.quantidadeEstoque <= 10 ? '#dc3545' : '#28a745'}">
                                            ${produto.quantidadeEstoque} unidades
                                        </span>
                                        <c:if test="${produto.quantidadeEstoque <= 10}">
                                            <br><small style="color: #dc3545;">⚠️ Estoque baixo!</small>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Status</div>
                                    <div class="meta-value">
                                        <span style="color: ${produto.ativo ? '#28a745' : '#dc3545'};">
                                            <i class="fas ${produto.ativo ? 'fa-check' : 'fa-times'}"></i>
                                            ${produto.ativo ? 'Ativo' : 'Inativo'}
                                        </span>
                                    </div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Avaliação</div>
                                    <div class="meta-value">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star" style="color: ${i <= produto.avaliacao ? '#ffc107' : '#ddd'};"></i>
                                        </c:forEach>
                                        (${produto.avaliacao}/5)
                                    </div>
                                </div>
                            </div>

                            <!-- BOTÕES ESPECÍFICOS PARA ESTOQUISTA -->
                            <div class="action-buttons">
                                <!-- APENAS Editar Estoque permitido -->
                                <a href="${pageContext.request.contextPath}/estoque/editar?id=${produto.id}"
                                   class="btn btn-submit">
                                    <i class="fas fa-edit"></i> Editar Estoque
                                </a>

                                <a href="${pageContext.request.contextPath}/estoque/produtos"
                                   class="btn btn-cancel">
                                    <i class="fas fa-arrow-left"></i> Voltar ao Estoque
                                </a>
                            </div>

                            <!-- NÃO MOSTRAR para estoquista: -->
                            <!--
                                ❌ Editar Produto (completo)
                                ❌ Ativar/Desativar Produto
                                ❌ Upload de Imagens
                                ❌ Outras ações de admin
                            -->
                        </div>
                    </div>

                    <!-- Descrição do Produto -->
                    <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                        <h3 style="color: #28a745; margin-bottom: 15px;">
                            <i class="fas fa-file-alt"></i> Descrição do Produto
                        </h3>
                        <div style="background: #f8f9fa; padding: 20px; border-radius: 6px; border-left: 4px solid #28a745;">
                            <c:choose>
                                <c:when test="${not empty produto.descricao}">
                                    ${produto.descricao}
                                </c:when>
                                <c:otherwise>
                                    <em style="color: #6c757d;">Nenhuma descrição fornecida para este produto.</em>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        document.querySelectorAll('.sidebar-menu li').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.sidebar-menu li').forEach(i => i.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>