CREATE SCHEMA IF NOT EXISTS "DW";

-- Limpeza (Ordem reversa para não quebrar chaves estrangeiras)
DROP TABLE IF EXISTS "DW".fat_ocr CASCADE;
DROP TABLE IF EXISTS "DW".dim_aer CASCADE;
DROP TABLE IF EXISTS "DW".dim_loc CASCADE;
DROP TABLE IF EXISTS "DW".dim_ocr CASCADE;
DROP TABLE IF EXISTS "DW".dim_tmp CASCADE;

-- 1. Dimensão Aeronave
CREATE TABLE "DW".dim_aer (
    srk_aer     SERIAL PRIMARY KEY,
    cod_mat     VARCHAR(50),  
    nom_fab     VARCHAR(255), 
    nom_mdl     VARCHAR(255), 
    des_tpo     VARCHAR(255), 
    UNIQUE (cod_mat, nom_fab, nom_mdl)
);

-- 2. Dimensão Localização (CORRIGIDO TAMANHO UF)
CREATE TABLE "DW".dim_loc (
    srk_loc     SERIAL PRIMARY KEY,
    nom_mun     VARCHAR(255),
    sgl_uf      VARCHAR(20),      
    num_lat     DOUBLE PRECISION,
    num_lon     DOUBLE PRECISION,
    UNIQUE (nom_mun, sgl_uf, num_lat, num_lon)
);

-- 3. Dimensão Tempo
CREATE TABLE "DW".dim_tmp (
    srk_tmp     SERIAL PRIMARY KEY,
    num_ano     INTEGER,
    num_mes     INTEGER,
    num_dia     INTEGER,
    UNIQUE (num_ano, num_mes, num_dia)
);

-- 4. Dimensão Detalhes da Ocorrência
CREATE TABLE "DW".dim_ocr (
    srk_ocr     SERIAL PRIMARY KEY,
    cod_ocr     VARCHAR(50),  
    des_cls     VARCHAR(100), 
    des_tpo     VARCHAR(255), 
    des_fse     VARCHAR(255), 
    des_sev     VARCHAR(50),  
    des_dno     VARCHAR(100), 
    UNIQUE (cod_ocr)
);

-- 5. Fato Ocorrências
CREATE TABLE "DW".fat_ocr (
    srk_aer     INTEGER REFERENCES "DW".dim_aer(srk_aer),
    srk_loc     INTEGER REFERENCES "DW".dim_loc(srk_loc),
    srk_tmp     INTEGER REFERENCES "DW".dim_tmp(srk_tmp),
    srk_ocr     INTEGER REFERENCES "DW".dim_ocr(srk_ocr),
    
    num_fat     INTEGER, 
    num_rec     INTEGER, 
    num_ase     INTEGER, 
    num_env     INTEGER  
);

-- Índices
CREATE INDEX idx_fat_aer ON "DW".fat_ocr(srk_aer);
CREATE INDEX idx_fat_loc ON "DW".fat_ocr(srk_loc);
CREATE INDEX idx_fat_tmp ON "DW".fat_ocr(srk_tmp);
CREATE INDEX idx_fat_ocr ON "DW".fat_ocr(srk_ocr);