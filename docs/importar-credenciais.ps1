# 1. Localiza o arquivo na sua pasta de Downloads
$path = "$env:USERPROFILE\Downloads\credentials.csv"

# 2. Importa os dados (garantindo que o PowerShell entenda o formato da AWS)
$cred = Import-Csv -Path $path

# 3. Alimenta o AWS CLI silenciosamente
aws configure set aws_access_key_id $cred."Access key ID"
aws configure set aws_secret_access_key $cred."Secret access key"
aws configure set region us-east-1  # Ou a região que você está usando
aws configure set output json

# 4. Limpeza de rastro imediata
Remove-Item -Path $path -Force

Write-Host "Configuração concluída com sucesso e CSV removido!" -ForegroundColor Green