<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Usuário - Sistema BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .container { max-width: 600px; margin: 20px auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #3a7bd5, #00d2ff); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: 500; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; }
        .error { color: #dc3545; font-size: 14px; margin-top: 5px; }
        .success { color: #28a745; background: #d4edda; padding: 10px; border-radius: 5px; margin-bottom: 15px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-secondary { background: #6c757d; color: white; }
        .checkbox-group { display: flex; align-items: center; gap: 10px; }
        .user-info { background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .user-info p { margin: 5px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-edit"></i> Editar Usuário</h1>
        </div>

        <%-- Mensagens de sucesso/erro --%>
        <c:if test="${not empty mensagemSucesso}">
            <div class="success">✅ ${mensagemSucesso}</div>
        </c:if>
        <%-- === ADICIONE ESTA LINHA === --%>
        <c:if test="${not empty param.sucesso}">
            <div class="success">✅ ${param.sucesso}</div>
        </c:if>
        <%-- =========================== --%>
        <c:if test="${not empty mensagemErro}">
            <div class="error">❌ ${mensagemErro}</div>
        </c:if>

        <%-- Mensagens de sucesso/erro --%>
        <c:if test="${not empty mensagemSucesso}">
            <div class="success">✅ ${mensagemSucesso}</div>
        </c:if>
        <c:if test="${not empty mensagemErro}">
            <div class="error">❌ ${mensagemErro}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/editar">
            <!-- Campo hidden para identificar o usuário -->
            <input type="hidden" name="email" value="${usuario.email}">

            <div class="form-group">
                <label for="nome">Nome completo:</label>
                <input type="text" id="nome" name="nome" value="${not empty param.nome ? param.nome : usuario.nome}" required>
                <c:if test="${not empty erroNome}"><div class="error">${erroNome}</div></c:if>
            </div>

            <div class="form-group">
                <label for="cpf">CPF:</label>
                <input type="text" id="cpf" name="cpf" value="${not empty param.cpf ? param.cpf : usuario.cpf}" placeholder="000.000.000-00" required>
                <c:if test="${not empty erroCpf}"><div class="error">${erroCpf}</div></c:if>
            </div>

            <div class="form-group">
                <label for="grupo">Grupo:</label>
                <select id="grupo" name="grupo" required>
                    <option value="">Selecione o grupo</option>
                    <option value="ADMIN" ${(not empty param.grupo && param.grupo == 'ADMIN') || usuario.grupo == 'ADMIN' ? 'selected' : ''}>Administrador</option>
                    <option value="ESTOQUISTA" ${(not empty param.grupo && param.grupo == 'ESTOQUISTA') || usuario.grupo == 'ESTOQUISTA' ? 'selected' : ''}>Estoquista</option>
                </select>
                <c:if test="${not empty erroGrupo}"><div class="error">${erroGrupo}</div></c:if>

                <!-- Mensagem se for o próprio usuário -->
                <c:if test="${usuario.email eq sessionScope.usuarioLogado.email}">
                    <div style="color: #6c757d; font-size: 12px; margin-top: 5px;">
                        <i class="fas fa-info-circle"></i> Você não pode alterar seu próprio grupo.
                    </div>
                </c:if>
            </div>

            <div class="form-group">
                <div class="checkbox-group">
                    <input type="checkbox" id="alterarSenha" name="alterarSenha" ${not empty param.alterarSenha ? 'checked' : ''}>
                    <label for="alterarSenha" style="display: inline; font-weight: normal;">Alterar senha</label>
                </div>
            </div>

            <div id="camposSenha" style="display: ${not empty param.alterarSenha ? 'block' : 'none'};">
                <div class="form-group">
                    <label for="novaSenha">Nova Senha:</label>
                    <input type="password" id="novaSenha" name="novaSenha">
                    <c:if test="${not empty erroSenha}"><div class="error">${erroSenha}</div></c:if>
                </div>

                <div class="form-group">
                    <label for="confirmarSenha">Confirmar Nova Senha:</label>
                    <input type="password" id="confirmarSenha" name="confirmarSenha">
                </div>
            </div>

            <!-- === CAMPO "USUÁRIO ATIVO" (POSIÇÃO CORRETA) === -->
            <c:if test="${usuario.email ne sessionScope.usuarioLogado.email}">
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="usuarioAtivo" name="usuarioAtivo" ${usuario.ativo ? 'checked' : ''}>
                        <label for="usuarioAtivo" style="display: inline; font-weight: normal;">Usuário ativo</label>
                    </div>
                </div>
            </c:if>
            <c:if test="${usuario.email eq sessionScope.usuarioLogado.email}">
                <div style="color: #6c757d; font-size: 14px; margin: 15px 0; padding: 10px; background: #f8f9fa; border-radius: 5px;">
                    <i class="fas fa-info-circle"></i> Você não pode desativar seu próprio usuário.
                </div>
            </c:if>

            <!-- === BOTÕES === -->
            <div style="display: flex; gap: 10px; margin-top: 20px;">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Salvar Alterações
                </button>
                <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Voltar
                </a>
            </div>
        </form>
    </div>

    <script>
        // Mostrar/ocultar campos de senha
        document.getElementById('alterarSenha').addEventListener('change', function() {
            document.getElementById('camposSenha').style.display = this.checked ? 'block' : 'none';
        });

        // Máscara para CPF
        document.getElementById('cpf').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 11) value = value.slice(0, 11);

            if (value.length > 9) {
                value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
            } else if (value.length > 6) {
                value = value.replace(/(\d{3})(\d{3})(\d{3})/, '$1.$2.$3');
            } else if (value.length > 3) {
                value = value.replace(/(\d{3})(\d{3})/, '$1.$2');
            }
            e.target.value = value;
        });

        // Validação de senha em tempo real
        document.getElementById('confirmarSenha').addEventListener('blur', function() {
            const senha = document.getElementById('novaSenha').value;
            const confirmar = this.value;

            if (senha !== confirmar) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#28a745';
            }
        });

        // Desabilitar grupo se for o próprio usuário
        window.addEventListener('load', function() {
            const isOwnUser = ${usuario.email eq sessionScope.usuarioLogado.email};
            if (isOwnUser) {
                document.getElementById('grupo').disabled = true;
            }
        });
    </script>
</body>
</html>