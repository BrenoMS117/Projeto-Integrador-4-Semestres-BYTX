<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Cliente - BytX</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            opacity: 0.9;
        }

        .form-container {
            padding: 30px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 18px;
            color: #3a7bd5;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f7ff;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
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

        .required::after {
            content: " *";
            color: #dc3545;
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

        .error {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .success {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 15px 0;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }

        .btn-primary {
            background: #28a745;
            color: white;
            width: 100%;
        }

        .btn-primary:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }

        .login-link a {
            color: #3a7bd5;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .address-fields {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #3a7bd5;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-plus"></i> Cadastro de Cliente</h1>
            <p>Preencha seus dados para criar sua conta</p>
        </div>

        <div class="form-container">
            <!-- Mensagens -->
            <c:if test="${not empty mensagemSucesso}">
                <div class="success">
                    <i class="fas fa-check-circle"></i> ${mensagemSucesso}
                </div>
            </c:if>

            <c:if test="${not empty erroGeral}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> ${erroGeral}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/cadastro-cliente" id="cadastroForm">

                <!-- Seção 1: Dados Pessoais -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-user"></i> Dados Pessoais
                    </h3>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nome" class="required">Nome Completo</label>
                            <input type="text" id="nome" name="nome" value="${param.nome}"
                                   placeholder="Seu nome completo" required>
                            <c:if test="${not empty erroNome}">
                                <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroNome}</div>
                            </c:if>
                            <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">
                                Deve conter pelo menos 2 palavras com 3 letras cada
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="cpf" class="required">CPF</label>
                            <input type="text" id="cpf" name="cpf" value="${param.cpf}"
                                   placeholder="000.000.000-00" required>
                            <c:if test="${not empty erroCpf}">
                                <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroCpf}</div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="email" class="required">Email</label>
                            <input type="email" id="email" name="email" value="${param.email}"
                                   placeholder="seu@email.com" required>
                            <c:if test="${not empty erroEmail}">
                                <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroEmail}</div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="dataNascimento">Data de Nascimento</label>
                            <input type="date" id="dataNascimento" name="dataNascimento" value="${param.dataNascimento}">
                            <c:if test="${not empty erroDataNascimento}">
                                <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroDataNascimento}</div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="genero">Gênero</label>
                            <select id="genero" name="genero">
                                <option value="">Selecione...</option>
                                <option value="MASCULINO" ${param.genero == 'MASCULINO' ? 'selected' : ''}>Masculino</option>
                                <option value="FEMININO" ${param.genero == 'FEMININO' ? 'selected' : ''}>Feminino</option>
                                <option value="OUTRO" ${param.genero == 'OUTRO' ? 'selected' : ''}>Outro</option>
                                <option value="PREFIRO_NAO_INFORMAR" ${param.genero == 'PREFIRO_NAO_INFORMAR' ? 'selected' : ''}>Prefiro não informar</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="telefone">Telefone</label>
                            <input type="text" id="telefone" name="telefone" value="${param.telefone}"
                                   placeholder="(11) 99999-9999">
                        </div>
                    </div>
                </div>

                <!-- Seção 2: Senha -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-lock"></i> Segurança
                    </h3>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="senha" class="required">Senha</label>
                            <input type="password" id="senha" name="senha" required
                                   placeholder="Mínimo 6 caracteres">
                            <c:if test="${not empty erroSenha}">
                                <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroSenha}</div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="confirmarSenha" class="required">Confirmar Senha</label>
                            <input type="password" id="confirmarSenha" name="confirmarSenha" required
                                   placeholder="Digite novamente sua senha">
                            <c:if test="${not empty erroConfirmarSenha}">
                                <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroConfirmarSenha}</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Seção 3: Endereço de Faturamento -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-credit-card"></i> Endereço de Faturamento
                    </h3>

                    <div class="address-fields">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="cep" class="required">CEP</label>
                                <input type="text" id="cep" name="cep" value="${param.cep}"
                                       placeholder="00000-000" required>
                                <c:if test="${not empty erroCep}">
                                    <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroCep}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="logradouro" class="required">Logradouro</label>
                                <input type="text" id="logradouro" name="logradouro" value="${param.logradouro}"
                                       placeholder="Rua, Avenida, etc." required>
                                <c:if test="${not empty erroLogradouro}">
                                    <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroLogradouro}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="numero" class="required">Número</label>
                                <input type="text" id="numero" name="numero" value="${param.numero}"
                                       placeholder="123" required>
                                <c:if test="${not empty erroNumero}">
                                    <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroNumero}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="complemento">Complemento</label>
                                <input type="text" id="complemento" name="complemento" value="${param.complemento}"
                                       placeholder="Apto, Bloco, etc.">
                            </div>

                            <div class="form-group">
                                <label for="bairro" class="required">Bairro</label>
                                <input type="text" id="bairro" name="bairro" value="${param.bairro}"
                                       placeholder="Seu bairro" required>
                                <c:if test="${not empty erroBairro}">
                                    <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroBairro}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="cidade" class="required">Cidade</label>
                                <input type="text" id="cidade" name="cidade" value="${param.cidade}"
                                       placeholder="Sua cidade" required>
                                <c:if test="${not empty erroCidade}">
                                    <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroCidade}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="uf" class="required">UF</label>
                                <input type="text" id="uf" name="uf" value="${param.uf}"
                                       placeholder="SP" maxlength="2" required>
                                <c:if test="${not empty erroUf}">
                                    <div class="error"><i class="fas fa-exclamation-circle"></i> ${erroUf}</div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox" id="mesmoEndereco" name="mesmoEndereco" checked>
                        <label for="mesmoEndereco">Usar mesmo endereço para entrega</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-user-plus"></i> Criar Conta
                </button>
            </form>

            <div class="login-link">
                Já tem uma conta? <a href="${pageContext.request.contextPath}/login">Faça login aqui</a>
            </div>
        </div>
    </div>

    <script>
        // Máscaras
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

        document.getElementById('telefone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 11) value = value.slice(0, 11);

            if (value.length > 10) {
                value = value.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
            } else if (value.length > 6) {
                value = value.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
            } else if (value.length > 2) {
                value = value.replace(/(\d{2})(\d{4})/, '($1) $2');
            } else if (value.length > 0) {
                value = value.replace(/(\d{2})/, '($1)');
            }
            e.target.value = value;
        });

        document.getElementById('cep').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 8) value = value.slice(0, 8);

            if (value.length > 5) {
                value = value.replace(/(\d{5})(\d{3})/, '$1-$2');
            }
            e.target.value = value;
        });

        // Validação de senha em tempo real
        document.getElementById('confirmarSenha').addEventListener('input', function() {
            const senha = document.getElementById('senha').value;
            const confirmar = this.value;

            if (senha !== confirmar && confirmar.length > 0) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#28a745';
            }
        });

        // CONSULTA CEP COM API ALTERNATIVA
        document.getElementById('cep').addEventListener('blur', function() {
            const cep = this.value.replace(/\D/g, '');

            if (cep.length !== 8) return;

            this.style.background = '#fff8e1';

            // Tentar API do OpenCEP (alternativa)
            const url = `https://opencep.com/v1/${cep}`;

            fetch(url)
            .then(response => {
                if (!response.ok) throw new Error('Erro na API');
                return response.json();
            })
            .then(data => {
                this.style.background = '';

                if (data.erro) {
                    alert('CEP não encontrado!');
                    return;
                }

                document.getElementById('logradouro').value = data.logradouro || '';
                document.getElementById('bairro').value = data.bairro || '';
                document.getElementById('cidade').value = data.localidade || '';
                document.getElementById('uf').value = data.uf || '';
                document.getElementById('numero').focus();

            })
            .catch(error => {
                this.style.background = '';
                console.error('Erro:', error);

                // Última tentativa com ViaCEP direto
                tentarViaCEPDireto(cep);
            });
        });

        function tentarViaCEPDireto(cep) {
            // Criar script dinâmico para bypass CORS (JSONP)
            const script = document.createElement('script');
            script.src = `https://viacep.com.br/ws/${cep}/json/?callback=meuCallback`;
            document.head.appendChild(script);

            // Remover após uso
            setTimeout(() => {
                document.head.removeChild(script);
            }, 1000);
        }

        // Função de callback para JSONP
        window.meuCallback = function(data) {
            if (data.erro) {
                alert('CEP não encontrado!');
                return;
            }

            document.getElementById('logradouro').value = data.logradouro || '';
            document.getElementById('bairro').value = data.bairro || '';
            document.getElementById('cidade').value = data.localidade || '';
            document.getElementById('uf').value = data.uf || '';
            document.getElementById('numero').focus();
        };

        // Validação do nome em tempo real
        document.getElementById('nome').addEventListener('blur', function() {
            const nome = this.value.trim();
            const palavras = nome.split(/\s+/);

            if (palavras.length < 2) {
                this.style.borderColor = '#dc3545';
            } else {
                let valido = true;
                for (let palavra of palavras) {
                    if (palavra.length < 3) {
                        valido = false;
                        break;
                    }
                }
                this.style.borderColor = valido ? '#28a745' : '#dc3545';
            }
        });
    </script>
</body>
</html>