# 🚀 Guia Completo: Configurar Supabase + Render

## Problema Encontrado
❌ Seus dados se perdem ao fazer deploy porque:
- O arquivo `data/db.json` é deletado a cada deploy no Render
- O Supabase não está configurado corretamente
- As variáveis de ambiente não estão no Render

---

## ✅ PASSO 1: Configurar o Schema no Supabase

### 1.1 Acessar Supabase
1. Vá para https://supabase.com e faça login
2. Abra seu projeto
3. No menu à esquerda, clique em **SQL Editor**
4. Clique em **New Query**

### 1.2 Copiar o Schema Completo
1. Abra o arquivo `supabase-schema-completo.sql` que foi criado
2. Copie TODO o conteúdo
3. Cole no SQL Editor do Supabase
4. Clique em **RUN** (botão azul)

**Aguarde** até ver a mensagem: ✅ "Queries executed successfully"

---

## ✅ PASSO 2: Pegar as Chaves do Supabase

### 2.1 Copiar as Credenciais
1. No Supabase, clique em **Settings** → **API**
2. Copie os seguintes dados:
   - **Project URL** (ex: `https://seu-projeto.supabase.co`)
   - **Service Role Key** (aquele que começa com `eyJhb...`)

**⚠️ IMPORTANTE:** Guarde essas chaves de forma segura!

---

## ✅ PASSO 3: Configurar Variáveis de Ambiente no Render

### 3.1 Acessar Render
1. Vá para https://render.com e faça login
2. Clique no seu serviço (nome da sua aplicação)
3. Clique na aba **Environment**

### 3.2 Adicionar as Variáveis
Clique em **Add Environment Variable** e adicione:

| Variable Name | Value | Notas |
|---|---|---|
| `SUPABASE_URL` | `https://seu-projeto.supabase.co` | Copie do Supabase (Passo 2.1) |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhb...` (cola aqui toda a chave) | Copie do Supabase (Passo 2.1) |
| `NODE_ENV` | `production` | Ambiente de produção |
| `JWT_SECRET` | `uma-chave-segura-qualquer` | Crie uma chave aleatória e segura |

**Após adicionar, clique em SAVE** (botão cinza no canto inferior direito)

### 3.3 Fazer Deploy
1. Após salvar as variáveis, o Render fará **auto-deploy**
2. Ou clique em **Manual Deploy** → **Deploy latest commit**
3. Aguarde até aparecer ✅ "Service is live"

---

## ✅ PASSO 4: Testar a Conexão

### 4.1 Testar Localmente (Opcional)
```bash
# Vá até a pasta do projeto
cd C:\Users\Deibson\Downloads\Aimzystore

# Crie um arquivo .env com suas credenciais
# (copie de .env.example e preencha com os dados do Supabase)

# Instale dependências se necessário
npm install

# Teste a conexão
node src/test-supabase.js
```

Você verá: ✅ "Supabase conectado!"

### 4.2 Testar no Render
1. Acesse sua aplicação no Render (clique em **Open Service** ou copie a URL)
2. Tente criar uma key, vender, registrar um usuário
3. Agora os dados devem ser salvos! 🎉

---

## ✅ PASSO 5: Verifica se Funcionou

### 5.1 Confirmar no Supabase
1. Volte para Supabase
2. Vá em **Table Editor**
3. Verifique se os dados aparecem em:
   - `keys` (se criou keys)
   - `vendas` (se registrou vendas)
   - `users` (se criou usuários)
   - `sessions` (se fez login)

### 5.2 Fazer Novo Deploy
1. Volte ao Render
2. Clique em **Manual Deploy** → **Deploy latest commit**
3. Aguarde o deploy terminar
4. Acesse a app novamente
5. Os dados devem estar lá! ✅

---

## 🐛 Se Ainda Não Funcionar

### Problema 1: "SUPABASE_URL ou SUPABASE_SERVICE_ROLE_KEY não configurada"
**Solução:**
- Volte ao Passo 3 e verifique se as variáveis estão salvas
- Clique em **Manual Deploy** para forçar novo deploy
- Aguarde 2 minutos para o Deploy iniciar

### Problema 2: Erro ao conectar no Supabase
**Solução:**
- Verifique se a chave é a **Service Role Key** (não a anon key)
- Copie exatamente como está no Supabase, sem espaços

### Problema 3: Tabelas não aparecem no Supabase
**Solução:**
- Volte ao Passo 1 e re-execute o SQL
- Verifique se a mensagem de sucesso apareceu
- Recarregue a página do Supabase (Ctrl+Shift+R)

### Problema 4: Dados aparecem mas desaparecem após logout
**Solução:**
- Isso é comportamento correto! As sessões expiram
- Mas as **keys** e **vendas** devem permanecer
- Se também sumirem, revise o Passo 3

---

## 📝 Checklist Final

Antes de considerar pronto, confirme:

- [ ] Schema executado com sucesso no Supabase (✅ verde)
- [ ] Variáveis de ambiente adicionadas ao Render
- [ ] Deploy feito após adicionar variáveis
- [ ] Aplicação está rodando (Status: "live" no Render)
- [ ] Dados aparecem no Supabase Table Editor
- [ ] Dados persistem após logout e novo acesso
- [ ] Dados ainda estão lá após fazer novo deploy

---

## 🔒 Próximos Passos (Segurança)

Depois que tudo funcionar, você pode:

1. **Mudar credenciais do Admin** no painel
2. **Configurar autenticação real** no Supabase
3. **Ativar RLS (Row Level Security)** adequadamente
4. **Fazer backup automático** do Supabase

---

## 💬 Dúvidas?

Se tiver problemas, guarde:
- ✅ Screenshots do Supabase SQL após executar
- ✅ Logs do Render (aba Logs)
- ✅ Mensagens de erro exatas

Boa sorte! 🚀
