# 🛩️ Acidentes Aéreos - ETL e Visualização

![Status](https://img.shields.io/badge/Status-Completo-brightgreen)
![Python](https://img.shields.io/badge/Python-3.9+-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14-blue)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)
![PowerBI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)

## 📋 Sobre o Projeto

Este projeto implementa um pipeline completo de **ETL (Extract, Transform, Load)** e análise de dados sobre acidentes aéreos no Brasil, utilizando a **arquitetura de dados em camadas de Medalhão (Medallion Architecture)** com três níveis: **Raw (Bronze)**, **Silver** e **Gold**.

O objetivo é transformar dados brutos de acidentes aeronáuticos em insights valiosos através de um processo estruturado de limpeza, transformação e modelagem dimensional, culminando em visualizações interativas no Power BI.

---

## 🏗️ Arquitetura de Medalhão (Medallion Architecture)

A arquitetura de medalhão organiza os dados em três camadas progressivas de qualidade e refinamento:

### 🥉 **Camada Raw (Bronze)**

- **Propósito**: Armazenamento dos dados brutos, tal como foram extraídos da fonte original
- **Características**:
  - Dados sem tratamento
  - Preservação da estrutura original
  - Alto volume de dados faltantes e inconsistentes
  - Base para rastreabilidade e auditoria
- **Localização**: `Data_Layer/raw/`
- **Arquivo**: `data_raw.csv`

### 🥈 **Camada Silver**

- **Propósito**: Dados limpos, padronizados e validados
- **Transformações aplicadas**:
  - ✅ Remoção de valores nulos e vazios
  - ✅ Padronização de tipos de dados
  - ✅ Normalização de datas
  - ✅ Criação de colunas derivadas (ex: ano de ocorrência)
  - ✅ Validação de integridade referencial
  - ✅ Normalização de nomenclaturas
- **Localização**: `Data_Layer/silver/`
- **Schema PostgreSQL**: `silver.acd`
- **ETL**: `Transformer/etl_raw_to_silver.ipynb`

### 🥇 **Camada Gold**

- **Propósito**: Dados modelados para análise (Data Warehouse)
- **Características**:
  - Modelo dimensional (Star Schema)
  - Otimizado para consultas analíticas
  - 4 tabelas de dimensão + 1 tabela fato
  - Agregações pré-calculadas
- **Localização**: `Data_Layer/gold/`
- **Schema PostgreSQL**: `DW` (Data Warehouse)
- **ETL**: `Transformer/etl_silver_to_gold.ipynb`

#### 📐 Modelo Dimensional (Star Schema)

**Dimensões:**

- `dim_aer` - Dimensão Aeronave (matrícula, fabricante, modelo, tipo)
- `dim_loc` - Dimensão Localização (município, UF, latitude, longitude)
- `dim_tmp` - Dimensão Tempo (ano, mês, dia)
- `dim_ocr` - Dimensão Ocorrência (código, classificação, tipo, fase, severidade, dano)

**Fato:**

- `fat_ocr` - Fato Ocorrências (métricas: fatalidades, recomendações, aeronaves, envolvidos)

---

## 📊 Insights da Camada Silver (Analytics)

A análise exploratória na camada Silver revelou importantes padrões nos dados de acidentes aéreos:

### 1. ✨ **Qualidade dos Dados Pós-ETL**

- **Resultado**: Nenhum dado faltante após o processamento ETL
- **Impacto**: 100% dos registros prontos para análise confiável
- Os tratamentos aplicados eliminaram completamente valores nulos e vazios

### 2. 📈 **Evolução Temporal**

- **Gráfico**: Série temporal de ocorrências por ano
- **Insight**: Identificação de tendências históricas e picos de acidentes
- Visualização com área preenchida mostra a intensidade ao longo das décadas

### 3. 🏷️ **Classificação das Ocorrências**

- **Gráficos**: Barras horizontais + Pizza
- **Insight**: Distribuição entre incidentes, acidentes e incidentes graves
- Permite priorização de ações preventivas baseadas na severidade

### 4. 🗺️ **Análise Geográfica**

- **Gráfico**: Top 15 estados (UF) com mais ocorrências
- **Insight**: Concentração regional de acidentes
- Estados com maior movimentação aérea apresentam mais registros
- Útil para alocação de recursos de fiscalização

### 5. 🔍 **Tipos de Ocorrência**

- **Gráfico**: Top 12 tipos mais frequentes
- **Insight**: Identificação das causas mais comuns
- Exemplos: falha de motor, perda de controle, colisão, etc.
- Base para programas de treinamento específicos

### 6. ⚠️ **Análise de Fatalidades**

- **Gráficos**: Pizza (com/sem fatalidades) + Histograma de vítimas
- **Insights**:
  - Proporção de acidentes fatais vs não fatais
  - Distribuição estatística do número de vítimas quando há fatalidades
  - Média de fatalidades por acidente grave
- Crítico para avaliar severidade e priorizar investigações

### 7. 🛫 **Fases de Operação**

- **Gráfico**: Top 10 fases operacionais
- **Insight**: Identificação dos momentos mais críticos do voo
- Fases comuns: decolagem, pouso, cruzeiro, táxi
- Direciona treinamentos para fases de maior risco

### 8. ✈️ **Tipos de Aeronave**

- **Gráfico**: Top 10 tipos de aeronaves envolvidas
- **Insight**: Perfil da frota brasileira acidentada
- Diferenciação entre aviação comercial, agrícola, privada e experimental

### 9. 🔥 **Heatmap: Fase vs Dano**

- **Gráfico**: Matriz de calor relacionando fase de operação e nível de dano
- **Insight**: Correlação entre momento do voo e gravidade dos danos
- Identifica combinações críticas (ex: pouso com destruição total)

### 10. 📅 **Idade da Aeronave vs Fatalidades**

- **Gráfico**: Boxplot com faixas etárias (0-10, 11-20, 21-30, 31-40, 41-50, 50+ anos)
- **Insight**: Relação entre idade da frota e severidade dos acidentes
- Aeronaves mais antigas podem apresentar maior risco de fatalidades
- Suporte para políticas de renovação de frota

---

## 🔧 Tecnologias Utilizadas

- **Python 3.9+**: Linguagem principal para ETL e análises
- **PostgreSQL 14**: Banco de dados relacional (Data Lakehouse)
- **Docker Compose**: Orquestração de containers
- **Pandas**: Manipulação e transformação de dados
- **SQLAlchemy**: ORM para conexão com PostgreSQL
- **Matplotlib & Seaborn**: Visualizações exploratórias
- **Jupyter Notebooks**: Ambiente de desenvolvimento e análise
- **Power BI**: Dashboard interativo final

---

## 📂 Estrutura do Projeto

```
acidentes-aereos-etl-visualization/
│
├── Data_Layer/
│   ├── raw/                          # Camada Bronze
│   │   ├── data_raw.csv             # Dados brutos originais
│   │   └── analytics.ipynb          # Análise exploratória inicial
│   │
│   ├── silver/                       # Camada Silver
│   │   ├── analytics.ipynb          # Análises pós-tratamento
│   │   └── ddl.sql                  # Schema SQL da camada
│   │
│   └── gold/                         # Camada Gold (DW)
│       ├── ddl.sql                  # Modelo dimensional
│       ├── consultas.sql            # Queries analíticas
│       └── mnemonicos.md            # Documentação de campos
│
├── Transformer/
│   ├── etl_raw_to_silver.ipynb      # Pipeline Raw → Silver
│   └── etl_silver_to_gold.ipynb     # Pipeline Silver → Gold
│
├── docker-compose.yml                # Configuração do PostgreSQL
├── requirements.txt                  # Dependências Python
└── README.md                         # Este arquivo
```

---

## 🚀 Como Executar o Projeto

### 1️⃣ **Pré-requisitos**

```bash
# Certifique-se de ter instalado:
- Docker Desktop
- Python 3.9+
- Jupyter Notebook ou VS Code com extensão Jupyter
```

### 2️⃣ **Iniciar o Banco de Dados**

```bash
# Subir o container PostgreSQL
docker-compose up -d

# Verificar se está rodando
docker ps
```

### 3️⃣ **Instalar Dependências Python**

```bash
pip install -r requirements.txt
```

### 4️⃣ **Executar o Pipeline ETL**

```bash
# 1. Executar o notebook Raw → Silver
jupyter notebook Transformer/etl_raw_to_silver.ipynb

# 2. Executar o notebook Silver → Gold
jupyter notebook Transformer/etl_silver_to_gold.ipynb
```

### 5️⃣ **Explorar as Análises**

```bash
# Análises na camada Silver
jupyter notebook Data_Layer/silver/analytics.ipynb
```

---

## 📈 Dashboard Power BI

Acesse o dashboard interativo completo com todas as visualizações e filtros dinâmicos:

### 🔗 [**Clique aqui para acessar o Dashboard no Power BI**](https://app.powerbi.com/view?r=eyJrIjoiNWY2ZTRmZTQtYjI5ZC00YTFlLTk2OWUtZjkxZmRlZGI5NmIxIiwidCI6ImVjMzU5YmExLTYzMGItNGQyYi1iODMzLWM4ZTZkNDhmODA1OSJ9)

O dashboard inclui:

- 📊 Indicadores chave (KPIs)
- 🗺️ Mapas interativos de ocorrências
- 📈 Gráficos temporais dinâmicos
- 🔍 Filtros por período, região, tipo de aeronave e severidade
- 📉 Análises de tendências e correlações

---

## 🎯 Principais Conquistas

✅ Pipeline ETL completo e automatizado  
✅ Arquitetura de dados escalável e modular  
✅ Limpeza e tratamento de 100% dos dados  
✅ Modelo dimensional otimizado para análises  
✅ 11 análises exploratórias detalhadas  
✅ Dashboard interativo no Power BI  
✅ Documentação técnica completa

---

## 📝 Licença

Este projeto está sob a licença especificada no arquivo [LICENSE](LICENSE).
