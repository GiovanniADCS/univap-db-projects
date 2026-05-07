-- ============================================================
-- schema.sql
-- Banco de dados simples para competicoes esportivas
-- MySQL Workbench
-- ============================================================

CREATE DATABASE IF NOT EXISTS competicao_esportiva;

USE competicao_esportiva;

DROP TABLE IF EXISTS Arbitro_Partida;
DROP TABLE IF EXISTS Pontuacoes_Atletas;
DROP TABLE IF EXISTS Evento_Partida;
DROP TABLE IF EXISTS Resultado_Partida;
DROP TABLE IF EXISTS Partida;
DROP TABLE IF EXISTS Atleta_Equipe;
DROP TABLE IF EXISTS Equipe_Campeonato;
DROP TABLE IF EXISTS Atleta;
DROP TABLE IF EXISTS Arbitro;
DROP TABLE IF EXISTS Estadio;
DROP TABLE IF EXISTS Equipe;
DROP TABLE IF EXISTS Campeonato_Temporada;
DROP TABLE IF EXISTS Campeonato;
DROP TABLE IF EXISTS Temporada;
DROP TABLE IF EXISTS Genero;
DROP TABLE IF EXISTS Categoria;
DROP TABLE IF EXISTS Modalidade;

CREATE TABLE Modalidade (
    id_modalidade INT AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    tipo_resultado VARCHAR(30) NOT NULL,
    descricao VARCHAR(255),
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_modalidade)
);

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    idade_minima INT,
    idade_maxima INT,
    descricao VARCHAR(255),
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE Genero (
    id_genero INT AUTO_INCREMENT,
    sigla CHAR(1) NOT NULL,
    nome VARCHAR(40) NOT NULL,
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_genero)
);

CREATE TABLE Temporada (
    id_temporada INT AUTO_INCREMENT,
    ano INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    situacao VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_temporada)
);

CREATE TABLE Campeonato (
    id_campeonato INT AUTO_INCREMENT,
    id_modalidade INT NOT NULL,
    id_categoria INT NOT NULL,
    id_genero INT NOT NULL,
    id_temporada INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    formato VARCHAR(50) NOT NULL,
    situacao VARCHAR(30) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    descricao VARCHAR(255),
    PRIMARY KEY (id_campeonato),
    FOREIGN KEY (id_modalidade) REFERENCES Modalidade (id_modalidade),
    FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
    FOREIGN KEY (id_genero) REFERENCES Genero (id_genero),
    FOREIGN KEY (id_temporada) REFERENCES Temporada (id_temporada)
);

CREATE TABLE Equipe (
    id_equipe INT AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    pais VARCHAR(60) NOT NULL,
    data_fundacao DATE,
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_equipe)
);

CREATE TABLE Equipe_Campeonato (
    id_equipe_campeonato INT AUTO_INCREMENT,
    id_equipe INT NOT NULL,
    id_campeonato INT NOT NULL,
    grupo VARCHAR(20),
    numero_inscricao INT,
    quantidade_atletas INT NOT NULL,
    data_inscricao DATE NOT NULL,
    situacao VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_equipe_campeonato),
    FOREIGN KEY (id_equipe) REFERENCES Equipe (id_equipe),
    FOREIGN KEY (id_campeonato) REFERENCES Campeonato (id_campeonato)
);

CREATE TABLE Atleta (
    id_atleta INT AUTO_INCREMENT,
    id_genero INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    data_nascimento DATE NOT NULL,
    nacionalidade VARCHAR(60) NOT NULL,
    documento VARCHAR(30),
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_atleta),
    FOREIGN KEY (id_genero) REFERENCES Genero (id_genero)
);

CREATE TABLE Atleta_Equipe (
    id_atleta_equipe INT AUTO_INCREMENT,
    id_atleta INT NOT NULL,
    id_equipe_campeonato INT NOT NULL,
    numero_camisa INT,
    posicao VARCHAR(60),
    data_inicio DATE NOT NULL,
    data_fim DATE,
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_atleta_equipe),
    FOREIGN KEY (id_atleta) REFERENCES Atleta (id_atleta),
    FOREIGN KEY (id_equipe_campeonato) REFERENCES Equipe_Campeonato (id_equipe_campeonato)
);

