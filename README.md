# ⚙️ Projeto TesteCervantes – Aplicação Flutter Desktop com SQLite

Este projeto foi desenvolvido como parte do Teste de Desenvolvimento, atendendo aos requisitos de criação de uma aplicação desktop em Flutter (Windows) integrada ao SQLite, com:

- Cadastro de usuários

- Validações diretamente no banco

- Registro automático de operações em log

- CRUD completo (Inserir, Listar, Atualizar, Deletar)

- Interface moderna construída com Flutter

## 🧩 Estrutura do Projeto
## 📁 Banco de Dados (SQLite)

Arquivo Local.db, criado automaticamente pela aplicação ao iniciar.

Contém:

- Tabela cadastro (tabela principal)

- Tabela log_operacoes (tabela de auditoria)

- Triggers automáticas para:

  - INSERT

  - UPDATE

  - DELETE

As validações são feitas diretamente no banco usando CHECK Constraints, garantindo integridade e segurança.

## 📁 Interface Gráfica (Flutter Desktop)

A aplicação possui as seguintes telas:

### 🟦 Home Page

Tela principal contendo:

- Campo Nome

- Campo Número

- Botões:

  - Inserir

  - Listar

  - Atualizar

  - Deletar

### 🟩 ListarPage

- Exibe todos os registros da tabela cadastro

- Permite editar ou excluir diretamente na lista

### 🟧 UpdatePage

- Mostra formulário de edição em um AlertDialog

- Atualiza dados e recarrega lista

### 🟥 DeletePage

- Lista registros e permite deletar com um clique

📁 Código Fonte (Dart / Flutter)

Implementação completa do CRUD utilizando:

- sqflite_common_ffi (SQLite para desktop)

- Validação via CHECK no banco

- Triggers para auditoria

- Widgets:

  - Scaffold

  - ListView

  - AlertDialog

  - TextField

  - SnackBar

Toda operação no banco (insert, update, delete) gera uma entrada na tabela log_operacoes automaticamente.


## 🗄️ Estrutura Detalhada do Banco de Dados
## 📝 Tabela cadastro

Armazena os registros principais.

|Campo |	Tipo	|Descrição|
|------|--------|---------|
|Id	|INTEGER PK	|Identificador único|
|Nome	|TEXT	|Apenas letras, sem números, limitado a 30 caract.|
|Numero	|INTEGER	|Número de telefone (11 dígitos), único|

## 📜 Tabela log_operacoes

Armazena o histórico completo de alterações.

|Campo|	Tipo	|Descrição|
|-----|-------|---------|
|Id	|PK	|ID da operação|
|DataHora	|TEXT	|Data e hora automática|
|TipoOperacao	|TEXT	|INSERT / UPDATE / DELETE|
|IdCadastro	|INTEGER	|Registro afetado|
|NomeAnterior	|TEXT	|Antes (UPDATE/DELETE)|
|NumeroAnterior	|INTEGER	|Antes (UPDATE/DELETE)|
|NomeNovo	|TEXT	|Depois (INSERT/UPDATE)|
|NumeroNovo	|INTEGER	|Depois (INSERT/UPDATE)|

## ⚙️ Trigger & Auditoria Automática

Os triggers garantem que toda alteração realizada na tabela cadastro seja registrada automaticamente na tabela log_operacoes:

- Quem alterou? (IdCadastro)

- O que mudou? (valores antigos e novos)

- Quando mudou? (DataHora)

- O que foi feito? (TipoOperacao)

Isso garante transparência e rastreabilidade.

## 🌐 Fluxo de Execução do App

1️⃣ Usuário insere, lista, atualiza ou deleta um registro

2️⃣ A operação é enviada para o SQLite via Localdb

3️⃣ As triggers registram tudo automaticamente

4️⃣ A interface recarrega os dados com setState()

5️⃣ Mensagens visuais (SnackBar) confirmam cada ação

## 🚀 Tecnologias Utilizadas

- Flutter (Desktop) → Interface gráfica

- Dart → Lógica da aplicação

- sqflite_common_ffi → Banco SQLite integrado ao desktop

- SQLite → Banco de dados local

- Triggers SQL → Auditoria automática

- Constraint CHECK → Validações diretamente no banco

- Material Design → Layout moderno e responsivo
