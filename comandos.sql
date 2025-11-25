## Tabela Cadastro

```
CREATE TABLE cadastro(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,

    Nome TEXT NOT NULL
        CHECK (
            Nome NOT GLOB '*[0-9]*' AND
            Nome NOT GLOB '*[^A-Za-zÀ-ÖØ-öø-ÿ ]*' AND
            Nome NOT GLOB ' *' AND
            Nome NOT GLOB '* ' AND
            Nome NOT LIKE '%  %' AND
            length(Nome) <= 30 AND
            length(trim(Nome)) > 0
        ),

    Numero INTEGER NOT NULL UNIQUE
        CHECK (
            typeof(Numero) = 'integer' AND
            Numero >= 10000000000 AND
            Numero <= 99999999999
        )
);

```

## Tabela log_operacoes

```
CREATE TABLE log_operacoes(
Id INTEGER PRIMARY KEY AUTOINCREMENT,
DataHora TEXT DEFAULT(datetime('now')),
TipoOperacao  TEXT NOT NULL,
IdCadastro INTEGER,
NomeAntigo  TEXT,
NumeroAnterior INTEGER,
NomeNovo TEXT,
NumeroNovo INTEGER
);
```

## Triggers

```
CREATE TRIGGER trg_cadastro_insert
AFTER INSERT ON cadastro
FOR EACH ROW
BEGIN
	INSERT INTO log_operacoes(TipoOperacao,IdCadastro,NomeNovo,NumeroNovo)
	VALUES('INSERT', NEW.Id,NEW.Nome,NEW.Numero);
END;

CREATE TRIGGER trg_cadastro_update
AFTER UPDATE ON cadastro
FOR EACH ROW
BEGIN
	INSERT INTO log_operacoes(TipoOperacao,IdCadastro,NomeAntigo,NumeroAnterior,NomeNovo,NumeroNovo)
	VALUES('UPDATE', OLD.Id,OLD.Nome,OLD.Numero, NEW.Nome,NEW.Numero);
END;

CREATE TRIGGER trg_cadastro_delete
AFTER DELETE ON cadastro
FOR EACH ROW
BEGIN
	INSERT INTO log_operacoes(TipoOperacao,IdCadastro,NomeAntigo,NumeroAnterior)
	VALUES('DELETE',OLD.ID,OLD.Nome,OLD.Numero);
END;
	
```