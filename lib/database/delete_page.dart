import 'package:flutter/material.dart';
import 'package:projeto_cervantes2/database/LocalDb.dart';

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  List<Map<String, dynamic>> cadastros = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future carregarDados() async {
    final dados = await Localdb().listarCadastros();
    setState(() {
      cadastros = dados;
    });
  }

  Future deletar(int id) async {
    await Localdb().deletarCadastro(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registro deletado!")),
    );

    await carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deletar Registro"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: cadastros.length,
        itemBuilder: (context, index) {
          final item = cadastros[index];

          return ListTile(
            title: Text(item['Nome']),
            subtitle: Text("Número: ${item['Numero']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deletar(item['Id']);
              },
            ),
          );
        },
      ),
    );
  }
}
