
import 'package:banco/models/TarefaDoFuncionario.dart';
import 'package:flutter/material.dart';

import '../../helpers/RouteNames.dart';
import '../../helpers/database_helper.dart';
import '../../models/Funcionario.dart';
import '../../models/Tarefa.dart';

class AddTarefaNoFuncionarioPage extends StatefulWidget {
  const AddTarefaNoFuncionarioPage({super.key});

  @override
  State<AddTarefaNoFuncionarioPage> createState() => _AddTarefaNoFuncionarioPageState();
}

class _AddTarefaNoFuncionarioPageState extends State<AddTarefaNoFuncionarioPage> {
 
  Color? conColorToBack;
  bool selected = false;
  bool modeSwitch = false;
  int contador = 0;
  List<bool> modeSwitchs = [];
  Funcionario funcionarioSelecionado = Funcionario();
  TarefaDoFuncionario tarefaFuncionario = TarefaDoFuncionario();
  List<TarefaDoFuncionario> tarefaDoFuncionario = [];
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

      db.getAllTarefasDoFuncionario().then((lista) {
        setState(() {
          tarefaDoFuncionario = lista;
        });
      });

      modeSwitchs.add(false);
    }


  void _getIdFuncionario(int coordenada){
    funcionarioSelecionado = funcionarios[coordenada];
  }

  void _getIdTarefa(int coordenada){
    tarefaFuncionario.id_tarefa = tarefas[coordenada].id;
  }


  void _atualizeListaTarefasDoFuncionario(){
    db.getAllTarefasDoFuncionario().then((lista) {
        setState(() {
          tarefaDoFuncionario = lista;
        });
      });
  }

  bool  _mostraDebug (TarefaDoFuncionario element, Tarefa t){
    return element.id_funcionario == funcionarioSelecionado.id && element.id_tarefa == t.id;
  }


  bool _validaCriterio(Tarefa t, int coordenada) {
    if (selected) {
      //return tarefaDoFuncionario.any((element) => element.id_funcionario == funcionarioSelecionado.id && element.id_tarefa == t.id);
       modeSwitch = tarefaDoFuncionario.any((element) => _mostraDebug(element, t));
       modeSwitchs.insert(coordenada, modeSwitch);
      return  modeSwitch;
    }

    return false;
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
                      tarefas[index].descricao,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  Switch( 
                    value: (modeSwitchs[index] == _validaCriterio(tarefas[index],index))? modeSwitchs[index] : modeSwitchs[index],
                    onChanged: (value){
                      super.setState(() {
                        modeSwitchs[index] = !modeSwitchs[index];
                        if(modeSwitchs[index] == true){
                          _getIdTarefa(index);
                          tarefaFuncionario.insert();
                          _atualizeListaTarefasDoFuncionario();
                        }else{
                          _getIdTarefa(index);
                          tarefaFuncionario.delete();
                          _atualizeListaTarefasDoFuncionario();
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
                  _getIdFuncionario(index);
                  containerIndex = funcionarios[index].nome;
                  conColorToBack = Colors.blue[colorCodes[index % colorCodes.length]];
                  containerColor = Colors.grey.shade200;
                  tarefaFuncionario.id_funcionario = funcionarios[index].id;

                }else{
                  containerColor = conColorToBack;
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
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
            },
          );
        }),
        centerTitle: true,
        title: const Text('Designar Tarefas Aos Funcionarios',
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
