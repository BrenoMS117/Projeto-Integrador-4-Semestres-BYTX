package br.com.bytx.util;


public class ValidadorCPF {

    /**
     * Valida um número de CPF
     * @param cpf Número do CPF (com ou sem formatação)
     * @return true se o CPF for válido, false caso contrário
     */
    public static boolean validar(String cpf) {
        if (cpf == null || cpf.trim().isEmpty()) {
            return false;
        }

        // Remove caracteres não numéricos
        cpf = cpf.replaceAll("[^0-9]", "");

        // Verifica se tem 11 dígitos ou se todos são iguais
        if (cpf.length() != 11 || cpf.matches("(\\d)\\1{10}")) {
            return false;
        }

        try {
            // Converte para array de inteiros
            int[] digits = new int[11];
            for (int i = 0; i < 11; i++) {
                digits[i] = Character.getNumericValue(cpf.charAt(i));
            }

            // Calcula o primeiro dígito verificador
            int soma = 0;
            for (int i = 0; i < 9; i++) {
                soma += digits[i] * (10 - i);
            }
            int resto = soma % 11;
            int digito1 = (resto < 2) ? 0 : 11 - resto;

            // Calcula o segundo dígito verificador
            soma = 0;
            for (int i = 0; i < 10; i++) {
                soma += digits[i] * (11 - i);
            }
            resto = soma % 11;
            int digito2 = (resto < 2) ? 0 : 11 - resto;

            // Verifica se os dígitos calculados conferem com os informados
            return (digits[9] == digito1) && (digits[10] == digito2);

        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Formata um CPF válido (xxx.xxx.xxx-xx)
     * @param cpf CPF sem formatação
     * @return CPF formatado ou null se inválido
     */
    public static String formatar(String cpf) {
        if (!validar(cpf)) {
            return null;
        }

        cpf = cpf.replaceAll("[^0-9]", "");
        return cpf.substring(0, 3) + "." +
                cpf.substring(3, 6) + "." +
                cpf.substring(6, 9) + "-" +
                cpf.substring(9, 11);
    }

    /**
     * Remove a formatação do CPF
     * @param cpf CPF formatado ou não
     * @return CPF apenas com números
     */
    public static String removerFormatacao(String cpf) {
        if (cpf == null) return null;
        return cpf.replaceAll("[^0-9]", "");
    }

    /**
     * Método para testar a validação
     */

}