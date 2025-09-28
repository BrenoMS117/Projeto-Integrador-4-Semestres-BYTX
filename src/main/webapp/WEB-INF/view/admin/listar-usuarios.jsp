<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Usuários - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
            border-radius: 8px;
        }

        .page-title {
            font-size: 28px;
            font-weight: bold;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: #28a745;
            color: white;
        }

        .btn-primary:hover {
            background: #218838;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: black;
        }

        .search-box {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }

        .search-input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .search-btn {
            padding: 10px 20px;
            background: #3a7bd5;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .users-table th,
        .users-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .users-table th {
            background: #3a7bd5;
            color: white;
            font-weight: 600;
        }

        .users-table tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-ativo {
            background: #d4edda;
            color: #155724;
        }

        .status-inativo {
            background: #f8d7da;
            color: #721c24;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }

        .no-users {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
        }

        .breadcrumb {
            margin-bottom: 20px;
            font-size: 14px;
            color: #6c757d;
        }

        .breadcrumb a {
            color: #3a7bd5;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            > Lista de Usuários
        </div>

        <div class="header">
            <h1 class="page-title">👥 Gestão de Usuários</h1>
            <a href="${pageContext.request.contextPath}/admin/usuarios/cadastrar" class="btn btn-primary">
                <i class="fas fa-plus"></i> Novo Usuário
            </a>
        </div>

        <!-- Formulário de Busca -->
        <form method="get" action="${pageContext.request.contextPath}/admin/usuarios" class="search-box">
            <input type="text" name="filtroNome" value="${param.filtroNome}"
                   placeholder="Buscar por nome..." class="search-input">
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Buscar
            </button>
            <c:if test="${not empty param.filtroNome}">
                <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Limpar
                </a>
            </c:if>
        </form>

        <!-- Tabela de Usuários -->
        <table class="users-table">
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>CPF</th>
                    <th>Grupo</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty usuarios}">
                        <c:forEach var="usuario" items="${usuarios}">
                            <tr>
                                <td>${usuario.nome}</td>
                                <td>${usuario.email}</td>
                                <td>${usuario.cpf}</td>
                                <td>${usuario.grupo}</td>
                                <td>
                                    <span class="status-badge ${usuario.ativo ? 'status-ativo' : 'status-inativo'}">
                                        ${usuario.ativo ? 'ATIVO' : 'INATIVO'}
                                    </span>
                                </td>
                                <td class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/usuarios/editar?email=${usuario.email}"
                                       class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit"></i> Editar
                                    </a>

                                    <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/alterar-status"
                                          style="display: inline;">
                                        <input type="hidden" name="email" value="${usuario.email}">
                                        <input type="hidden" name="acao" value="${usuario.ativo ? 'desativar' : 'ativar'}">
                                        <button type="submit" class="btn ${usuario.ativo ? 'btn-danger' : 'btn-primary'} btn-sm"
                                                onclick="return confirm('Tem certeza que deseja ${usuario.ativo ? 'desativar' : 'ativar'} este usuário?')">
                                            <i class="fas ${usuario.ativo ? 'fa-times' : 'fa-check'}"></i>
                                            ${usuario.ativo ? 'Desativar' : 'Ativar'}
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="no-users">
                                <i class="fas fa-users fa-2x" style="margin-bottom: 10px;"></i>
                                <br>
                                Nenhum usuário encontrado.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <script>
        // Confirmação para ativar/desativar
        function confirmarAcao(acao, id) {
            return confirm('Tem certeza que deseja ' + acao + ' este usuário?');
        }
    </script>
</body>
</html>