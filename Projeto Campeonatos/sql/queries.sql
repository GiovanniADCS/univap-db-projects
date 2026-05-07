-- ============================================================
-- queries.sql
-- Consultas obrigatorias do professor
-- ============================================================

USE competicao_esportiva;

-- a) Quantos e quais campeonatos de voleibol, basquete e rugby estao em andamento atualmente?

SELECT
    COUNT(*) OVER () AS total_campeonatos,
    m.nome AS modalidade,
    c.nome AS campeonato,
    cat.nome AS categoria,
    g.nome AS genero,
    t.ano AS temporada,
    c.situacao
FROM Campeonato c
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Categoria cat ON cat.id_categoria = c.id_categoria
JOIN Genero g ON g.id_genero = c.id_genero
JOIN Temporada t ON t.id_temporada = c.id_temporada
WHERE m.nome IN ('Voleibol', 'Basquete', 'Rugby')
  AND c.situacao = 'em andamento'
  AND t.ano = (SELECT MAX(ano) FROM Temporada)
ORDER BY m.nome, c.nome;

-- b) Quais equipes de futebol possuem o maior numero de vitorias em uma unica temporada?

WITH desempenho AS (
    SELECT
        t.ano,
        e.nome AS equipe,
        CASE WHEN rp.pontos_mandante > rp.pontos_visitante THEN 1 ELSE 0 END AS vitoria
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_mandante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    WHERE m.nome = 'Futebol'
    UNION ALL
    SELECT
        t.ano,
        e.nome AS equipe,
        CASE WHEN rp.pontos_visitante > rp.pontos_mandante THEN 1 ELSE 0 END AS vitoria
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_visitante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    WHERE m.nome = 'Futebol'
),
ranking AS (
    SELECT
        ano,
        equipe,
        SUM(vitoria) AS vitorias,
        RANK() OVER (ORDER BY SUM(vitoria) DESC) AS posicao
    FROM desempenho
    GROUP BY ano, equipe
)
SELECT ano AS temporada, equipe, vitorias
FROM ranking
WHERE posicao = 1
ORDER BY equipe;

-- c) Maiores artilheiros ou pontuadores nas ultimas 10 temporadas por modalidade.

WITH pontuacao AS (
    SELECT
        m.nome AS modalidade,
        a.nome AS atleta,
        e.nome AS equipe,
        SUM(pa.pontos) AS total_pontos
    FROM Pontuacoes_Atletas pa
    JOIN Atleta_Equipe ae ON ae.id_atleta_equipe = pa.id_atleta_equipe
    JOIN Atleta a ON a.id_atleta = ae.id_atleta
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = ae.id_equipe_campeonato
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Partida p ON p.id_partida = pa.id_partida
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    WHERE t.ano >= (SELECT MAX(ano) - 9 FROM Temporada)
    GROUP BY m.nome, a.nome, e.nome
),
ranking AS (
    SELECT
        modalidade,
        atleta,
        equipe,
        total_pontos,
        RANK() OVER (PARTITION BY modalidade ORDER BY total_pontos DESC) AS posicao
    FROM pontuacao
)
SELECT modalidade, atleta, equipe, total_pontos
FROM ranking
WHERE posicao = 1
ORDER BY modalidade;

-- d) Classificacao do futebol masculino sub-11, sub-13, sub-15 e sub-17 na temporada passada.

