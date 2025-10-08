<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="br.com.bytx.model.Usuario" %>
<%
    if (session == null || session.getAttribute("usuarioLogado") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (!usuario.isEstoquista()) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?erro=Acesso negado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Estoquista - Sistema BytX</title>
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

        .estoque-header {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .card-estoque {
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body>
    <div class="header estoque-header">
        <div class="logo">
            <i class="fas fa-boxes"></i>
            <span>Sistema BytX - Estoquista</span>
        </div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=<%= usuario.getNome() %>&background=28a745&color=fff" alt="User">
            <span><%= usuario.getNome() %> (Estoquista)</span>
            <form action="${pageContext.request.contextPath}/logout" method="get">
                <button type="submit" class="logout-btn">Sair <i class="fas fa-sign-out-alt"></i></button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/estoque/produtos" style="text-decoration: none; color: inherit;"><i class="fas fa-boxes"></i> Gerenciar Estoque</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="welcome-banner">
                <h1>Bem-vindo, Estoquista <%= usuario.getNome() %>! 📦</h1>
                <p>Controle de estoque e gestão de produtos</p>
            </div>

            <div class="dashboard-cards">
                <div class="card card-estoque">
                    <div class="card-header">
                        <div class="card-title">Acesso Rápido</div>
                        <div class="card-icon">
                            <i class="fas fa-boxes"></i>
                        </div>
                    </div>
                    <div class="card-value">Gerenciar Estoque</div>
                    <div class="card-text">
                        <a href="${pageContext.request.contextPath}/estoque/produtos"
                           style="color: #28a745; text-decoration: none; font-weight: bold;">
                            <i class="fas fa-arrow-right"></i> Ver todos os produtos
                        </a>
                    </div>
                </div>

                </div>
            </div>

        </div>
    </div>

    <script>
        document.querySelectorAll('.sidebar-menu li').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.sidebar-menu li').forEach(i => i.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>