# Projeto de Banco de Dados: Campeonatos Esportivos

Este projeto cria um banco de dados MySQL simples para controlar campeonatos esportivos.

O objetivo e representar modalidades, categorias, generos, campeonatos, temporadas, equipes, atletas, partidas, resultados, eventos de partidas e arbitros.

## Pasta do projeto

```text
C:\Users\giova\Documents\Faculdade\Banco de Dados\Projeto Campeonatos
```

## Estrutura de pastas

```text
Projeto Campeonatos
  setup_project.bat
  sql
    schema.sql
    queries.sql
  seeds
    seed.sql
  docs
    README.md
  diagrams
    DER.txt
```

## Arquivos principais

`sql/schema.sql`

Cria o banco de dados `competicao_esportiva` e todas as tabelas.

`seeds/seed.sql`

Insere dados de exemplo para testar o banco.

`sql/queries.sql`

Contem consultas para relatorios e analises.

`diagrams/DER.txt`

Mostra o DER em formato de texto.

`setup_project.bat`

Cria automaticamente a estrutura de pastas do projeto no Windows.

## Regras usadas na versao simples

Esta versao foi feita de forma simples, sem:

- `UNSIGNED`
- `DEFAULT CURRENT_TIMESTAMP`
- `ENGINE`
- `DEFAULT CHARSET`
- `COLLATE`
- validacoes extras em restricoes
- `INDEX`
- `TRIGGER`

As tabelas usam apenas:

- Chaves primarias
- Chaves estrangeiras
- Tipos comuns do MySQL
- Nomes de tabelas e colunas em portugues

## Entidades do banco

`Modalidade`

Armazena os esportes, como Futebol, Basquete e Volei.

`Categoria`

Armazena categorias como Adulto e Sub-20.

`Genero`

Armazena classificacoes como Masculino, Feminino e Misto.

`Campeonato`

Representa um campeonato. Cada campeonato pertence a uma modalidade, uma categoria e um genero.

`Temporada`

Representa o ano ou periodo da competicao.

`Campeonato_Temporada`

Liga um campeonato a uma temporada, formando uma edicao especifica do campeonato.

`Equipe`

Armazena os dados das equipes.

`Equipe_Campeonato`

Liga equipes a uma edicao de campeonato.

`Atleta`

Armazena os dados dos atletas.

`Atleta_Equipe`

Liga atletas a equipes.

`Partida`

Armazena os jogos de uma edicao de campeonato.

`Resultado_Partida`

Armazena o resultado de uma partida.

`Evento_Partida`

Armazena eventos como gol, ponto, penalidade e outros acontecimentos.

`Arbitro`

Armazena os dados dos arbitros.

`Arbitro_Partida`

Liga arbitros a partidas.

## Relacionamentos

## Relacionamentos 1:N

Uma `Modalidade` pode ter muitos `Campeonato`.

Uma `Categoria` pode ter muitos `Campeonato`.

Um `Genero` pode ter muitos `Campeonato` e muitos `Atleta`.

Um `Campeonato_Temporada` pode ter muitas `Partida`.

Uma `Partida` pode ter muitos `Evento_Partida`.

Um `Arbitro` pode participar de muitos registros em `Arbitro_Partida`.

## Relacionamentos N:N

`Campeonato` e `Temporada` formam uma relacao N:N por meio da tabela `Campeonato_Temporada`.

`Equipe` e `Campeonato_Temporada` formam uma relacao N:N por meio da tabela `Equipe_Campeonato`.

`Atleta` e `Equipe` formam uma relacao N:N por meio da tabela `Atleta_Equipe`.

`Arbitro` e `Partida` formam uma relacao N:N por meio da tabela `Arbitro_Partida`.

## Relacionamento 1:1

Na regra de negocio, uma `Partida` deve ter um resultado oficial em `Resultado_Partida`.

Nesta versao simples, essa relacao fica representada pela chave estrangeira `id_partida`.

## Como executar no MySQL Workbench

1. Abra o MySQL Workbench.
2. Conecte no seu servidor MySQL.
3. Clique em `File > Open SQL Script`.
4. Abra o arquivo:

```text
C:\Users\giova\Documents\Faculdade\Banco de Dados\Projeto Campeonatos\sql\schema.sql
```

5. Execute o script completo.
6. Abra o arquivo:

```text
C:\Users\giova\Documents\Faculdade\Banco de Dados\Projeto Campeonatos\seeds\seed.sql
```

7. Execute o script completo para inserir os dados.
8. Abra o arquivo:

```text
C:\Users\giova\Documents\Faculdade\Banco de Dados\Projeto Campeonatos\sql\queries.sql
```

9. Execute as consultas para ver os resultados.

## Ordem correta de importacao

```text
1. sql/schema.sql
2. seeds/seed.sql
3. sql/queries.sql
```

Sempre execute primeiro o `schema.sql`, depois o `seed.sql` e por ultimo o `queries.sql`.
