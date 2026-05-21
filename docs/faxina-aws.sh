#!/bin/bash

# Verifica se o arquivo CSV foi passado
if [ -z "$1" ]; then
    echo "Uso: ./faxina-aws.sh usuarios.csv"
    exit 1
fi

INPUT="$1"

# Pula o cabeçalho e lê o arquivo
# IFS=';' porque o seu CSV usa ponto e vírgula
tail -n +2 "$INPUT" | while IFS=';' read -r usuario grupo senha || [ -n "$usuario" ]; do
    
    # Remove espaços em branco indesejados (limpeza de string)
    usuario=$(echo $usuario | tr -d '\r' | tr -d ' ')
    grupo=$(echo $grupo | tr -d '\r' | tr -d ' ')

    echo "------------------------------------------"
    echo "Higienizando usuário: $usuario"

    # 1. Remove do grupo (O 2>/dev/null esconde erros se já estiver fora)
    aws iam remove-user-from-group --group-name "$grupo" --user-name "$usuario" 2>/dev/null
    echo "[-] Removido do grupo $grupo"

    # 2. Deleta o perfil de login (a senha do console)
    aws iam delete-login-profile --user-name "$usuario" 2>/dev/null
    echo "[-] Perfil de login excluído"

    # 3. Deleta o usuário permanentemente
    aws iam delete-user --user-name "$usuario" 2>/dev/null
    echo "[!] Usuário $usuario deletado com sucesso!"

done

echo "------------------------------------------"
echo "CONTA LIMPA! O robô aspirador terminou o serviço. 🧹"