FROM python:3.13.5-alpine3.22

# No .pyc writes: the root filesystem may be read-only
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app
COPY requirements.txt ./

# Updates to newest packages,
RUN apk update \
    && apk upgrade --no-cache --available \
    && apk add --no-cache \
    && pip install --no-cache-dir -r requirements.txt \
    && mkdir ./config \
    && addgroup -S -g 1000 ntripmonitor \
    && adduser -S -D -H -u 1000 -G ntripmonitor ntripmonitor

COPY ./src/ ./
COPY ./src/settings.py ./settings.py
COPY ./src/ingestion.py ./ingestion.py

# Code stays owned by root and read-only to the runtime user. Numeric so that
# runAsNonRoot can be verified without resolving a name.
USER 1000:1000

ENTRYPOINT ["python3", "ingestion.py"]
