# 🚀 GitHub Actions - WebDiário Platform

## 📋 Visão Geral

Este diretório contém os workflows do GitHub Actions para automatizar o build e push das imagens Docker do ecossistema WebDiário Platform para o DockerHub público.

## 🎯 Workflows Disponíveis

### 🐳 **docker-build-push.yml**
- **Descrição**: Build e push das imagens base do WebDiário
- **Trigger**: Push/PR nas pastas `webdiario-base-images/**`
- **Imagens**: Todas as imagens base (Ubuntu e Alpine) com suporte AWS/GCP

### 🚀 **applications-build-push.yml**
- **Descrição**: Build e push das aplicações WebDiário
- **Trigger**: Push/PR nas pastas das aplicações
- **Aplicações**: APIs e Frontends do WebDiário

## 🏗️ Estrutura dos Workflows

### 📊 **Imagens Base (docker-build-push.yml)**

#### 🐧 **Versões Ubuntu**
- `webdiario-base` - Imagem base Ubuntu com Grafana
- `webdiario-aws` - AWS CLI + ferramentas
- `webdiario-aws-java` - Java + Maven/Gradle + AWS
- `webdiario-aws-java-21` - Java 21 + AWS
- `webdiario-aws-node` - Node.js + AWS
- `webdiario-aws-node-22.17.1` - Node.js 22.17.1 + AWS
- `webdiario-gcp` - Google Cloud SDK + ferramentas
- `webdiario-gcp-java` - Java + Maven/Gradle + GCP
- `webdiario-gcp-java-21` - Java 21 + GCP
- `webdiario-gcp-node` - Node.js + GCP
- `webdiario-gcp-node-22.17.1` - Node.js 22.17.1 + GCP

#### 🏔️ **Versões Alpine**
- `webdiario-base-alpine` - Imagem base Alpine com Grafana
- `webdiario-aws-alpine` - AWS CLI + ferramentas (Alpine)
- `webdiario-gcp-alpine` - Google Cloud SDK + ferramentas (Alpine)

### 🚀 **Aplicações (applications-build-push.yml)**

#### ☕ **APIs Java**
- `api-webdiario` - API principal (porta 8080)
- `api-webdiario-security` - API de segurança (porta 8081)
- `api-webdiario-event-hub` - API de eventos (porta 8083)
- `api-webdiario-subscription` - API de assinaturas (porta 8082)

#### 📦 **Frontends React**
- `app-webdiario-financial` - Frontend financeiro (porta 3001)
- `app-webdiario-security` - Frontend de segurança (porta 3003)
- `app-webdiario-site` - Site público (porta 80)

## 🔧 Configuração

### 🔐 **Secrets Necessários**

#### **Obrigatórios**
- `DOCKERHUB_USERNAME` - Usuário DockerHub
- `DOCKERHUB_TOKEN` - Token DockerHub

#### **Opcionais (para integração)**
- `GRAFANA_ADMIN_USER` - Usuário admin Grafana
- `GRAFANA_ADMIN_PASSWORD` - Senha admin Grafana
- `GRAFANA_API_KEY` - Chave API Grafana
- `AWS_ACCESS_KEY_ID` - Chave acesso AWS
- `AWS_SECRET_ACCESS_KEY` - Chave secreta AWS
- `AWS_DEFAULT_REGION` - Região padrão AWS
- `GCP_PROJECT_ID` - ID projeto GCP
- `GCP_SERVICE_ACCOUNT_KEY` - Chave service account GCP
- `GCP_REGION` - Região padrão GCP

### 📝 **Como Configurar**

1. **Acesse o repositório** no GitHub
2. Vá em **Settings** → **Secrets and variables** → **Actions**
3. Clique em **New repository secret**
4. Configure os secrets necessários

**📚 Documentação completa**: [SECRETS_CONFIGURATION.md](./SECRETS_CONFIGURATION.md)

## 🚀 Como Usar

### 🔄 **Execução Automática**

Os workflows são executados automaticamente quando:
- **Push** para branches `main` ou `develop`
- **Pull Request** para branches `main` ou `develop`
- **Tags** com padrão `v*` (ex: `v1.0.0`)

