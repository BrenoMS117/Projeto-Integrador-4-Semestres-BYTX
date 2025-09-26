<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="br.com.bytx.model.Usuario" %>
<%
    // Verificar se o usuário está logado como estoquista
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
    <title>Gerenciar Estoque - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        <%@ include file="/WEB-INF/css/styles.css" %>

        /* ESTILOS ESPECÍFICOS DO ESTOQUISTA */
        .estoque-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .badge-estoque-baixo {
            background: #ffc107;
            color: #212529;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: bold;
        }

        .btn-estoque {
            background: #28a745;
            color: white;
        }

        .btn-estoque:hover {
            background: #218838;
        }

        .card-estoque {
            border-left: 4px solid #28a745;
        }

        .table-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="header estoque-header">
        <div class="logo">
            <i class="fas fa-boxes"></i>
            <span>Controle de Estoque - BytX</span>
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=<%= usuario.getNome() %>&background=28a745&color=fff" alt="User">
            <span><%= usuario.getNome() %> (Estoquista)</span>
            <form action="${pageContext.request.contextPath}/logout" method="get" style="display: inline;">
                <button type="submit" class="logout-btn">Sair <i class="fas fa-sign-out-alt"></i></button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/estoque/dashboard" style="text-decoration: none; color: inherit;"><i class="fas fa-home"></i> Dashboard</a></li>
                <li class="active"><i class="fas fa-boxes"></i> Gerenciar Estoque</li>
                <li><i class="fas fa-chart-bar"></i> Relatórios</li>
                <li><i class="fas fa-user"></i> Meu Perfil</li>
            </ul>
        </div>

        <div class="main-content">
            <div class="content-header">
                <h1><i class="fas fa-boxes"></i> Controle de Estoque</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/estoque/dashboard" class="btn-primary">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </div>
            </div>

            <!-- Cards de Resumo -->
            <div class="dashboard-cards">
                <div class="card card-estoque">
                    <div class="card-header">
                        <div class="card-title">Total de Produtos</div>
                        <div class="card-icon">
                            <i class="fas fa-box"></i>
                        </div>
                    </div>
                    <div class="card-value">${produtos.size()}</div>
                    <div class="card-text">Produtos cadastrados</div>
                </div>

                <div class="card card-estoque">
                    <div class="card-header">
                        <div class="card-title">Estoque Baixo</div>
                        <div class="card-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <div class="card-value">
                        <c:set var="estoqueBaixo" value="0"/>
                        <c:forEach var="produto" items="${produtos}">
                            <c:if test="${produto.quantidadeEstoque <= 10 && produto.ativo}">
                                <c:set var="estoqueBaixo" value="${estoqueBaixo + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${estoqueBaixo}
                    </div>
                    <div class="card-text">Produtos com estoque ≤ 10</div>
                </div>

                <div class="card card-estoque">
                    <div class="card-header">
                        <div class="card-title">Produtos Ativos</div>
                        <div class="card-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="card-value">
                        <c:set var="ativos" value="0"/>
                        <c:forEach var="produto" items="${produtos}">
                            <c:if test="${produto.ativo}">
                                <c:set var="ativos" value="${ativos + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${ativos}
                    </div>
                    <div class="card-text">Disponíveis para venda</div>
                </div>
            </div>

            <!-- Tabela de Produtos -->
            <div class="table-container">
                <div class="search-box">
                    <form method="get" action="${pageContext.request.contextPath}/estoque/produtos">
                        <input type="text" name="search" class="search-input" placeholder="Buscar produtos por nome..."
                               value="${param.search}">
                        <button type="submit" class="btn-search">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                    </form>
                </div>

                <table class="produtos-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nome do Produto</th>
                            <th>Estoque Atual</th>
                            <th>Preço</th>
                            <th>Status</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="produto" items="${produtos}">
                            <tr>
                                <td>${produto.id}</td>
                                <td>
                                    ${produto.nome}
                                    <c:if test="${produto.quantidadeEstoque <= 10 && produto.ativo}">
                                        <span class="badge-estoque-baixo">ESTOQUE BAIXO</span>
                                    </c:if>
                                </td>
                                <td>
                                    <span style="font-weight: bold; color: ${produto.quantidadeEstoque <= 10 ? '#dc3545' : '#28a745'}">
                                        ${produto.quantidadeEstoque} unidades
                                    </span>
                                </td>
                                <td>R$ ${produto.preco}</td>
                                <td>
                                    <span class="${produto.ativo ? 'status-ativo' : 'status-inativo'}">
                                        <i class="fas ${produto.ativo ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                        ${produto.ativo ? 'Ativo' : 'Inativo'}
                                    </span>
                                </td>
                                <td>
                                    <!-- AÇÃO: Ver Detalhes -->
                                    <a href="${pageContext.request.contextPath}/produto/visualizar?id=${produto.id}"
                                       class="btn-action btn-view" title="Ver detalhes">
                                        <i class="fas fa-eye"></i> Ver
                                    </a>

                                    <!-- AÇÃO: Editar Estoque (APENAS ESTOQUISTA) -->
                                    <a href="${pageContext.request.contextPath}/estoque/editar?id=${produto.id}"
                                       class="btn-action btn-estoque" title="Editar estoque">
                                        <i class="fas fa-edit"></i> Editar Estoque
                                    </a>

                                    <!-- NÃO MOSTRAR para estoquista: -->
                                    <!-- Editar Produto, Ativar/Desativar -->
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty produtos}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 30px;">
                                    <i class="fas fa-box-open" style="font-size: 48px; color: #ddd; margin-bottom: 10px;"></i>
                                    <p>Nenhum produto cadastrado</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Adicionar confirmação para ações
        document.addEventListener('DOMContentLoaded', function() {
            // Menu
            const menuItems = document.querySelectorAll('.sidebar-menu li');
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    menuItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Destacar produtos com estoque baixo
            const estoqueBaixo = document.querySelectorAll('.badge-estoque-baixo');
            estoqueBaixo.forEach(badge => {
                badge.closest('tr').style.backgroundColor = '#fff3cd';
            });
        });
    </script>
</body>
</html>