<<%@ page import="br.com.bytx.model.Usuario" %>
 <%
     if (session == null || session.getAttribute("usuarioLogado") == null) {
         response.sendRedirect(request.getContextPath() + "/login");
         return;
     }

     Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
     boolean ehAdmin = usuario.isAdministrador();

     if (!ehAdmin) {
         response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Acesso negado");
         return;
     }
 %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Imagens - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* MANTER TODO O STYLE DA DASHBOARD E ADICIONAR: */

        .images-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .image-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .image-preview {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .image-placeholder {
            width: 100%;
            height: 200px;
            background: #f8f9fa;
            border: 2px dashed #ddd;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            margin-bottom: 10px;
        }

        .image-actions {
            display: flex;
            gap: 5px;
            justify-content: center;
        }

        .btn-image {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .btn-set-main {
            background: #28a745;
            color: white;
        }

        .btn-remove {
            background: #dc3545;
            color: white;
        }

        .main-badge {
            background: #17a2b8;
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-top: 5px;
        }

        .upload-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .upload-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 10px;
            align-items: end;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
    <%-- Código de verificação de sessão igual ao listar.jsp --%>

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

    <div class="sidebar">
        <ul class="sidebar-menu">
            <li><i class="fas fa-home"></i> Dashboard</li>
            <li><i class="fas fa-chart-bar"></i> Relatórios</li>
            <li class="active"><i class="fas fa-tag"></i> Produtos</li>
            <li><a href="${pageContext.request.contextPath}/admin/usuarios" style="text-decoration: none; color: inherit;"><i class="fas fa-users"></i> Gerenciar Usuários</a></li>
            <li><i class="fas fa-cog"></i> Configurações</li>
        </ul>
    </div>

        <div class="main-content">
            <div class="content-header">
                <h1>Gerenciar Imagens do Produto</h1>
                <a href="${pageContext.request.contextPath}/produto/listar" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Voltar para Lista
                </a>
            </div>

            <%-- Mensagens de sucesso/erro --%>
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

            <div class="upload-section">
                <h3>Adicionar Nova Imagem</h3>
                <form class="upload-form" action="${pageContext.request.contextPath}/produto/imagens" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="produtoId" value="${param.id}">

                    <div>
                        <label class="form-label">Selecionar Arquivo</label>
                        <input type="file" name="imagem" class="form-control" accept="image/*" required>
                    </div>

                    <div class="form-check">
                        <input type="checkbox" name="principal" id="principal-check">
                        <label for="principal-check">Definir como imagem principal</label>
                    </div>

                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-upload"></i> Upload
                    </button>
                </form>
            </div>

            <div class="images-container">
                <c:forEach var="imagem" items="${imagens}">
                    <div class="image-card">
                        <img src="${imagem.caminho}/${imagem.nomeArquivo}"
                             alt="Imagem do produto" class="image-preview"
                             onerror="this.src='https://via.placeholder.com/250x200?text=Imagem+Não+Encontrada'">

                        <div class="image-info">
                            <strong>${imagem.nomeArquivo}</strong>
                            <c:if test="${imagem.principal}">
                                <div class="main-badge">Principal</div>
                            </c:if>
                        </div>

                        <div class="image-actions">
                            <c:if test="${not imagem.principal}">
                                <form action="${pageContext.request.contextPath}/produto/imagens" method="post" style="display: inline;">
                                    <input type="hidden" name="acao" value="setPrincipal">
                                    <input type="hidden" name="imagemId" value="${imagem.id}">
                                    <input type="hidden" name="produtoId" value="${param.id}">
                                    <button type="submit" class="btn-image btn-set-main">
                                        <i class="fas fa-star"></i> Principal
                                    </button>
                                </form>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/produto/imagens" method="post" style="display: inline;">
                                <input type="hidden" name="acao" value="remover">
                                <input type="hidden" name="imagemId" value="${imagem.id}">
                                <input type="hidden" name="produtoId" value="${param.id}">
                                <button type="submit" class="btn-image btn-remove"
                                        onclick="return confirm('Tem certeza que deseja remover esta imagem?')">
                                    <i class="fas fa-trash"></i> Remover
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty imagens}">
                    <div class="image-card">
                        <div class="image-placeholder">
                            <i class="fas fa-image" style="font-size: 48px;"></i>
                        </div>
                        <p>Nenhuma imagem cadastrada</p>
                    </div>
                </c:if>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/produto/listar" class="btn btn-submit">
                    <i class="fas fa-check"></i> Finalizar
                </a>
                <a href="${pageContext.request.contextPath}/produto/gerenciar?id=${param.id}&acao=editar" class="btn btn-cancel">
                    <i class="fas fa-edit"></i> Editar Produto
                </a>
            </div>
        </div>
    </div>
</body>
</html>