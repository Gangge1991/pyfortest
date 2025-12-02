# FROM python:3.10-slim
# WORKDIR /app
# COPY py4jks /app/py4jks
# RUN pip install --no-cache-dir fastapi uvicorn
# EXPOSE 8000
# CMD ["python", "-m", "uvicorn", "py4jks.main:app", "--host", "0.0.0.0", "--port", "8000"]

FROM python:3.10-slim
ENV UV_LINK_MODE=copy
ENV PATH="/root/.local/bin:$PATH"
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -LsSf https://astral.sh/uv/install.sh | sh
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev
COPY py4jks /app/py4jks
ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8000
CMD ["uvicorn", "py4jks.main:app", "--host", "0.0.0.0", "--port", "8000"]