WITH desempenho AS (
    SELECT
        cat.nome AS categoria,
        e.nome AS equipe,
        rp.pontos_mandante AS gols_feitos,
        rp.pontos_visitante AS gols_sofridos,
        CASE
            WHEN rp.pontos_mandante > rp.pontos_visitante THEN 3
            WHEN rp.pontos_mandante = rp.pontos_visitante THEN 1
            ELSE 0
        END AS pontos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_mandante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    JOIN Categoria cat ON cat.id_categoria = c.id_categoria
    JOIN Genero g ON g.id_genero = c.id_genero
    WHERE m.nome = 'Futebol'
      AND g.nome = 'Masculino'
      AND cat.nome IN ('Sub-11', 'Sub-13', 'Sub-15', 'Sub-17')
      AND t.ano = (SELECT MAX(ano) - 1 FROM Temporada)
    UNION ALL
    SELECT
        cat.nome AS categoria,
        e.nome AS equipe,
        rp.pontos_visitante AS gols_feitos,
        rp.pontos_mandante AS gols_sofridos,
        CASE
            WHEN rp.pontos_visitante > rp.pontos_mandante THEN 3
            WHEN rp.pontos_visitante = rp.pontos_mandante THEN 1
            ELSE 0
        END AS pontos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_visitante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    JOIN Categoria cat ON cat.id_categoria = c.id_categoria
    JOIN Genero g ON g.id_genero = c.id_genero
    WHERE m.nome = 'Futebol'
      AND g.nome = 'Masculino'
      AND cat.nome IN ('Sub-11', 'Sub-13', 'Sub-15', 'Sub-17')
      AND t.ano = (SELECT MAX(ano) - 1 FROM Temporada)
)
SELECT
    categoria,
    equipe,
    COUNT(*) AS jogos,
    SUM(pontos) AS pontos,
    SUM(gols_feitos) AS gols_feitos,
    SUM(gols_sofridos) AS gols_sofridos,
    SUM(gols_feitos) - SUM(gols_sofridos) AS saldo_gols
FROM desempenho
GROUP BY categoria, equipe
ORDER BY categoria, pontos DESC, saldo_gols DESC, gols_feitos DESC;

-- e) Partidas do voleibol feminino adulto com maior publico nas ultimas 5 temporadas.

SELECT
    t.ano AS temporada,
    c.nome AS campeonato,
    mandante.nome AS equipe_mandante,
    visitante.nome AS equipe_visitante,
    est.nome AS estadio,
    est.cidade,
    p.publico_presente,
    rp.pontos_mandante,
    rp.pontos_visitante
FROM Partida p
JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
JOIN Equipe_Campeonato ec_m ON ec_m.id_equipe_campeonato = p.id_equipe_mandante
JOIN Equipe mandante ON mandante.id_equipe = ec_m.id_equipe
JOIN Equipe_Campeonato ec_v ON ec_v.id_equipe_campeonato = p.id_equipe_visitante
JOIN Equipe visitante ON visitante.id_equipe = ec_v.id_equipe
JOIN Estadio est ON est.id_estadio = p.id_estadio
JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
JOIN Temporada t ON t.id_temporada = c.id_temporada
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Categoria cat ON cat.id_categoria = c.id_categoria
JOIN Genero g ON g.id_genero = c.id_genero
WHERE m.nome = 'Voleibol'
  AND g.nome = 'Feminino'
  AND cat.nome = 'Adulto'
  AND t.ano >= (SELECT MAX(ano) - 4 FROM Temporada)
ORDER BY p.publico_presente DESC, t.ano DESC;

-- f) Media de pontos por partida de cada equipe de basquete masculino em todas as categorias na ultima temporada.

WITH pontos AS (
    SELECT
        cat.nome AS categoria,
        e.nome AS equipe,
        rp.pontos_mandante AS pontos_feitos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_mandante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    JOIN Categoria cat ON cat.id_categoria = c.id_categoria
    JOIN Genero g ON g.id_genero = c.id_genero
    WHERE m.nome = 'Basquete'
      AND g.nome = 'Masculino'
      AND t.ano = (SELECT MAX(ano) FROM Temporada)
    UNION ALL
    SELECT
        cat.nome AS categoria,
        e.nome AS equipe,
        rp.pontos_visitante AS pontos_feitos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_visitante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    JOIN Categoria cat ON cat.id_categoria = c.id_categoria
    JOIN Genero g ON g.id_genero = c.id_genero
    WHERE m.nome = 'Basquete'
      AND g.nome = 'Masculino'
      AND t.ano = (SELECT MAX(ano) FROM Temporada)
)
SELECT categoria, equipe, COUNT(*) AS partidas, ROUND(AVG(pontos_feitos), 2) AS media_pontos
FROM pontos
GROUP BY categoria, equipe
ORDER BY categoria, media_pontos DESC;

-- g) Arbitros federados com mais jogos no futsal adulto masculino e feminino na temporada atual.

SELECT
    a.nome AS arbitro,
    a.federacao,
    COUNT(*) AS jogos_apitados
