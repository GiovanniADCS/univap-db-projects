-- ============================================================
-- seed.sql
-- Dados de exemplo para testar o banco competicao_esportiva
-- ============================================================

USE competicao_esportiva;

DELETE FROM Arbitro_Partida WHERE id_arbitro_partida > 0;
DELETE FROM Arbitro WHERE id_arbitro > 0;
DELETE FROM Evento_Partida WHERE id_evento > 0;
DELETE FROM Resultado_Partida WHERE id_resultado > 0;
DELETE FROM Partida WHERE id_partida > 0;
DELETE FROM Atleta_Equipe WHERE id_atleta_equipe > 0;
DELETE FROM Atleta WHERE id_atleta > 0;
DELETE FROM Equipe_Campeonato WHERE id_equipe_campeonato > 0;
DELETE FROM Equipe WHERE id_equipe > 0;
DELETE FROM Campeonato_Temporada WHERE id_campeonato_temporada > 0;
DELETE FROM Temporada WHERE id_temporada > 0;
DELETE FROM Campeonato WHERE id_campeonato > 0;
DELETE FROM Genero WHERE id_genero > 0;
DELETE FROM Categoria WHERE id_categoria > 0;
DELETE FROM Modalidade WHERE id_modalidade > 0;

INSERT INTO Modalidade (id_modalidade, nome, tipo_resultado, descricao, ativo) VALUES
(1, 'Futebol', 'Gols', 'Campeonato de futebol de campo', TRUE),
(2, 'Basquete', 'Pontos', 'Campeonato de basquete', TRUE),
(3, 'Volei', 'Sets', 'Campeonato de volei', TRUE);

INSERT INTO Categoria (id_categoria, nome, idade_minima, idade_maxima, descricao, ativo) VALUES
(1, 'Adulto', 18, NULL, 'Categoria adulta', TRUE),
(2, 'Sub-20', 16, 20, 'Categoria para atletas ate 20 anos', TRUE);

INSERT INTO Genero (id_genero, sigla, nome, descricao, ativo) VALUES
(1, 'M', 'Masculino', 'Competicao masculina', TRUE),
(2, 'F', 'Feminino', 'Competicao feminina', TRUE),
(3, 'X', 'Misto', 'Competicao mista', TRUE);

INSERT INTO Campeonato (id_campeonato, id_modalidade, id_categoria, id_genero, nome, formato, situacao, descricao) VALUES
(1, 1, 1, 1, 'Copa Metropolitana de Futebol', 'Pontos corridos', 'Ativo', 'Campeonato adulto masculino de futebol'),
(2, 2, 1, 1, 'Liga Regional de Basquete', 'Pontos corridos', 'Ativo', 'Campeonato adulto masculino de basquete'),
(3, 3, 1, 2, 'Circuito Estadual de Volei', 'Mata-mata', 'Finalizado', 'Campeonato adulto feminino de volei'),
(4, 1, 2, 1, 'Copa Sub-20 de Futebol', 'Pontos corridos', 'Ativo', 'Campeonato masculino sub-20 de futebol');

INSERT INTO Temporada (id_temporada, ano, nome, data_inicio, data_fim, situacao) VALUES
(1, 2025, 'Temporada 2025', '2025-01-01', '2025-12-31', 'Finalizada'),
(2, 2026, 'Temporada 2026', '2026-01-01', '2026-12-31', 'Ativa');

INSERT INTO Campeonato_Temporada (id_campeonato_temporada, id_campeonato, id_temporada, nome_edicao, data_inicio, data_fim, situacao) VALUES
(1, 1, 2, 'Copa Metropolitana de Futebol 2026', '2026-03-01', '2026-07-30', 'Ativo'),
(2, 2, 2, 'Liga Regional de Basquete 2026', '2026-02-15', '2026-08-20', 'Ativo'),
(3, 3, 1, 'Circuito Estadual de Volei 2025', '2025-05-01', '2025-09-15', 'Finalizado'),
(4, 4, 2, 'Copa Sub-20 de Futebol 2026', '2026-04-01', '2026-10-10', 'Ativo');

