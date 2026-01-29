# 1. Resumo da Arquitetura (Acidentes Aéreos)

## 1.1. Camada Prata (Silver)
* **Artefato Principal:** `silver.acd` (One Big Table).
* **Foco:** Dados limpos, tipados e com coordenadas corrigidas, mantendo a granularidade original.

## 1.2. Camada Gold (Data Warehouse)
* **Conceito:** Modelo Dimensional (Star Schema).
* **Foco:** Otimização para BI, métricas de segurança (Fatalidades, Danos) e dimensões de análise (Aeronave, Local, Tempo, Detalhes).

---

# 2. Mnemónicos

## 2.1. Padrões Gerais
| Mnemónico | Significado |
| :--- | :--- |
| **dim_** | Tabelas de Dimensão |
| **fat_** | Tabelas de Fato |
| **srk_** | Surrogate Key (Chave Artificial Sequencial) |
| **nom_** | Nome (Texto descritivo) |
| **cod_** | Código de Negócio (ex: Matrícula, Código Ocorrência) |
| **des_** | Descrição ou Classificação |
| **num_** | Número / Quantidade (Métrica Inteira ou Float) |
| **sgl_** | Sigla |

## 2.2. Siglas de Negócio
| Mnemónico | Significado |
| :--- | :--- |
| **ocr** | Ocorrência (Acidente/Incidente) |
| **aer** | Aeronave |
| **loc** | Localização |
| **tmp** | Tempo (Data/Hora) |
| **fat** | Fatalidade |
| **rec** | Recomendação |
| **fab** | Fabricante |
| **mdl** | Modelo |
| **mat** | Matrícula |
| **mun** | Município |
| **env** | Envolvidos |
| **dno** | Dano |
| **sev** | Severidade |
| **fse** | Fase |
| **cls** | Classificação |
| **ase** | Assentos |

## 2.3. Glossário Detalhado por Tabela

### 2.3.1 Dimensão Aeronave (`"DW".dim_aer`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_aer** | Surrogate Key da Aeronave (PK) |
| **cod_mat** | Matrícula da Aeronave (ex: PT-XYZ) |
| **nom_fab** | Nome do Fabricante (ex: CESSNA AIRCRAFT) |
| **nom_mdl** | Modelo da Aeronave (ex: 172) |
| **des_tpo** | Tipo da Aeronave (ex: AVIÃO, HELICÓPTERO) |

### 2.3.2 Dimensão Localização (`"DW".dim_loc`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_loc** | Surrogate Key da Localização (PK) |
| **nom_mun** | Nome do Município da ocorrência |
| **sgl_uf** | Sigla da Unidade Federativa (UF) |
| **num_lat** | Latitude geográfica tratada |
| **num_lon** | Longitude geográfica tratada |

### 2.3.3 Dimensão Tempo (`"DW".dim_tmp`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_tmp** | Surrogate Key do Tempo (PK) |
| **num_ano** | Ano da ocorrência |
| **num_mes** | Mês da ocorrência (1-12) |
| **num_dia** | Dia da ocorrência (1-31) |

### 2.3.4 Dimensão Detalhes Ocorrência (`"DW".dim_ocr`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_ocr** | Surrogate Key da Ocorrência (PK) |
| **cod_ocr** | Código Original da Ocorrência (Identificador CENIPA) |
| **des_cls** | Classificação Oficial (ex: ACIDENTE, INCIDENTE GRAVE) |
| **des_tpo** | Tipo da Ocorrência (ex: FALHA DE MOTOR, POUSO BRUSCO) |
| **des_fse** | Fase de Operação (ex: DECOLAGEM, CRUZEIRO) |
| **des_sev** | Severidade Calculada (ex: CRÍTICA, LEVE - regra de negócio) |
| **des_dno** | Nível de Dano na Aeronave (ex: SUBSTANCIAL, DESTRUÍDA) |

### 2.3.5 Fato Ocorrências (`"DW".fat_ocr`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_aer** | FK para Dimensão Aeronave |
| **srk_loc** | FK para Dimensão Localização |
| **srk_tmp** | FK para Dimensão Tempo |
| **srk_ocr** | FK para Dimensão Detalhes Ocorrência |
| **num_fat** | Quantidade total de Fatalidades |
| **num_rec** | Quantidade total de Recomendações emitidas |
| **num_ase** | Quantidade de Assentos na aeronave |
| **num_env** | Total de Aeronaves Envolvidas na ocorrência |