# Configuração do Projeto de Tarefas no Protheus

Este guia descreve o passo a passo para configurar um projeto de cadastro de tarefas no Protheus, incluindo a criação da tabela, desenvolvimento da tela, menu, validações e relatórios.

## 1. Criação da Tabela no SIGACFG
1. Acesse o SIGACFG.
2. Vá em **Base de Dados > Dicionário > Tabelas**.
3. Crie a tabela `ZE1` (ou outra de sua preferência).
4. Adicione os campos necessários, como:
   - `ZE1_CODIGO` (Identificador)
   - `ZE1_TITULO` (Título)
   - `ZE1_DT` (Data Inicial)
   - `ZE1_DTFINA` (Data Final)
   - `ZE1_OK` (Marcação)
   - `ZE1_STATUS` (Status da Tarefa)
   - `ZE1_DESCRI` (Descrição)
5. Configure os índices, por exemplo:
   - `CODIGO` baseado no campo `ZE1_CODIGO`.
6. Salve e atualize o dicionário.
7. ![image](https://github.com/user-attachments/assets/bb9c46db-1bce-46e8-990f-203929d0a66a)

8. ![image](https://github.com/user-attachments/assets/a2d1a5ff-2f74-46b5-8865-cb47ccd0bf54)

## 2. Criação da Função (Fonte) da Tela de Cadastro
1. Crie um novo arquivo `.PRW` com o código da sua função de cadastro.
   Meu fonte → [`src/zExer04.prw`](src/zExer04.prw)
3. Compile o fonte

## 3. Criação de um Menu para Acesso à Tela
1. Acesse o SIGACFG.
2. Vá em **Ambiente > Cadastro > Menus**.
3. Crie um novo item de menu apontando para a função ADVPL (no meu caso: `zExer04()`).
4. Salve e atualize.
   ![image](https://github.com/user-attachments/assets/e4a3a665-cabf-491a-b546-b89a1d0cb130)

## 4. Populando a Tabela para Testes

1. Acesse o sistema via SmartClient.
2. Vá até o menu criado e utilize a tela de cadastro para inserir tarefas de teste.

## 7. Criação de Relatórios

1. Em arquivos `.PRW` separados, implementei relatórios com `FWMSPrinter`.
Saiba mais em:
   Meus relatórios → [`src/relatorios/`](src/relatorios/)

   
---

© Cárita Dias Martins da Silva – 2025
