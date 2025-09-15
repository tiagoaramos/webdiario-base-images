# 📚 WebDiário Base Images

## 📋 Visão Geral

Este projeto contém uma hierarquia de imagens Docker base para o ecossistema WebDiário Platform, fornecendo imagens padronizadas com diferentes combinações de dependências para AWS e GCP.

## 🏗️ Arquitetura da Hierarquia

### 📊 Estrutura de Imagens

#### 🐧 **Versões Ubuntu (Padrão)**
```
webdiario-base (Ubuntu 22.04 + Grafana dependencies)
├── webdiario-aws (AWS CLI + tools)
│   ├── webdiario-aws-java (Java installer + Maven/Gradle)
│   │   └── webdiario-aws-java-21 (Java 21)
│   └── webdiario-aws-node (Node.js installer + NVM)
│       └── webdiario-aws-node-22.17.1 (Node.js 22.17.1)
└── webdiario-gcp (Google Cloud SDK + tools)
    ├── webdiario-gcp-java (Java installer + Maven/Gradle)
    │   └── webdiario-gcp-java-21 (Java 21)
    └── webdiario-gcp-node (Node.js installer + NVM)
        └── webdiario-gcp-node-22.17.1 (Node.js 22.17.1)
```

#### 🏔️ **Versões Alpine (Leves)**
```
webdiario-base-alpine (Alpine 3.19 + Grafana dependencies)
├── webdiario-aws-alpine (AWS CLI + tools)
│   ├── webdiario-aws-java-alpine (Java installer + Maven/Gradle)
│   │   └── webdiario-aws-java-21-alpine (Java 21)
│   └── webdiario-aws-node-alpine (Node.js installer + NVM)
│       └── webdiario-aws-node-22.17.1-alpine (Node.js 22.17.1)
└── webdiario-gcp-alpine (Google Cloud SDK + tools)
    ├── webdiario-gcp-java-alpine (Java installer + Maven/Gradle)
    │   └── webdiario-gcp-java-21-alpine (Java 21)
    └── webdiario-gcp-node-alpine (Node.js installer + NVM)
        └── webdiario-gcp-node-22.17.1-alpine (Node.js 22.17.1)
```

## 🎯 Imagens Disponíveis

### 🏠 **webdiario-base** (Ubuntu)
- **Base**: Ubuntu 22.04
- **Dependências**: Grafana, bibliotecas gráficas, utilitários básicos
- **Uso**: Imagem pai para todas as outras imagens Ubuntu

### 🏔️ **webdiario-base-alpine** (Alpine)
- **Base**: Alpine 3.19
- **Dependências**: Grafana, bibliotecas gráficas, utilitários básicos
- **Uso**: Imagem pai para todas as outras imagens Alpine (mais leve)

### ☁️ **AWS Images**

#### **webdiario-aws** (Ubuntu)
- **Base**: webdiario-base
- **Dependências**: AWS CLI v2, Python, boto3, AWS CDK
- **Uso**: Projetos que precisam interagir com AWS

#### **webdiario-aws-alpine** (Alpine)
- **Base**: webdiario-base-alpine
- **Dependências**: AWS CLI v2, Python, boto3, AWS CDK
- **Uso**: Projetos que precisam interagir com AWS (versão leve)

#### **webdiario-aws-java** (Ubuntu)
- **Base**: webdiario-aws
- **Dependências**: OpenJDK 11, Maven, Gradle, Ant, Ivy
- **Uso**: Projetos Java que usam AWS

#### **webdiario-aws-java-alpine** (Alpine)
- **Base**: webdiario-aws-alpine
- **Dependências**: OpenJDK 11, Maven, Gradle, Ant, Ivy
- **Uso**: Projetos Java que usam AWS (versão leve)

#### **webdiario-aws-java-21** (Ubuntu)
- **Base**: webdiario-aws-java
- **Dependências**: OpenJDK 21, Maven, Gradle
- **Uso**: Projetos Java 21 que usam AWS

#### **webdiario-aws-java-21-alpine** (Alpine)
- **Base**: webdiario-aws-java-alpine
- **Dependências**: OpenJDK 21, Maven, Gradle
- **Uso**: Projetos Java 21 que usam AWS (versão leve)

#### **webdiario-aws-node** (Ubuntu)
- **Base**: webdiario-aws
- **Dependências**: Node.js 18.17.0, NVM, npm, yarn, pnpm, TypeScript
- **Uso**: Projetos Node.js que usam AWS

