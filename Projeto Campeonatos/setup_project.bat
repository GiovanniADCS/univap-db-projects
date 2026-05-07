@echo off
setlocal

set "PASTA_PROJETO=C:\Users\giova\Documents\Faculdade\Banco de Dados\Projeto Campeonatos"

echo.
echo Criando projeto de banco de dados para campeonatos esportivos...
echo Pasta: "%PASTA_PROJETO%"
echo.

if not exist "%PASTA_PROJETO%" mkdir "%PASTA_PROJETO%"
if not exist "%PASTA_PROJETO%\sql" mkdir "%PASTA_PROJETO%\sql"
if not exist "%PASTA_PROJETO%\docs" mkdir "%PASTA_PROJETO%\docs"
if not exist "%PASTA_PROJETO%\diagrams" mkdir "%PASTA_PROJETO%\diagrams"
if not exist "%PASTA_PROJETO%\seeds" mkdir "%PASTA_PROJETO%\seeds"

if not exist "%PASTA_PROJETO%\sql\schema.sql" type nul > "%PASTA_PROJETO%\sql\schema.sql"
if not exist "%PASTA_PROJETO%\sql\queries.sql" type nul > "%PASTA_PROJETO%\sql\queries.sql"
if not exist "%PASTA_PROJETO%\docs\README.md" type nul > "%PASTA_PROJETO%\docs\README.md"
if not exist "%PASTA_PROJETO%\diagrams\DER.txt" type nul > "%PASTA_PROJETO%\diagrams\DER.txt"
if not exist "%PASTA_PROJETO%\seeds\seed.sql" type nul > "%PASTA_PROJETO%\seeds\seed.sql"

echo Estrutura criada com sucesso.
echo.
tree "%PASTA_PROJETO%" /F
echo.
echo Ordem para importar no MySQL Workbench:
echo 1. sql\schema.sql
echo 2. seeds\seed.sql
echo 3. sql\queries.sql
echo.

pause
endlocal
