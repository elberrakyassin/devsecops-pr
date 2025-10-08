# STAGE 1: Construcción (Alpine)
FROM python:3.11-alpine AS builder

WORKDIR /app

# Instalar dependencias de compilación para garantizar que Flask funcione
RUN apk add --no-cache build-base linux-headers libffi-dev openssl-dev

# Copia y instala dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# STAGE 2: Imagen Final (Alpine limpia)
FROM python:3.11-alpine

WORKDIR /app

# --- PASO DE SEGURIDAD: Parchear el SO BASE ---
# Ejecutar actualización para corregir vulnerabilidades del sistema operativo
RUN apk update && \
    apk upgrade --no-cache && \
    rm -rf /var/cache/apk/*

# Copiar paquetes instalados y el código fuente
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY app.py .

# Crear y cambiar a usuario no-root
RUN adduser -D appuser
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]