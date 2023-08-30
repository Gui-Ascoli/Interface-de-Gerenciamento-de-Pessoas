import 'package:banco/Pages/drower.dart';
import 'package:banco/helpers/database_helper.dart';
import 'package:banco/models/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../../helpers/route_names.dart';
import '../../models/funcionario.dart';
import '../../models/screenshot.dart';

class ListTarefaPage extends StatefulWidget {
  const ListTarefaPage({super.key});

  @override
  State<ListTarefaPage> createState() => _ListTarefaPageState();
}

class _ListTarefaPageState extends State<ListTarefaPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final ScreenshotOps _screenshot = ScreenshotOps();
  SnackBar? snackBar;
  ClipRRect? howDrawer;
  TextEditingController? textFieldControler = TextEditingController();
  Tarefa tarefaSelecionada = Tarefa();
  Funcionario funcionarioSelecionado = Funcionario();
  String? hinttxt;
  String drowerMode = 'Adicionar Funcionario';
  List<Tarefa> tarefas = [];
  List<Funcionario> funcionarios = [];
  DatabaseHelper db = DatabaseHelper();
  List<int> colorCodes = [50, 100];
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Funcionarios'),
    const Tab(text: 'Tarefas'),
  ];
  CustomDrawer customDrower = CustomDrawer();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _snackBarErroVazio() {
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

  void _snackBarAddFuncionario() {
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

  void _snackBarAddTarefa() {
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

  void _snackBarEditFuncionario() {
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

  void _snackBarEditTarefa() {
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

  void _pegarFuncionarios() {
    db.getAllFuncionarios().then((lista) {
      setState(() {
        funcionarios = lista;
      });
    });
  }

  void _pegarTarefas() {
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

  Widget _listarFuncionarios(int index) {
    return InkWell(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 3,
              blurRadius: 15,
              offset: const Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: Row(children: <Widget>[
          Container(
            width: 30,
          ),
          Expanded(
            child: Text(
              funcionarios[index].nome,
              style: const TextStyle(fontSize: 50),
            ),
          ),
          Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                textFieldControler!.text = funcionarios[index].nome;
                funcionarioSelecionado.nome = funcionarios[index].nome;
                funcionarioSelecionado.id = funcionarios[index].id;
                hinttxt = funcionarios[index].nome;
                howDrawer = customDrower.drawerEdit("Editar Funcionario");
                setState(() {
                  //_theUniqueDrower();
                });
                Scaffold.of(context).openEndDrawer();
              },
              tooltip: 'Editar Funcionario',
              icon: const Icon(Icons.edit),
            );
          }),
          Container(
            width: 30,
          ),
          Switch(
            activeColor: Colors.black,
            value: funcionarios[index].apto,
            onChanged: (value) {
              setState(() {
                funcionarios[index].apto = !funcionarios[index].apto;
                funcionarios[index].update();
              });
            },
          ),
          Container(
            width: 50,
          ),
        ]),
      ),
    );
  }

  Widget _bodyListFuncionarios() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: funcionarios.length,
      itemBuilder: (context, index) {
        return _listarFuncionarios(index);
      },
    );
  }

  Widget _listarTarefas(int index) {
    return InkWell(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                tarefas[index].descricao,
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                textFieldControler!.text = tarefas[index].descricao;
                tarefaSelecionada.descricao = tarefas[index].descricao;
                tarefaSelecionada.id = tarefas[index].id;
                hinttxt = tarefas[index].descricao;
                howDrawer = customDrower.drawerEdit('Editar Tarefa');
                setState(() {
                  //_theUniqueDrower();
                });
                Scaffold.of(context).openEndDrawer();
              },
              tooltip: 'Editar Tarefa',
              icon: const Icon(Icons.edit),
            );
          }),
          Container(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              tarefas[index].delete();
            },
            tooltip: 'Deletar Tarefa',
            icon: const Icon(Icons.delete),
            //TODO: deseja realmente deletar?
          ),
          Container(
            width: 10,
          ),
        ]),
      ),
    );
  }

  Widget _bodyListTarefas() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        return _listarTarefas(index);
      },
    );
  }

  Widget _selectedBody() {
    return TabBarView(
        children: tabs.map((Tab tab) {
      if (tab.text == 'Funcionarios') {
        return _bodyListFuncionarios();
      } else {
        return _bodyListTarefas();
      }
    }).toList());
  }