CREATE TABLE Estadio (
    id_estadio INT AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    capacidade INT NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_estadio)
);

CREATE TABLE Partida (
    id_partida INT AUTO_INCREMENT,
    id_campeonato INT NOT NULL,
    id_equipe_mandante INT NOT NULL,
    id_equipe_visitante INT NOT NULL,
    id_estadio INT NOT NULL,
    data_hora DATETIME NOT NULL,
    fase VARCHAR(60) NOT NULL,
    rodada INT,
    situacao VARCHAR(30) NOT NULL,
    publico_presente INT NOT NULL,
    observacoes VARCHAR(255),
    PRIMARY KEY (id_partida),
    FOREIGN KEY (id_campeonato) REFERENCES Campeonato (id_campeonato),
    FOREIGN KEY (id_equipe_mandante) REFERENCES Equipe_Campeonato (id_equipe_campeonato),
    FOREIGN KEY (id_equipe_visitante) REFERENCES Equipe_Campeonato (id_equipe_campeonato),
    FOREIGN KEY (id_estadio) REFERENCES Estadio (id_estadio)
);

CREATE TABLE Resultado_Partida (
    id_resultado INT AUTO_INCREMENT,
    id_partida INT NOT NULL,
    pontos_mandante INT NOT NULL,
    pontos_visitante INT NOT NULL,
    criterio_desempate VARCHAR(120),
    observacoes VARCHAR(255),
    PRIMARY KEY (id_resultado),
    FOREIGN KEY (id_partida) REFERENCES Partida (id_partida)
);

CREATE TABLE Pontuacoes_Atletas (
    id_pontuacao INT AUTO_INCREMENT,
    id_partida INT NOT NULL,
    id_atleta_equipe INT NOT NULL,
    tipo_pontuacao VARCHAR(40) NOT NULL,
    pontos INT NOT NULL,
    minuto INT,
    observacoes VARCHAR(255),
    PRIMARY KEY (id_pontuacao),
    FOREIGN KEY (id_partida) REFERENCES Partida (id_partida),
    FOREIGN KEY (id_atleta_equipe) REFERENCES Atleta_Equipe (id_atleta_equipe)
);

CREATE TABLE Evento_Partida (
    id_evento INT AUTO_INCREMENT,
    id_partida INT NOT NULL,
    id_atleta_equipe INT NOT NULL,
    periodo INT,
    minuto INT,
    segundo INT,
    tipo_evento VARCHAR(40) NOT NULL,
    valor_pontos INT NOT NULL,
    descricao VARCHAR(255),
    PRIMARY KEY (id_evento),
    FOREIGN KEY (id_partida) REFERENCES Partida (id_partida),
    FOREIGN KEY (id_atleta_equipe) REFERENCES Atleta_Equipe (id_atleta_equipe)
);

CREATE TABLE Arbitro (
    id_arbitro INT AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    documento VARCHAR(30),
    federacao VARCHAR(80),
    federado BOOLEAN NOT NULL,
    nivel VARCHAR(30) NOT NULL,
    ativo BOOLEAN NOT NULL,
    PRIMARY KEY (id_arbitro)
);

CREATE TABLE Arbitro_Partida (
    id_arbitro_partida INT AUTO_INCREMENT,
    id_arbitro INT NOT NULL,
    id_partida INT NOT NULL,
    funcao VARCHAR(40) NOT NULL,
    escala_confirmada BOOLEAN NOT NULL,
    observacoes VARCHAR(255),
    PRIMARY KEY (id_arbitro_partida),
    FOREIGN KEY (id_arbitro) REFERENCES Arbitro (id_arbitro),
    FOREIGN KEY (id_partida) REFERENCES Partida (id_partida)
);
