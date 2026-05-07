# Projeto de Banco de Dados: Competicoes Esportivas

Este projeto contem um banco de dados MySQL simples, normalizado e coerente para competicoes esportivas multi-modalidade.

O modelo foi refatorado para remover excesso de tabelas e excesso de registros. A tabela antiga de ligacao entre campeonato e temporada foi removida; agora cada registro em `Campeonato` representa uma edicao de um campeonato em uma temporada especifica.

## Arquivos principais

```text
sql/schema.sql
seeds/seed.sql
sql/queries.sql
```

## Tabelas mantidas

- `Modalidade`
- `Categoria`
- `Genero`
- `Temporada`
- `Campeonato`
- `Equipe`
- `Equipe_Campeonato`
- `Atleta`
- `Atleta_Equipe`
- `Estadio`
- `Partida`
- `Resultado_Partida`
- `Evento_Partida`
- `Pontuacoes_Atletas`
- `Arbitro`
- `Arbitro_Partida`

## Modelo simplificado

`Campeonato` possui chave estrangeira direta para:

- `Modalidade`
- `Categoria`
- `Genero`
- `Temporada`

`Equipe_Campeonato` indica quais equipes participam de cada campeonato.

`Atleta_Equipe` liga o atleta a uma equipe inscrita em um campeonato. Isso evita que o mesmo atleta apareca nos dois times de uma mesma partida.

`Partida` liga duas equipes inscritas no mesmo campeonato e um estadio.

`Resultado_Partida` guarda o placar oficial.

`Evento_Partida` guarda eventos gerais, como gols, pontos e penalidades.

`Pontuacoes_Atletas` guarda somente registros de gols e pontos dos atletas, facilitando rankings de artilharia e pontuacao.

`Arbitro_Partida` guarda a escala de arbitragem.

## Quantidades de dados

O `seed.sql` foi mantido enxuto:

```text
Modalidade = 8
Categoria = 8
Genero = 2
Temporada = 20
Campeonato = 28
Equipe = 100
Estadio = 12
Equipe_Campeonato = 96
Atleta = 100
Atleta_Equipe = 96
Partida = 136
Resultado_Partida = 136
Evento_Partida = 476
Pontuacoes_Atletas = 412
Arbitro = 18
Arbitro_Partida = 181
```

## Modalidades

- Futebol
- Futsal
- Basquete
- Rugby
- Voleibol
- Handebol
- Tenis
- Natacao

## Categorias

- Sub-11
- Sub-13
- Sub-15
- Sub-17
- Adulto
- Sub-20
- Universitario
- Master

## Generos

- Masculino
- Feminino

## Como executar no MySQL Workbench

Execute os arquivos nesta ordem:

```text
1. sql/schema.sql
2. seeds/seed.sql
3. sql/queries.sql
```

O arquivo `queries.sql` contem as consultas obrigatorias de `a` ate `j`.