INSERT INTO Equipe (id_equipe, nome, cidade, estado, pais, data_fundacao, ativo) VALUES
(1, 'Tigres FC', 'Sao Paulo', 'SP', 'Brasil', '1995-05-10', TRUE),
(2, 'Leoes FC', 'Campinas', 'SP', 'Brasil', '1988-08-20', TRUE),
(3, 'Aguias FC', 'Santos', 'SP', 'Brasil', '2001-03-15', TRUE),
(4, 'Tubaroes BC', 'Sao Paulo', 'SP', 'Brasil', '1999-11-02', TRUE),
(5, 'Falcoes BC', 'Sorocaba', 'SP', 'Brasil', '2003-06-25', TRUE),
(6, 'Orbitas BC', 'Jundiai', 'SP', 'Brasil', '2010-09-12', TRUE),
(7, 'Panteras VC', 'Osasco', 'SP', 'Brasil', '1992-02-18', TRUE),
(8, 'Estrelas VC', 'Sao Caetano', 'SP', 'Brasil', '1998-12-01', TRUE),
(9, 'Relampagos Sub20', 'Guarulhos', 'SP', 'Brasil', '2015-01-30', TRUE),
(10, 'Atletico Jovem', 'Sao Bernardo', 'SP', 'Brasil', '2012-07-21', TRUE);

INSERT INTO Equipe_Campeonato (id_equipe_campeonato, id_equipe, id_campeonato_temporada, grupo, numero_inscricao, data_inscricao, situacao) VALUES
(1, 1, 1, 'A', 1, '2026-02-01', 'Ativa'),
(2, 2, 1, 'A', 2, '2026-02-01', 'Ativa'),
(3, 3, 1, 'A', 3, '2026-02-02', 'Ativa'),
(4, 4, 2, 'A', 1, '2026-01-20', 'Ativa'),
(5, 5, 2, 'A', 2, '2026-01-20', 'Ativa'),
(6, 6, 2, 'A', 3, '2026-01-21', 'Ativa'),
(7, 7, 3, 'Final', 1, '2025-04-10', 'Ativa'),
(8, 8, 3, 'Final', 2, '2025-04-11', 'Ativa'),
(9, 9, 4, 'A', 1, '2026-03-10', 'Ativa'),
(10, 10, 4, 'A', 2, '2026-03-11', 'Ativa');

INSERT INTO Atleta (id_atleta, id_genero, nome, data_nascimento, nacionalidade, documento, ativo) VALUES
(1, 1, 'Carlos Silva', '1998-04-10', 'Brasil', 'ATL0001', TRUE),
(2, 1, 'Bruno Costa', '1997-09-21', 'Brasil', 'ATL0002', TRUE),
(3, 1, 'Rafael Souza', '1996-03-30', 'Brasil', 'ATL0003', TRUE),
(4, 1, 'Marcos Rocha', '1999-07-14', 'Brasil', 'ATL0004', TRUE),
(5, 1, 'Felipe Alves', '2000-02-19', 'Brasil', 'ATL0005', TRUE),
(6, 1, 'Andre Reis', '1996-06-18', 'Brasil', 'ATL0006', TRUE),
(7, 1, 'Renato Melo', '1997-11-09', 'Brasil', 'ATL0007', TRUE),
(8, 1, 'Thiago Pires', '1995-05-22', 'Brasil', 'ATL0008', TRUE),
(9, 1, 'Victor Santos', '1994-08-17', 'Brasil', 'ATL0009', TRUE),
(10, 1, 'Otavio Lima', '1999-04-25', 'Brasil', 'ATL0010', TRUE),
(11, 1, 'Igor Matos', '1998-01-12', 'Brasil', 'ATL0011', TRUE),
(12, 2, 'Ana Ribeiro', '1997-07-07', 'Brasil', 'ATL0012', TRUE),
(13, 2, 'Bianca Torres', '1996-09-03', 'Brasil', 'ATL0013', TRUE),
(14, 2, 'Carla Mendes', '1998-02-28', 'Brasil', 'ATL0014', TRUE),
(15, 2, 'Daniela Lopes', '1995-12-16', 'Brasil', 'ATL0015', TRUE),
(16, 1, 'Joao Pedro', '2007-01-14', 'Brasil', 'ATL0016', TRUE),
(17, 1, 'Mateus Freitas', '2006-05-05', 'Brasil', 'ATL0017', TRUE),
(18, 1, 'Gabriel Moreira', '2007-03-27', 'Brasil', 'ATL0018', TRUE),
(19, 1, 'Henrique Dias', '2006-08-08', 'Brasil', 'ATL0019', TRUE);

