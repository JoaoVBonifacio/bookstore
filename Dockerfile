# Dockerfile

# Etapa base
FROM python:3.12-slim AS base

# Variáveis de ambiente
ENV PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup"

# Define o PATH para incluir o local de instalação do Poetry
ENV PATH="/root/.local/bin:$PATH"

# Atualiza pacotes e instala dependências de sistema e de build
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Instala o Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Define o diretório de trabalho
WORKDIR $PYSETUP_PATH

# Copia arquivos de dependência para otimizar o cache do Docker
COPY poetry.lock pyproject.toml ./

# Instala as dependências do projeto
RUN poetry install --no-root

# Copia o restante do código (depois do install para cache eficiente)
COPY . .

# Expõe a porta do servidor
EXPOSE 8000

# Comando padrão
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]