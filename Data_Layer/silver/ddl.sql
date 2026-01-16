CREATE TABLE IF NOT EXISTS public.acidentes_silver (
    -- Identificação da ocorrência
    "Codigo da Ocorrencia" VARCHAR(50),
    "Numero da Ficha" VARCHAR(50),
    
    -- Informações temporais
    "Data e Hora da Ocorrencia" TIMESTAMP,
    "Ano" INTEGER,
    "Mes" INTEGER,
    "Dia" INTEGER,
    "Hora" INTEGER,
    
    -- Localização
    "UF da Ocorrencia" VARCHAR(2),
    "Municipio da Ocorrencia" VARCHAR(255),
    "Regiao da Ocorrencia" VARCHAR(100),
    "Latitude" VARCHAR(50),
    "Longitude" VARCHAR(50),
    
    -- Classificação e tipo
    "Classificacao da Ocorrencia" VARCHAR(100),
    "Tipo de Ocorrencia" VARCHAR(255),
    "Tipo de Operacao da Aeronave" VARCHAR(255),
    "Fase de Operacao da Aeronave" VARCHAR(255),
    
    -- Aeronave
    "Tipo de Aeronave" VARCHAR(255),
    "Fabricante da Aeronave" VARCHAR(255),
    "Modelo da Aeronave" VARCHAR(255),
    "Matricula da Aeronave" VARCHAR(50),
    "Numero de Serie da Aeronave" VARCHAR(100),
    "Ano de Fabricacao da Aeronave" INTEGER,
    "Quantidade de Assentos na Aeronave" INTEGER,
    
    -- Danos e fatalidades
    "Nivel de Dano da Aeronave" VARCHAR(100),
    "Total de Fatalidades no Acidente" INTEGER NOT NULL DEFAULT 0,
    "Total de Aeronaves Envolvidas" INTEGER NOT NULL DEFAULT 0,
    
    -- Investigação
    "Total de Recomendacoes" INTEGER NOT NULL DEFAULT 0,
    "Status da Investigacao" VARCHAR(100),
    "Relatorio Publicado" VARCHAR(10),
    
    -- Indicadores calculados
    "Nivel_Severidade" VARCHAR(20),
    
    -- Outras informações
    "Pais da Ocorrencia" VARCHAR(100),
    "Horario de Salida" VARCHAR(50),
    "Horario de Chegada" VARCHAR(50),
    "Rota" VARCHAR(255),
    "Operador Padronizado" VARCHAR(255),
    "Historico da Aeronave" TEXT
);

-- Índices para melhorar performance de consultas
CREATE INDEX IF NOT EXISTS idx_acidentes_ano ON public.acidentes_silver("Ano");
CREATE INDEX IF NOT EXISTS idx_acidentes_uf ON public.acidentes_silver("UF da Ocorrencia");
CREATE INDEX IF NOT EXISTS idx_acidentes_tipo ON public.acidentes_silver("Tipo de Ocorrencia");
CREATE INDEX IF NOT EXISTS idx_acidentes_severidade ON public.acidentes_silver("Nivel_Severidade");
CREATE INDEX IF NOT EXISTS idx_acidentes_data ON public.acidentes_silver("Data e Hora da Ocorrencia");
CREATE INDEX IF NOT EXISTS idx_acidentes_classificacao ON public.acidentes_silver("Classificacao da Ocorrencia");

-- Comentários na tabela
COMMENT ON TABLE public.acidentes_silver IS 'Tabela da camada SILVER contendo dados tratados de acidentes aeronáuticos no Brasil';
COMMENT ON COLUMN public.acidentes_silver."Nivel_Severidade" IS 'Indicador calculado: CRÍTICO (>50 fatalidades), GRAVE (>10), MODERADO (>0), LEVE (0)';
