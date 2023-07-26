import 'package:banco/Pages/CustomAppBar.dart';
import 'package:banco/models/Funcionario.dart';
import 'package:flutter/material.dart';

import '../helpers/RouteNames.dart';
import '../helpers/database_helper.dart';
import '../models/Tarefa.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool selected = false;
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  List<int> colorCodes = [200, 250];
  DatabaseHelper db = DatabaseHelper();
  Color? containerColor = Colors.blue;
  String containerIndex = '';

  @override
  void initState() {
    super.initState();
      //db.initialize();

      db.getAllFuncionarios().then((lista) {
        setState(() {
          funcionarios = lista;
        });
      });


      db.getAllTarefas().then((lista) {
        setState(() {
          tarefas = lista;
        });
      });
      
    }


  Widget _listaTarefas(int index){
    return InkWell(
            child:Container(
              height: 100,
              color: containerColor = Colors.amber[colorCodes[index % colorCodes.length]],
              child: Center(
                child: Text(
                  tarefas[index].descricao,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                selected = true;
              }
            );
          },
        );
  }

  Widget _bodyTarefasPage(){
    return ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: tarefas.length,
        itemBuilder: (context, index){
          return _listaTarefas(index);
      },
    );
  }

  Widget _listaFuncionarios(int index){
    return InkWell(
            child:Container(
              height: 100,
              color:(containerIndex == funcionarios[index].nome) ? containerColor : Colors.blue[colorCodes[index % colorCodes.length]] ,
              child: Center(
                child: Text(
                  funcionarios[index].nome,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                selected = !selected;
                if(selected == true){
                  containerIndex = funcionarios[index].nome;
                  containerColor = Colors.grey.shade200;

                }else{
                  containerColor = Colors.blue[colorCodes[index % colorCodes.length]];
                }
              }
            );
          },
        );
  }

  Widget _bodyRegisterPage(){
    return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: funcionarios.length,
          itemBuilder: (context, index){
            return _listaFuncionarios(index);
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    
    final routeSettings = ModalRoute.of(context)?.settings;
    final startStop = routeSettings?.arguments as bool; //recebe o valor da variavel "finalizar" que vem da tela "startPage"(carrega a escolha de iniciar ou finalizar uma tarefa)

    if(startStop == true){
    }else{
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: CustomAppBar.createAppBar(context: context, backRoute:RouteNames.rotaStartPage),
      body: Row(
        children: [
          Expanded(
            child: _bodyRegisterPage(),
          ),
          if (selected == true)
            Expanded(
            child:_bodyTarefasPage(),
            ),
        ],
      ),
    );
  }
}