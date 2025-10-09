package br.com.bytx.util;

import org.mindrot.jbcrypt.BCrypt;

public class CriptografiaUtil {

    /**
     * Criptografa uma senha usando BCrypt
     */
    public static String criptografarSenha(String senha) {
        if (senha == null || senha.trim().isEmpty()) {
            throw new IllegalArgumentException("Senha não pode ser nula ou vazia");
        }

        String hash = BCrypt.hashpw(senha, BCrypt.gensalt(12));
        return hash;
    }

    /**
     * Verifica se uma senha digitada corresponde ao hash armazenado
     */
    public static boolean verificarSenha(String senhaDigitada, String senhaCriptografada) {
        System.out.println("=== VERIFICAÇÃO DE SENHA ===");
        System.out.println("Senha digitada: '" + senhaDigitada + "'");
        System.out.println("Hash armazenado: '" + senhaCriptografada + "'");

        if (senhaDigitada == null) {
            System.out.println("Senha digitada é nula");
            return false;
        }

        if (senhaCriptografada == null) {
            System.out.println("Hash armazenado é nulo");
            return false;
        }

        if (senhaCriptografada.trim().isEmpty()) {
            System.out.println("Hash armazenado está vazio");
            return false;
        }

        try {
            // Verifica se o hash tem o formato BCrypt
            if (!senhaCriptografada.startsWith("$2a$")) {
                System.out.println("Hash não parece ser BCrypt (não começa com $2a$)");
                System.out.println("Hash atual: " + senhaCriptografada);
                return false;
            }

            boolean resultado = BCrypt.checkpw(senhaDigitada, senhaCriptografada);
            System.out.println("Resultado da verificação: " + resultado);

            return resultado;

        } catch (Exception e) {
            System.out.println("Erro na verificação da senha: " + e.getMessage());
            System.out.println("Possível problema: Hash corrompido ou formato inválido");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Método para testar um hash específico - use via console ou página de debug
     */
    public static String testarHash(String senhaTeste, String hashParaTestar) {
        StringBuilder resultado = new StringBuilder();
        resultado.append("=== TESTE DE HASH ===\n");
        resultado.append("Senha testada: ").append(senhaTeste).append("\n");
        resultado.append("Hash para testar: ").append(hashParaTestar).append("\n");

        boolean valido = verificarSenha(senhaTeste, hashParaTestar);
        resultado.append("Resultado: ").append(valido ? "VÁLIDO" : "INVÁLIDO").append("\n");

        // Gerar um novo hash para comparação
        if (!valido) {
            String novoHash = criptografarSenha(senhaTeste);
            resultado.append("Novo hash gerado: ").append(novoHash).append("\n");
            resultado.append("Hash do banco é igual ao novo? ").append(hashParaTestar.equals(novoHash)).append("\n");
        }

        return resultado.toString();
    }


}