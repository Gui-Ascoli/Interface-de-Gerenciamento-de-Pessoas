import 'package:banco/models/Categoria.dart';
import 'package:flutter/material.dart';

import '../../helpers/database_helper.dart';

class AddTarefaPage extends StatefulWidget {
  const AddTarefaPage({super.key});

  @override
  State<AddTarefaPage> createState() => _AddTarefaPageState();
}

class _AddTarefaPageState extends State<AddTarefaPage> {
  DatabaseHelper db = DatabaseHelper();

  Future<DropdownButton<Categoria>> _bodyAddTarefaPage() async {
    var listaCategorias = await db.getAllCategorias();

    return DropdownButton<Categoria>(
      value: listaCategorias.first,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Categoria? value) {
        // This is called when the user selects an item.
        setState(() {
          listaCategorias.first = value!;
        });
      },
      items: listaCategorias.map<DropdownMenuItem<Categoria>>((Categoria value) {
        return DropdownMenuItem<Categoria>(
          value: value,
          child: Text(value.descricao),
        );
      }).toList(),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text("Adicionar Tarefa")
        ),
        body: FutureBuilder<DropdownButton<Categoria>>(
              future: _bodyAddTarefaPage(),
              builder: (context, snapshot) 
              {
                if (snapshot.connectionState == ConnectionState.done)
                {
                  return snapshot.data!;
                }else{
                  return Scaffold();
                }
              },
            ),
        floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed ('/AddFuncionariosPage', arguments:null );
          }
        ),
    );
  }
}