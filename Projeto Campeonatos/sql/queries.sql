-- ============================================================
-- queries.sql
-- Consultas para o banco competicao_esportiva
-- ============================================================

USE competicao_esportiva;

-- 1. Campeonatos ativos por modalidade

SELECT
    m.nome AS modalidade,
    c.nome AS campeonato,
    cat.nome AS categoria,
    g.nome AS genero,
    t.ano AS temporada,
    ct.nome_edicao AS edicao,
    ct.data_inicio,
    ct.data_fim,
    ct.situacao
FROM Campeonato_Temporada ct
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Categoria cat ON cat.id_categoria = c.id_categoria
JOIN Genero g ON g.id_genero = c.id_genero
JOIN Temporada t ON t.id_temporada = ct.id_temporada
WHERE ct.situacao = 'Ativo'
ORDER BY m.nome, c.nome, t.ano DESC;

-- 2. Equipes com mais vitorias

WITH desempenho AS (
    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_mandante AS id_equipe_campeonato,
        rp.pontos_mandante AS pontos_feitos,
        rp.pontos_visitante AS pontos_sofridos,
        CASE WHEN rp.pontos_mandante > rp.pontos_visitante THEN 1 ELSE 0 END AS vitoria
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'

    UNION ALL

    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_visitante AS id_equipe_campeonato,
        rp.pontos_visitante AS pontos_feitos,
        rp.pontos_mandante AS pontos_sofridos,
        CASE WHEN rp.pontos_visitante > rp.pontos_mandante THEN 1 ELSE 0 END AS vitoria
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'
)
SELECT
    m.nome AS modalidade,
    c.nome AS campeonato,
    t.ano AS temporada,
    e.nome AS equipe,
    COUNT(*) AS jogos,
    SUM(vitoria) AS vitorias,
    SUM(pontos_feitos) AS pontos_feitos,
    SUM(pontos_sofridos) AS pontos_sofridos
FROM desempenho d
JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = d.id_equipe_campeonato
JOIN Equipe e ON e.id_equipe = ec.id_equipe
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = d.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Temporada t ON t.id_temporada = ct.id_temporada
GROUP BY m.nome, c.nome, t.ano, e.nome
ORDER BY vitorias DESC, pontos_feitos DESC, equipe;

-- 3. Maiores pontuadores por modalidade

SELECT
    m.nome AS modalidade,
    a.nome AS atleta,
    e.nome AS equipe,
    SUM(ep.valor_pontos) AS total_pontos,
    COUNT(*) AS eventos_de_pontuacao
FROM Evento_Partida ep
JOIN Partida p ON p.id_partida = ep.id_partida
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = p.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Atleta a ON a.id_atleta = ep.id_atleta
JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = ep.id_equipe_campeonato
JOIN Equipe e ON e.id_equipe = ec.id_equipe
WHERE ep.valor_pontos > 0
GROUP BY m.nome, a.nome, e.nome
ORDER BY m.nome, total_pontos DESC, atleta;

-- 4. Classificacao por categoria

WITH desempenho AS (
    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_mandante AS id_equipe_campeonato,
        rp.pontos_mandante AS pontos_feitos,
        rp.pontos_visitante AS pontos_sofridos,
        CASE
            WHEN rp.pontos_mandante > rp.pontos_visitante THEN 3
            WHEN rp.pontos_mandante = rp.pontos_visitante THEN 1
            ELSE 0
        END AS pontos_classificacao,
        CASE WHEN rp.pontos_mandante > rp.pontos_visitante THEN 1 ELSE 0 END AS vitoria,
        CASE WHEN rp.pontos_mandante = rp.pontos_visitante THEN 1 ELSE 0 END AS empate,
        CASE WHEN rp.pontos_mandante < rp.pontos_visitante THEN 1 ELSE 0 END AS derrota
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'

    UNION ALL

    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_visitante AS id_equipe_campeonato,
        rp.pontos_visitante AS pontos_feitos,
        rp.pontos_mandante AS pontos_sofridos,
        CASE
            WHEN rp.pontos_visitante > rp.pontos_mandante THEN 3
            WHEN rp.pontos_visitante = rp.pontos_mandante THEN 1
            ELSE 0
        END AS pontos_classificacao,
        CASE WHEN rp.pontos_visitante > rp.pontos_mandante THEN 1 ELSE 0 END AS vitoria,
        CASE WHEN rp.pontos_visitante = rp.pontos_mandante THEN 1 ELSE 0 END AS empate,
        CASE WHEN rp.pontos_visitante < rp.pontos_mandante THEN 1 ELSE 0 END AS derrota
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'
)
SELECT
    cat.nome AS categoria,
    m.nome AS modalidade,
    c.nome AS campeonato,
    t.ano AS temporada,
    e.nome AS equipe,
    COUNT(*) AS jogos,
    SUM(vitoria) AS vitorias,
    SUM(empate) AS empates,
    SUM(derrota) AS derrotas,
    SUM(pontos_classificacao) AS pontos,
    SUM(pontos_feitos) AS pontos_feitos,
    SUM(pontos_sofridos) AS pontos_sofridos,
    SUM(pontos_feitos) - SUM(pontos_sofridos) AS saldo
