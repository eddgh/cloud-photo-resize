#!/bin/bash

# Verifica se o argumento de entrada foi fornecido
if [ -z "$1" ]; then
    echo "Por favor, forneça o arquivo CSV como argumento."
    exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "$INPUT arquivo não encontrado"
    exit 1
fi

command -v dos2unix >/dev/null || { echo "utilitário dos2unix não encontrado. Por favor, instale dos2unix antes de executar o script."; exit 1; }

dos2unix "$INPUT"

# A MÁGICA ESTÁ AQUI: o 'tail -n +2' lê o arquivo a partir da SEGUNDA linha
tail -n +2 "$INPUT" | while IFS= read -r line || [ -n "$line" ]; do
    
    # Separa as informações usando o delimitador ';'
    usuario=$(echo "$line" | cut -d';' -f1)
    grupo=$(echo "$line" | cut -d';' -f2)
    senha=$(echo "$line" | cut -d';' -f3)

    echo "Processando usuário: $usuario..."

    # Cria um usuário no IAM
    aws iam create-user --user-name "$usuario"
    
    # Define uma senha e solicita a redefinição
    aws iam create-login-profile --password-reset-required --user-name "$usuario" --password "$senha"
    
    # Adiciona o usuário ao grupo
    aws iam add-user-to-group --group-name "$grupo" --user-name "$usuario"

done

echo "Usuários importados com sucesso."