INSERT INTO Atleta_Equipe (id_atleta_equipe, id_atleta, id_equipe, numero_camisa, posicao, data_inicio, data_fim, ativo) VALUES
(1, 1, 1, 9, 'Atacante', '2025-01-10', NULL, TRUE),
(2, 2, 1, 10, 'Meia', '2025-01-10', NULL, TRUE),
(3, 3, 2, 11, 'Atacante', '2025-01-10', NULL, TRUE),
(4, 4, 2, 7, 'Ponta', '2025-01-10', NULL, TRUE),
(5, 5, 3, 9, 'Atacante', '2025-01-10', NULL, TRUE),
(6, 6, 4, 12, 'Armador', '2025-01-10', NULL, TRUE),
(7, 7, 4, 22, 'Ala', '2025-01-10', NULL, TRUE),
(8, 8, 5, 6, 'Armador', '2025-01-10', NULL, TRUE),
(9, 9, 5, 14, 'Pivo', '2025-01-10', NULL, TRUE),
(10, 10, 6, 8, 'Ala', '2025-01-10', NULL, TRUE),
(11, 11, 6, 33, 'Pivo', '2025-01-10', NULL, TRUE),
(12, 12, 7, 4, 'Ponteira', '2025-01-10', NULL, TRUE),
(13, 13, 7, 7, 'Levantadora', '2025-01-10', NULL, TRUE),
(14, 14, 8, 9, 'Oposta', '2025-01-10', NULL, TRUE),
(15, 15, 8, 11, 'Central', '2025-01-10', NULL, TRUE),
(16, 16, 9, 9, 'Atacante', '2026-01-05', NULL, TRUE),
(17, 17, 9, 10, 'Meia', '2026-01-05', NULL, TRUE),
(18, 18, 10, 11, 'Atacante', '2026-01-05', NULL, TRUE),
(19, 19, 10, 6, 'Volante', '2026-01-05', NULL, TRUE);

INSERT INTO Partida (id_partida, id_campeonato_temporada, id_equipe_mandante, id_equipe_visitante, data_hora, local_partida, cidade, estado, fase, rodada, situacao, publico_presente, observacoes) VALUES
(1, 1, 1, 2, '2026-03-10 19:30:00', 'Estadio Municipal Norte', 'Sao Paulo', 'SP', 'Classificatoria', 1, 'Finalizada', 12000, 'Tigres venceu em casa'),
(2, 1, 3, 1, '2026-03-17 20:00:00', 'Arena Litoral', 'Santos', 'SP', 'Classificatoria', 2, 'Finalizada', 9800, 'Tigres venceu fora de casa'),
(3, 1, 2, 3, '2026-03-24 19:00:00', 'Estadio do Interior', 'Campinas', 'SP', 'Classificatoria', 3, 'Finalizada', 8700, 'Empate com gols'),
(4, 2, 4, 5, '2026-02-20 18:00:00', 'Ginasio Central', 'Sao Paulo', 'SP', 'Classificatoria', 1, 'Finalizada', 4300, 'Vitoria dos Tubaroes'),
(5, 2, 6, 4, '2026-02-27 18:30:00', 'Ginasio Municipal', 'Jundiai', 'SP', 'Classificatoria', 2, 'Finalizada', 5100, 'Tubaroes venceu fora'),
(6, 2, 5, 6, '2026-03-06 19:00:00', 'Arena Sorocaba', 'Sorocaba', 'SP', 'Classificatoria', 3, 'Finalizada', 3900, 'Falcoes venceu em casa'),
(7, 3, 7, 8, '2025-08-20 17:00:00', 'Ginasio Jose Liberatti', 'Osasco', 'SP', 'Final', 1, 'Finalizada', 2400, 'Panteras venceu'),
(8, 3, 8, 7, '2025-08-27 17:00:00', 'Ginasio Lauro Gomes', 'Sao Caetano', 'SP', 'Final', 2, 'Finalizada', 2600, 'Panteras fechou a serie'),
(9, 4, 9, 10, '2026-04-12 16:00:00', 'Campo Municipal Leste', 'Guarulhos', 'SP', 'Classificatoria', 1, 'Finalizada', 900, 'Empate sub-20'),
(10, 4, 10, 9, '2026-04-19 16:00:00', 'Campo Vila Jovem', 'Sao Bernardo', 'SP', 'Classificatoria', 2, 'Finalizada', 1100, 'Relampagos venceu fora');

