import 'package:banco/models/Tarefa.dart';
import 'package:flutter/material.dart';

import '../../helpers/RouteNames.dart';
import '../../helpers/database_helper.dart';

class AddTarefaPage extends StatefulWidget {
  const AddTarefaPage({super.key});

  @override
  State<AddTarefaPage> createState() => _AddTarefaPageState();
}

  Widget _bodyAddTarefaPage(){
    return   Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: TextField(
                    controller: nomeControler,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: hinttxt,
                    ),
                    onChanged: (text){
                      tarefaSelecionada.descricao = text;
                    },
                  ),
                ),
              )
            ],
          )
        )
      ],
    );
  }


  TextEditingController? nomeControler = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  Tarefa tarefaSelecionada = Tarefa();
  String? hinttxt = "";

class _AddTarefaPageState extends State<AddTarefaPage> {
  @override
  Widget build(BuildContext context) {

    final routeSettings = ModalRoute.of(context)?.settings;
    if (routeSettings?.arguments == null){
        tarefaSelecionada = Tarefa();
        hinttxt = "Adicionar";
    }
    else {
      tarefaSelecionada = routeSettings?.arguments as Tarefa;
      hinttxt = "Editar";
    }

    nomeControler!.text = tarefaSelecionada.descricao;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
            },
          );
        }),
        
        centerTitle: true,
        title: Text(nomeControler!.text == "" ? 'Adicionar' : nomeControler!.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _bodyAddTarefaPage(),
      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: (){
            

            if(tarefaSelecionada.descricao != ''){
              if(hinttxt == "Editar"){
                tarefaSelecionada.update();
              }
              else{
                tarefaSelecionada.insert(); 
              }
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaAdminOptionsPage);
            }
            else{
               //retornar um aviso que nao é possivel inserir uma Tarefa vazio
            }
          }
      ),
    );
  }
}
