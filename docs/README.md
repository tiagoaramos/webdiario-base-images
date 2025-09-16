# 📚 WebDiário Base Images

## 📋 Visão Geral

Este projeto contém uma hierarquia de imagens Docker base para o ecossistema WebDiário Platform, fornecendo imagens padronizadas com diferentes combinações de dependências para AWS e GCP.

## 🏗️ Arquitetura da Hierarquia

### 📊 Estrutura de Imagens

#### 🏔️ **Versões Alpine (Disponíveis)**
```
webdiario/alpine (Alpine 3.19 + Prometheus monitoring)
├── webdiario/alpine/local (Alpine local development)
│   └── webdiario/alpine/local/java (Java development)
│       └── webdiario/alpine/local/java/21 (Java 21)
└── [Futuras extensões AWS/GCP quando necessárias]
```

## 🎯 Imagens Disponíveis

### 🏔️ **webdiario/alpine** (Alpine Base)
- **Base**: Alpine 3.19
- **Dependências**: Prometheus monitoring, bibliotecas gráficas, utilitários básicos
- **Uso**: Imagem pai para todas as outras imagens Alpine
- **Tag**: `webdiario/alpine:latest`

### 🏠 **webdiario/alpine/local** (Alpine Local)
- **Base**: webdiario/alpine
- **Dependências**: Ferramentas de desenvolvimento local
- **Uso**: Desenvolvimento local com Alpine
- **Tag**: `webdiario/alpine/local:latest`

### ☕ **webdiario/alpine/local/java** (Alpine Java)
- **Base**: webdiario/alpine/local
- **Dependências**: Java, Maven, Gradle
- **Uso**: Desenvolvimento Java com Alpine
- **Tag**: `webdiario/alpine/local/java:latest`

### ☕ **webdiario/alpine/local/java/21** (Alpine Java 21)
- **Base**: webdiario/alpine/local/java
- **Dependências**: Java 21, Maven, Gradle
- **Uso**: Desenvolvimento Java 21 com Alpine
- **Tag**: `webdiario/alpine/local/java/21:latest`

### 🚧 **Futuras Extensões**

#### **AWS Images** (Planejadas)
- `webdiario/alpine/aws` - AWS CLI e ferramentas
- `webdiario/alpine/aws/java` - AWS + Java
- `webdiario/alpine/aws/java/21` - AWS + Java 21

#### **GCP Images** (Planejadas)
- `webdiario/alpine/gcp` - Google Cloud SDK e ferramentas
- `webdiario/alpine/gcp/java` - GCP + Java
- `webdiario/alpine/gcp/java/21` - GCP + Java 21

#### **Node.js Images** (Planejadas)
- `webdiario/alpine/local/node` - Node.js development
- `webdiario/alpine/local/node/22` - Node.js 22

## 🚀 Guias de Uso

### 🔧 Build das Imagens

#### 🏔️ **Versões Alpine (Disponíveis)**
```bash
# Build de todas as imagens Alpine
./devops/build-complete.sh  # Linux/Mac

# Build manual das imagens Alpine
docker build -t webdiario/alpine:latest ./alpine/
docker build -t webdiario/alpine/local:latest ./alpine/local/
docker build -t webdiario/alpine/local/java:latest ./alpine/local/java/
docker build -t webdiario/alpine/local/java/21:latest ./alpine/local/java/21/

# Build individual (recomendado)
./devops/build-alpine.sh    # Apenas imagem base Alpine
./devops/build-all.sh       # Todas as imagens Alpine disponíveis
```

### 📦 Uso em Projetos

#### 🏔️ **Versões Alpine (Disponíveis)**
```dockerfile
# Para projetos básicos com monitoring Prometheus:
FROM webdiario/alpine:latest
# Seu código aqui

# Para desenvolvimento local:
FROM webdiario/alpine/local:latest
# Seu código aqui

# Para projetos Java:
FROM webdiario/alpine/local/java:latest
# Seu código aqui

# Para projetos Java 21:
FROM webdiario/alpine/local/java/21:latest
# Seu código aqui
```

## 🔧 Desenvolvimento

### 📝 Estrutura de Arquivos

