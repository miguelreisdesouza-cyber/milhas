# Publicação e integração

## Opção recomendada: uma aplicação no mesmo domínio

A configuração Docker incluída publica o frontend no Nginx e encaminha `/api/*` ao FastAPI. Essa opção simplifica CORS, cookies e streaming do Copiloto.

```bash
cp backend/.env.example backend/.env
docker compose up --build -d
```

Para usar um domínio real, coloque um proxy reverso ou serviço de borda na frente da porta 8080 e habilite HTTPS.

No `backend/.env`:

```env
ENVIRONMENT=production
JWT_SECRET=gere-uma-chave-segura
CORS_ORIGINS=https://app.seudominio.com
COOKIE_SECURE=true
COOKIE_SAMESITE=lax
```

## Frontend e backend em domínios diferentes

Exemplo:

- Frontend: `https://app.seudominio.com`
- Backend: `https://api.seudominio.com`

Compile o frontend com:

```env
REACT_APP_BACKEND_URL=https://api.seudominio.com
```

Configure o backend:

```env
CORS_ORIGINS=https://app.seudominio.com
COOKIE_SECURE=true
COOKIE_SAMESITE=none
```

Cookies com `SameSite=none` exigem HTTPS. O login por JWT salvo no navegador funciona mesmo sem cookie, mas o login externo usa sessão por cookie.

## Render, Railway, Fly.io ou serviço semelhante

Crie três serviços:

1. MongoDB gerenciado.
2. Backend usando `backend/Dockerfile`.
3. Frontend usando `frontend/Dockerfile`.

No frontend separado, passe `REACT_APP_BACKEND_URL` como argumento de build. No backend, defina todas as variáveis de `backend/.env.example` necessárias.

## Vercel ou hospedagem estática

O frontend pode ser publicado como build estático, mas o backend FastAPI e o MongoDB devem ficar em outro serviço.

Comandos:

```bash
cd frontend
yarn install --frozen-lockfile
yarn build
```

Publique a pasta `frontend/build` e configure fallback de todas as rotas para `index.html`.

## Banco de dados

O backend cria automaticamente índices únicos para:

- e-mail e ID de usuário;
- IDs de programas, cartões e metas por usuário;
- token de sessão;
- ID de promoção.

Faça backup do MongoDB antes de alterações em produção.

## Integrações reais

Os botões da página de integrações continuam em modo demonstrativo. O backend registra o estado conectado/desconectado, mas não coleta dados dos programas. Para ativar uma integração real:

1. implemente OAuth ou credenciais no backend;
2. armazene tokens criptografados;
3. crie rotina de sincronização;
4. atualize o catálogo para indicar o status real;
5. não envie tokens de terceiros ao frontend.

## Monitor de promoções

A varredura automática fica desativada por padrão para evitar múltiplas execuções em ambientes com vários workers.

```env
ENABLE_PROMO_SCHEDULER=true
PROMO_SCAN_INTERVAL=3600
```

O fallback de promoções heurísticas está desativado por padrão para não exibir campanhas estimadas como reais:

```env
ALLOW_HEURISTIC_PROMOTIONS=false
```

## Checklist de produção

- [ ] HTTPS ativo.
- [ ] `JWT_SECRET` substituído.
- [ ] `CORS_ORIGINS` restrito.
- [ ] MongoDB não exposto publicamente.
- [ ] Backup configurado.
- [ ] Logs e monitoramento configurados.
- [ ] Copiloto e login externo testados, caso habilitados.
- [ ] Build do frontend executado no ambiente de CI/CD.
- [ ] Testes de integração executados contra um banco temporário.
