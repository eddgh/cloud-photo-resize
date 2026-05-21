#!/bin/bash

# 1. Configuração (Mude apenas o ID da conta e o seu nome de usuário)
# MFA_ARN="arn:aws:iam::id-da-sua-conta:mfa/seu-nome-de-usuario"
MFA_ARN="arn:aws:iam::999999999999:mfa/fulano.de-tal-cel"

echo "Digite o código do MFA (6 dígitos):"
read -s token

echo "Solicitando credenciais temporárias..."

# 2. Chama o STS e guarda o JSON da resposta em uma variável
SESSION=$(aws sts get-session-token --serial-number $MFA_ARN --token-code $token --output json)

# 3. Extrai os valores do JSON usando o comando 'sed' (nativo do Git Bash)
# Se você tiver o 'jq' instalado, é melhor, mas com sed funciona em qualquer Git Bash:
export AWS_ACCESS_KEY_ID=$(echo $SESSION | sed -n 's/.*"AccessKeyId": "\([^"]*\)".*/\1/p')
export AWS_SECRET_ACCESS_KEY=$(echo $SESSION | sed -n 's/.*"SecretAccessKey": "\([^"]*\)".*/\1/p')
export AWS_SESSION_TOKEN=$(echo $SESSION | sed -n 's/.*"SessionToken": "\([^"]*\)".*/\1/p')

if [ -z "$AWS_SESSION_TOKEN" ]; then
    echo "Erro: Não foi possível obter o token. Verifique o código ou o ARN."
else
    echo "Sucesso! Sessão autenticada via MFA."
    echo "As credenciais expiram em 12 horas."
    # Testa se está funcionando
    aws sts get-caller-identity
fi