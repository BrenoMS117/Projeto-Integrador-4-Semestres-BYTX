<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Login Automático</title>
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
    </style>
</head>
<body>
    <%
        // Verificar se o usuário está logado
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Obter dados do usuário da sessão
        br.com.bytx.model.Usuario usuario = (br.com.bytx.model.Usuario) session.getAttribute("usuarioLogado");
        String grupoUsuario = (String) session.getAttribute("grupoUsuario");

        // Data e hora atuais para exibição
        SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy 'às' HH:mm");
        String dataHoraLogin = sdf.format(new Date());
    %>

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
                <li class="active"><i class="fas fa-home"></i> Dashboard</li>
                <li><i class="fas fa-chart-bar"></i> Relatórios</li>
                <li><a href="${pageContext.request.contextPath}/produto/listar" style="text-decoration: none; color: inherit;"><i class="fas fa-tag"></i> Produtos</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/usuarios" style="text-decoration: none; color: inherit;"><i class="fas fa-users"></i> Gerenciar Usuários</a></li>
                <li><i class="fas fa-cog"></i> Configurações</li>
                <li><i class="fas fa-database"></i> Console H2</li>
                <li><i class="fas fa-history"></i> Histórico</li>
                <li><i class="fas fa-question-circle"></i> Ajuda</li>
            </ul>
        </div>

        <div class="main-content">
            <div class="welcome-banner">
                <h1>Bem-vindo ao Sistema BytX, <%= usuario.getNome() %>!</h1>
                <p>Seu login foi realizado com sucesso em <%= dataHoraLogin %></p>
                <p><strong>Perfil:</strong> <%= "ADMIN".equals(grupoUsuario) ? "Administrador" : "Estoquista" %></p>
            </div>

            <div class="dashboard-cards">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">Usuários Ativos</div>
                        <div class="card-icon">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="card-value">1,248</div>
                    <div class="card-text">+12% desde o último mês</div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-title">Processos Hoje</div>
                        <div class="card-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                    </div>
                    <div class="card-value">384</div>
                    <div class="card-text">+8% desde ontem</div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-title">Taxa de Sucesso</div>
                        <div class="card-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                    </div>
                    <div class="card-value">98.2%</div>
                    <div class="card-text">+2.4% desde a última semana</div>
                </div>
            </div>

            <div class="recent-activities">
                <h2 class="section-title">Atividades Recentes</h2>
                <ul class="activity-list">
                    <li class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Login realizado com sucesso</div>
                            <div class="activity-time">Há 2 minutos</div>
                        </div>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-file-import"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Novo arquivo de configuração importado</div>
                            <div class="activity-time">Há 15 minutos</div>
                        </div>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-sync-alt"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Sincronização automática concluída</div>
                            <div class="activity-time">Há 1 hora</div>
                        </div>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Sistema de segurança atualizado</div>
                            <div class="activity-time">Ontem às 16:45</div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>Sistema BytX © 2023 - Todos os direitos reservados</p>
        <p>Versão 2.3.1 | Última atualização: <%= new SimpleDateFormat("dd/MM/yyyy").format(new Date()) %></p>
    </div>

    <script>
        // Adicionando interatividade ao menu
        const menuItems = document.querySelectorAll('.sidebar-menu li');
        menuItems.forEach(item => {
            item.addEventListener('click', function() {
                menuItems.forEach(i => i.classList.remove('active'));
                this.classList.add('active');

                // Simular carregamento de conteúdo
                const title = this.querySelector('i').nextSibling.textContent.trim();
                document.querySelector('.welcome-banner h1').textContent = `Bem-vindo ao ${title}, <%= usuario.getNome() %>!`;
            });
        });

        // Simular notificação
        setTimeout(() => {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.bottom = '20px';
            notification.style.right = '20px';
            notification.style.backgroundColor = '#3a7bd5';
            notification.style.color = 'white';
            notification.style.padding = '15px';
            notification.style.borderRadius = '5px';
            notification.style.boxShadow = '0 4px 10px rgba(0,0,0,0.2)';
            notification.innerHTML = '<i class="fas fa-bell"></i> Sistema sincronizado com sucesso!';
            document.body.appendChild(notification);

            // Remover notificação após 5 segundos
            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transition = 'opacity 0.5s';
                setTimeout(() => notification.remove(), 500);
            }, 5000);
        }, 3000);
    </script>
</body>
</html>