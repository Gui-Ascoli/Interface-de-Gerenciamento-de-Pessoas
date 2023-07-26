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
  bool isSaved = false;
  bool? finalizar;
  bool selected = false;
  bool apto = false;
  Color? conColorToBack;
  Color? containerColor = Colors.blue;
  Funcionario funcionarioSelecionado = Funcionario();
  TimeStampTarefaDoFuncionario iniciarParar= TimeStampTarefaDoFuncionario();
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  List<TarefaDoFuncionario> tarefaDoFuncionario = [];
  List<TimeStampTarefaDoFuncionario> timeStampTarefaDoFuncionario = [];
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

      db.getAllTimeStampTarefaDoFuncionario().then((lista) {
        setState((){
          timeStampTarefaDoFuncionario = lista;
        });
      });

      db.getTempoAtual().then((lista) {
        setState(() {
          tempoAtual = lista;
        });
      });
  }

  void _getIdFuncionario(int coordenada){
    iniciarParar.id_funcionario = funcionarios[coordenada].id;
  }
  void _getIdTarefa(int coordenada){
    iniciarParar.id_tarefa = tarefas[coordenada].id;
  }

  bool  _mostraDebug (TarefaDoFuncionario element, int index){
    return element.id_funcionario == funcionarioSelecionado.id && element.id_tarefa == index;
  }


  void _tarefaCadastrada(int coordenada) {
    if (selected) {
      coordenada = coordenada + 1; // adapta o valor para pegar a tarefa correta
      apto = tarefaDoFuncionario.any((element) => _mostraDebug(element, coordenada));
    }
  }


  bool  _verDebug (TimeStampTarefaDoFuncionario element, int index){
    return element.id_funcionario == funcionarioSelecionado.id && element.id_tarefa == index && element.start_timestamp!.isNotEmpty && element.start_timestamp!.isEmpty;
  }


  void _timeStampCadastrado(int coordenada) {
    if (selected) {
      coordenada = coordenada + 1; // adapta o valor para pegar a tarefa correta
      isSaved = timeStampTarefaDoFuncionario.any((element) => _verDebug(element, coordenada));
    }
  }

   bool  _olharDebug (TimeStampTarefaDoFuncionario element, int index){
    return element.id_funcionario == funcionarioSelecionado.id && element.id_tarefa == index && element.start_timestamp!.isNotEmpty && element.start_timestamp!.isEmpty;
  }


  void _timeStampFinalizado(int coordenada) {
    if (selected) {
      coordenada = coordenada + 1; // adapta o valor para pegar a tarefa correta
      isSaved = timeStampTarefaDoFuncionario.any((element) => _olharDebug(element, coordenada));
    }
  }

  Widget _listaTarefas(int index){
    _tarefaCadastrada(index);
    if(apto == true){
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
          if (finalizar == true) {
            iniciarParar.stop_timestamp = tempoAtual;
            iniciarParar.update();
            Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
          }else{
            _timeStampCadastrado(index);
            if(isSaved == false){
              //exibir aviso de cadastrado
              iniciarParar.start_timestamp = tempoAtual;
              iniciarParar.insert();
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
            }else{
              //exibir aviso de nao cadastrado
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage);
            }
            
          }
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
            funcionarioSelecionado.id = funcionarios[index].id;
            containerIndex = funcionarios[index].nome;
            conColorToBack = Colors.blue[colorCodes[index % colorCodes.length]];
            containerColor = Colors.grey.shade200;
            if(finalizar == true){
              //e se tiver algo em aberto na base de dados ( idfuncionario existe! && stopdatatime é nulo") finalizar.
              //utilizar a mesma rotina quando for adicionar uma nova tarefa(se vou iniciar outra tarefa, logo, a tarefa anterior ja deve estar finalizada!)
              //criar rotina que garante que o stop nao seja salvo caso nao exista nada aberto.

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
    finalizar= routeSettings?.arguments as bool; //recebe o valor da variavel "finalizar" que vem da tela "startPage"(carrega a escolha de iniciar ou finalizar uma tarefa)

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