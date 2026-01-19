# Imagem base oficial do Jupyter com SPARK e JAVA já configurados
# Inclui: Python, Java, Spark, Pandas, Matplotlib, Seaborn, etc.
FROM jupyter/pyspark-notebook:latest

# Troca para root para instalar pacotes do sistema necessários para o Postgres
USER root

# Instala compiladores e dependências do driver Postgres (libpq-dev)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Volta para o usuário padrão do Jupyter para instalar bibliotecas Python
USER jovyan

# Instala as bibliotecas de conexão com banco e utilitários
# Nota: PySpark, Pandas e Numpy já vêm na imagem base!
RUN pip install --no-cache-dir \
    sqlalchemy \
    psycopg2-binary \
    python-dotenv \
    ipython-sql

# Configura permissões para garantir escrita na pasta de trabalho
USER root
RUN chown -R jovyan:users /home/jovyan/work

# Define o usuário final e diretório
USER jovyan
WORKDIR /home/jovyan/work

# O comando padrão já inicia o Jupyter Lab