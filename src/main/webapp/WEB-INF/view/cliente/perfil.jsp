<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - BytX</title>
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
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .profile-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        @media (max-width: 768px) {
            .profile-layout {
                grid-template-columns: 1fr;
            }
        }

        .profile-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .card-title {
            font-size: 1.3rem;
            color: #3a7bd5;
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

        input, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #3a7bd5;
            box-shadow: 0 0 0 3px rgba(58, 123, 213, 0.1);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
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
            color: #3a7bd5;
            border: 2px solid #3a7bd5;
        }

        .btn-outline:hover {
            background: #3a7bd5;
            color: white;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        .user-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
        }

        .info-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .info-value {
            font-weight: 500;
            color: #333;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .section {
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-circle"></i> Meu Perfil</h1>
            <p>Gerencie suas informações pessoais</p>
        </div>

        <!-- Mensagens -->
        <c:if test="${not empty sucesso}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sucesso}
            </div>
        </c:if>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${erro}
            </div>
        </c:if>

        <div class="profile-layout">
            <!-- Coluna 1: Dados Pessoais -->
            <div class="profile-card">
                <h3 class="card-title">
                    <i class="fas fa-user-edit"></i> Dados Pessoais
                </h3>

                <form method="post" action="${pageContext.request.contextPath}/cliente/perfil">
                    <input type="hidden" name="acao" value="atualizarDados">

                    <div class="form-group">
                        <label for="nome">Nome Completo</label>
                        <input type="text" id="nome" name="nome" value="${cliente.usuario.nome}" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" value="${cliente.usuario.email}" disabled
                               style="background: #f8f9fa; color: #666;">
                        <small style="color: #666; font-size: 12px;">Email não pode ser alterado</small>
                    </div>

                    <div class="form-group">
                        <label for="cpf">CPF</label>
                        <input type="text" id="cpf" value="${cliente.usuario.cpf}" disabled
                               style="background: #f8f9fa; color: #666;">
                    </div>

                    <div class="form-group">
                        <label for="dataNascimento">Data de Nascimento</label>
                        <input type="date" id="dataNascimento" name="dataNascimento"
                               value="${cliente.dataNascimento}">
                    </div>

                    <div class="form-group">
                        <label for="genero">Gênero</label>
                        <select id="genero" name="genero">
                            <option value="">Selecione...</option>
                            <option value="MASCULINO" ${cliente.genero == 'MASCULINO' ? 'selected' : ''}>Masculino</option>
                            <option value="FEMININO" ${cliente.genero == 'FEMININO' ? 'selected' : ''}>Feminino</option>
                            <option value="OUTRO" ${cliente.genero == 'OUTRO' ? 'selected' : ''}>Outro</option>
                            <option value="PREFIRO_NAO_INFORMAR" ${cliente.genero == 'PREFIRO_NAO_INFORMAR' ? 'selected' : ''}>Prefiro não informar</option>
                        </select>
                    </div>



                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Salvar Alterações
                    </button>
                </form>
            </div>

            <!-- Coluna 2: Alterar Senha e Informações -->
            <div>
                <!-- Alterar Senha -->
                <div class="profile-card" style="margin-bottom: 25px;">
                    <h3 class="card-title">
                        <i class="fas fa-lock"></i> Alterar Senha
                    </h3>

                    <form method="post" action="${pageContext.request.contextPath}/cliente/perfil">
                        <input type="hidden" name="acao" value="alterarSenha">

                        <div class="form-group">
                            <label for="senhaAtual">Senha Atual</label>
                            <input type="password" id="senhaAtual" name="senhaAtual" required>
                        </div>

                        <div class="form-group">
                            <label for="novaSenha">Nova Senha</label>
                            <input type="password" id="novaSenha" name="novaSenha" required
                                   placeholder="Mínimo 6 caracteres">
                        </div>

                        <div class="form-group">
                            <label for="confirmarSenha">Confirmar Nova Senha</label>
                            <input type="password" id="confirmarSenha" name="confirmarSenha" required>
                            <c:if test="${not empty erroSenha}">
                                <div class="alert alert-error" style="margin-top: 10px;">
                                    <i class="fas fa-exclamation-circle"></i> ${erroSenha}
                                </div>
                            </c:if>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-key"></i> Alterar Senha
                        </button>
                    </form>
                </div>

                <!-- Informações da Conta -->
                <div class="profile-card">
                    <h3 class="card-title">
                        <i class="fas fa-info-circle"></i> Informações da Conta
                    </h3>

                    <div class="user-info">
                        <div class="info-item">
                            <div class="info-label">Status da Conta</div>
                            <div class="info-value" style="color: #28a745;">
                                <i class="fas fa-check-circle"></i> Ativa
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Membro desde</div>
                            <div class="info-value">
                                <fmt:formatDate value="${cliente.dataCadastro}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Tipo de Conta</div>
                            <div class="info-value">Cliente</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Total de Endereços</div>
                            <div class="info-value">${cliente.enderecos.size()}</div>
                        </div>
                    </div>

                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/cliente/enderecos" class="btn btn-outline">
                            <i class="fas fa-map-marker-alt"></i> Gerenciar Endereços
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline">
                            <i class="fas fa-store"></i> Continuar Comprando
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Validação de senha em tempo real
        document.getElementById('confirmarSenha').addEventListener('input', function() {
            const novaSenha = document.getElementById('novaSenha').value;
            const confirmar = this.value;

            if (novaSenha !== confirmar && confirmar.length > 0) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#28a745';
            }
        });
    </script>
</body>
</html>