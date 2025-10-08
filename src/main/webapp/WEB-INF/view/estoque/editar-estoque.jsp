<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Editar Estoque - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS COMPLETO - Mesmo estilo das outras páginas do estoquista */
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
            border: none;
            cursor: pointer;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        /* ESTILOS ESPECÍFICOS DO FORMULÁRIO */
        .form-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #28a745;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-control:read-only {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }

        .form-control:focus {
            outline: none;
            border-color: #28a745;
            box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.2);
        }

        .form-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .info-box {
            background: #e9f7ef;
            border: 1px solid #28a745;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .info-box i {
            color: #28a745;
            margin-right: 10px;
        }

        .field-readonly {
            background: #f8f9fa;
            padding: 10px 15px;
            border-radius: 4px;
            border: 1px solid #ddd;
            color: #495057;
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
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <i class="fas fa-boxes"></i>
            <span>Editar Estoque - Estoquista</span>
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
                <li class="active"><i class="fas fa-edit"></i> Editar Estoque</li>
            </ul>
        </div>

        <div class="main-content">
            <div class="content-header">
                <h1><i class="fas fa-edit"></i> Editar Estoque</h1>
                <a href="${pageContext.request.contextPath}/estoque/produtos" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Voltar ao Estoque
                </a>
            </div>

            <!-- Mensagens -->
            <c:if test="${not empty param.mensagem}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${param.mensagem}
                </div>
            </c:if>

            <c:if test="${not empty param.erro}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${param.erro}
                </div>
            </c:if>

            <!-- Caixa de Informação -->
            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                <strong>Modo de Edição - Estoquista:</strong> Você pode alterar apenas a quantidade em estoque.
                Os demais campos são apenas para visualização.
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
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/estoque/editar" method="post">
                        <input type="hidden" name="id" value="${produto.id}">

                        <!-- Dados do Produto (Somente Leitura) -->
                        <div class="form-group">
                            <label class="form-label">Código do Produto</label>
                            <div class="field-readonly">
                                #${produto.id}
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Nome do Produto</label>
                            <div class="field-readonly">
                                ${produto.nome}
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Preço</label>
                            <div class="field-readonly">
                                R$ ${produto.preco}
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Status</label>
                            <div class="field-readonly">
                                <span style="color: ${produto.ativo ? '#28a745' : '#dc3545'};">
                                    <i class="fas ${produto.ativo ? 'fa-check' : 'fa-times'}"></i>
                                    ${produto.ativo ? 'Ativo' : 'Inativo'}
                                </span>
                            </div>
                        </div>

                        <!-- Campo Editável: Estoque -->
                        <div class="form-group">
                            <label class="form-label">Quantidade em Estoque *</label>
                            <input type="number" name="quantidadeEstoque" class="form-control"
                                   value="${produto.quantidadeEstoque}" min="0" required
                                   placeholder="Digite a quantidade em estoque">
                            <div class="form-help">
                                Quantidade atual: <strong>${produto.quantidadeEstoque} unidades</strong>
                                <c:if test="${produto.quantidadeEstoque <= 10}">
                                    <span style="color: #dc3545;"> ⚠️ Estoque baixo!</span>
                                </c:if>
                            </div>
                        </div>

                        <div class="btn-group">
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save"></i> Atualizar Estoque
                            </button>
                            <a href="${pageContext.request.contextPath}/estoque/produtos" class="btn btn-cancel">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                        </div>
                    </form>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Menu
            const menuItems = document.querySelectorAll('.sidebar-menu li');
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    menuItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Confirmação antes de enviar
            document.querySelector('form').addEventListener('submit', function(e) {
                const quantidadeInput = document.querySelector('input[name="quantidadeEstoque"]');
                const novaQuantidade = parseInt(quantidadeInput.value);
                const quantidadeAtual = ${produto.quantidadeEstoque};

                if (novaQuantidade < 0) {
                    alert('❌ A quantidade não pode ser negativa!');
                    e.preventDefault();
                    return;
                }

                if (novaQuantidade === quantidadeAtual) {
                    if (!confirm('⚠️ A quantidade não foi alterada. Deseja continuar mesmo assim?')) {
                        e.preventDefault();
                        return;
                    }
                }

                const diferenca = novaQuantidade - quantidadeAtual;
                let mensagem = '';

                if (diferenca > 0) {
                    mensagem = `✅ Você está adicionando ${diferenca} unidades ao estoque.\n\nDeseja confirmar?`;
                } else if (diferenca < 0) {
                    mensagem = `❌ Você está removendo ${Math.abs(diferenca)} unidades do estoque.\n\nDeseja confirmar?`;
                } else {
                    mensagem = `ℹ️ A quantidade permanece a mesma: ${quantidadeAtual} unidades.\n\nDeseja confirmar?`;
                }

                if (!confirm(mensagem)) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>