# AUREON

Aplicação full-stack para gestão de patrimônio em milhas, pontos, cartões e metas de viagem.

## Estrutura

- `frontend/`: React, Tailwind CSS, Recharts e componentes Radix UI.
- `backend/`: FastAPI, autenticação JWT, MongoDB, monitor de promoções e Copiloto opcional.
- `docker-compose.yml`: ambiente completo com frontend, backend e MongoDB.
- `DEPLOYMENT.md`: instruções de publicação e integração.
- `RELATORIO_CORRECOES.md`: auditoria do arquivo original e correções realizadas.

## Subir com Docker

1. Copie o arquivo de configuração:

```bash
cp backend/.env.example backend/.env
```

2. Defina uma chave segura em `backend/.env`:

```env
JWT_SECRET=uma-chave-longa-aleatoria-com-no-minimo-48-caracteres
```

3. Inicie o projeto:

```bash
docker compose up --build -d
```

4. Acesse:

```text
http://localhost:8080
```

O Nginx do frontend encaminha `/api` para o backend. Assim, não é necessário expor a API diretamente ao navegador.

## Desenvolvimento sem Docker

### Backend

Requer Python 3.12 e MongoDB ativo.

```bash
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r backend/requirements.txt
cp backend/.env.example backend/.env
uvicorn backend.server:app --reload --port 8000
```

### Frontend

Requer Node.js 20 e Yarn 1.22.

```bash
cd frontend
cp .env.example .env
npm install -g yarn@1.22.22
yarn install --frozen-lockfile
yarn start
```

A aplicação será aberta em `http://localhost:3000` e usará `http://localhost:8000/api`.

## Configurações opcionais

### Usuário demonstrativo

No `backend/.env`:

```env
CREATE_DEMO_USER=true
DEMO_EMAIL=demo@aureon.com
DEMO_PASSWORD=uma-senha-segura
```

### Copiloto

O backend aceita um endpoint compatível com `POST /chat/completions` e streaming SSE:

```env
LLM_API_BASE=https://seu-provedor.example/v1
LLM_API_KEY=sua-chave
LLM_MODEL=nome-do-modelo
LLM_MODEL_LABEL=Nome exibido no painel
```

Sem essas variáveis, o Copiloto fica oculto e a aplicação continua funcionando normalmente.

### Login externo

```env
OAUTH_LOGIN_URL=https://seu-provedor.example/login
OAUTH_SESSION_URL=https://seu-provedor.example/session-data
OAUTH_SESSION_HEADER=X-Session-ID
```

Sem essa configuração, o botão de login externo não aparece. E-mail e senha continuam disponíveis.

## Testes

Com a API em execução:

```bash
AUREON_TEST_BASE_URL=http://localhost:8000 pytest -q backend/tests
```

Validações offline incluídas na auditoria:

- compilação sintática de todo o backend;
- parsing de todos os arquivos JavaScript e JSX;
- validação de importações locais;
- importação do backend com registro das rotas;
- validações Pydantic;
- teste básico do parser de promoções.

## Antes de publicar

- Use HTTPS.
- Troque `JWT_SECRET`.
- Configure `CORS_ORIGINS` apenas com seus domínios.
- Mantenha `COOKIE_SECURE=true` em produção.
- Não envie arquivos `.env` ao Git.
- Valide os termos de uso das fontes consultadas pelo monitor de promoções.
