# STAGE 1: Construcción (Slim Bullseye)
FROM python:3.11-slim-bullseye AS builder

WORKDIR /app

# Actualización crítica del sistema operativo en el stage de construcción
# Esto garantiza que el SO tenga los últimos parches de seguridad disponibles
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copia y instala dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# STAGE 2: Imagen Final Limpia
FROM python:3.11-slim-bullseye

WORKDIR /app

# Copia solo los paquetes y el código necesarios
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY app.py .

# Crear y cambiar a usuario no-root
RUN useradd -m appuser
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]