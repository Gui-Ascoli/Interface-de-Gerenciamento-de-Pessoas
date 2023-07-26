import 'package:banco/Pages/custom_app_bar.dart';
import 'package:banco/models/funcionario.dart';
import 'package:banco/models/stop_watch_tarefa.dart';
import 'package:flutter/material.dart';
import '../helpers/route_names.dart';
import '../helpers/database_helper.dart';
import '../models/tarefa.dart';
import '../models/tarefa_do_funcionario.dart';

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
  StopWatchTarefa timerTarefa= StopWatchTarefa();
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  List<TarefaDoFuncionario> tarefaDoFuncionario = [];
  List<int> colorCodes = [200, 250];
  String snackbarFuncionario = '';
  String snackbarTarefa = '';
  SnackBar? snackBar;

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
    timerTarefa.idFuncionario = funcionarios[coordenada].id;
  }
  void _getIdTarefa(int coordenada){
    timerTarefa.idTarefa = tarefas[coordenada].id;
  }


  bool  _mostraDebug (TarefaDoFuncionario element){
    return element.idFuncionario == timerTarefa.idFuncionario && element.idTarefa == timerTarefa.idTarefa;
  }
  void _tarefaCadastrada() {
    if (selected) {
      tarefaCadastrada = tarefaDoFuncionario.any((element) => _mostraDebug(element));
    }
  }

  void _snackBarStop(){
    snackBar = SnackBar(
      content: Text('$snackbarFuncionario sua tarefa em aberto foi finalizada!'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _snackBarStart(){
    snackBar = SnackBar(
      content: Text('$snackbarTarefa foi iniciada!'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
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
          snackbarTarefa = tarefas[index].descricao;
          _snackBarStart();
          ScaffoldMessenger.of(context).showSnackBar(snackBar!);
          _getIdTarefa(index);
          timerTarefa.inserirTimeStamp();
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
        color:(snackbarFuncionario == funcionarios[index].nome) ? containerColor : Colors.blue[colorCodes[index % colorCodes.length]] ,
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
            snackbarFuncionario = funcionarios[index].nome;
            _snackBarStop();
            ScaffoldMessenger.of(context).showSnackBar(snackBar!);
            conColorToBack = Colors.blue[colorCodes[index % colorCodes.length]];
            containerColor = Colors.grey.shade200;
            timerTarefa.fecharTarefasAbertas();

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
    isStop = routeSettings?.arguments as bool; 
    
    _snackBarStop();

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