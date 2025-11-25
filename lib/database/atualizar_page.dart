import 'package:flutter/material.dart';
import 'package:projeto_cervantes2/database/LocalDb.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
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

  void abrirFormulario(Map item) {
    final nomeCTRL = TextEditingController(text: item['Nome']);
    final numeroCTRL = TextEditingController(text: item['Numero'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Atualizar Cadastro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCTRL,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: numeroCTRL,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Número"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Salvar"),
            onPressed: () async {
              final nome = nomeCTRL.text;
              final numero = int.tryParse(numeroCTRL.text);

              await Localdb()
                  .AtualizarCadastro(item['Id'], nome, numero!);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Atualizado com sucesso!")),
              );

              carregarDados();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar Registro"),
        backgroundColor: Colors.blue,
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
            trailing: Icon(Icons.edit, color: Colors.blue),
            onTap: () => abrirFormulario(item),
          );
        },
      ),
    );
  }
}