FROM desempenho d
JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = d.id_equipe_campeonato
JOIN Equipe e ON e.id_equipe = ec.id_equipe
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = d.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Categoria cat ON cat.id_categoria = c.id_categoria
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Temporada t ON t.id_temporada = ct.id_temporada
GROUP BY cat.nome, m.nome, c.nome, t.ano, e.nome
ORDER BY categoria, modalidade, campeonato, temporada, pontos DESC, vitorias DESC, saldo DESC;

-- 5. Partidas com maior publico

SELECT
    p.id_partida,
    m.nome AS modalidade,
    c.nome AS campeonato,
    t.ano AS temporada,
    mandante.nome AS equipe_mandante,
    visitante.nome AS equipe_visitante,
    rp.pontos_mandante,
    rp.pontos_visitante,
    p.data_hora,
    p.local_partida,
    p.cidade,
    p.estado,
    p.publico_presente
FROM Partida p
JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = p.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Temporada t ON t.id_temporada = ct.id_temporada
JOIN Equipe_Campeonato ec_mandante ON ec_mandante.id_equipe_campeonato = p.id_equipe_mandante
JOIN Equipe mandante ON mandante.id_equipe = ec_mandante.id_equipe
JOIN Equipe_Campeonato ec_visitante ON ec_visitante.id_equipe_campeonato = p.id_equipe_visitante
JOIN Equipe visitante ON visitante.id_equipe = ec_visitante.id_equipe
WHERE p.situacao = 'Finalizada'
ORDER BY p.publico_presente DESC, p.data_hora DESC;

-- 6. Media de pontos por equipe

WITH pontos_por_jogo AS (
    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_mandante AS id_equipe_campeonato,
        rp.pontos_mandante AS pontos_feitos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'

    UNION ALL

    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_visitante AS id_equipe_campeonato,
        rp.pontos_visitante AS pontos_feitos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'
)
SELECT
    m.nome AS modalidade,
    c.nome AS campeonato,
    t.ano AS temporada,
    e.nome AS equipe,
    COUNT(*) AS jogos,
    SUM(ppj.pontos_feitos) AS total_pontos,
    ROUND(AVG(ppj.pontos_feitos), 2) AS media_pontos
FROM pontos_por_jogo ppj
JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = ppj.id_equipe_campeonato
JOIN Equipe e ON e.id_equipe = ec.id_equipe
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = ppj.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Temporada t ON t.id_temporada = ct.id_temporada
GROUP BY m.nome, c.nome, t.ano, e.nome
ORDER BY media_pontos DESC, equipe;

-- 7. Arbitros com mais partidas

SELECT
    a.nome AS arbitro,
    a.federacao,
    a.nivel,
    COUNT(ap.id_partida) AS partidas
FROM Arbitro a
JOIN Arbitro_Partida ap ON ap.id_arbitro = a.id_arbitro
GROUP BY a.nome, a.federacao, a.nivel
ORDER BY partidas DESC, arbitro;

-- 8. Melhor ataque e melhor defesa

WITH desempenho AS (
    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_mandante AS id_equipe_campeonato,
        rp.pontos_mandante AS pontos_feitos,
        rp.pontos_visitante AS pontos_sofridos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'

    UNION ALL

    SELECT
        p.id_campeonato_temporada,
        p.id_equipe_visitante AS id_equipe_campeonato,
        rp.pontos_visitante AS pontos_feitos,
        rp.pontos_mandante AS pontos_sofridos
    FROM Partida p
    JOIN Resultado_Partida rp ON rp.id_partida = p.id_partida
    WHERE p.situacao = 'Finalizada'
)
SELECT
    m.nome AS modalidade,
    c.nome AS campeonato,
    t.ano AS temporada,
    e.nome AS equipe,
    COUNT(*) AS jogos,
    SUM(d.pontos_feitos) AS ataque,
    SUM(d.pontos_sofridos) AS defesa,
    SUM(d.pontos_feitos) - SUM(d.pontos_sofridos) AS saldo
FROM desempenho d
JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = d.id_equipe_campeonato
JOIN Equipe e ON e.id_equipe = ec.id_equipe
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = d.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Temporada t ON t.id_temporada = ct.id_temporada
GROUP BY m.nome, c.nome, t.ano, e.nome
ORDER BY modalidade, campeonato, temporada, ataque DESC, defesa ASC;

-- 9. Atletas com mais penalidades

SELECT
    m.nome AS modalidade,
    a.nome AS atleta,
    e.nome AS equipe,
    COUNT(*) AS penalidades
FROM Evento_Partida ep
JOIN Partida p ON p.id_partida = ep.id_partida
JOIN Campeonato_Temporada ct ON ct.id_campeonato_temporada = p.id_campeonato_temporada
JOIN Campeonato c ON c.id_campeonato = ct.id_campeonato
JOIN Modalidade m ON m.id_modalidade = c.id_modalidade
JOIN Atleta a ON a.id_atleta = ep.id_atleta
JOIN Equipe_Campeonato ec ON ec.id_equipe_campeonato = ep.id_equipe_campeonato
JOIN Equipe e ON e.id_equipe = ec.id_equipe
WHERE ep.tipo_evento = 'Penalidade'
GROUP BY m.nome, a.nome, e.nome
ORDER BY penalidades DESC, atleta;
