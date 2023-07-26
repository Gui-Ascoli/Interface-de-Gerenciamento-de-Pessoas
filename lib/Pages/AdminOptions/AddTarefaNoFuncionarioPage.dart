import 'package:banco/models/TarefaDoFuncionario.dart';
import 'package:flutter/material.dart';

import '../../helpers/database_helper.dart';
import '../../models/Funcionario.dart';
import '../../models/Tarefa.dart';

class AddTarefaNoFuncionarioPage extends StatefulWidget {
  const AddTarefaNoFuncionarioPage({super.key});

  @override
  State<AddTarefaNoFuncionarioPage> createState() => _AddTarefaNoFuncionarioPageState();
}

class _AddTarefaNoFuncionarioPageState extends State<AddTarefaNoFuncionarioPage> {
 
  bool selected = false;
  
  TarefaDoFuncionario tarefaFuncionario = TarefaDoFuncionario();
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

/*
      db.getAllTarefas().then((lista) {
        setState(() {
          tarefas = lista;
        });
      });
      */
    }


  Widget _listaTarefas(int index){
    return InkWell(
            child:Container(
              height: 100,
              color: Colors.green[colorCodes[index % colorCodes.length]],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      tarefas[index].tarefa,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
 
                  
                  Container(
                    width: 10,
                  ),
                  Switch( 
                    value: false,
                    onChanged: (value){
                      setState(() {
                        value = !value;
                        if(value == true){
                          tarefaFuncionario.id_tarefa = tarefas[index].id;
                          tarefaFuncionario.insert();
                        }else{
                          tarefaFuncionario.delete();
                        }
                        
                      });
                    },
                  ),
                  Container(
                    width: 10,
                  ),
                ]
              ),
            ),
 
            
        );
  }

  Widget _BodyTarefasPage(){
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
                  tarefaFuncionario.id_funcionario = funcionarios[index].id;

                }else{
                  containerColor = Colors.blue[colorCodes[index % colorCodes.length]];
                }
              }
            );
          },
        );
  }

  Widget _BodyRegisterPage(){
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
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Axtor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          Expanded(
            child: _BodyRegisterPage(),
          ),
          if (selected == true)
            Expanded(
            child:_BodyRegisterPage(),
            ),
        ],
      ),
    );
  }
}