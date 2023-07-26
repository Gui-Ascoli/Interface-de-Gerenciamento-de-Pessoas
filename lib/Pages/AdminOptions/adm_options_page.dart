
import 'package:banco/helpers/database_helper.dart';
import 'package:banco/models/tarefa.dart';
import 'package:flutter/material.dart';
import '../../helpers/route_names.dart';
import '../../models/funcionario.dart';

class AdmOptionsPage extends StatefulWidget {
  const AdmOptionsPage({super.key});

  @override
  State<AdmOptionsPage> createState() => _AdmOptionsPageState();
}

class _AdmOptionsPageState extends State<AdmOptionsPage> {

  SnackBar? snackBar;
  Drawer? howDrawer ;
  TextEditingController? textFieldControler = TextEditingController();
  Tarefa tarefaSelecionada = Tarefa(descricao: 'a');
  Funcionario funcionarioSelecionado = Funcionario(nome:'a');
  String? hinttxt ;
  String drowerMode = 'Adicionar Funcionario';
  String oldDrowerMode = '';
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  DatabaseHelper db = DatabaseHelper();
  List<int> colorCodes = [50, 100];
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Funcionarios'),
    const Tab(text: 'Tarefas'),
  ];
/*
  void _ofScreen(){
    Navigator.of(context).pushReplacementNamed(RouteNames.rotaListFuncionarioPage);
  }
*/

  void _snackBarErroVazio(){
    snackBar = SnackBar(
      content: const Text('Não é possível inserir vazio.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _snackBarAddFuncionario(){
    snackBar = SnackBar(
      content: const Text('Funcionario adicionado.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _snackBarAddTarefa(){
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

  void _snackBarEditFuncionario(){
    snackBar = SnackBar(
      content: const Text('Funcionario editado.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _snackBarEditTarefa(){
    snackBar = SnackBar(
      content: const Text('Tarefa editada.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _pegarFuncionarios(){
    db.getAllFuncionarios().then((lista) {
      setState(() {
        funcionarios = lista;
      });
    });
  }

  void _pegarTarefas(){
    db.getAllTarefas().then((lista) {
      setState(() {
        tarefas = lista;
      });
    });
  }

  @override
  void initState() {
    super.initState();
      db.getAllTarefas().then((lista) {
        setState(() {
          tarefas = lista;
        });
      });
      db.getAllFuncionarios().then((lista) {
        setState(() {
          funcionarios = lista;
        });
      });
  }

  Widget _listarFuncionarios(int index){
    return InkWell(
      child:Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), 
          boxShadow:[ 
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 3, 
              blurRadius: 15, 
              offset: const Offset(0, 6), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
            ),
            Expanded(
              child: Text(
                funcionarios[index].nome,
                style: const TextStyle(fontSize: 50),
              ),
            ),
            Builder(
              builder: (BuildContext context){
                return IconButton(
                  onPressed: (){
                    textFieldControler!.text = funcionarios[index].nome;
                    hinttxt = funcionarios[index].nome;
                    funcionarioSelecionado.nome = funcionarios[index].nome;
                    funcionarioSelecionado.id = funcionarios[index].id;
                    drowerMode = 'Editar Funcionario';
                    setState(() {
                      _drower();
                    });
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip: 'Editar Funcionario',
                  icon: const Icon(Icons.edit),
                );
              }
            ),
            Container(
              width: 30,
            ),
            Switch( 
              activeColor: Colors.black,
              value: funcionarios[index].apto,
              onChanged: (value){
                setState(() {
                  funcionarios[index].apto = !funcionarios[index].apto;
                  funcionarios[index].update();
                });
              },
            ),
            Container(
              width: 50,
            ),
          ]
        ),
      ),
    );
  }

  Widget _bodyListFuncionarios(){
  return ListView.builder(
    padding: const EdgeInsets.all(15),
    itemCount: funcionarios.length,
    itemBuilder: (context, index){
      return _listarFuncionarios(index);
    },
  );
}

  Widget _listarTarefas(int index){
    return InkWell(
      child:Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), 
          boxShadow:[ 
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), 
              spreadRadius: 3, 
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  tarefas[index].descricao,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            Builder(
              builder: (BuildContext context){
                return IconButton(
                  onPressed: (){
                    textFieldControler!.text = tarefas[index].descricao;
                    hinttxt = tarefas[index].descricao;
                    tarefaSelecionada.descricao = tarefas[index].descricao;
                    tarefaSelecionada.id = tarefas[index].id;
                    drowerMode = 'Editar Tarefa';
                    setState(() {
                      _drower();
                    });
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip: 'Editar Tarefa',
                  icon: const Icon(Icons.edit),
                );
              }
            ),
            Container(
              width: 10,
            ),
            IconButton(
              onPressed: (){
                tarefas[index].delete();
              },
              tooltip: 'Deletar Tarefa',
              icon: const Icon(Icons.delete),
              //TODO: deseja realmente deletar?
            ),
            Container(
              width: 10,
            ),
          ]
        ),
      ),  
    );
  }

  Widget _bodyListTarefas(){
  return ListView.builder(
    padding: const EdgeInsets.all(15),
    itemCount: tarefas.length,
    itemBuilder: (context, index){
      return _listarTarefas(index);
    },
  );
}

  Widget _selectedBody(){
    return TabBarView(
      children:tabs.map((Tab tab) {
        if(tab.text == 'Funcionarios'){
          return _bodyListFuncionarios();
        }
        else{
          return _bodyListTarefas();
        }
      }).toList()
    );
  }

  Drawer? _drower(){
    howDrawer= Drawer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                Text(
                  textAlign: TextAlign.center ,
                  drowerMode,
                  style: const TextStyle(fontSize: 30),
                ),
                TextField(
                  controller: textFieldControler,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: hinttxt,
                  ),
                  onChanged: (text){
                    if(drowerMode == 'Adicionar Funcionario'){funcionarioSelecionado.nome = text;}
                    if(drowerMode == 'Adicionar Tarefa'){tarefaSelecionada.descricao = text;}
                    if(drowerMode == 'Editar Funcionario'){funcionarioSelecionado.nome = text;}
                    if(drowerMode == 'Editar Tarefa'){tarefaSelecionada.descricao = text;}
                  },
                ),
                IconButton(
                  highlightColor: Colors.grey,
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    if(funcionarioSelecionado.nome != ''){
                      if(drowerMode == 'Adicionar Funcionario'){
                        _snackBarAddFuncionario();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        //funcionarioSelecionado.id = null;
                        await funcionarioSelecionado.insert(); 
                        _pegarFuncionarios();
                      }if(drowerMode == 'Editar Funcionario'){
                        _snackBarEditFuncionario();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        await funcionarioSelecionado.update(); 
                        _pegarFuncionarios();
                        hinttxt = '';
                        textFieldControler!.text = '';
                      }
                      Navigator.pop(context);
                    }else{
                      //_snackBarErroVazio();
                      //ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                    }
                    if(tarefaSelecionada.descricao != ''){
                      if(drowerMode == 'Adicionar Tarefa'){
                        _snackBarAddTarefa();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        //tarefaSelecionada.id = null;
                        await tarefaSelecionada.insert(); 
                        _pegarTarefas();
                      }if(drowerMode == 'Editar Tarefa'){
                        _snackBarEditTarefa();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        await tarefaSelecionada.update();
                        _pegarTarefas();
                        hinttxt = '';
                        textFieldControler!.text = '';
                      }
                      Navigator.pop(context);
                    }
                    else{
                      //TODO:desenvolver uma rotina para a snack bar erro vazio que nao apareça multiplas vezes, ou em momentos indesejados.
                      //_snackBarErroVazio();
                      //ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                      }
                  }
                ),
                const Expanded(
                  child: SizedBox()
                )
              ],
            )
          )
        ],
      ),
    );
    return howDrawer;
  }

  //var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
  howDrawer = _drower();
  
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
          }
        });
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title:const Text('Opções De ADM',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50.0,
          ),
        ),
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage );
            },
          );
        }),
        bottom: TabBar(
          tabs: tabs ,
          onTap: (int indexTab){
            if(indexTab == 0){
              drowerMode = 'Adicionar Funcionario';
            }else{
              drowerMode = 'Adicionar Tarefa';
            }
            setState(() {
              
            });
          }
        ),
      ),
        body: _selectedBody(),
        endDrawer: howDrawer,
        floatingActionButton:
          FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
            onPressed: (){
              drowerMode = 'Adicionar Tarefa';
              _drower();
              setState(() {
                      
              });
              Scaffold.of(context).openEndDrawer();
            }
          ),
        );
      }),
    );
  }
}
