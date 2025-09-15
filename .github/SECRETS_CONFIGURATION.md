# 🔐 Configuração de Secrets - GitHub Actions

## 📋 Visão Geral

Este documento descreve como configurar os secrets necessários para os GitHub Actions do projeto WebDiário Platform, incluindo credenciais para DockerHub, Grafana, AWS e GCP.

## 🎯 Secrets Necessários

### 🐳 **DockerHub Secrets**

#### `DOCKERHUB_USERNAME`
- **Descrição**: Nome de usuário do DockerHub
- **Tipo**: String
- **Exemplo**: `webdiario`
- **Obrigatório**: ✅ Sim
- **Uso**: Login no DockerHub para push das imagens

#### `DOCKERHUB_TOKEN`
- **Descrição**: Token de acesso do DockerHub (não a senha)
- **Tipo**: String (Access Token)
- **Exemplo**: `dckr_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **Obrigatório**: ✅ Sim
- **Uso**: Autenticação para push das imagens

**Como obter o token:**
1. Acesse [DockerHub](https://hub.docker.com/)
2. Vá em **Account Settings** → **Security**
3. Clique em **New Access Token**
4. Dê um nome descritivo (ex: "GitHub Actions WebDiário")
5. Selecione as permissões necessárias (Read, Write, Delete)
6. Copie o token gerado

### 📊 **Grafana Secrets**

#### `GRAFANA_ADMIN_USER`
- **Descrição**: Usuário administrador do Grafana
- **Tipo**: String
- **Exemplo**: `admin`
- **Obrigatório**: ⚠️ Opcional (para configurações específicas)
- **Uso**: Configuração de dashboards e alertas

#### `GRAFANA_ADMIN_PASSWORD`
- **Descrição**: Senha do administrador do Grafana
- **Tipo**: String (senha segura)
- **Exemplo**: `GrafanaSecurePass123!`
- **Obrigatório**: ⚠️ Opcional (para configurações específicas)
- **Uso**: Configuração de dashboards e alertas

#### `GRAFANA_API_KEY`
- **Descrição**: Chave API do Grafana para automação
- **Tipo**: String (API Key)
- **Exemplo**: `eyJrIjoiR0ZXZmtqUFJkUjNxS0E3eFJ6dHoxM2lKZ0x6VzEiLCJuIjoiZ2l0aHViLWFjdGlvbnMiLCJpZCI6MX0=`
- **Obrigatório**: ⚠️ Opcional (para automação avançada)
- **Uso**: Configuração automática de dashboards

**Como obter a API Key:**
1. Acesse o Grafana (http://localhost:3000)
2. Vá em **Configuration** → **API Keys**
3. Clique em **New API Key**
4. Dê um nome descritivo
5. Selecione as permissões (Admin, Editor, Viewer)
6. Copie a chave gerada

### ☁️ **AWS Secrets**

#### `AWS_ACCESS_KEY_ID`
- **Descrição**: Chave de acesso AWS
- **Tipo**: String (Access Key ID)
- **Exemplo**: `AKIAIOSFODNN7EXAMPLE`
- **Obrigatório**: ⚠️ Opcional (para integração AWS)
- **Uso**: Autenticação com serviços AWS

#### `AWS_SECRET_ACCESS_KEY`
- **Descrição**: Chave secreta AWS
- **Tipo**: String (Secret Access Key)
- **Exemplo**: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`
- **Obrigatório**: ⚠️ Opcional (para integração AWS)
- **Uso**: Autenticação com serviços AWS

#### `AWS_DEFAULT_REGION`
- **Descrição**: Região padrão AWS
- **Tipo**: String
- **Exemplo**: `us-east-1`
- **Obrigatório**: ⚠️ Opcional (para integração AWS)
- **Uso**: Configuração de região para serviços AWS

