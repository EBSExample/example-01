FROM python:3.13-slim AS venv

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY ./src ./src

COPY ./pyproject.toml ./uv.lock ./.python-version ./README.md ./

RUN uv sync --locked --no-editable

FROM python:3.13-slim

WORKDIR /app

COPY --from=venv /app/.venv .venv

ENV PATH="/app/.venv/bin:$PATH"