#### **webdiario-aws-node-alpine** (Alpine)
- **Base**: webdiario-aws-alpine
- **Dependências**: Node.js 18.17.0, NVM, npm, yarn, pnpm, TypeScript
- **Uso**: Projetos Node.js que usam AWS (versão leve)

#### **webdiario-aws-node-22.17.1** (Ubuntu)
- **Base**: webdiario-aws-node
- **Dependências**: Node.js 22.17.1, ferramentas atualizadas
- **Uso**: Projetos Node.js 22.17.1 que usam AWS

#### **webdiario-aws-node-22.17.1-alpine** (Alpine)
- **Base**: webdiario-aws-node-alpine
- **Dependências**: Node.js 22.17.1, ferramentas atualizadas
- **Uso**: Projetos Node.js 22.17.1 que usam AWS (versão leve)

### 🌐 **GCP Images**

#### **webdiario-gcp** (Ubuntu)
- **Base**: webdiario-base
- **Dependências**: Google Cloud SDK, kubectl, Python, bibliotecas GCP
- **Uso**: Projetos que precisam interagir com Google Cloud

#### **webdiario-gcp-alpine** (Alpine)
- **Base**: webdiario-base-alpine
- **Dependências**: Google Cloud SDK, kubectl, Python, bibliotecas GCP
- **Uso**: Projetos que precisam interagir com Google Cloud (versão leve)

#### **webdiario-gcp-java** (Ubuntu)
- **Base**: webdiario-gcp
- **Dependências**: OpenJDK 11, Maven, Gradle, bibliotecas Google Cloud Java
- **Uso**: Projetos Java que usam Google Cloud

#### **webdiario-gcp-java-alpine** (Alpine)
- **Base**: webdiario-gcp-alpine
- **Dependências**: OpenJDK 11, Maven, Gradle, bibliotecas Google Cloud Java
- **Uso**: Projetos Java que usam Google Cloud (versão leve)

#### **webdiario-gcp-java-21** (Ubuntu)
- **Base**: webdiario-gcp-java
- **Dependências**: OpenJDK 21, Maven, Gradle
- **Uso**: Projetos Java 21 que usam Google Cloud

#### **webdiario-gcp-java-21-alpine** (Alpine)
- **Base**: webdiario-gcp-java-alpine
- **Dependências**: OpenJDK 21, Maven, Gradle
- **Uso**: Projetos Java 21 que usam Google Cloud (versão leve)

#### **webdiario-gcp-node** (Ubuntu)
- **Base**: webdiario-gcp
- **Dependências**: Node.js 18.17.0, NVM, bibliotecas Google Cloud Node.js
- **Uso**: Projetos Node.js que usam Google Cloud

#### **webdiario-gcp-node-alpine** (Alpine)
- **Base**: webdiario-gcp-alpine
- **Dependências**: Node.js 18.17.0, NVM, bibliotecas Google Cloud Node.js
- **Uso**: Projetos Node.js que usam Google Cloud (versão leve)

#### **webdiario-gcp-node-22.17.1** (Ubuntu)
- **Base**: webdiario-gcp-node
- **Dependências**: Node.js 22.17.1, bibliotecas Google Cloud atualizadas
- **Uso**: Projetos Node.js 22.17.1 que usam Google Cloud

#### **webdiario-gcp-node-22.17.1-alpine** (Alpine)
- **Base**: webdiario-gcp-node-alpine
- **Dependências**: Node.js 22.17.1, bibliotecas Google Cloud atualizadas
- **Uso**: Projetos Node.js 22.17.1 que usam Google Cloud (versão leve)

## 🚀 Guias de Uso

### 🔧 Build das Imagens

#### 🐧 **Versões Ubuntu (Padrão)**
```bash
# Build de todas as imagens Ubuntu
./build-all.sh  # Linux/Mac
# ou
build-all.bat   # Windows

# Build manual das imagens Ubuntu
docker build -t webdiario-base .
docker build -t webdiario-aws ./aws/
docker build -t webdiario-aws-java ./aws/java/
docker build -t webdiario-aws-java-21 ./aws/java/21/
docker build -t webdiario-aws-node ./aws/node/
docker build -t webdiario-aws-node-22.17.1 ./aws/node/22.17.1/
docker build -t webdiario-gcp ./gcp/
docker build -t webdiario-gcp-java ./gcp/java/
docker build -t webdiario-gcp-java-21 ./gcp/java/21/
docker build -t webdiario-gcp-node ./gcp/node/
docker build -t webdiario-gcp-node-22.17.1 ./gcp/node/22.17.1/
```

