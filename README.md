# 📚 WebDiário Base Images

## 📋 Visão Geral

Este projeto contém uma hierarquia de imagens Docker base para o ecossistema WebDiário Platform, fornecendo imagens padronizadas com diferentes combinações de dependências para AWS e GCP.

## 🎯 Status do Projeto

**Status**: ✅ **FUNCIONAL** - Configuração de monitoring corrigida para Prometheus

## 🚀 Início Rápido

### 🔧 Build das Imagens

```bash
# Build da imagem base Alpine (recomendada)
docker build -t webdiario/alpine:latest ./alpine/

# Build de todas as imagens Alpine
./devops/build-complete.sh
```

### 📦 Uso em Projetos

```dockerfile
# Para projetos que precisam de monitoring com Prometheus
FROM webdiario/alpine:latest
# Seu código aqui

# Para projetos Java com Java 21
FROM webdiario/alpine/local/java/21:latest
# Seu código aqui
```

## 📊 Monitoring

O projeto agora está configurado corretamente para **Prometheus monitoring**:

- ✅ **Prometheus**: Configuração de métricas e targets
- ✅ **Health Checks**: Verificação de conectividade com Prometheus
- ✅ **Metrics Endpoint**: Configuração automática de `/actuator/prometheus`

## 📚 Documentação Completa

Para documentação detalhada, consulte:

- **[Documentação Principal](./docs/README.md)** - Guia completo de uso
- **[Estrutura de Imagens](./docs/README.md#-arquitetura-da-hierarquia)** - Hierarquia de imagens
- **[Guias de Build](./docs/README.md#-guias-de-uso)** - Scripts de build
- **[Configuração de Monitoring](./docs/README.md#-monitoring)** - Setup do Prometheus

## 🔗 Links Úteis

- **Repositório**: [GitHub](https://github.com/webdiario/webdiario-base-images)
- **Docker Hub**: [webdiario-base-images](https://hub.docker.com/r/webdiario/base-images)
- **Prometheus**: [Documentação](https://prometheus.io/docs/)

---

**📝 Última Atualização**: Janeiro 2025  
**👨‍💻 Responsável**: Equipe de Desenvolvimento WebDiário  
**🏗️ Projeto**: WebDiário Base Images  
**🎯 Status**: ✅ **FUNCIONAL**
