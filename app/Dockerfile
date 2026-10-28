# Image de base à jour : corrige les vulnérabilités que le scan Trivy bloque.
FROM python:3.13-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
ARG VERSION=dev
ENV VERSION=$VERSION
EXPOSE 8080
USER 1000
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "app:creer_app()"]
