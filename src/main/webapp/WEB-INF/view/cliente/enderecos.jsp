<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Endereços - BytX</title>
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
        }

        .header h1 {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .content-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        @media (max-width: 768px) {
            .content-layout {
                grid-template-columns: 1fr;
            }
        }

        .card {
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

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
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

        .address-list {
            max-height: 500px;
            overflow-y: auto;
        }

        .address-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #3a7bd5;
            position: relative;
        }

        .address-item.padrao {
            border-left-color: #28a745;
            background: #f0fff4;
        }

        .address-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #28a745;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }

        .address-type {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
            text-transform: uppercase;
            font-weight: 500;
        }

        .address-content {
            line-height: 1.5;
            margin-bottom: 10px;
        }

        .address-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
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

        .nav-links {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }

        .empty-state i {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 15px;
        }
        .btn-warning {
            background: #ffc107;
            color: #212529;
            border: none;
        }

        .btn-warning:hover {
            background: #e0a800;
            color: #212529;
        }

        .btn-success {
            background: #28a745;
            color: white;
            border: none;
        }

        .btn-success:hover {
            background: #218838;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-map-marker-alt"></i> Meus Endereços</h1>
            <p>Gerencie seus endereços de entrega e faturamento</p>
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

        <div class="content-layout">
            <!-- Coluna 1: Adicionar Endereço -->
            <div class="card">
                <h3 class="card-title">
                    <i class="fas fa-plus-circle"></i> Adicionar Endereço de Entrega
                </h3>

                <form method="post" action="${pageContext.request.contextPath}/cliente/enderecos">
                    <input type="hidden" name="acao" value="adicionar">

                    <div class="form-group">
                        <label for="cep" class="required">CEP</label>
                        <input type="text" id="cep" name="cep" placeholder="00000-000" required>
                        <c:if test="${not empty erroCep}">
                            <div class="alert alert-error" style="margin-top: 10px;">
                                <i class="fas fa-exclamation-circle"></i> ${erroCep}
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="logradouro" class="required">Logradouro</label>
                        <input type="text" id="logradouro" name="logradouro"
                               placeholder="Rua, Avenida, etc." required>
                        <c:if test="${not empty erroLogradouro}">
                            <div class="alert alert-error" style="margin-top: 10px;">
                                <i class="fas fa-exclamation-circle"></i> ${erroLogradouro}
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="numero" class="required">Número</label>
                        <input type="text" id="numero" name="numero" placeholder="123" required>
                        <c:if test="${not empty erroNumero}">
                            <div class="alert alert-error" style="margin-top: 10px;">
                                <i class="fas fa-exclamation-circle"></i> ${erroNumero}
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="complemento">Complemento</label>
                        <input type="text" id="complemento" name="complemento"
                               placeholder="Apto, Bloco, etc.">
                    </div>

                    <div class="form-group">
                        <label for="bairro" class="required">Bairro</label>
                        <input type="text" id="bairro" name="bairro" placeholder="Seu bairro" required>
                        <c:if test="${not empty erroBairro}">
                            <div class="alert alert-error" style="margin-top: 10px;">
                                <i class="fas fa-exclamation-circle"></i> ${erroBairro}
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="cidade" class="required">Cidade</label>
                        <input type="text" id="cidade" name="cidade" placeholder="Sua cidade" required>
                        <c:if test="${not empty erroCidade}">
                            <div class="alert alert-error" style="margin-top: 10px;">
                                <i class="fas fa-exclamation-circle"></i> ${erroCidade}
                            </div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="uf" class="required">UF</label>
                        <input type="text" id="uf" name="uf" placeholder="SP" maxlength="2" required>
                        <c:if test="${not empty erroUf}">
                            <div class="alert alert-error" style="margin-top: 10px;">
                                <i class="fas fa-exclamation-circle"></i> ${erroUf}
                            </div>
                        </c:if>
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox" id="padrao" name="padrao">
                        <label for="padrao">Definir como endereço padrão de entrega</label>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Adicionar Endereço
                    </button>
                </form>
            </div>

            <!-- Coluna 2: Lista de Endereços -->
            <div class="card">
                <h3 class="card-title">
                    <i class="fas fa-list"></i> Meus Endereços
                    <span style="font-size: 14px; color: #666; margin-left: auto;">
                        ${cliente.enderecos.size()} endereços
                    </span>
                </h3>

                <div class="address-list">
                    <c:choose>
                        <c:when test="${not empty cliente.enderecos}">
                            <c:forEach var="endereco" items="${cliente.enderecos}">
                                <div class="address-item ${endereco.padrao ? 'padrao' : ''}">
                                    <c:if test="${endereco.padrao}">
                                        <div class="address-badge">PADRÃO</div>
                                    </c:if>

                                    <div class="address-type">
                                        <c:choose>
                                            <c:when test="${endereco.tipo == 'FATURAMENTO'}">
                                                <i class="fas fa-credit-card"></i> Endereço de Faturamento
                                            </c:when>
                                            <c:when test="${endereco.tipo == 'ENTREGA'}">
                                                <i class="fas fa-truck"></i> Endereço de Entrega
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <div class="address-content">
                                        <strong>${endereco.logradouro}, ${endereco.numero}</strong>
                                        <c:if test="${not endereco.ativado}">
                                            <span style="color: #dc3545; margin-left: 10px; font-size: 12px;">
                                                <i class="fas fa-ban"></i> Desativado
                                            </span>
                                        </c:if>
                                        <br>
                                        <c:if test="${not empty endereco.complemento}">
                                            ${endereco.complemento}<br>
                                        </c:if>
                                        ${endereco.bairro}<br>
                                        ${endereco.cidade} - ${endereco.uf}<br>
                                        CEP: ${endereco.cep}
                                    </div>

                                    <div class="address-actions">
                                        <c:if test="${endereco.tipo == 'ENTREGA' && !endereco.padrao}">
                                            <form method="post" action="${pageContext.request.contextPath}/cliente/enderecos" style="display: inline;">
                                                <input type="hidden" name="acao" value="definirPadrao">
                                                <input type="hidden" name="enderecoId" value="${endereco.id}">
                                                <button type="submit" class="btn btn-outline btn-sm">
                                                    <i class="fas fa-star"></i> Tornar Padrão
                                                </button>
                                            </form>
                                        </c:if>

                                        <!-- BOTÕES ATIVAR/DESATIVAR -->
                                        <c:if test="${endereco.tipo == 'ENTREGA' && cliente.enderecos.size() > 1}">
                                            <c:choose>
                                                <c:when test="${endereco.ativado}">
                                                    <form method="post" action="${pageContext.request.contextPath}/cliente/enderecos"
                                                          onsubmit="return confirm('Tem certeza que deseja desativar este endereço?');"
                                                          style="display: inline;">
                                                        <input type="hidden" name="acao" value="desativar">
                                                        <input type="hidden" name="enderecoId" value="${endereco.id}">
                                                        <button type="submit" class="btn btn-warning btn-sm">
                                                            <i class="fas fa-pause"></i> Desativar
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form method="post" action="${pageContext.request.contextPath}/cliente/enderecos" style="display: inline;">
                                                        <input type="hidden" name="acao" value="ativar">
                                                        <input type="hidden" name="enderecoId" value="${endereco.id}">
                                                        <button type="submit" class="btn btn-success btn-sm">
                                                            <i class="fas fa-play"></i> Ativar
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-map-marker-alt"></i>
                                <h3>Nenhum endereço cadastrado</h3>
                                <p>Adicione seu primeiro endereço usando o formulário ao lado.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/cliente/perfil" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Voltar ao Perfil
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline">
                        <i class="fas fa-store"></i> Continuar Comprando
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Máscara do CEP
        document.getElementById('cep').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 8) value = value.slice(0, 8);

            if (value.length > 5) {
                value = value.replace(/(\d{5})(\d{3})/, '$1-$2');
            }
            e.target.value = value;
        });

      // Funções para mensagens de erro do CEP
      function mostrarErroCep(mensagem) {
          // Criar ou atualizar mensagem de erro
          let erroElement = document.getElementById('erro-cep');
          if (!erroElement) {
              erroElement = document.createElement('div');
              erroElement.id = 'erro-cep';
              erroElement.className = 'alert alert-error';
              erroElement.style.marginTop = '10px';
              document.getElementById('cep').parentNode.appendChild(erroElement);
          }
          erroElement.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${mensagem}`;

          document.getElementById('cep').style.borderColor = '#dc3545';
      }

      function limparErroCep() {
          const erroElement = document.getElementById('erro-cep');
          if (erroElement) {
              erroElement.remove();
          }
          document.getElementById('cep').style.borderColor = '#e1e5e9';
      }

      document.getElementById('cep').addEventListener('blur', function() {
          const cepInput = this;
          const cep = cepInput.value.replace(/\D/g, '');

          console.log("CEP digitado:", cepInput.value);
          console.log("CEP limpo:", cep);

          if (cep.length !== 8) {
              if (cep.length > 0) {
                  mostrarErroCep('CEP inválido');
              }
              return;
          }

          cepInput.style.background = '#fff8e1';
          cepInput.disabled = true;
          limparErroCep();

          const url = '/api/cep/' + cep;

          fetch(url)
          .then(response => {
              if (!response.ok) {
                  throw new Error('Erro na consulta');
              }
              return response.json();
          })
          .then(data => {
              cepInput.style.background = '';
              cepInput.disabled = false;

              if (data.erro) {
                  mostrarErroCep('CEP inválido');
                  return;
              }

              // Preencher campos automaticamente
              document.getElementById('logradouro').value = data.logradouro || '';
              document.getElementById('bairro').value = data.bairro || '';
              document.getElementById('cidade').value = data.localidade || '';
              document.getElementById('uf').value = data.uf || '';

              // Limpar erros
              limparErroCep();

              // Focar no número
              document.getElementById('numero').focus();

          })
          .catch(error => {
              cepInput.style.background = '';
              cepInput.disabled = false;
              console.error('Erro:', error);
              mostrarErroCep('Erro ao consultar CEP');
          });
      });

      // Limpar erro quando usuário começar a digitar
      document.getElementById('cep').addEventListener('input', function() {
          const cep = this.value.replace(/\D/g, '');
          if (cep.length > 0) {
              limparErroCep();
              this.style.borderColor = '#e1e5e9';
          }
      });
        // Auto-completar UF em maiúsculas
        document.getElementById('uf').addEventListener('input', function(e) {
            this.value = this.value.toUpperCase();
        });
    </script>
</body>
</html>