/*
  Drawer? _theUniqueDrower() {
    howDrawer = Drawer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                Text(
                  textAlign: TextAlign.center,
                  drowerMode,
                  style: const TextStyle(fontSize: 30),
                ),
                TextField(
                  controller: textFieldControler,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: hinttxt,
                  ),
                  onChanged: (text) {
                    if (drowerMode == 'Adicionar Funcionario') {
                      funcionarioSelecionado.nome = text;
                    }
                    if (drowerMode == 'Adicionar Tarefa') {
                      tarefaSelecionada.descricao = text;
                    }
                    if (drowerMode == 'Editar Funcionario') {
                      funcionarioSelecionado.nome = text;
                    }
                    if (drowerMode == 'Editar Tarefa') {
                      tarefaSelecionada.descricao = text;
                    }
                  },
                ),
                IconButton(
                  highlightColor: Colors.grey,
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    if (funcionarioSelecionado.nome != '') {
                      if (drowerMode == 'Adicionar Funcionario') {
                        _snackBarAddFuncionario();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        await funcionarioSelecionado.insert();
                        _pegarFuncionarios();
                      }
                      if (drowerMode == 'Editar Funcionario') {
                        _snackBarEditFuncionario();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        await funcionarioSelecionado.update();
                        _pegarFuncionarios();
                        drowerMode = 'Adicionar Funcionario';
                      }
                      Navigator.pop(context);
                    } else {
                      //TODO:snackbar erro ao inserir vazio
                      //_snackBarErroVazio();
                      //ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                    }
                    if (tarefaSelecionada.descricao != '') {
                      if (drowerMode == 'Adicionar Tarefa') {
                        _snackBarAddTarefa();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        tarefaSelecionada.id = null;
                        await tarefaSelecionada.insert();
                        _pegarTarefas();
                      }
                      if (drowerMode == 'Editar Tarefa') {
                        _snackBarEditTarefa();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                        await tarefaSelecionada.update();
                        _pegarTarefas();
                        drowerMode = 'Adicionar Tarefa';
                      }
                      Navigator.pop(context);
                    } else {}
                    hinttxt = '';
                    textFieldControler?.text = '';
                  },
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          ),
        ],
      ),
    );
    return howDrawer;
  }
*/
  @override
  Widget build(BuildContext context) {
    //howDrawer = _theUniqueDrower();

    return Screenshot(
      controller: _screenshotController,
      child: DefaultTabController(
        length: tabs.length,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context);
            tabController.addListener(
              () {
                if (!tabController.indexIsChanging) {}
              },
            );
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: const Text(
                  'Opções De ADM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                  ),
                ),
                leading: Builder(
                  builder: (BuildContext context) {
                    return BackButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(RouteNames.rotaStartPage);
                      },
                    );
                  },
                ),
                bottom: TabBar(
                  tabs: tabs,
                  onTap: (int indexTab) {
                    if (indexTab == 0) {
                      drowerMode = 'Adicionar Funcionario';
                      howDrawer =
                          customDrower.drawerAdd('Adicionar Funcionario');
                    } else {
                      drowerMode = 'Adicionar Tarefa';
                      howDrawer = customDrower.drawerAdd('Adicionar Tarefa');
                    }
                    setState(() {});
                  },
                ),
              ),
              body: _selectedBody(),
              endDrawerEnableOpenDragGesture: false,
              endDrawer: howDrawer,
              floatingActionButton: Stack(
                children: [
                  Positioned(
                    right: 16.0,
                    bottom: 20.0,
                    child: FloatingActionButton(
                      heroTag: 'btn1',
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        //drowerMode = 'Adicionar Tarefa';
                        //_theUniqueDrower();
                        howDrawer = customDrower.drawerEdit('Editar Tarefa');
                        setState(() {});
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    bottom: 90.0,
                    child: FloatingActionButton(
                      heroTag: 'btn2',
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.screenshot),
                      onPressed: () async {
                        drowerMode = 'Adicionar Tarefa';
                        _screenshotController
                            .captureAndSave(await _screenshot.takePath());
                        setState(() {});
                        //Scaffold.of(context).openEndDrawer();
                        print('screenshot realizada');
                      },
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    bottom: 160.0,
                    child: FloatingActionButton(
                      heroTag: 'btn3',
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.settings),
                      onPressed: () async {
                        openAppSettings();
                        drowerMode = 'Adicionar Tarefa';
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
