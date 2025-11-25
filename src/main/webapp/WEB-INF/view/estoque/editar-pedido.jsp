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
    <title>Editar Pedido - Estoquista BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Mantenha todo o CSS do header/sidebar que você já tem */
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
            background: linear-gradient(135deg, #28a745, #20c997);
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
            display: flex;
            align-items: center;
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

        .page-header {
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 2rem;
            color: #28a745;
            margin-bottom: 10px;
        }

        .page-subtitle {
            color: #666;
            font-size: 1.1rem;
        }

        /* ESTILOS DO FORMULÁRIO DE EDIÇÃO */
        .card {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 1.3rem;
            color: #28a745;
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

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e1e5e9;
            border-radius: 6px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }

        .status-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }

        .status-option {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .status-option:hover {
            border-color: #28a745;
            background: #f8fff9;
        }

        .status-option input[type="radio"] {
            margin-right: 10px;
        }

        .status-info {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .icon-aguardando_pagamento {
            background: #fff3cd;
            color: #856404;
        }

        .icon-pagamento_rejeitado {
            background: #f8d7da;
            color: #721c24;
        }

        .icon-pagamento_sucesso {
            background: #d1ecf1;
            color: #0c5460;
        }

        .icon-aguardando_retirada {
            background: #fff3cd;
            color: #856404;
        }

        .icon-em_transito {
            background: #d1ecf1;
            color: #0c5460;
        }

        .icon-entregue {
            background: #d4edda;
            color: #155724;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
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
            color: #6c757d;
            border: 2px solid #6c757d;
        }

        .btn-outline:hover {
            background: #6c757d;
            color: white;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .pedido-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .info-row {
            display: flex;
            gap: 20px;
            margin-bottom: 8px;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 120px;
        }

        .info-value {
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <i class="fas fa-boxes"></i>
            <span>Sistema BytX - Estoquista</span>
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=<%= usuario.getNome() %>&background=28a745&color=fff" alt="User">
            <span><%= usuario.getNome() %> (Estoquista)</span>
            <form action="${pageContext.request.contextPath}/logout" method="get">
                <button type="submit" class="logout-btn">Sair <i class="fas fa-sign-out-alt"></i></button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/estoque/produtos" style="text-decoration: none; color: inherit;"><i class="fas fa-boxes"></i> Gerenciar Estoque</a></li>
                <li><a href="${pageContext.request.contextPath}/estoque/pedidos" style="text-decoration: none; color: inherit;"><i class="fas fa-clipboard-list"></i> Gerenciar Pedidos</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-edit"></i> Alterar Status do Pedido
                </h1>
                <p class="page-subtitle">Atualize o status do pedido conforme o andamento</p>
            </div>

            <!-- Mensagens -->
            <c:if test="${not empty erro}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${erro}
                </div>
            </c:if>

            <c:if test="${not empty pedido}">
                <!-- Informações do Pedido -->
                <div class="pedido-info">
                    <div class="info-row">
                        <span class="info-label">Número do Pedido:</span>
                        <span class="info-value"><strong>#${pedido.numeroPedido}</strong></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Data:</span>
                        <span class="info-value">
                            <c:if test="${not empty pedido.dataCriacao}">
                                <fmt:parseDate value="${pedido.dataCriacao}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                            </c:if>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Valor Total:</span>
                        <span class="info-value">R$ <fmt:formatNumber value="${pedido.total}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Status Atual:</span>
                        <span class="info-value">
                            <span class="status-badge status-${pedido.status}">
                                ${pedido.statusFormatado}
                            </span>
                        </span>
                    </div>
                </div>

                <!-- Formulário de Edição -->
                <div class="card">
                    <h3 class="card-title">
                        <i class="fas fa-sync-alt"></i> Atualizar Status
                    </h3>

                    <form method="post" action="${pageContext.request.contextPath}/estoque/pedidos/editar">
                        <input type="hidden" name="pedidoId" value="${pedido.id}">

                        <div class="form-group">
                            <label>Selecione o novo status:</label>
                            <div class="status-options">
                                <!-- Aguardando Pagamento -->
                                <label class="status-option">
                                    <input type="radio" name="status" value="aguardando_pagamento" ${pedido.status == 'aguardando_pagamento' ? 'checked' : ''}>
                                    <div class="status-info">
                                        <div class="status-icon icon-aguardando_pagamento">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">Aguardando Pagamento</div>
                                            <div style="font-size: 0.8rem; color: #666;">Pagamento pendente</div>
                                        </div>
                                    </div>
                                </label>

                                <!-- Pagamento Rejeitado -->
                                <label class="status-option">
                                    <input type="radio" name="status" value="pagamento_rejeitado" ${pedido.status == 'pagamento_rejeitado' ? 'checked' : ''}>
                                    <div class="status-info">
                                        <div class="status-icon icon-pagamento_rejeitado">
                                            <i class="fas fa-times"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">Pagamento Rejeitado</div>
                                            <div style="font-size: 0.8rem; color: #666;">Pagamento não aprovado</div>
                                        </div>
                                    </div>
                                </label>

                                <!-- Pagamento com Sucesso -->
                                <label class="status-option">
                                    <input type="radio" name="status" value="pagamento_sucesso" ${pedido.status == 'pagamento_sucesso' ? 'checked' : ''}>
                                    <div class="status-info">
                                        <div class="status-icon icon-pagamento_sucesso">
                                            <i class="fas fa-check"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">Pagamento com Sucesso</div>
                                            <div style="font-size: 0.8rem; color: #666;">Pagamento confirmado</div>
                                        </div>
                                    </div>
                                </label>

                                <!-- Aguardando Retirada -->
                                <label class="status-option">
                                    <input type="radio" name="status" value="aguardando_retirada" ${pedido.status == 'aguardando_retirada' ? 'checked' : ''}>
                                    <div class="status-info">
                                        <div class="status-icon icon-aguardando_retirada">
                                            <i class="fas fa-box"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">Aguardando Retirada</div>
                                            <div style="font-size: 0.8rem; color: #666;">Pronto para retirada</div>
                                        </div>
                                    </div>
                                </label>

                                <!-- Em Trânsito -->
                                <label class="status-option">
                                    <input type="radio" name="status" value="em_transito" ${pedido.status == 'em_transito' ? 'checked' : ''}>
                                    <div class="status-info">
                                        <div class="status-icon icon-em_transito">
                                            <i class="fas fa-shipping-fast"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">Em Trânsito</div>
                                            <div style="font-size: 0.8rem; color: #666;">A caminho do cliente</div>
                                        </div>
                                    </div>
                                </label>

                                <!-- Entregue -->
                                <label class="status-option">
                                    <input type="radio" name="status" value="entregue" ${pedido.status == 'entregue' ? 'checked' : ''}>
                                    <div class="status-info">
                                        <div class="status-icon icon-entregue">
                                            <i class="fas fa-home"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 500;">Entregue</div>
                                            <div style="font-size: 0.8rem; color: #666;">Pedido finalizado</div>
                                        </div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/estoque/pedidos" class="btn btn-outline">
                                <i class="fas fa-arrow-left"></i> Voltar
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Atualizar Status
                            </button>
                        </div>
                    </form>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Validação antes de enviar o formulário
        document.querySelector('form').addEventListener('submit', function(e) {
            const selectedStatus = document.querySelector('input[name="status"]:checked');
            if (!selectedStatus) {
                e.preventDefault();
                alert('Por favor, selecione um status para o pedido.');
                return;
            }

            if (!confirm('Tem certeza que deseja atualizar o status deste pedido?')) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>