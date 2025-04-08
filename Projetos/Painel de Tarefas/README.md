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

## 🪟 Demonstração
![image](https://github.com/user-attachments/assets/6121a451-b471-48e9-b190-f7a2eaba7d27)
![image](https://github.com/user-attachments/assets/643613a3-7670-42e4-b297-516bfbeb7def)
![image](https://github.com/user-attachments/assets/093a65be-6644-480c-8ccb-6a978c529236)
![image](https://github.com/user-attachments/assets/8e6a80a5-95de-4e43-9683-70bd56c1d313)
![image](https://github.com/user-attachments/assets/14c6baae-0091-46f8-9af0-a7f57810a5ea)




### Relatórios
![zrel002000001_20250408_10-11-15_page-0001](https://github.com/user-attachments/assets/5c42a245-baaf-4881-bb2c-daa395524281)

![zrel002c000001_20250408_08-48-45_page-0001](https://github.com/user-attachments/assets/395df376-436f-4caa-954e-cf895d1ac602)






---

Desenvolvido por **Cárita Dias Martins da Silva**.