#### 🏔️ **Versões Alpine (Leves)**
```bash
# Build de todas as imagens Alpine
./build-alpine.sh  # Linux/Mac
# ou
build-alpine.bat   # Windows

# Build manual das imagens Alpine
docker build -t webdiario-base-alpine ./alpine/
docker build -t webdiario-aws-alpine ./alpine/aws/
docker build -t webdiario-aws-java-alpine ./alpine/aws/java/
docker build -t webdiario-aws-java-21-alpine ./alpine/aws/java/21/
docker build -t webdiario-aws-node-alpine ./alpine/aws/node/
docker build -t webdiario-aws-node-22.17.1-alpine ./alpine/aws/node/22.17.1/
docker build -t webdiario-gcp-alpine ./alpine/gcp/
docker build -t webdiario-gcp-java-alpine ./alpine/gcp/java/
docker build -t webdiario-gcp-java-21-alpine ./alpine/gcp/java/21/
docker build -t webdiario-gcp-node-alpine ./alpine/gcp/node/
docker build -t webdiario-gcp-node-22.17.1-alpine ./alpine/gcp/node/22.17.1/
```

### 📦 Uso em Projetos

#### 🐧 **Versões Ubuntu (Padrão)**
```dockerfile
# Para Projetos Java com AWS:
FROM webdiario-aws-java-21:latest
# Seu código aqui

# Para Projetos Node.js com GCP:
FROM webdiario-gcp-node-22.17.1:latest
# Seu código aqui
```

#### 🏔️ **Versões Alpine (Leves)**
```dockerfile
# Para Projetos Java com AWS (versão leve):
FROM webdiario-aws-java-21-alpine:latest
# Seu código aqui

# Para Projetos Node.js com GCP (versão leve):
FROM webdiario-gcp-node-22.17.1-alpine:latest
# Seu código aqui
```

## 🔧 Desenvolvimento

### 📝 Estrutura de Arquivos

```
webdiario-base-images/
├── Dockerfile                    # 🐧 Imagem base Ubuntu
├── README.md                     # 📚 Esta documentação
├── build-all.sh                  # 🚀 Script build Ubuntu (Linux/Mac)
├── build-all.bat                 # 🚀 Script build Ubuntu (Windows)
├── build-alpine.sh               # 🚀 Script build Alpine (Linux/Mac)
├── build-alpine.bat              # 🚀 Script build Alpine (Windows)
├── aws/                          # ☁️ Imagens AWS Ubuntu
│   ├── Dockerfile               # AWS base
│   ├── java/
│   │   ├── Dockerfile           # AWS Java base
│   │   └── 21/
│   │       └── Dockerfile       # AWS Java 21
│   └── node/
│       ├── Dockerfile           # AWS Node base
│       └── 22.17.1/
│           └── Dockerfile       # AWS Node 22.17.1
├── gcp/                          # 🌐 Imagens GCP Ubuntu
│   ├── Dockerfile               # GCP base
│   ├── java/
│   │   ├── Dockerfile           # GCP Java base
│   │   └── 21/
│   │       └── Dockerfile       # GCP Java 21
│   └── node/
│       ├── Dockerfile           # GCP Node base
│       └── 22.17.1/
│           └── Dockerfile       # GCP Node 22.17.1
└── alpine/                       # 🏔️ Imagens Alpine (Leves)
    ├── Dockerfile               # Imagem base Alpine
    ├── aws/                     # Imagens AWS Alpine
    │   ├── Dockerfile           # AWS base Alpine
    │   ├── java/
    │   │   ├── Dockerfile       # AWS Java base Alpine
    │   │   └── 21/
    │   │       └── Dockerfile   # AWS Java 21 Alpine
    │   └── node/
    │       ├── Dockerfile       # AWS Node base Alpine
    │       └── 22.17.1/
    │           └── Dockerfile   # AWS Node 22.17.1 Alpine
    └── gcp/                     # Imagens GCP Alpine
        ├── Dockerfile           # GCP base Alpine
        ├── java/
        │   ├── Dockerfile       # GCP Java base Alpine
        │   └── 21/
        │       └── Dockerfile   # GCP Java 21 Alpine
        └── node/
            ├── Dockerfile       # GCP Node base Alpine
            └── 22.17.1/
                └── Dockerfile   # GCP Node 22.17.1 Alpine
```

