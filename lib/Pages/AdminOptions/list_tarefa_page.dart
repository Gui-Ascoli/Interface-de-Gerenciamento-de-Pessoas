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

  TextEditingController? nomeControler = TextEditingController();
  Funcionario funcionarioSelecionado = Funcionario();
  String? hinttxt = "";
  String drowerMode = "";
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  DatabaseHelper db = DatabaseHelper();
  List<int> colorCodes = [50, 100];
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Funcionarios'),
    const Tab(text: 'Tarefas'),
  ];


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

  void _drowerMode(String? tabtext){
    drowerMode = tabtext!;
  }

  Widget? drowerText(){
    if (drowerMode == "Funcionarios"){
      return 
         const Center(
           child: Text(
            'Adicionar Funcionario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
        );

    }else{
      return Container();
    }
  }

  
  Widget _listaFuncionarios2(int index){
    return InkWell(
      child:Container(
        height: 100,
        //color: Colors.green[colorCodes[index % colorCodes.length]],
        decoration: BoxDecoration(
            color: Colors.white,
             borderRadius: BorderRadius.circular(30), //border corner radius
             boxShadow:[ 
               BoxShadow(
                  color: Colors.grey.withOpacity(0.5), //color of shadow
                  spreadRadius: 3, //spread radius
                  blurRadius: 15, // blur radius
                  offset: const Offset(0, 6), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
               ),
               //you can set more BoxShadow() here
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
        //color: Colors.green[colorCodes[index % colorCodes.length]],
        decoration: BoxDecoration(
            color: Colors.white,
             borderRadius: BorderRadius.circular(30), //border corner radius
             boxShadow:[ 
               BoxShadow(
                  color: Colors.grey.withOpacity(0.5), //color of shadow
                  spreadRadius: 3, //spread radius
                  blurRadius: 15, // blur radius
                  offset: const Offset(0, 6), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
               ),
               //you can set more BoxShadow() here
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
          _drowerMode(tab.text);
          return _bodyListFuncionarios();
        }
        else{
          //_drowerMode(tab.text);
          return _bodyListTarefas();
        }
      }).toList()
    );

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {

          }
        });
        return Scaffold(
      appBar: AppBar(
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
        ),
        backgroundColor: Colors.black,
      ),

      body: _bodyListTarefaPage(),

      endDrawer: Drawer(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 200,
                    child: Text('adicionar Funcionario'),
                    //TODO:se tela funcionario, se nao tela tarefas
                  ),
                  TextField(
                    controller: nomeControler,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: hinttxt,
                    ),
                    onChanged: (text){
                      funcionarioSelecionado.nome = text;
                    },
                  ),
                  const Expanded(
                    child: SizedBox()
                  )
                ],
              )
            )
          ],
        ),
      ),
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