FROM Arbitro_Partida ap
JOIN Arbitro a ON a.id_arbitro = ap.id_arbitro
JOIN Partida p ON p.id_partida = ap.id_partida
JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
JOIN Temporada t ON t.id_temporada = c.id_temporada
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Categoria cat ON cat.id_categoria = c.id_categoria
WHERE a.federado = TRUE
  AND m.nome = 'Futsal'
  AND cat.nome = 'Adulto'
  AND t.ano = (SELECT MAX(ano) FROM Temporada)
GROUP BY a.nome, a.federacao
ORDER BY jogos_apitados DESC, a.nome;

-- h) Melhor ataque e melhor defesa no Campeonato de Futebol Amador da Cidade na temporada passada.

WITH desempenho AS (
    SELECT
        e.nome AS equipe,
        rp.pontos_mandante AS gols_feitos,
        rp.pontos_visitante AS gols_sofridos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_mandante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    WHERE c.nome LIKE 'Campeonato de Futebol Amador da Cidade%'
      AND t.ano = (SELECT MAX(ano) - 1 FROM Temporada)
    UNION ALL
    SELECT
        e.nome AS equipe,
        rp.pontos_visitante AS gols_feitos,
        rp.pontos_mandante AS gols_sofridos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = p.id_equipe_visitante
    JOIN Equipe e ON e.id_equipe = ec.id_equipe
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    WHERE c.nome LIKE 'Campeonato de Futebol Amador da Cidade%'
      AND t.ano = (SELECT MAX(ano) - 1 FROM Temporada)
),
ranking AS (
    SELECT
        equipe,
        SUM(gols_feitos) AS ataque,
        SUM(gols_sofridos) AS defesa,
        RANK() OVER (ORDER BY SUM(gols_feitos) DESC) AS ranking_ataque,
        RANK() OVER (ORDER BY SUM(gols_sofridos) ASC) AS ranking_defesa
    FROM desempenho
    GROUP BY equipe
)
SELECT equipe, ataque, defesa, ranking_ataque, ranking_defesa
FROM ranking
WHERE ranking_ataque = 1 OR ranking_defesa = 1
ORDER BY ranking_ataque, ranking_defesa, equipe;

-- i) Atletas masculinos com mais penalidades nas ultimas 5 temporadas.

SELECT
    a.nome AS atleta,
    m.nome AS modalidade,
    COUNT(*) AS total_penalidades
FROM Evento_Partida ep
JOIN Atleta_Equipe ae ON ae.id_atleta_equipe = ep.id_atleta_equipe
JOIN Atleta a ON a.id_atleta = ae.id_atleta
JOIN Genero g ON g.id_genero = a.id_genero
JOIN Partida p ON p.id_partida = ep.id_partida
JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
JOIN Temporada t ON t.id_temporada = c.id_temporada
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
WHERE ep.tipo_evento = 'penalidade'
  AND g.nome = 'Masculino'
  AND t.ano >= (SELECT MAX(ano) - 4 FROM Temporada)
GROUP BY a.nome, m.nome
ORDER BY total_penalidades DESC, a.nome
LIMIT 10;

-- j) Estadios ou arenas com mais partidas em cada modalidade e categoria na temporada atual.

WITH sedes AS (
    SELECT
        m.nome AS modalidade,
        cat.nome AS categoria,
        est.nome AS estadio,
        est.cidade,
        COUNT(*) AS total_partidas
    FROM Partida p
    JOIN Estadio est ON est.id_estadio = p.id_estadio
    JOIN Campeonato c ON c.id_campeonato = p.id_campeonato
    JOIN Temporada t ON t.id_temporada = c.id_temporada
    JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
    JOIN Categoria cat ON cat.id_categoria = c.id_categoria
    WHERE t.ano = (SELECT MAX(ano) FROM Temporada)
    GROUP BY m.nome, cat.nome, est.nome, est.cidade
),
ranking AS (
    SELECT
        modalidade,
        categoria,
        estadio,
        cidade,
        total_partidas,
        RANK() OVER (
            PARTITION BY modalidade, categoria
            ORDER BY total_partidas DESC, estadio
        ) AS posicao
    FROM sedes
)
SELECT modalidade, categoria, estadio, cidade, total_partidas
FROM ranking
WHERE posicao = 1
ORDER BY modalidade, categoria;
