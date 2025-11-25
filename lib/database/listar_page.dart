import 'package:flutter/material.dart';
import 'localdb.dart';

class ListarPage extends StatefulWidget {
  @override
  State<ListarPage> createState() => _ListarPageState();
}

class _ListarPageState extends State<ListarPage> {
  List<Map<String, dynamic>> registros = [];
  final Localdb db = Localdb();

  @override
  void initState() {
    super.initState();
    carregarRegistros();
  }

  Future carregarRegistros() async {
    registros = await db.listarCadastros();
    setState(() {});
  }

  Future editarRegistro(Map item) async {
    TextEditingController nomeCtrl =
        TextEditingController(text: item['Nome']);
    TextEditingController numeroCtrl =
        TextEditingController(text: item['Numero'].toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Cadastro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeCtrl,
                decoration: InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: numeroCtrl,
                decoration: InputDecoration(labelText: "Número"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () async {
                await db.AtualizarCadastro(
                  item['Id'],
                  nomeCtrl.text,
                  int.parse(numeroCtrl.text),
                );
                Navigator.of(context).pop();
                carregarRegistros();
              },
            ),
          ],
        );
      },
    );
  }

  Future deletarRegistro(int id) async {
    await db.deletarCadastro(id);
    carregarRegistros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Cadastros"),
        centerTitle: true,
      ),

      body: registros.isEmpty
          ? Center(
              child: Text(
                "Nenhum registro encontrado",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final item = registros[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("Nome: ${item['Nome']}"),
                    subtitle: Text("Número: ${item['Numero']}"),
                    leading: Text("ID: ${item['Id']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editarRegistro(item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletarRegistro(item['Id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
