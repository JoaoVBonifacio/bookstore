# Etapa base
FROM python:3.12-slim AS base

# Variáveis de ambiente
ENV PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# Atualiza pacotes e instala dependências básicas
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instala o Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Instala libs do sistema necessárias ao psycopg2
RUN apt-get update && apt-get install -y \
    libpq-dev gcc \
    && pip install psycopg2-binary \
    && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR $PYSETUP_PATH

# Copia arquivos essenciais
COPY poetry.lock pyproject.toml ./
# <- ESTA LINHA É ESSENCIAL
RUN poetry install --without dev --no-root

# Copia o restante do código (depois do install para cache eficiente)
COPY . .

# Expõe a porta do servidor
EXPOSE 8000

# Comando padrão
CMD ["./.venv/bin/python", "manage.py", "runserver", "0.0.0.0:8000"]
