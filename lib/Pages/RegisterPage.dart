import 'package:banco/Pages/CustomAppBar.dart';
import 'package:banco/models/Funcionario.dart';
import 'package:banco/models/TimeStampTarefaDoFuncionario.dart';
import 'package:flutter/material.dart';
import '../helpers/RouteNames.dart';
import '../helpers/database_helper.dart';
import '../models/Tarefa.dart';
import '../models/TarefaDoFuncionario.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  DatabaseHelper db = DatabaseHelper();
  bool? isStop;
  bool selected = false;
  bool tarefaCadastrada = false;
  Color? conColorToBack;
  Color? containerColor = Colors.blue;
  TimeStampTarefaDoFuncionario iniciarParar= TimeStampTarefaDoFuncionario();
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  List<TarefaDoFuncionario> tarefaDoFuncionario = [];
  List<int> colorCodes = [200, 250];
  String containerIndex = '';
  String tempoAtual = '';

  @override
  void initState() {
    super.initState();

      db.getAllFuncionarios().then((lista) {
        setState(() {
          funcionarios = lista;
        });
      });

      db.getAllTarefas().then((lista) {
        setState((){
          tarefas = lista;
        });
      });
      
      db.getAllTarefasDoFuncionario().then((lista) {
        setState(() {
          tarefaDoFuncionario = lista;
        });
      });
  }

  void _getIdFuncionario(int coordenada){
    iniciarParar.id_funcionario = funcionarios[coordenada].id;
  }
  void _getIdTarefa(int coordenada){
    iniciarParar.id_tarefa = tarefas[coordenada].id;
  }


  bool  _mostraDebug (TarefaDoFuncionario element){
    return element.id_funcionario == iniciarParar.id_funcionario && element.id_tarefa == iniciarParar.id_tarefa;
  }
  void _tarefaCadastrada() {
    if (selected) {
      tarefaCadastrada = tarefaDoFuncionario.any((element) => _mostraDebug(element));
    }
  }

  Widget _listaTarefas(int index){
    _getIdTarefa(index);
    _tarefaCadastrada();
    if(tarefaCadastrada == true){
      return InkWell(
        child:Container(
          height: 100,
          color: containerColor = Colors.green[colorCodes[index % colorCodes.length]],
          child: Center(
            child: Text(
              tarefas[index].descricao,
              style: const TextStyle(fontSize: 50),
            ),
          ),
        ),
        onTap: () {
          _getIdTarefa(index);
          iniciarParar.inserirTimeStamp();
          Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
        }
      );    
    }else{
      return Container(
        height: 1,
        color: Colors.transparent,
      );
    }
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
        _getIdFuncionario(index);
        setState(() {
          selected = !selected;
          if(selected == true){
            containerIndex = funcionarios[index].nome;
            conColorToBack = Colors.blue[colorCodes[index % colorCodes.length]];
            containerColor = Colors.grey.shade200;
            iniciarParar.fecharTarefasAbertas();
            if(isStop == true){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
            }
          }else{
            containerColor = conColorToBack;
          }
        });
      }
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
    isStop= routeSettings?.arguments as bool; 

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