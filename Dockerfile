FROM mcr.microsoft.com/playwright/python:v1.60.0-noble

RUN apt-get update && apt-get install -y xvfb && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip install --no-cache-dir uv

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-install-project

COPY app/ ./app/
COPY ./scripts/docker_init.sh ./
RUN chmod +x docker_init.sh

EXPOSE 5049 5900

ENV PATH="/app/.venv/bin:$PATH"

CMD ["./docker_init.sh"]
