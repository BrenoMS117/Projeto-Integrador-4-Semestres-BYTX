package br.com.bytx.util;

public class ValidadorCliente {

    /**
     * Valida se o nome tem pelo menos 2 palavras com mínimo 3 letras cada
     */
    public static boolean validarNome(String nome) {
        if (nome == null || nome.trim().isEmpty()) {
            return false;
        }

        String[] palavras = nome.trim().split("\\s+");

        if (palavras.length < 2) {
            return false;
        }

        for (String palavra : palavras) {
            if (palavra.length() < 3) {
                return false;
            }
        }

        return true;
    }

    /**
     * Valida formato do CEP (apenas números, 8 dígitos)
     */
    public static boolean validarCEP(String cep) {
        if (cep == null) {
            return false;
        }

        String cepLimpo = cep.replace("-", "").replace(" ", "");
        return cepLimpo.matches("\\d{8}");
    }
}