**Como obter as credenciais AWS:**
1. Acesse o [AWS Console](https://console.aws.amazon.com/)
2. Vá em **IAM** → **Users** → **Create User**
3. Selecione **Programmatic access**
4. Anexe políticas necessárias (ex: `AmazonEC2ContainerRegistryFullAccess`)
5. Copie o **Access Key ID** e **Secret Access Key**

### 🌐 **GCP Secrets**

#### `GCP_PROJECT_ID`
- **Descrição**: ID do projeto Google Cloud
- **Tipo**: String
- **Exemplo**: `webdiario-platform-123456`
- **Obrigatório**: ⚠️ Opcional (para integração GCP)
- **Uso**: Identificação do projeto GCP

#### `GCP_SERVICE_ACCOUNT_KEY`
- **Descrição**: Chave da service account GCP (JSON)
- **Tipo**: String (JSON completo)
- **Exemplo**: `{"type": "service_account", "project_id": "webdiario-platform-123456", ...}`
- **Obrigatório**: ⚠️ Opcional (para integração GCP)
- **Uso**: Autenticação com serviços GCP

#### `GCP_REGION`
- **Descrição**: Região padrão GCP
- **Tipo**: String
- **Exemplo**: `us-central1`
- **Obrigatório**: ⚠️ Opcional (para integração GCP)
- **Uso**: Configuração de região para serviços GCP

**Como obter as credenciais GCP:**
1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Vá em **IAM & Admin** → **Service Accounts**
3. Clique em **Create Service Account**
4. Dê um nome e descrição
5. Anexe as roles necessárias (ex: `Container Registry Service Agent`)
6. Clique em **Create Key** → **JSON**
7. Baixe o arquivo JSON e copie o conteúdo

## 🚀 Como Configurar os Secrets

### 📝 **Via GitHub Web Interface**

1. **Acesse o repositório** no GitHub
2. Vá em **Settings** → **Secrets and variables** → **Actions**
3. Clique em **New repository secret**
4. Digite o **Name** (ex: `DOCKERHUB_USERNAME`)
5. Digite o **Secret** (ex: `webdiario`)
6. Clique em **Add secret**
7. Repita para todos os secrets necessários

### 🔧 **Via GitHub CLI**

```bash
# Instalar GitHub CLI (se não tiver)
# https://cli.github.com/

# Fazer login
gh auth login

# Adicionar secrets
gh secret set DOCKERHUB_USERNAME --body "webdiario"
gh secret set DOCKERHUB_TOKEN --body "dckr_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
gh secret set GRAFANA_ADMIN_USER --body "admin"
gh secret set GRAFANA_ADMIN_PASSWORD --body "GrafanaSecurePass123!"
gh secret set AWS_ACCESS_KEY_ID --body "AKIAIOSFODNN7EXAMPLE"
gh secret set AWS_SECRET_ACCESS_KEY --body "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
gh secret set AWS_DEFAULT_REGION --body "us-east-1"
gh secret set GCP_PROJECT_ID --body "webdiario-platform-123456"
gh secret set GCP_SERVICE_ACCOUNT_KEY --body '{"type": "service_account", "project_id": "webdiario-platform-123456", ...}'
gh secret set GCP_REGION --body "us-central1"
```

### 🏢 **Para Organizações**

Se o repositório pertence a uma organização, você pode configurar secrets a nível de organização:

1. Vá para a **organização** no GitHub
2. Clique em **Settings** → **Secrets and variables** → **Actions**
3. Clique em **New organization secret**
4. Configure os secrets que serão compartilhados entre repositórios

## 🔒 **Boas Práticas de Segurança**

### ✅ **Recomendações**

1. **Use tokens específicos**: Crie tokens com permissões mínimas necessárias
2. **Rotacione credenciais**: Mude senhas e tokens regularmente
3. **Monitore acesso**: Revise logs de acesso periodicamente
4. **Use variáveis de ambiente**: Não hardcode credenciais no código
5. **Limite escopo**: Use secrets apenas quando necessário
6. **Audite permissões**: Revise permissões de tokens regularmente

### ❌ **Evite**

1. **Compartilhar credenciais**: Nunca compartilhe secrets via chat/email
2. **Usar credenciais pessoais**: Use contas de serviço dedicadas
3. **Permissões excessivas**: Não dê mais permissões que o necessário
4. **Logs de credenciais**: Nunca faça log de secrets
5. **Commits com credenciais**: Nunca commite credenciais no código

## 🧪 **Testando a Configuração**

### 🔍 **Verificar Secrets**

```bash
# Listar secrets configurados
gh secret list

# Verificar se um secret específico existe
gh secret get DOCKERHUB_USERNAME
```

### 🐳 **Testar DockerHub**

```bash
# Testar login no DockerHub
echo $DOCKERHUB_TOKEN | docker login --username $DOCKERHUB_USERNAME --password-stdin

# Testar push de uma imagem
docker tag test-image $DOCKERHUB_USERNAME/test-image:latest
docker push $DOCKERHUB_USERNAME/test-image:latest
```

### ☁️ **Testar AWS**

```bash
# Configurar credenciais AWS
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

# Testar conexão
aws sts get-caller-identity
```

### 🌐 **Testar GCP**

```bash
# Configurar credenciais GCP
echo $GCP_SERVICE_ACCOUNT_KEY > gcp-key.json
export GOOGLE_APPLICATION_CREDENTIALS=gcp-key.json

# Testar conexão
gcloud auth list
gcloud config get-value project
```

## 🆘 **Troubleshooting**

### ❓ **Problemas Comuns**

**Problema**: Erro de autenticação DockerHub
**Solução**: 
- Verifique se o token está correto
- Confirme se o usuário tem permissões de push
- Teste o login manualmente

**Problema**: Erro de permissões AWS
**Solução**:
- Verifique se as credenciais estão corretas
- Confirme se o usuário tem as políticas necessárias
- Teste com `aws sts get-caller-identity`

**Problema**: Erro de autenticação GCP
**Solução**:
- Verifique se o JSON da service account está correto
- Confirme se a service account tem as roles necessárias
- Teste com `gcloud auth list`

**Problema**: Secrets não encontrados no workflow
**Solução**:
- Verifique se os nomes dos secrets estão corretos
- Confirme se os secrets estão configurados no repositório
- Verifique se o workflow tem permissões para acessar secrets

### 🔧 **Comandos de Diagnóstico**

```bash
# Verificar status dos workflows
gh run list

# Ver logs de um workflow específico
gh run view [RUN_ID]

# Ver secrets configurados
gh secret list

# Testar conexões
docker login --username $DOCKERHUB_USERNAME --password $DOCKERHUB_TOKEN
aws sts get-caller-identity
gcloud auth list
```

## 📊 **Monitoramento**

### 📈 **Métricas Importantes**

1. **Taxa de sucesso dos builds**: Monitore falhas de build
2. **Tempo de build**: Otimize builds lentos
3. **Uso de recursos**: Monitore consumo de CPU/memória
4. **Logs de segurança**: Revise tentativas de acesso
5. **Rotação de credenciais**: Mantenha credenciais atualizadas

### 🚨 **Alertas Recomendados**

1. **Falhas de build**: Notificar sobre builds que falharam
2. **Tentativas de acesso suspeitas**: Alertar sobre acessos anômalos
3. **Credenciais expiradas**: Notificar sobre tokens próximos do vencimento
4. **Uso excessivo de recursos**: Alertar sobre consumo alto

## 🔗 **Links Úteis**

- **GitHub Secrets**: [Documentação](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- **DockerHub Tokens**: [Criar Access Token](https://hub.docker.com/settings/security)
- **AWS IAM**: [Gerenciar Usuários](https://console.aws.amazon.com/iam/)
- **GCP Service Accounts**: [Criar Service Account](https://console.cloud.google.com/iam-admin/serviceaccounts)
- **Grafana API Keys**: [Gerenciar API Keys](http://localhost:3000/org/apikeys)

---

**📝 Última Atualização**: Janeiro 2025  
**👨‍💻 Responsável**: Equipe de Desenvolvimento WebDiário  
**🏗️ Projeto**: WebDiário Platform - GitHub Actions  
**🎯 Status**: ✅ **CONFIGURAÇÃO COMPLETA**