INSERT INTO Resultado_Partida (id_resultado, id_partida, pontos_mandante, pontos_visitante, criterio_desempate, observacoes) VALUES
(1, 1, 3, 1, NULL, 'Resultado oficial'),
(2, 2, 0, 2, NULL, 'Resultado oficial'),
(3, 3, 2, 2, NULL, 'Resultado oficial'),
(4, 4, 78, 72, NULL, 'Resultado oficial'),
(5, 5, 88, 91, NULL, 'Resultado oficial'),
(6, 6, 84, 80, NULL, 'Resultado oficial'),
(7, 7, 3, 1, NULL, 'Resultado oficial'),
(8, 8, 2, 3, NULL, 'Resultado oficial'),
(9, 9, 1, 1, NULL, 'Resultado oficial'),
(10, 10, 0, 2, NULL, 'Resultado oficial');

INSERT INTO Evento_Partida (id_evento, id_partida, id_equipe_campeonato, id_atleta, periodo, minuto, segundo, tipo_evento, valor_pontos, descricao) VALUES
(1, 1, 1, 1, 1, 12, 20, 'Gol', 1, 'Gol de Carlos Silva'),
(2, 1, 1, 2, 1, 31, 10, 'Gol', 1, 'Gol de Bruno Costa'),
(3, 1, 2, 3, 2, 50, 40, 'Gol', 1, 'Gol de Rafael Souza'),
(4, 1, 1, 1, 2, 74, 5, 'Gol', 1, 'Gol de Carlos Silva'),
(5, 1, 1, 2, 2, 81, 0, 'Penalidade', 0, 'Falta dura'),
(6, 2, 1, 1, 1, 22, 0, 'Gol', 1, 'Gol fora de casa'),
(7, 2, 1, 2, 2, 63, 35, 'Gol', 1, 'Gol de contra-ataque'),
(8, 2, 3, 5, 1, 40, 0, 'Penalidade', 0, 'Reclamacao'),
(9, 3, 2, 3, 1, 9, 15, 'Gol', 1, 'Gol de Rafael Souza'),
(10, 3, 3, 5, 1, 27, 45, 'Gol', 1, 'Gol de Felipe Alves'),
(11, 3, 2, 4, 2, 56, 10, 'Gol', 1, 'Gol de Marcos Rocha'),
(12, 3, 3, 5, 2, 70, 30, 'Gol', 1, 'Gol de Felipe Alves'),
(13, 3, 2, 4, 2, 79, 0, 'Penalidade', 0, 'Entrada perigosa'),
(14, 4, 4, 6, 1, 10, 0, 'Ponto', 30, 'Andre Reis pontuou'),
(15, 4, 4, 7, 2, 20, 0, 'Ponto', 24, 'Renato Melo pontuou'),
(16, 4, 5, 8, 3, 30, 0, 'Ponto', 27, 'Thiago Pires pontuou'),
(17, 4, 5, 9, 4, 39, 0, 'Ponto', 22, 'Victor Santos pontuou'),
(18, 4, 5, 9, 4, 40, 0, 'Penalidade', 0, 'Falta tecnica'),
(19, 5, 6, 10, 1, 11, 0, 'Ponto', 29, 'Otavio Lima pontuou'),
(20, 5, 6, 11, 2, 22, 0, 'Ponto', 21, 'Igor Matos pontuou'),
(21, 5, 4, 6, 3, 33, 0, 'Ponto', 34, 'Andre Reis decidiu'),
(22, 5, 4, 7, 4, 39, 0, 'Ponto', 25, 'Renato Melo pontuou'),
(23, 6, 5, 8, 1, 8, 0, 'Ponto', 32, 'Thiago Pires pontuou'),
(24, 6, 5, 9, 2, 19, 0, 'Ponto', 20, 'Victor Santos pontuou'),
(25, 6, 6, 10, 3, 28, 0, 'Ponto', 31, 'Otavio Lima pontuou'),
(26, 6, 6, 11, 4, 38, 0, 'Ponto', 18, 'Igor Matos pontuou'),
(27, 6, 5, 9, 4, 39, 30, 'Penalidade', 0, 'Falta antidesportiva'),
(28, 7, 7, 12, 1, 5, 0, 'Ponto', 18, 'Ana Ribeiro pontuou'),
(29, 7, 7, 13, 2, 12, 0, 'Ponto', 12, 'Bianca Torres pontuou'),
(30, 7, 8, 14, 3, 20, 0, 'Ponto', 16, 'Carla Mendes pontuou'),
(31, 8, 8, 14, 1, 6, 0, 'Ponto', 20, 'Carla Mendes pontuou'),
(32, 8, 8, 15, 2, 18, 0, 'Ponto', 14, 'Daniela Lopes pontuou'),
(33, 8, 7, 12, 3, 25, 0, 'Ponto', 22, 'Ana Ribeiro pontuou'),
(34, 9, 9, 16, 1, 33, 0, 'Gol', 1, 'Gol de Joao Pedro'),
(35, 9, 10, 18, 2, 61, 0, 'Gol', 1, 'Gol de Gabriel Moreira'),
(36, 9, 10, 19, 2, 75, 0, 'Penalidade', 0, 'Falta tatica'),
(37, 10, 9, 16, 1, 18, 0, 'Gol', 1, 'Gol de Joao Pedro'),
(38, 10, 9, 17, 2, 66, 0, 'Gol', 1, 'Gol de Mateus Freitas'),
(39, 10, 10, 19, 2, 82, 0, 'Penalidade', 0, 'Segunda penalidade'),
(40, 10, 9, 17, 2, 88, 0, 'Penalidade', 0, 'Falta de jogo');