### 🎯 **Execução Manual**

Para executar manualmente:
1. Vá em **Actions** no GitHub
2. Selecione o workflow desejado
3. Clique em **Run workflow**
4. Escolha a branch e clique em **Run workflow**

### 📊 **Monitoramento**

- **Status dos builds**: Verifique na aba **Actions**
- **Logs detalhados**: Clique em cada job para ver logs
- **Notificações**: Configure notificações no GitHub

## 🏷️ **Sistema de Tags**

### 📋 **Padrões de Tags**

- **Branch**: `main` → `latest`, `develop` → `develop`
- **PR**: `pr-123` (número do PR)
- **Versão**: `v1.0.0` → `1.0.0`, `1.0`, `latest`
- **Semantic Versioning**: Suporte completo a semver

### 🐳 **Exemplos de Tags**

```bash
# Imagens base
docker pull webdiario/webdiario-base:latest
docker pull webdiario/webdiario-aws-java-21:1.0.0
docker pull webdiario/webdiario-gcp-node-22.17.1:develop

# Aplicações
docker pull webdiario/api-webdiario:latest
docker pull webdiario/app-webdiario-financial:v2.1.0
docker pull webdiario/api-webdiario-security:develop
```

## 🔍 **Recursos Avançados**

### 🛡️ **Security Scanning**

- **Trivy**: Scan de vulnerabilidades em todas as imagens
- **SARIF**: Relatórios de segurança no GitHub Security tab
- **Automático**: Executado em todos os pushes

### ⚡ **Otimizações**

- **Cache**: Cache de dependências Maven e npm
- **Buildx**: Build paralelo e multi-platform
- **Layers**: Otimização de layers Docker
- **Multi-stage**: Builds otimizados para produção

### 📊 **Métricas**

- **Tempo de build**: Monitorado para otimização
- **Tamanho das imagens**: Otimizado para produção
- **Taxa de sucesso**: Monitoramento de falhas
- **Uso de recursos**: Otimização de CPU/memória

## 🆘 **Troubleshooting**

### ❓ **Problemas Comuns**

**Problema**: Build falha por falta de secrets
**Solução**: Configure os secrets obrigatórios no GitHub

**Problema**: Push falha por permissões
**Solução**: Verifique se o token DockerHub tem permissões de push

**Problema**: Build lento
**Solução**: Verifique se o cache está funcionando corretamente

**Problema**: Imagem não encontrada
**Solução**: Verifique se o build foi executado com sucesso

### 🔧 **Comandos Úteis**

```bash
# Ver status dos workflows
gh run list

# Ver logs de um workflow
gh run view [RUN_ID]

# Executar workflow manualmente
gh workflow run docker-build-push.yml

# Ver secrets configurados
gh secret list
```

## 📈 **Roadmap**

### 🚧 **Em Desenvolvimento**
- [ ] Suporte a multi-platform (ARM64, AMD64)
- [ ] Integração com registries privados
- [ ] Deploy automático para ambientes
- [ ] Notificações via Slack/Discord

### 🎯 **Futuro**
- [ ] Integração com Kubernetes
- [ ] Deploy automático para produção
- [ ] Monitoramento de aplicações
- [ ] Backup automático de dados

## 🔗 **Links Úteis**

- **GitHub Actions**: [Documentação](https://docs.github.com/en/actions)
- **Docker Buildx**: [Documentação](https://docs.docker.com/buildx/)
- **Trivy Security**: [Documentação](https://aquasecurity.github.io/trivy/)
- **DockerHub**: [WebDiário Images](https://hub.docker.com/u/webdiario)
- **Secrets Config**: [SECRETS_CONFIGURATION.md](./SECRETS_CONFIGURATION.md)

---

**📝 Última Atualização**: Janeiro 2025  
**👨‍💻 Responsável**: Equipe de Desenvolvimento WebDiário  
**🏗️ Projeto**: WebDiário Platform - GitHub Actions  
**🎯 Status**: ✅ **FUNCIONAL**
