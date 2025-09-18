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

    // DECLARAR USUÁRIO (esta linha estava faltando)
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        boolean ehAdmin = usuario.isAdministrador();

        // Se não for admin, redirecionar
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
        <title>${empty produto.id ? 'Novo Produto' : 'Editar Produto'} - Sistema BytX</title>
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

        .form-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            max-width: 800px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #3a7bd5;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-control:focus {
            outline: none;
            border-color: #3a7bd5;
            box-shadow: 0 0 0 2px rgba(58, 123, 213, 0.2);
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
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

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-weight: 500;
        }

        .btn-submit {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .rating-stars {
            display: flex;
            gap: 10px;
            margin: 10px 0;
        }

        .rating-star {
            font-size: 24px;
            color: #ddd;
            cursor: pointer;
        }

        .rating-star.active {
            color: #ffc107;
        }

        .char-count {
            text-align: right;
            font-size: 12px;
            color: #666;
        }

        .char-count.warning {
            color: #dc3545;
        }

        /* DEPOIS OS ESTILOS ESPECÍFICOS DO FORMULÁRIO */
                .form-container {
                    background: white;
                    border-radius: 8px;
                    padding: 30px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                    max-width: 800px;
                    margin: 0 auto;
                }

        .images-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .image-preview-item {
            width: 100px;
            height: 100px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            position: relative;
        }

        .image-preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 3px;
        }

        .image-actions {
            position: absolute;
            top: -10px;
            right: -10px;
            display: flex;
            gap: 5px;
        }

        .badge-primary {
            background: #3a7bd5;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
        }

        .btn-small {
            padding: 2px 6px;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 10px;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .upload-section {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
            border: 1px dashed #ddd;
        }

        .upload-section h4 {
            margin-bottom: 10px;
            color: #3a7bd5;
            font-size: 14px;
        }

        .text-muted {
            color: #6c757d;
            font-style: italic;
        }

        .images-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: #fafafa;
        }

        .image-preview-item {
            width: 100px;
            height: 100px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            position: relative;
            background: white;
        }

        .image-preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 3px;
        }

        .image-actions {
            position: absolute;
            top: -8px;
            right: -8px;
            display: flex;
            gap: 5px;
        }

        .badge-primary {
            background: #3a7bd5;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
        }

        .btn-small {
            width: 24px;
            height: 24px;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #bd2130;
        }

        .upload-section {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
            border: 1px dashed #ddd;
        }

        .upload-section h4 {
            margin-bottom: 10px;
            color: #3a7bd5;
            font-size: 14px;
        }

        .text-muted {
            color: #6c757d;
            font-style: italic;
        }

        .form-check {
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
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
                <h1>${empty produto.id ? 'Cadastrar Novo Produto' : 'Editar Produto'}</h1>
                <a href="${pageContext.request.contextPath}/produto/listar" class="btn-primary">
                    <i class="fas fa-arrow-left"></i> Voltar
                </a>
            </div>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/produto/gerenciar" method="post" enctype="multipart/form-data">
                    <c:if test="${not empty produto.id}">
                        <input type="hidden" name="id" value="${produto.id}">
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">Nome do Produto *</label>
                        <input type="text" name="nome" class="form-control"
                               value="${produto.nome}" required maxlength="200"
                               placeholder="Digite o nome do produto">
                        <div class="char-count" id="nome-count">0/200</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Descrição Detalhada</label>
                        <textarea name="descricao" class="form-control"
                                  maxlength="2000" placeholder="Descreva o produto detalhadamente">${produto.descricao}</textarea>
                        <div class="char-count" id="descricao-count">0/2000</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Preço *</label>
                        <input type="number" name="preco" class="form-control"
                               value="${produto.preco}" step="0.01" min="0" required
                               placeholder="0,00">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Quantidade em Estoque *</label>
                        <input type="number" name="quantidadeEstoque" class="form-control"
                               value="${produto.quantidadeEstoque}" min="0" required
                               placeholder="0">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Imagens do Produto</label>

                        <div class="images-preview">
                            <c:forEach var="imagem" items="${imagens}">
                                <div class="image-preview-item">
                                    <img src="${imagem.caminho}/${imagem.nomeArquivo}"
                                         alt="Imagem do produto"
                                         onerror="this.src='https://via.placeholder.com/100x100?text=Imagem'">
                                    <div class="image-actions">
                                        <c:if test="${imagem.principal}">
                                            <span class="badge-primary">Principal</span>
                                        </c:if>
                                        <button type="button" class="btn-small btn-danger" onclick="removerImagem(${imagem.id})">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty imagens}">
                                <p class="text-muted">Nenhuma imagem cadastrada</p>
                            </c:if>
                        </div>

                        <div class="upload-section">
                            <h4>Adicionar Nova Imagem</h4>
                            <input type="file" name="novaImagem" accept="image/*" class="form-control">
                            <div class="form-check">
                                <input type="checkbox" name="imagemPrincipal" id="imagemPrincipal">
                                <label for="imagemPrincipal">Definir como imagem principal</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Avaliação (1-5)</label>
                        <div class="rating-stars" id="rating-stars">
                            <span class="rating-star" data-value="1"><i class="fas fa-star"></i></span>
                            <span class="rating-star" data-value="2"><i class="fas fa-star"></i></span>
                            <span class="rating-star" data-value="3"><i class="fas fa-star"></i></span>
                            <span class="rating-star" data-value="4"><i class="fas fa-star"></i></span>
                            <span class="rating-star" data-value="5"><i class="fas fa-star"></i></span>
                        </div>
                        <input type="hidden" name="avaliacao" id="avaliacao-input" value="${produto.avaliacao}">
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-submit">
                            <i class="fas fa-save"></i> ${empty produto.id ? 'Cadastrar' : 'Atualizar'}
                        </button>
                        <a href="${pageContext.request.contextPath}/produto/listar" class="btn btn-cancel">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Contador de caracteres
        document.querySelectorAll('input[name="nome"], textarea[name="descricao"]').forEach(input => {
            const counter = document.getElementById(input.name + '-count');

            input.addEventListener('input', function() {
                const count = this.value.length;
                const max = parseInt(this.getAttribute('maxlength'));
                counter.textContent = `${count}/${max}`;

                if (count > max * 0.9) {
                    counter.classList.add('warning');
                } else {
                    counter.classList.remove('warning');
                }
            });

            // Inicializar contador
            input.dispatchEvent(new Event('input'));
        });

        // Sistema de avaliação por estrelas
        const stars = document.querySelectorAll('.rating-star');
        const ratingInput = document.getElementById('avaliacao-input');

        // Inicializar estrelas com valor atual
        if (ratingInput.value) {
            setRating(parseFloat(ratingInput.value));
        }

        stars.forEach(star => {
            star.addEventListener('click', () => {
                const value = parseFloat(star.getAttribute('data-value'));
                setRating(value);
            });
        });

        function setRating(value) {
            ratingInput.value = value;
            stars.forEach(star => {
                const starValue = parseFloat(star.getAttribute('data-value'));
                if (starValue <= value) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
        }

        // Função para remover imagem
        function removerImagem(imagemId) {
            if (confirm('Tem certeza que deseja remover esta imagem?')) {
                // Aqui você pode implementar a remoção via AJAX ou criar um form hidden
                console.log('Remover imagem ID:', imagemId);
                // Implementar lógica de remoção
            }
        }
    </script>
</body>
</html>