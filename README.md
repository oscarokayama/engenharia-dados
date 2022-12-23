# Engenharia Dados
Projeto - Engenharia de Dados

  Objetivo do projeto: desenvolver uma estrutura de dados, que possibilidade a entrega dos dados com maior velocidade e assertividade para a equipe de ciência de dados.
  
  Data: 22/12/2022

## Resumo do projeto

Para facilitar o entendimento do projeto, criei um guia que auxilia o entendimento do projeto.

O guia está disponível em:

![](./imagens/Projeto.png "Pastas")

https://github.com/oscarokayama/engenharia-dados/blob/main/00.%20Documentacao/0.%20Projeto%20-%20Engenharia%20Dados.drawio.pdf

## Estrutura de pastas

![](./imagens/Pastas.png "Pastas")

* 00 . Documentacao (Pasta com a documentação do projeto e arquivos exportados em PDF)
  
  * 0 . Projeto - Engenharia Dados.drawio.pdf (Guia do projeto)
  * 1 . Processo de carga dos dados.pdf (Notebook do processo de carga)
  * 2 . Testes (unitário e integrado).pdf (Notebook com os testes unitários e integrado)
  * 3 . Atividade extra.pdf (Notebook com o export de arquivos csv que será utilizado no powerbi)


* 01 . laboratorio (Pasta com os scripts e arquivos utilizados para o desenvolvimento de um laboratório de dados para geração da massa de dados utilizados no projeto)
  
  * sql (Pasta com scripts DDL (criar tabelas, index, sequences) e DML (inserts e selects) para criação de tabelas e massas de dados para serem  utilizados no projeto
  * nomes.csv (Arquivo csv com nomes gerados aleatoriamente)

* 02 . DDL - Criação do banco Target (Pasta com os scripts SQL para criação de tabelas do banco de target)

  * ddl_target.sql (Script de criação de tabelas do banco de target)

* 03 . notebooks (Pasta com os arquivos Notebooks no formato "ipynb")

  * 1 . Processo de carga dos dados.ipynb (Notebook com o processo de carga documentado)
  * 2 . Teste.ipynb (Notebook com o processo de testes documentado)
  * 3 . Atividade extra.ipynb (Notebook com um script para extração de dados para serem utilizados no powerbi)

* 04 . export (Pasta com os arquivos flat gerados em CSV)

  * movimento_flat_csv.zip (Arquivo solicitado no projeto)
  * associado_comportamento_compras.csv (Arquivo extra utilizado no powerbi)
  * associado_compras_fatura_inad.csv (Arquivo extra utilizado no powerbi)

* 05 . powerbi (Pasta com um arquivo do powerbi de análise exploratória dos dados)

  * Analise dos associados.pbix (Arquivo powerbi com a análise exploratória)

## Sobre o projeto

O projeto foi desenvolvido utilizando Docker para montar o ambiente de desenvolvimento 
