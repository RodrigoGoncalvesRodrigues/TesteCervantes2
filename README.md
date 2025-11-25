⚙️Projeto TesteCervantes 2
Este projeto foi desenvolvido como parte do Teste de Desenvolvimento , atendendo aos requisitos de criação de uma aplicação desktop em Windows Forms integrada ao PostgreSQL, com cadastro, validações no banco e registro de operações em log.

🧩 Estrutura do Projeto
📁 Banco de Dados
Container com PostgreSQL 15, rodando na porta 5432, configurado com banco inicial meu_banco, usuário postgres e senha definida no momento da criação.
📁 Gerenciador Web (pgAdmin)
Container com pgAdmin4, acessível via navegador em http://localhost:8080, permitindo administração visual do banco de dados.
📁 Rede Docker
Ambos os containers estão conectados em uma rede Docker dedicada chamada postgres-network, garantindo comunicação segura entre eles.
📁 Interface Gráfica (Windows Forms)
Tela de cadastro desenvolvida em Windows Forms.
Contém campos para Nome (texto) e Telefone/Número (numérico).
Inclui botões com as seguintes funcionalidades:
Salvar → Insere um novo registro.
Atualizar → Atualiza um cadastro existente.
Deletar → Remove um registro.
Listar → Exibe todos os registros cadastrados.
📁 Código Fonte (C#)
Implementação da lógica de conexão com o PostgreSQL.
Configuração dos eventos dos botões para operações de Insert, Update, Delete e Select.
Integração com validações do banco de dados (campos obrigatórios, valores numéricos maiores que zero, unicidade do campo).
📁 Script SQL
Arquivo script.sql com a criação das tabelas:
cadastros (tabela principal com os campos Nome e Numero).
log_operacoes (tabela de auditoria de operações realizadas).
Função e trigger para registrar automaticamente cada operação no log.
🗄️ Estrutura do Banco de Dados
📝 Cadastros A tabela cadastros armazena os registros principais. Campos:

Id: Identificador único do cadastro (SERIAL / PK)

Nome: Nome do cadastro (VARCHAR 100, NOT NULL)

Numero: Número associado ao cadastro (NUMERIC 15, NOT NULL, UNIQUE)

📜 LogOperacoes A tabela log_operacoes armazena todas as alterações realizadas na tabela cadastros. Campos:

Id: Identificador único da operação (SERIAL / PK)

DataHora: Data e hora da operação (TIMESTAMP, default = CURRENT_TIMESTAMP)

TipoOperacao: Tipo da operação realizada (INSERT, UPDATE, DELETE)

IdCadastro: ID do registro da tabela cadastros afetado (INTEGER, FK implícita)

NomeAnterior: Nome antes da alteração (VARCHAR 100, só em UPDATE/DELETE)

NumeroAnterior: Número antes da alteração (NUMERIC 15, só em UPDATE/DELETE)

NomeNovo: Nome após a alteração (VARCHAR 100, só em INSERT/UPDATE)

NumeroNovo: Número após a alteração (NUMERIC 15, só em INSERT/UPDATE)

⚙️ Trigger & Function

A função log_operacoes_function() é chamada automaticamente toda vez que ocorre um INSERT, UPDATE ou DELETE na tabela cadastros.

O trigger trg_log_operacoes aplica a função para cada linha modificada.

Dessa forma, o histórico de operações fica salvo na tabela log_operacoes.

🌐 Fluxo de Configuração
🔹 Passos manuais (via Docker CLI) Etapa Descrição

Etapa	Descrição
Criar Rede	docker network create postgres-network
Subir PostgresSQL	docker run --name meu-postgres --network postgres-network -e POSTGRES_DB=meu_banco -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=sua_senha -p 5432:5432 -d postgres:15
Subir pgAdmin	docker run --name meu-pgadmin --network postgres-network -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin -p 8080:80 -d dpage/pgadmin4
Acessar pgAdmin	http://localhost:8080 (login com admin@admin.com / admin)
Conectar ao banco	Host: meu-postgres · Porta: 5432 · User: postgres · Senha: sua_senha
🚀 Tecnologias do Projeto
PostgreSQL 15 (banco de dados relacional)

pgAdmin4 (interface de administração web)

Docker (containers e rede virtual)

Docker Network (para comunicação segura entre containers)

Windows Forms (C#) → Desenvolvimento da interface gráfica da aplicação desktop.

Triggers e Funções no PostgreSQL → Responsáveis por registrar automaticamente logs das operações (INSERT, UPDATE, DELETE) na tabela log_operacoes.

.NET Framework / C# → Implementação da lógica de negócio, validações e manipulação do banco de dados pela aplicação.