### 🧪 Testes

Cada imagem inclui health checks para verificar se as dependências estão funcionando corretamente:

#### 🐧 **Versões Ubuntu**
```bash
# Testar imagem base Ubuntu
docker run --rm webdiario-base

# Testar imagem AWS Java Ubuntu
docker run --rm webdiario-aws-java-21 java -version

# Testar imagem GCP Node Ubuntu
docker run --rm webdiario-gcp-node-22.17.1 node --version
```

#### 🏔️ **Versões Alpine**
```bash
# Testar imagem base Alpine
docker run --rm webdiario-base-alpine

# Testar imagem AWS Java Alpine
docker run --rm webdiario-aws-java-21-alpine java -version

# Testar imagem GCP Node Alpine
docker run --rm webdiario-gcp-node-22.17.1-alpine node --version
```

## 📊 Referência Técnica

### 🔧 Variáveis de Ambiente

#### AWS Images:
- `AWS_DEFAULT_REGION`: Região padrão AWS (us-east-1)
- `AWS_DEFAULT_OUTPUT`: Formato de saída (json)

#### GCP Images:
- `GOOGLE_APPLICATION_CREDENTIALS`: Caminho para credenciais
- `GCLOUD_PROJECT`: Projeto GCP padrão

#### Java Images:
- `JAVA_HOME`: Caminho para instalação Java
- `PATH`: Inclui binários Java

#### Node Images:
- `NVM_DIR`: Diretório do NVM
- `NODE_VERSION`: Versão do Node.js
- `PATH`: Inclui binários Node.js

### 🏥 Health Checks

Todas as imagens incluem health checks que verificam:
- **Base**: Comando básico de sistema
- **AWS**: AWS CLI funcionando
- **GCP**: Google Cloud SDK funcionando
- **Java**: Java instalado e funcionando
- **Node**: Node.js instalado e funcionando

## 🆘 Suporte

### ❓ FAQ

**Q: Como escolher a imagem correta?**
A: Use a imagem mais específica para seu projeto:
- Java + AWS → webdiario-aws-java-21 (Ubuntu) ou webdiario-aws-java-21-alpine (Alpine)
- Node.js + GCP → webdiario-gcp-node-22.17.1 (Ubuntu) ou webdiario-gcp-node-22.17.1-alpine (Alpine)
- Apenas AWS → webdiario-aws (Ubuntu) ou webdiario-aws-alpine (Alpine)

**Q: Qual versão escolher: Ubuntu ou Alpine?**
A: 
- **Ubuntu**: Mais compatível, mais ferramentas disponíveis, maior tamanho
- **Alpine**: Mais leve, menor tamanho, menos ferramentas, mais rápido

**Q: Posso usar versões diferentes do Java/Node?**
A: Sim, você pode estender qualquer imagem e instalar versões específicas.

**Q: As imagens são otimizadas para produção?**
A: Sim, todas as imagens são otimizadas com multi-stage builds quando possível.

### 🔧 Troubleshooting

**Problema**: Erro de permissão
**Solução**: Verifique se está usando o usuário `webdiario` ou configure permissões adequadas.

**Problema**: AWS CLI não funciona
**Solução**: Configure as credenciais AWS usando `aws configure` ou variáveis de ambiente.

**Problema**: Google Cloud SDK não funciona
**Solução**: Configure as credenciais GCP usando `gcloud auth login` ou service account.

## 🔗 Links Úteis

- **Repositório**: [GitHub](https://github.com/webdiario/webdiario-base-images)
- **Docker Hub**: [webdiario-base-images](https://hub.docker.com/r/webdiario/base-images)
- **Documentação AWS**: [AWS CLI](https://docs.aws.amazon.com/cli/)
- **Documentação GCP**: [Google Cloud SDK](https://cloud.google.com/sdk/docs)

---

**📝 Última Atualização**: Janeiro 2025  
**👨‍💻 Responsável**: Equipe de Desenvolvimento WebDiário  
**🏗️ Projeto**: WebDiário Base Images  
**🎯 Status**: ✅ **FUNCIONAL**
