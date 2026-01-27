-- =============================================================================
-- CONSULTAS ANALÍTICAS AVANÇADAS (DATA WAREHOUSE - ACIDENTES AÉREOS)
-- Descrição: 10 Queries estratégicas para análise de segurança aeronáutica
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. TENDÊNCIA ANUAL DE SEGURANÇA
-- Pergunta: O número de acidentes e mortes está aumentando ou diminuindo?
-- -----------------------------------------------------------------------------
SELECT 
    t.num_ano AS "Ano",
    COUNT(DISTINCT f.srk_ocr) AS "Total Ocorrências",
    SUM(f.num_fat) AS "Total Fatalidades",
    CASE 
        WHEN COUNT(DISTINCT f.srk_ocr) = 0 THEN 0
        ELSE ROUND(SUM(f.num_fat)::numeric / COUNT(DISTINCT f.srk_ocr), 2) 
    END AS "Média Mortes/Evento"
FROM gold.fat_ocr f
JOIN gold.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY t.num_ano
ORDER BY t.num_ano DESC;

-- -----------------------------------------------------------------------------
-- 2. SAZONALIDADE: OS MESES MAIS PERIGOSOS
-- Pergunta: Existe algum mês do ano com maior incidência histórica de acidentes?
-- -----------------------------------------------------------------------------
SELECT 
    CASE t.num_mes
        WHEN 1 THEN 'Janeiro' WHEN 2 THEN 'Fevereiro' WHEN 3 THEN 'Março'
        WHEN 4 THEN 'Abril'   WHEN 5 THEN 'Maio'      WHEN 6 THEN 'Junho'
        WHEN 7 THEN 'Julho'   WHEN 8 THEN 'Agosto'    WHEN 9 THEN 'Setembro'
        WHEN 10 THEN 'Outubro' WHEN 11 THEN 'Novembro' WHEN 12 THEN 'Dezembro'
    END AS "Mês",
    COUNT(*) AS "Frequência Histórica"
FROM gold.fat_ocr f
JOIN gold.dim_tmp t ON f.srk_tmp = t.srk_tmp
GROUP BY t.num_mes
ORDER BY "Frequência Histórica" DESC;

-- -----------------------------------------------------------------------------
-- 3. RANKING DE RISCO POR ESTADO (UF)
-- Pergunta: Quais estados concentram o maior número de ocorrências graves?
-- -----------------------------------------------------------------------------
SELECT 
    l.sgl_uf AS "UF",
    COUNT(CASE WHEN o.des_cls = 'ACIDENTE' THEN 1 END) AS "Qtd Acidentes",
    COUNT(CASE WHEN o.des_cls = 'INCIDENTE' THEN 1 END) AS "Qtd Incidentes",
    SUM(f.num_fat) AS "Total Vidas Perdidas"
FROM gold.fat_ocr f
JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
JOIN gold.dim_ocr o ON f.srk_ocr = o.srk_ocr
WHERE l.sgl_uf <> 'NÃO INFORMADO'
GROUP BY l.sgl_uf
ORDER BY "Qtd Acidentes" DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 4. TOP 10 MUNICÍPIOS CRÍTICOS
-- Pergunta: Quais cidades específicas exigem atenção das autoridades?
-- -----------------------------------------------------------------------------
SELECT 
    l.nom_mun || ' - ' || l.sgl_uf AS "Município",
    COUNT(*) AS "Total Ocorrências",
    SUM(f.num_fat) AS "Total Fatalidades"
FROM gold.fat_ocr f
JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.nom_mun, l.sgl_uf
ORDER BY "Total Ocorrências" DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 5. COMPARATIVO: AVIÃO vs HELICÓPTERO vs OUTROS
-- Pergunta: Qual tipo de aeronave se envolve em acidentes mais letais?
-- -----------------------------------------------------------------------------
SELECT 
    a.des_tpo AS "Tipo Aeronave",
    COUNT(*) AS "Quantidade Eventos",
    SUM(f.num_fat) AS "Total Mortes",
    ROUND((SUM(f.num_fat)::numeric / NULLIF(COUNT(*), 0)), 2) AS "Índice Letalidade"
FROM gold.fat_ocr f
JOIN gold.dim_aer a ON f.srk_aer = a.srk_aer
WHERE a.des_tpo IN ('AVIÃO', 'HELICÓPTERO', 'ULTRALEVE')
GROUP BY a.des_tpo
ORDER BY "Índice Letalidade" DESC;

-- -----------------------------------------------------------------------------
-- 6. FABRICANTES COM MAIS OCORRÊNCIAS (DRILL-DOWN)
-- Pergunta: Quais as marcas de aeronaves mais frequentes nos relatórios?
-- -----------------------------------------------------------------------------
SELECT 
    a.nom_fab AS "Fabricante",
    COUNT(*) AS "Ocorrências",
    COUNT(DISTINCT a.nom_mdl) AS "Modelos Diferentes Envolvidos"
