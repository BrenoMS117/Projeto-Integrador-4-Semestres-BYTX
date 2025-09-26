package br.com.bytx.controller.produto;

import br.com.bytx.dao.ImagemProdutoDAO;
import br.com.bytx.dao.ProdutoDAO;
import br.com.bytx.model.Usuario;
import br.com.bytx.model.produto.ImagemProduto;
import br.com.bytx.model.produto.Produto;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;

@WebServlet("/produto/imagens")
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 5,      // 5 MB
        maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class ImagemProdutoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !usuario.isAdministrador()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String produtoId = request.getParameter("id");
        if (produtoId != null) {
            try {
                ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
                request.setAttribute("imagens", imagemDAO.buscarPorProdutoId(Long.parseLong(produtoId)));
                request.setAttribute("produtoId", produtoId);
            } catch (NumberFormatException e) {
                request.setAttribute("erro", "ID do produto inválido");
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/produto/gerenciar-imagens.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        System.out.println("=== INICIANDO UPLOAD DE IMAGEM ===");

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !usuario.isAdministrador()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // DEBUG: Log dos parâmetros
        System.out.println("Parâmetros recebidos:");
        java.util.Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String paramName = params.nextElement();
            System.out.println(paramName + ": " + request.getParameter(paramName));
        }

        String produtoIdStr = request.getParameter("produtoId");
        System.out.println("produtoId: " + produtoIdStr);

        if (produtoIdStr == null || produtoIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/produto/listar?erro=ID do produto não especificado");
            return;
        }

        try {
            Long produtoId = Long.parseLong(produtoIdStr);
            ProdutoDAO produtoDAO = new ProdutoDAO();
            Produto produto = produtoDAO.buscarPorId(produtoId);

            if (produto == null) {
                response.sendRedirect(request.getContextPath() + "/produto/listar?erro=Produto não encontrado");
                return;
            }

            // Verificar se é upload ou remoção
            String acao = request.getParameter("acao");
            if (acao != null && acao.equals("remover")) {
                processarRemocao(request, response, produtoId);
                return;
            }

            // PROCESSAR UPLOAD
            processarUpload(request, response, produto);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produtoIdStr + "&acao=editar&erro=Erro ao processar imagem: " + e.getMessage());
        }
    }

    private void processarUpload(HttpServletRequest request, HttpServletResponse response, Produto produto)
            throws IOException, ServletException {

        try {
            Part filePart = request.getPart("novaImagem");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produto.getId() + "&acao=editar&erro=Nenhuma imagem selecionada");
                return;
            }

            // Obter nome do arquivo CORRETAMENTE
            String fileName = getFileName(filePart);
            System.out.println("Nome do arquivo: " + fileName);

            if (fileName == null || fileName.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produto.getId() + "&acao=editar&erro=Nome de arquivo inválido");
                return;
            }

            // Validar extensão
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp").contains(fileExtension)) {
                response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produto.getId() + "&acao=editar&erro=Tipo de arquivo não suportado. Use JPG, PNG, GIF ou BMP");
                return;
            }

            // Criar diretório de uploads
            String uploadPath = getServletContext().getRealPath("/uploads/imagens");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
                System.out.println("Diretório criado: " + uploadPath);
            }

            // Verificar se é imagem principal
            boolean isPrincipal = "on".equals(request.getParameter("imagemPrincipal"));
            System.out.println("É principal: " + isPrincipal);

            // Se for principal, remover status de principal das outras imagens
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            if (isPrincipal) {
                imagemDAO.removerPrincipalDoProduto(produto.getId());
            }

            // Gerar nome único para o arquivo
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Salvar arquivo fisicamente
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Arquivo salvo em: " + filePath);
            }

            // Salvar no banco de dados
            ImagemProduto novaImagem = new ImagemProduto();
            novaImagem.setProduto(produto);
            novaImagem.setNomeArquivo(uniqueFileName);
            novaImagem.setCaminho("/uploads/imagens");
            novaImagem.setPrincipal(isPrincipal);

            boolean sucesso = imagemDAO.inserir(novaImagem);
            System.out.println("Imagem salva no banco: " + sucesso);

            if (sucesso) {
                request.getSession().setAttribute("mensagemSucesso", "Imagem salva com sucesso!");
                response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produto.getId() + "&acao=editar");
            } else {
                new File(filePath).delete();
                request.getSession().setAttribute("mensagemErro", "Erro ao salvar imagem no banco de dados");
                response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produto.getId() + "&acao=editar");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produto.getId() + "&acao=editar&erro=Erro no upload: " + e.getMessage());
        }
    }

    private void processarRemocao(HttpServletRequest request, HttpServletResponse response, Long produtoId)
            throws IOException {

        String imagemIdStr = request.getParameter("imagemId");
        System.out.println("Removendo imagem ID: " + imagemIdStr);

        if (imagemIdStr == null || imagemIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produtoId + "&acao=editar&erro=ID da imagem não especificado");
            return;
        }

        try {
            Long imagemId = Long.parseLong(imagemIdStr);
            ImagemProdutoDAO imagemDAO = new ImagemProdutoDAO();
            ImagemProduto imagem = imagemDAO.buscarPorId(imagemId);

            if (imagem == null) {
                response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produtoId + "&acao=editar&erro=Imagem não encontrada");
                return;
            }

            // Deletar arquivo físico
            String filePath = getServletContext().getRealPath(imagem.getCaminho() + "/" + imagem.getNomeArquivo());
            File arquivo = new File(filePath);
            if (arquivo.exists()) {
                if (arquivo.delete()) {
                    System.out.println("Arquivo físico deletado: " + filePath);
                } else {
                    System.out.println("Falha ao deletar arquivo físico: " + filePath);
                }
            }

            // Deletar do banco
            if (imagemDAO.deletar(imagemId)) {
                request.getSession().setAttribute("mensagemSucesso", "Imagem removida com sucesso!");
            } else {
                request.getSession().setAttribute("mensagemErro", "Erro ao remover imagem do banco");
            }
            response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produtoId + "&acao=editar");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/produto/gerenciar?id=" + produtoId + "&acao=editar&erro=ID da imagem inválido");
        }
    }

    // MÉTODO CORRIGIDO para obter nome do arquivo
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        System.out.println("Content-Disposition: " + contentDisposition);

        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                token = token.trim();
                if (token.startsWith("filename")) {
                    String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                    // Extrair apenas o nome do arquivo do caminho completo
                    if (fileName.contains("\\")) {
                        fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
                    } else if (fileName.contains("/")) {
                        fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
                    }
                    return fileName;
                }
            }
        }
        return null;
    }
}