INSERT INTO Arbitro (id_arbitro, nome, documento, federacao, nivel, ativo) VALUES
(1, 'Roberto Almeida', 'ARB0001', 'FPF', 'Estadual', TRUE),
(2, 'Sergio Martins', 'ARB0002', 'FPF', 'Estadual', TRUE),
(3, 'Nelson Pereira', 'ARB0003', 'CBB', 'Nacional', TRUE),
(4, 'Patricia Lima', 'ARB0004', 'FPV', 'Nacional', TRUE),
(5, 'Fernanda Castro', 'ARB0005', 'FPV', 'Internacional', TRUE);

INSERT INTO Arbitro_Partida (id_arbitro_partida, id_arbitro, id_partida, funcao, escala_confirmada, observacoes) VALUES
(1, 1, 1, 'Principal', TRUE, NULL),
(2, 2, 1, 'Auxiliar', TRUE, NULL),
(3, 1, 2, 'Principal', TRUE, NULL),
(4, 2, 3, 'Principal', TRUE, NULL),
(5, 3, 4, 'Principal', TRUE, NULL),
(6, 3, 5, 'Principal', TRUE, NULL),
(7, 2, 5, 'Mesario', TRUE, NULL),
(8, 3, 6, 'Principal', TRUE, NULL),
(9, 4, 7, 'Principal', TRUE, NULL),
(10, 5, 7, 'Auxiliar', TRUE, NULL),
(11, 5, 8, 'Principal', TRUE, NULL),
(12, 4, 8, 'Auxiliar', TRUE, NULL),
(13, 1, 9, 'Principal', TRUE, NULL),
(14, 2, 9, 'Auxiliar', TRUE, NULL),
(15, 1, 10, 'Principal', TRUE, NULL);
