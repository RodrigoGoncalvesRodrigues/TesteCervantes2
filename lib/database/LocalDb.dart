import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
Database? _database;
class Localdb {
  Future get database async {
    _database = await _initializeDB('Local.db');
    return _database;
  }

Future _initializeDB(String filepath)async{
  final dbpath = await getDatabasesPath();
  final path = join(dbpath,filepath);
  return await openDatabase(path,version: 1, onCreate: _createDB);
}

Future _createDB(Database db,int version)async{
  await db.execute(
    '''
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
''');
await db.execute(
  '''
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
''');
await db.execute(
  '''
CREATE TRIGGER trg_cadastro_insert
AFTER INSERT ON cadastro
FOR EACH ROW
BEGIN
	INSERT INTO log_operacoes(TipoOperacao,IdCadastro,NomeNovo,NumeroNovo)
	VALUES('INSERT', NEW.Id,NEW.Nome,NEW.Numero);
END;
''');
await db.execute(
  '''
CREATE TRIGGER trg_cadastro_update
AFTER UPDATE ON cadastro
FOR EACH ROW
BEGIN
	INSERT INTO log_operacoes(TipoOperacao,IdCadastro,NomeAntigo,NumeroAnterior,NomeNovo,NumeroNovo)
	VALUES('UPDATE', OLD.Id,OLD.Nome,OLD.Numero, NEW.Nome,NEW.Numero);
END;
''');
await db.execute(
  '''
CREATE TRIGGER trg_cadastro_delete
AFTER DELETE ON cadastro
FOR EACH ROW
BEGIN
	INSERT INTO log_operacoes(TipoOperacao,IdCadastro,NomeAntigo,NumeroAnterior)
	VALUES('DELETE',OLD.ID,OLD.Nome,OLD.Numero);
END;
''');

}

Future insertCadastro(String nome, int numero)async{
  final db = await database;
  await db.insert(
    "cadastro",
    {"Nome": nome , "Numero": numero},

  );
  

}

Future<List<Map<String,dynamic>>> listarCadastros() async {
  final db = await database;
  return await db.query("cadastro");
}

Future AtualizarCadastro(int id,String nome, int numero) async{
  final db = await database;

  await db.update(
    "cadastro",
    {"Nome": nome , "Numero": numero},
    where: "Id = ?",
    whereArgs: [id],
  );
}

Future deletarCadastro(int id) async {
  final db = await database;

  await db.delete(
    "cadastro",
    where: "Id = ?",
    whereArgs: [id],
  );
}

}

