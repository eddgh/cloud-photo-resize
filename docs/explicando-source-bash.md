# Porque alguns scripts de gitbash (*.sh) precisam rodar com "source ./script.sh" em vez de simplesmente executarmos direto?
Porque quando você executa um script normalmente no Bash/Git Bash, ele roda em um **subshell** (um processo filho).
Já com `source ./script.sh`, o script roda **dentro do shell atual**.

Essa diferença muda completamente:

* variáveis de ambiente
* diretório atual
* aliases
* funções
* exportações (`export`)
* ativação de ambientes virtuais

---

# Executando normalmente

```bash id="vsbjlwm"
./script.sh
```

ou

```bash id="xdyvzyz"
bash script.sh
```

Nesse caso:

* o Bash cria outro processo
* roda o script
* depois destrói o processo

Tudo que o script alterou morre junto.

---

# Usando source

```bash id="z1c9xcz"
source ./script.sh
```

ou:

```bash id="2onb9e7"
. ./script.sh
```

Agora:

* o script roda no shell atual
* alterações permanecem depois

---

# Exemplo clássico

## script.sh

```bash id="0dfg8ns"
export APP_ENV=production
cd /tmp
```

---

## Executando normalmente

```bash id="cgm0zdf"
./script.sh
```

Depois:

```bash id="2g1xg87"
echo $APP_ENV
pwd
```

Resultado:

* variável desapareceu
* diretório não mudou

Porque tudo ocorreu num subshell.

---

## Usando source

```bash id="x9hmszz"
source ./script.sh
```

Agora:

* `APP_ENV` continua existindo
* diretório mudou para `/tmp`

Porque o shell atual foi modificado.

---

# Casos comuns onde source é necessário

## Python venv

```bash id="s4bxj3x"
source venv/bin/activate
```

O script:

* altera PATH
* define variáveis
* muda prompt

Se rodasse normal:

* ambiente virtual morreria ao fim do processo

---

## SDKs e CLIs

Exemplo:

* NVM
* SDKMAN
* Conda
* scripts AWS
* scripts Docker
* Terraform helpers

Todos modificam ambiente do shell atual.

---

# No Git Bash isso aparece muito

Porque:

* Git Bash emula ambiente Unix no Windows
* muita coisa depende de variáveis temporárias
* vários scripts Linux assumem comportamento POSIX

---

# Regra prática

## Use execução normal:

Quando o script:

* apenas executa comandos
* gera arquivos
* roda build
* roda automação

```bash id="f4ruwmg"
./deploy.sh
```

---

## Use source:

Quando o script:

* muda variáveis de ambiente
* altera PATH
* ativa ambientes
* define aliases/funções
* precisa persistir mudanças

```bash id="phdlw8k"
source env.sh
```

---

# Conceito resumido

> `source` executa o script dentro do shell atual, permitindo que mudanças de ambiente permaneçam após o término do script.
