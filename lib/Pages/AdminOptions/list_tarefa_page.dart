
import 'package:banco/helpers/database_helper.dart';
import 'package:banco/models/tarefa.dart';
import 'package:flutter/material.dart';
import '../../helpers/route_names.dart';
import '../../models/funcionario.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class ListTarefaPage extends StatefulWidget {
  const ListTarefaPage({super.key});

  @override
  State<ListTarefaPage> createState() => _ListTarefaPageState();
}

class _ListTarefaPageState extends State<ListTarefaPage> {

  SnackBar? snackBar;
  Drawer? f ;
  TextEditingController? nomeControler = TextEditingController();
  Funcionario funcionarioSelecionado = Funcionario();
  String? hinttxt = "";
  String drowerMode = "a";
  String oldDrowerMode = '';
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  DatabaseHelper db = DatabaseHelper();
  List<int> colorCodes = [50, 100];
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Funcionarios'),
    const Tab(text: 'Tarefas'),
  ];


  void _ofScreen(){
    Navigator.of(context).pushReplacementNamed(RouteNames.rotaListFuncionarioPage);
  }

  void _snackBarAdd(){
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

  Widget _listaFuncionarios2(int index){
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
            IconButton(
              onPressed: (){
                if(funcionarios[index].apto == true){
                  Navigator.of(context).pushReplacementNamed (RouteNames.rotaAddFuncionariosPage, arguments:funcionarios[index] );
                }
              },
              tooltip: "Editar funcionario",
              icon: const Icon(Icons.edit),
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
      return _listaFuncionarios2(index);
    },
  );
}

  Widget _listaTarefas2(int index){
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
            IconButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed (RouteNames.rotaAddTarefaPage, arguments:tarefas[index] );
              },
              tooltip: "Editar Tarefa",
              icon: const Icon(Icons.edit),
            ),
            Container(
              width: 10,
            ),
            IconButton(
              onPressed: (){
                tarefas[index].delete();
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

  Widget _bodyListTarefas(){
  return ListView.builder(
    padding: const EdgeInsets.all(15),
    itemCount: tarefas.length,
    itemBuilder: (context, index){
      return _listaTarefas2(index);
    },
  );
}

  Widget _bodyListTarefaPage(){
    return TabBarView(
      children:tabs.map((Tab tab) {
        if(tab.text == "Funcionarios"){
          return _bodyListFuncionarios();
        }
        else{
          return _bodyListTarefas();
        }
      }).toList()
    );
  }

  Drawer? _drowerListTarefa(){
    
    f= Drawer(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    child: Text(drowerMode),
                    //TODO:se tela funcionario, se nao tela tarefas
                  ),
                  TextField(
                    controller: nomeControler,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: drowerMode,
                    ),
                    onChanged: (text){
                      funcionarioSelecionado.nome = text;
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      if(funcionarioSelecionado.nome != ''){
                        if(drowerMode == 'Adicionar Funcionario'){
                          _snackBarAdd();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                          await funcionarioSelecionado.insert(); 
                        }
                        else{
                          _snackBarAdd();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                          await funcionarioSelecionado.insert(); 
                        }
                        _ofScreen(); // nao é legal chamar "build context" em uma rotina async
                      }
                      else{
                        //TODO:retornar um aviso que nao é possivel inserir um nome vazio
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
      return f;
  }

  @override
  Widget build(BuildContext context) {
  f = _drowerListTarefa();

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
      body: _bodyListTarefaPage(),

      endDrawer: f,
      floatingActionButton:
        FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed (RouteNames.rotaAddTarefaPage, arguments:null );
          }
        ),
    );
      }),
    );
  }
}
