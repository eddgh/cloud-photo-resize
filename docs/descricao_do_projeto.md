# CloudPhotoResize — Descrição Técnica da Arquitetura

O **CloudPhotoResize** é um MVP serverless orientado a processamento automatizado de imagens na nuvem utilizando serviços da Amazon Web Services.

A solução foi projetada com foco em:

* baixo custo operacional,
* escalabilidade automática,
* desacoplamento de componentes,
* simplicidade de manutenção,
* e utilização de serviços gerenciados.

---

# Objetivo do Projeto

A aplicação permite que usuários realizem upload de imagens através de uma interface web hospedada em uma instância Amazon EC2.

Após o envio:

1. a imagem é armazenada no Amazon S3;
2. um evento automático aciona uma função AWS Lambda;
3. a imagem é redimensionada e otimizada;
4. a nova versão é salva em outro bucket/prefixo S3;
5. a aplicação web exibe a galeria de imagens processadas.

---

# Arquitetura Geral

A arquitetura segue um modelo:

* **event-driven**
* **serverless-first**
* **pay-per-use**
* desacoplado por eventos S3.

O fluxo principal ocorre da seguinte forma:

```text id="r7m2k8v"
Usuário → EC2 → S3(upload)
                ↓
            Evento S3
                ↓
             Lambda
                ↓
          S3(resized)
                ↓
              EC2
```

---

# Componentes Utilizados

## 1. Cliente Web

O usuário acessa a aplicação via HTTPS utilizando navegador web.

Funções:

* upload de imagens;
* visualização da galeria;
* consumo das imagens processadas.

---

# 2. Amazon S3 — Bucket de Upload

Serviço:

* Amazon S3

Responsabilidade:

* armazenamento das imagens originais enviadas pelos usuários.

Estrutura lógica:

```text id="x4n9w1q"
uploads/
```

Características:

* armazenamento altamente durável;
* escalabilidade automática;
* baixo custo;
* integração nativa com eventos.

---

# 3. AWS Lambda — Processamento Automático

Serviço:

* AWS Lambda

A função Lambda é acionada automaticamente através de:

* eventos `ObjectCreated` do S3.

Responsabilidades:

* detectar novas imagens;
* realizar redimensionamento;
* otimizar compressão;
* gerar versão padronizada.

Possíveis bibliotecas:

* Sharp (Node.js)
* Pillow (Python)
* ImageMagick

Características técnicas:

* execução sob demanda;
* escalabilidade automática;
* cobrança por execução;
* ausência de gerenciamento de servidores.

---

# 4. Amazon S3 — Bucket/Prefixo de Imagens Processadas

Serviço:

* Amazon S3

Estrutura:

```text id="t8q5m2n"
resized/
```

Responsabilidade:

* armazenar imagens processadas e otimizadas.

Exemplo:

```text id="f2m8x4v"
img_001_800x600.jpg
```

Benefícios:

* separação entre originais e processadas;
* organização lógica;
* facilidade de versionamento e lifecycle policies.

---

# 5. Amazon EC2 — Servidor Web

Serviço:

* Amazon EC2 t3a.micro

Responsabilidade:

* hospedagem da aplicação web;
* renderização da galeria;
* leitura das imagens processadas no S3.

Tecnologias possíveis:

* Nginx
* Apache
* Node.js
* PHP
* React/Vue frontend estático

Justificativa da escolha:

* baixo custo;
* compatibilidade x86;
* modelo burstable ideal para MVP;
* adequado para cargas leves.

---

# 6. Amazon EBS — Persistência Local

Serviço:

* Amazon EBS

Responsabilidades:

* armazenamento persistente da instância EC2;
* sistema operacional;
* logs locais;
* arquivos temporários.

Características:

* persistência independente da instância;
* alta disponibilidade dentro da AZ;
* integração nativa com snapshots.

---

# Escalabilidade

A arquitetura foi desenhada para crescer gradualmente.

## Componentes autoescaláveis:

* S3
* Lambda

## Possível gargalo inicial:

* EC2

Evoluções futuras possíveis:

* migração do frontend para S3 Static Website Hosting;
* utilização de Amazon CloudFront;
* remoção completa da EC2;
* API serverless com Amazon API Gateway.

---

# Segurança

Possíveis mecanismos:

* IAM Roles com princípio do menor privilégio;
* buckets privados;
* HTTPS/TLS;
* MFA para acesso administrativo;
* Security Groups restritivos;
* criptografia S3.

---

# Benefícios da Solução

## Baixo custo

Arquitetura baseada em:

* serverless;
* pay-per-use;
* instâncias burstáveis.

---

## Escalabilidade automática

O processamento de imagens cresce sob demanda através do Lambda.

---

## Desacoplamento

Cada componente possui responsabilidade isolada:

* upload;
* processamento;
* armazenamento;
* entrega.

---

## Facilidade de manutenção

Uso predominante de serviços gerenciados reduz complexidade operacional.

---

# Conclusão Técnica

O CloudPhotoResize representa uma arquitetura moderna orientada a eventos utilizando serviços nativos AWS para construir uma pipeline automatizada de processamento de imagens.

A solução demonstra conceitos fundamentais de cloud computing:

* elasticidade,
* desacoplamento,
* serverless,
* armazenamento distribuído,
* processamento assíncrono,
* e otimização de custos.

O projeto é adequado para:

* MVPs,
* portfólio cloud,
* estudos de arquitetura AWS,
* workloads leves de processamento de mídia,
* e evolução futura para ambientes altamente escaláveis.