```
webdiario-base-images/
├── README.md                     # 📚 README principal
├── docs/                         # 📚 TODA documentação
│   ├── README.md                # Documentação completa
│   └── CORRECOES-MONITORING.md  # Documento de correções
├── devops/                       # 🔧 TODOS os scripts
│   ├── build-alpine.sh          # Build Alpine base
│   ├── build-all.sh             # Build todas Alpine
│   ├── build-complete.sh        # Build completo
│   ├── entrypoint.sh            # Entrypoint Prometheus
│   ├── health-check.sh          # Health check Prometheus
│   └── start-java-app.sh        # Script Java
└── alpine/                       # 🏔️ Imagens Alpine
    ├── Dockerfile               # webdiario/alpine:latest
    └── local/                   # Imagens de desenvolvimento local
        ├── Dockerfile           # webdiario/alpine/local:latest
        └── java/                # Imagens Java
            ├── Dockerfile       # webdiario/alpine/local/java:latest
            └── 21/
                └── Dockerfile   # webdiario/alpine/local/java/21:latest
```

### 🧪 Testes

Cada imagem inclui health checks para verificar se as dependências estão funcionando corretamente:

#### 🏔️ **Versões Alpine**
```bash
# Testar imagem base Alpine
docker run --rm webdiario/alpine:latest

# Testar imagem local Alpine
docker run --rm webdiario/alpine/local:latest

# Testar imagem Java Alpine
docker run --rm webdiario/alpine/local/java:latest java -version

# Testar imagem Java 21 Alpine
docker run --rm webdiario/alpine/local/java/21:latest java -version

# Executar health check completo
docker run --rm webdiario/alpine:latest /app/health-check.sh
```

## 📊 Referência Técnica

### 🔧 Variáveis de Ambiente

#### Prometheus Monitoring:
- `ENABLE_PROMETHEUS_MONITORING`: Habilita monitoring (true/false)
- `PROMETHEUS_URL`: URL do Prometheus (http://prometheus:9090)
- `PROMETHEUS_JOB_NAME`: Nome do job no Prometheus
- `METRICS_PATH`: Caminho das métricas (/actuator/prometheus)

#### Java Images:
- `JAVA_HOME`: Caminho para instalação Java
- `PATH`: Inclui binários Java
- `JAVA_VERSION`: Versão do Java instalada

#### Application:
- `APP_NAME`: Nome da aplicação
- `APP_HOST`: Host da aplicação
- `APP_PORT`: Porta da aplicação
- `MONITORING_INTERVAL`: Intervalo de monitoring (5s)

### 🏥 Health Checks

Todas as imagens incluem health checks que verificam:
- **Base**: Comando básico de sistema
- **Prometheus**: Conectividade com Prometheus
- **Java**: Java instalado e funcionando
- **Application**: Health endpoint da aplicação
- **Monitoring**: Configuração de métricas

## 🆘 Suporte

### ❓ FAQ

**Q: Como escolher a imagem correta?**
A: Use a imagem mais específica para seu projeto:
- Projetos básicos → webdiario/alpine:latest
- Desenvolvimento local → webdiario/alpine/local:latest
- Projetos Java → webdiario/alpine/local/java:latest
- Projetos Java 21 → webdiario/alpine/local/java/21:latest

**Q: Por que apenas Alpine?**
A: Alpine é mais leve, seguro e rápido que Ubuntu, sendo ideal para containers.

**Q: Posso usar versões diferentes do Java?**
A: Sim, você pode estender qualquer imagem e instalar versões específicas.

**Q: As imagens são otimizadas para produção?**
A: Sim, todas as imagens são otimizadas com multi-stage builds quando possível.

**Q: Como funciona o monitoring com Prometheus?**
A: As imagens configuram automaticamente métricas no endpoint `/actuator/prometheus` para serem coletadas pelo Prometheus.

### 🔧 Troubleshooting

**Problema**: Erro de permissão
**Solução**: Verifique se está usando o usuário `webdiario` ou configure permissões adequadas.

**Problema**: Prometheus não consegue coletar métricas
**Solução**: Verifique se a aplicação está expondo o endpoint `/actuator/prometheus` e se o Prometheus está configurado para fazer scraping.

**Problema**: Java não funciona
**Solução**: Verifique se a imagem Java está sendo usada e se o JAVA_HOME está configurado corretamente.

## 🔗 Links Úteis

- **Repositório**: [GitHub](https://github.com/webdiario/webdiario-base-images)
- **Docker Hub**: [webdiario-base-images](https://hub.docker.com/r/webdiario/base-images)
- **Prometheus**: [Documentação](https://prometheus.io/docs/)
- **Spring Boot Actuator**: [Métricas](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.metrics)

---

**📝 Última Atualização**: Janeiro 2025  
**👨‍💻 Responsável**: Equipe de Desenvolvimento WebDiário  
**🏗️ Projeto**: WebDiário Base Images  
**🎯 Status**: ✅ **FUNCIONAL**
