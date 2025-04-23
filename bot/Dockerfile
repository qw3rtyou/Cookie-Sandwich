ARG PYTHON_VERSION=3.12.0
FROM python:${PYTHON_VERSION}-alpine as base

RUN apk update && apk add --no-cache chromium \
        chromium-chromedriver

RUN pip install --upgrade pip

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

WORKDIR /app

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/appuser" \
    --shell "/sbin/nologin" \
    --uid "${UID}" \
    appuser

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

USER appuser

COPY app.py .

EXPOSE 8000

CMD gunicorn 'app:app' --bind=0.0.0.0:8000
