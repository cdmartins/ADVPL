# Cadastro de Tarefas no Protheus

Este projeto é uma rotina personalizada para cadastro e controle de tarefas no Protheus, utilizando ADVPL e o framework MVC da TOTVS.

## 📋 Funcionalidades

- Cadastro de tarefas com 
  Código, Título, Status, Descrição, Data Inicial e Data Final.
- Personalização 
- Validações:
  - Só permite deixar data final em branco se status for "Em andamento"
  - Data final deve ser maior que data inicial
- Relatório em PDF com FWMSPrinter

##  Como rodar

1. Compile os arquivos `.PRW` do diretório `/src` no Protheus.
2. Registre a função `zExer04` no configurador.
3. Crie uma entrada de menu apontando para a função.
4. Acesse o menu no sistema e utilize normalmente.


## 📁 Estrutura

README.md → Visão geral do projeto
/src → Códigos ADVPL (MVC) 
/Relatórios → Relatórios e Saídas



---

Desenvolvido por **Cárita Dias Martins da Silva**.

