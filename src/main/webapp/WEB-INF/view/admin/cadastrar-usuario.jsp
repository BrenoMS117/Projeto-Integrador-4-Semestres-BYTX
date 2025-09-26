<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastrar Usuário - Sistema BytX</title>
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
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-plus"></i> Cadastrar Novo Usuário</h1>
        </div>

        <%-- Mensagens de sucesso/erro --%>
        <c:if test="${not empty mensagemSucesso}">
            <div class="success">✅ ${mensagemSucesso}</div>
        </c:if>
        <c:if test="${not empty mensagemErro}">
            <div class="error">❌ ${mensagemErro}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/cadastrar">
            <div class="form-group">
                <label for="nome">Nome completo:</label>
                <input type="text" id="nome" name="nome" value="${param.nome}" required>
                <c:if test="${not empty erroNome}"><div class="error">${erroNome}</div></c:if>
            </div>

            <div class="form-group">
                <label for="cpf">CPF:</label>
                <input type="text" id="cpf" name="cpf" value="${param.cpf}" placeholder="000.000.000-00" required>
                <c:if test="${not empty erroCpf}"><div class="error">${erroCpf}</div></c:if>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${param.email}" required>
                <c:if test="${not empty erroEmail}"><div class="error">${erroEmail}</div></c:if>
            </div>

            <div class="form-group">
                <label for="senha">Senha:</label>
                <input type="password" id="senha" name="senha" required>
                <c:if test="${not empty erroSenha}"><div class="error">${erroSenha}</div></c:if>
            </div>

            <div class="form-group">
                <label for="confirmarSenha">Confirmar Senha:</label>
                <input type="password" id="confirmarSenha" name="confirmarSenha" required>
            </div>

            <div class="form-group">
                <label for="grupo">Grupo:</label>
                <select id="grupo" name="grupo" required>
                    <option value="">Selecione o grupo</option>
                    <option value="ADMIN" ${param.grupo == 'ADMIN' ? 'selected' : ''}>Administrador</option>
                    <option value="ESTOQUISTA" ${param.grupo == 'ESTOQUISTA' ? 'selected' : ''}>Estoquista</option>
                </select>
                <c:if test="${not empty erroGrupo}"><div class="error">${erroGrupo}</div></c:if>
            </div>

            <div style="display: flex; gap: 10px; margin-top: 20px;">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Cadastrar Usuário
                </button>
                <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Voltar
                </a>
            </div>
        </form>
    </div>

    <script>
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
            const senha = document.getElementById('senha').value;
            const confirmar = this.value;

            if (senha !== confirmar) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#28a745';
            }
        });
    </script>
</body>
</html>