import 'package:banco/models/tarefa.dart';
import 'package:flutter/material.dart';
import '../../helpers/route_names.dart';
import '../../helpers/database_helper.dart';

class AddTarefaPage extends StatefulWidget {
  const AddTarefaPage({super.key});

  @override
  State<AddTarefaPage> createState() => _AddTarefaPageState();
}
class _AddTarefaPageState extends State<AddTarefaPage> {

  TextEditingController? nomeControler = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  Tarefa tarefaSelecionada = Tarefa();
  String? hinttxt = "";
  SnackBar? snackBar;

  void _snackBarAdd(){
    snackBar = SnackBar(
      content: const Text('Tarefa adicionada.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _snackBarEdit(){
    snackBar = SnackBar(
      content: const Text('Tarefa editado.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {

    final routeSettings = ModalRoute.of(context)?.settings;
    if (routeSettings?.arguments == null){
        tarefaSelecionada = Tarefa();
        hinttxt = "Adicionar Tarefa";
    }
    else {
      tarefaSelecionada = routeSettings?.arguments as Tarefa;
      hinttxt = "Editar Tarefa";
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
        title: Text(nomeControler!.text == "" ? 'Adicionar Tarefa' : nomeControler!.text,
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
              if(hinttxt == "Editar Tarefa"){
                _snackBarEdit();
                ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                tarefaSelecionada.update();
              }
              else{
                _snackBarAdd();
                ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                tarefaSelecionada.insert(); 
              }
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaListTarefaPage);
            }
            else{
               //TODO:retornar um aviso que nao é possivel inserir uma Tarefa vazio
            }
          }
      ),
    );
  }
}
