# 📚 Como Usar a Imagem Nginx Base

## 🔍 **Problema Identificado**

A imagem base `webdiario/alpine` define um `ENTRYPOINT` fixo que não pode ser sobrescrito:

```dockerfile
ENTRYPOINT ["/app/entrypoint.sh"]
```

## ✅ **Solução Implementada**

A imagem nginx agora sobrescreve o `ENTRYPOINT` para iniciar o nginx diretamente:

```dockerfile
ENTRYPOINT ["/usr/local/bin/start-nginx.sh"]
```

## 🚀 **Como Usar**

### **Dockerfile de Exemplo:**

```dockerfile
FROM webdiario/alpine/local/nginx:latest

# Copiar arquivos do site para /app
COPY ./build /app

# Dar permissões para o usuário nginx
RUN chown -R nginx:nginx /app
```

### **Comandos Docker:**

```bash
# Build da imagem
docker build -t meu-site .

# Executar o container
docker run -p 8080:80 meu-site

# O site estará disponível em http://localhost:8080
```

## 🔧 **Hierarquia de Imagens Corrigida:**

1. **`alpine:3.19`** - Imagem base Alpine
2. **`webdiario/alpine`** - Prometheus monitoring + entrypoint
3. **`webdiario/alpine/local`** - Herda entrypoint
4. **`webdiario/alpine/local/nginx`** - **SOBRESCREVE** entrypoint para nginx

## ⚠️ **Importante:**

- A imagem nginx **não executa** mais o script de monitoramento Prometheus
- Se precisar do monitoramento, use `webdiario/alpine/local` diretamente
- O nginx serve apenas arquivos estáticos da pasta `/app`
