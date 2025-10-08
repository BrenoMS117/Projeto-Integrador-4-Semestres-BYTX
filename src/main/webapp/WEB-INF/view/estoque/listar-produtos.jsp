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
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
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
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 250px;
            background: white;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px 0;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            padding: 15px 20px;
            border-left: 4px solid transparent;
            transition: all 0.3s;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .sidebar-menu li:hover {
            background: #f5f7fa;
            border-left: 4px solid #3a7bd5;
        }

        .sidebar-menu li.active {
            background: #f0f7ff;
            border-left: 4px solid #3a7bd5;
            color: #3a7bd5;
            font-weight: 500;
        }

        .sidebar-menu i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
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
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-weight: 500;
        }

        .btn-primary i {
            margin-right: 8px;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        .table-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .produtos-table {
            width: 100%;
            border-collapse: collapse;
        }

        .produtos-table th,
        .produtos-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .produtos-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #3a7bd5;
        }

        .produtos-table tr:hover {
            background: #f8f9fa;
        }

        .status-ativo {
            color: #28a745;
            font-weight: 500;
        }

        .status-inativo {
            color: #dc3545;
            font-weight: 500;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
        }

        .btn-edit {
            background: #ffc107;
            color: #212529;
        }

        .btn-view {
            background: #17a2b8;
            color: white;
        }

        .btn-status {
            background: #6c757d;
            color: white;
        }

        .alert {
            padding: 12px;
            border-radius: 4px;
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

        .search-box {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }

        .search-input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            flex: 1;
        }

        .btn-search {
            background: #3a7bd5;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }

        .welcome-banner {
            background: linear-gradient(to right, #3a7bd5, #00d2ff);
            color: white;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .welcome-banner h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: #3a7bd5;
        }

        .card-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #f0f7ff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #3a7bd5;
        }

        .card-value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .card-text {
            color: #777;
            font-size: 14px;
        }

        .recent-activities {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            color: #3a7bd5;
        }

        .activity-list {
            list-style: none;
        }

        .activity-item {
            padding: 15px 0;
            border-bottom: 1px solid #f5f5f5;
            display: flex;
            align-items: center;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #f0f7ff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #3a7bd5;
            margin-right: 15px;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            margin-bottom: 5px;
        }

        .activity-time {
            font-size: 12px;
            color: #888;
        }

        .footer {
            text-align: center;
            padding: 20px;
            background: white;
            color: #666;
            font-size: 14px;
            border-top: 1px solid #eee;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                padding: 10px;
            }

            .dashboard-cards {
                grid-template-columns: 1fr;
            }
        }

        /* ESTILOS ESPECÍFICOS DO ESTOQUISTA */
        .estoque-header {
            background: linear-gradient(135deg, #28a745, #20c997) !important;
            color: white;
        }

        .badge-estoque-baixo {
            background: #ffc107;
            color: #212529;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: bold;
            margin-left: 5px;
        }

        .btn-estoque {
            background: #28a745 !important;
            color: white !important;
        }

        .btn-estoque:hover {
            background: #218838 !important;
        }

        .card-estoque {
            border-left: 4px solid #28a745 !important;
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
                                    <a href="${pageContext.request.contextPath}/estoque/visualizar?id=${produto.id}"
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