import 'package:banco/helpers/database_helper.dart';
import 'package:banco/models/Tarefa.dart';
import 'package:flutter/material.dart';
import '../../helpers/RouteNames.dart';

class ListTarefaPage extends StatefulWidget {
  const ListTarefaPage({super.key});

  @override
  State<ListTarefaPage> createState() => _ListTarefaPageState();
}

class _ListTarefaPageState extends State<ListTarefaPage> {

  List<Tarefa> tarefa = [];
  DatabaseHelper db = DatabaseHelper();
  List<int> colorCodes = [50, 100];

  @override
  void initState() {
    super.initState();
      db.getAllTarefas().then((lista) {
        setState(() {
          tarefa = lista;
        });
      });
    }

  Widget _listaTarefas2(int index){
    return InkWell(
      child:Container(
        height: 100,
        color: Colors.green[colorCodes[index % colorCodes.length]],
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                tarefa[index].descricao,
                style: const TextStyle(fontSize: 50),
              ),
            ),
            IconButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed (RouteNames.rotaAddTarefaPage, arguments:tarefa[index] );
              },
              tooltip: "Editar Tarefa",
              icon: const Icon(Icons.edit),
            ),
            Container(
              width: 10,
            ),
            IconButton(
              onPressed: (){
                tarefa[index].delete();
              },
              tooltip: "Deletar Tarefa",
              icon: const Icon(Icons.delete),
            ),
            Container(
              width: 10,
            ),
          ]
        ),
      ),  
    );
  }

  Widget _bodyListTarefaPage(){
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: tarefa.length,
      itemBuilder: (context, index){
        return _listaTarefas2(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage );
            },
          );
        }),
        centerTitle: true,
        title:const Text('Lista De Tarefas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: _bodyListTarefaPage(),

      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed (RouteNames.rotaAddTarefaPage, arguments:null );
          }
        ),
    );
  }
}