FROM gold.fat_ocr f
JOIN gold.dim_aer a ON f.srk_aer = a.srk_aer
WHERE a.nom_fab <> 'NÃO INFORMADO'
GROUP BY a.nom_fab
ORDER BY "Ocorrências" DESC
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 7. PARETO DE CAUSAS (TIPOS DE OCORRÊNCIA)
-- Pergunta: Quais são os problemas raiz que causam 80% dos acidentes?
-- -----------------------------------------------------------------------------
WITH Causas AS (
    SELECT 
        o.des_tpo AS tipo,
        COUNT(*) AS total
    FROM gold.fat_ocr f
    JOIN gold.dim_ocr o ON f.srk_ocr = o.srk_ocr
    GROUP BY o.des_tpo
)
SELECT 
    tipo AS "Causa Principal",
    total AS "Frequência",
    ROUND((total::numeric / (SELECT COUNT(*) FROM gold.fat_ocr) * 100), 2) AS "% do Total"
FROM Causas
ORDER BY total DESC
LIMIT 15;

-- -----------------------------------------------------------------------------
-- 8. MATRIZ DE RISCO: FASE DO VOO vs DANOS
-- Pergunta: Em que momento do voo a aeronave sofre danos mais severos?
-- -----------------------------------------------------------------------------
SELECT 
    o.des_fse AS "Fase de Operação",
    SUM(CASE WHEN o.des_dno = 'DESTRUÍDA' THEN 1 ELSE 0 END) AS "Aeronaves Destruídas",
    SUM(CASE WHEN o.des_dno = 'SUBSTANCIAL' THEN 1 ELSE 0 END) AS "Danos Substanciais",
    SUM(CASE WHEN o.des_dno = 'LEVE' THEN 1 ELSE 0 END) AS "Danos Leves"
FROM gold.fat_ocr f
JOIN gold.dim_ocr o ON f.srk_ocr = o.srk_ocr
WHERE o.des_fse NOT IN ('NÃO INFORMADO', 'INDETERMINADA')
GROUP BY o.des_fse
ORDER BY "Aeronaves Destruídas" DESC;

-- -----------------------------------------------------------------------------
-- 9. EFICIÊNCIA DAS INVESTIGAÇÕES (Recomendações de Segurança)
-- Pergunta: Acidentes mais graves geram mais aprendizado (recomendações)?
-- -----------------------------------------------------------------------------
SELECT 
    o.des_sev AS "Severidade da Ocorrência",
    COUNT(*) AS "Qtd Eventos",
    SUM(f.num_rec) AS "Total Recomendações Emitidas",
    ROUND(AVG(f.num_rec), 1) AS "Média Rec. por Evento"
FROM gold.fat_ocr f
JOIN gold.dim_ocr o ON f.srk_ocr = o.srk_ocr
GROUP BY o.des_sev
ORDER BY "Média Rec. por Evento" DESC;

------------------------------------------------------------
-- 10. VARIAÇÃO ANO A ANO (YoY) - CRESCIMENTO OU QUEDA?
-- Pergunta: Qual o percentual de aumento ou diminuição de casos vs ano anterior?
-- -----------------------------------------------------------------------------
WITH MetricasAnuais AS (
    -- CTE: Prepara os dados agrupados por ano
    SELECT 
        t.num_ano,
        COUNT(*) AS total_eventos,
        SUM(f.num_fat) AS total_fatalidades
    FROM gold.fat_ocr f
    JOIN gold.dim_tmp t ON f.srk_tmp = t.srk_tmp
    GROUP BY t.num_ano
)
SELECT 
    atual.num_ano AS "Ano",
    atual.total_eventos AS "Ocorrências (Ano)",
    anterior.total_eventos AS "Ocorrências (Ano Ant.)",
    
    -- Cálculo da Diferença Absoluta
    (atual.total_eventos - anterior.total_eventos) AS "Dif. Absoluta",
    
    -- Cálculo da Variação Percentual (Evita divisão por zero com NULLIF)
    CASE 
        WHEN anterior.total_eventos IS NULL THEN NULL 
        ELSE ROUND(((atual.total_eventos - anterior.total_eventos)::numeric / NULLIF(anterior.total_eventos, 0)) * 100, 2) 
    END AS "Variação %"
    
FROM MetricasAnuais atual
-- JOIN da CTE com ela mesma (Self-Join) para pegar o ano anterior
LEFT JOIN MetricasAnuais anterior ON atual.num_ano = anterior.num_ano + 1
ORDER BY atual.num_ano DESC;