<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Login Automático</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 900px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        @media (min-width: 768px) {
            .container {
                flex-direction: row;
            }
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
            font-size: 16px;
            opacity: 0.9;
        }

        .login-section {
            padding: 30px;
            flex: 1;
        }

        .login-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
            padding-left: 40px;
        }

        .form-group i {
            position: absolute;
            left: 15px;
            top: 40px;
            color: #777;
        }

        .form-group input:focus {
            border-color: #3a7bd5;
            outline: none;
        }

        .btn {
            background: linear-gradient(to right, #3a7bd5, #00d2ff);
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .btn:active {
            transform: translateY(0);
        }

        .links-section {
            background-color: #f9f9f9;
            padding: 30px;
            flex: 1;
        }

        .links-section h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
        }

        .useful-links {
            list-style-type: none;
        }

        .useful-links li {
            margin-bottom: 15px;
        }

        .useful-links a {
            display: flex;
            align-items: center;
            color: #3a7bd5;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .useful-links a:hover {
            color: #00d2ff;
        }

        .useful-links a::before {
            content: "→";
            margin-right: 10px;
            font-weight: bold;
        }

        .footer {
            text-align: center;
            padding: 20px;
            background-color: #eee;
            color: #666;
            font-size: 14px;
        }

        .error-message {
            color: #ff4757;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .success-message {
            background-color: #2ed573;
            color: white;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            text-align: center;
            display: none;
        }

        .login-options {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            font-size: 14px;
        }

        .remember-me {
            display: flex;
            align-items: center;
        }

        .remember-me input {
            margin-right: 5px;
        }

        .forgot-password {
            color: #3a7bd5;
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .loading {
            display: none;
            text-align: center;
            margin-top: 20px;
        }

        .loading i {
            font-size: 24px;
            color: #3a7bd5;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-section">
            <h2>Fazer Login Automático</h2>
            <form id="loginForm">
                <div class="form-group">
                    <label for="username">Usuário</label>
                    <i class="fas fa-user"></i>
                    <input type="text" id="username" placeholder="Digite seu usuário" required>
                    <div class="error-message" id="usernameError">Por favor, insira um nome de usuário válido</div>
                </div>
                <div class="form-group">
                    <label for="password">Senha</label>
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" placeholder="Digite sua senha" required>
                    <div class="error-message" id="passwordError">A senha deve ter pelo menos 6 caracteres</div>
                </div>
                <div class="form-group">
                    <label for="token">Token de Autenticação (Opcional)</label>
                    <i class="fas fa-key"></i>
                    <input type="text" id="token" placeholder="Digite o token se necessário">
                </div>

                <div class="login-options">
                    <div class="remember-me">
                        <input type="checkbox" id="remember">
                        <label for="remember">Lembrar-me</label>
                    </div>
                    <a href="#" class="forgot-password">Esqueci minha senha</a>
                </div>

                <button type="submit" class="btn">Login Automático</button>

                <div class="loading" id="loading">
                    <i class="fas fa-spinner"></i>
                    <p>Processando login...</p>
                </div>

                <div class="success-message" id="successMessage">
                    Login realizado com sucesso! Redirecionando...
                </div>
            </form>
        </div>

        <div class="links-section">
            <h3>Links Úteis</h3>
            <ul class="useful-links">
                <li><a href="#">Página de Login Normal</a></li>
                <li><a href="#">Console H2</a></li>
                <li><a href="#">Página Inicial</a></li>
                <li><a href="#">Suporte Técnico</a></li>
                <li><a href="#">Documentação do Sistema</a></li>
            </ul>

            <div class="demo-accounts">
                <h4>Contas para teste:</h4>
                <p>Usuário: <strong>admin</strong> | Senha: <strong>admin123</strong></p>
                <p>Usuário: <strong>usuario</strong> | Senha: <strong>senha123</strong></p>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const token = document.getElementById('token').value;
            const usernameError = document.getElementById('usernameError');
            const passwordError = document.getElementById('passwordError');
            const loading = document.getElementById('loading');
            const successMessage = document.getElementById('successMessage');

            // Reset error messages
            usernameError.style.display = 'none';
            passwordError.style.display = 'none';

            let isValid = true;

            // Validate username
            if (username.trim() === '' || username.length < 3) {
                usernameError.style.display = 'block';
                isValid = false;
            }

            // Validate password
            if (password.length < 6) {
                passwordError.style.display = 'block';
                isValid = false;
            }

            if (!isValid) {
                return;
            }

            // Show loading animation
            loading.style.display = 'block';

            // Simulate login process
            setTimeout(() => {
                // Check for demo accounts
                if ((username === 'admin' && password === 'admin123') ||
                    (username === 'usuario' && password === 'senha123')) {
                    // Login successful
                    loading.style.display = 'none';
                    successMessage.style.display = 'block';

                    // Simulate redirect
                    setTimeout(() => {
                        alert('Login bem-sucedido! Bem-vindo, ' + username + '!');
                        // In a real scenario, you would redirect to another page
                        // window.location.href = 'dashboard.html';
                    }, 1500);
                } else {
                    // Login failed
                    loading.style.display = 'none';
                    alert('Erro: Usuário ou senha incorretos. Tente novamente.');
                }
            }, 2000);
        });

        // Add real-time validation
        document.getElementById('username').addEventListener('input', function() {
            if (this.value.length >= 3) {
                document.getElementById('usernameError').style.display = 'none';
            }
        });

        document.getElementById('password').addEventListener('input', function() {
            if (this.value.length >= 6) {
                document.getElementById('passwordError').style.display = 'none';
            }
        });
    </script>
</body>
</html>