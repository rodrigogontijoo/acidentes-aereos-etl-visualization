-- Criação da tabela no schema PUBLIC
CREATE TABLE IF NOT EXISTS public.acd (
    -- Identificação da ocorrência (chave primária)
    cod_ocr VARCHAR(50) PRIMARY KEY,
    num_fic VARCHAR(50),
    
    -- Informações temporais
    dta_ocr TIMESTAMP NOT NULL,
    ano INTEGER,
    mes INTEGER,
    dia INTEGER,
    hor INTEGER,
    
    -- Localização
    uf VARCHAR(2),
    mun VARCHAR(255),
    reg VARCHAR(100),
    lat DOUBLE PRECISION,
    lon DOUBLE PRECISION,
    
    -- Classificação e tipo de ocorrência
    cls_ocr VARCHAR(100),
    tpo_ocr VARCHAR(255),
    tpo_ope VARCHAR(255),
    fse_ope VARCHAR(255),
    
    -- Dados da aeronave
    tpo_aer VARCHAR(255),
    fab_aer VARCHAR(255),
    mdl_aer VARCHAR(255),
    mat_aer VARCHAR(50),
    sre_aer VARCHAR(100),
    ano_fab_aer INTEGER,
    qtd_ase_aer INTEGER,
    
    -- Danos e fatalidades
    nvl_dno VARCHAR(100),
    ttl_fat INTEGER NOT NULL DEFAULT 0,
    ttl_aer_env INTEGER NOT NULL DEFAULT 0,
    
    -- Investigação
    ttl_rec INTEGER NOT NULL DEFAULT 0,
    sts_inv VARCHAR(100),
    rlt_pub VARCHAR(10),
    
    -- Indicadores calculados
    nvl_sev VARCHAR(20),
    
    -- Outras informações
    pais_ocr VARCHAR(100),
    hor_sda VARCHAR(50),
    hor_chg VARCHAR(50),
    rta VARCHAR(255),
    ope_pdr VARCHAR(255),
    hst_aer TEXT
);

-- Índices para melhorar performance de consultas (Apontando para public.acd)
CREATE INDEX IF NOT EXISTS idx_acd_ano ON public.acd(ano);
CREATE INDEX IF NOT EXISTS idx_acd_uf ON public.acd(uf);
CREATE INDEX IF NOT EXISTS idx_acd_tpo_ocr ON public.acd(tpo_ocr);
CREATE INDEX IF NOT EXISTS idx_acd_nvl_sev ON public.acd(nvl_sev);
CREATE INDEX IF NOT EXISTS idx_acd_dta_ocr ON public.acd(dta_ocr);
CREATE INDEX IF NOT EXISTS idx_acd_cls_ocr ON public.acd(cls_ocr);
CREATE INDEX IF NOT EXISTS idx_acd_fse_ope ON public.acd(fse_ope);

-- Comentários na tabela (Apontando para public.acd)
COMMENT ON TABLE public.acd IS 'Tabela consolidada (One Big Table) contendo dados tratados de acidentes aeronáuticos no Brasil. Armazenada no schema PUBLIC.';
COMMENT ON COLUMN public.acd.cod_ocr IS 'Código único identificador da ocorrência aeronáutica';
COMMENT ON COLUMN public.acd.dta_ocr IS 'Data e hora da ocorrência no formato TIMESTAMP';
COMMENT ON COLUMN public.acd.ano IS 'Ano extraído de dta_ocr para facilitar filtros';
COMMENT ON COLUMN public.acd.uf IS 'Unidade Federativa da ocorrência (sigla de 2 caracteres)';
COMMENT ON COLUMN public.acd.ttl_fat IS 'Total de fatalidades registradas no acidente (0 = sem vítimas)';
COMMENT ON COLUMN public.acd.nvl_sev IS 'Indicador calculado de severidade: CRÍTICO (>50 fatalidades), GRAVE (11-50), MODERADO (1-10), LEVE (0)';
COMMENT ON COLUMN public.acd.ttl_rec IS 'Quantidade de recomendações geradas pela investigação';