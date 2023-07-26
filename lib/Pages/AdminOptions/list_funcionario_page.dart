import 'package:banco/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import '../../helpers/route_names.dart';
import '../../models/funcionario.dart';

class ListFuncionarioPage extends StatefulWidget {
  const ListFuncionarioPage({super.key});

  @override
  State<ListFuncionarioPage> createState() => _ListFuncionarioPageState();
}

class _ListFuncionarioPageState extends State<ListFuncionarioPage> {

  List<Funcionario> funcionarios = [];
  DatabaseHelper db = DatabaseHelper();
  List<int> colorCodes = [50, 100];

  @override
  void initState() {
    super.initState();
      
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
        color: Colors.green[colorCodes[index % colorCodes.length]],
        child: Row(
          children: <Widget>[
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
              width: 10,
            ),
            Switch( 
              value: funcionarios[index].apto,
              onChanged: (value){
                setState(() {
                  funcionarios[index].apto = !funcionarios[index].apto;
                  funcionarios[index].update();
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

Widget _bodyNewRootPage(){
  return ListView.builder(
    padding: const EdgeInsets.all(15),
    itemCount: funcionarios.length,
    itemBuilder: (context, index){
      return _listaFuncionarios2(index);
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaStartPage );
            },
          );
        }),
        centerTitle: true,
        title:const Text('Lista De Funcionarios',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _bodyNewRootPage() ,
      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed (RouteNames.rotaAddFuncionariosPage, arguments:null );
          }
      ),
    );
  }
}