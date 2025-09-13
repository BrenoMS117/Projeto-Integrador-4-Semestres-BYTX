<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.bytx.util.CriptografiaUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Debug - Teste de Hash</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        pre { background: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto; }
        code { background: #eee; padding: 2px 5px; border-radius: 3px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>🔧 Teste de Hash BCrypt - Debug</h1>

    <div class="section">
        <h2>Testar Hash</h2>
        <form method="post">
            <div>
                <label>Senha: <input type="text" name="senha" value="admin123"></label>
            </div>
            <div>
                <label>Hash: <input type="text" name="hash" value="${param.hash}" size="70"></label>
            </div>
            <div>
                <button type="submit">Testar</button>
            </div>
        </form>
    </div>

    <%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String senha = request.getParameter("senha");
        String hash = request.getParameter("hash");

        if (senha != null && hash != null) {
            String resultado = CriptografiaUtil.testarHash(senha, hash);
    %>
            <div class="section">
                <h2>Resultado do Teste:</h2>
                <pre><%= resultado %></pre>
            </div>
    <%
        }
    }
    %>

    <div class="section">
        <h2>Informações do Banco de Dados</h2>
        <p>Para verificar o hash atual no banco, execute no console H2:</p>
        <code>SELECT email, senha FROM usuarios WHERE email = 'admin@bytX.com';</code>

        <p>Para atualizar o hash, execute:</p>
        <code>UPDATE usuarios SET senha = 'SEU_NOVO_HASH_AQUI' WHERE email = 'admin@bytX.com';</code>
    </div>

    <div class="section">
        <h2>Hash de Exemplo Válido</h2>
        <p>Um hash BCrypt válido para "admin123" deve parecer com:</p>
        <code>$2a$12$r4A6aU6wz6q6q6q6q6q6qO6q6q6q6q6q6q6q6q6q6q6q6q6q6q6</code>
    </div>
</body>
</html>