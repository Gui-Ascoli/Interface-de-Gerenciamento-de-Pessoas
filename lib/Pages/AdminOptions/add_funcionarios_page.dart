import 'package:flutter/material.dart';
import 'package:banco/models/funcionario.dart';
import '../../helpers/route_names.dart';
import '../../helpers/database_helper.dart';

class AddFuncionariosPage extends StatefulWidget {
  const AddFuncionariosPage({super.key});

  @override
  State<AddFuncionariosPage> createState() => _AddFuncionariosPageState();
}

class _AddFuncionariosPageState extends State<AddFuncionariosPage> {
  
  TextEditingController? nomeControler = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  Funcionario funcionarioSelecionado = Funcionario();
  String? hinttxt = "";
  SnackBar? snackBar;

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

  void _snackBarEdit(){
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

  Widget _bodyAddFuncionarioPage(){
    return   Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: TextField(
                    controller: nomeControler,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: hinttxt,
                    ),
                    onChanged: (text){
                      funcionarioSelecionado.nome = text;
                    },
                  ),
                ),
              )
            ],
          )
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final routeSettings = ModalRoute.of(context)?.settings;
    if (routeSettings?.arguments == null){
        funcionarioSelecionado = Funcionario();
        hinttxt = "Adicionar Funcionario";
    }
    else {
      funcionarioSelecionado = routeSettings?.arguments as Funcionario;
      hinttxt = "Editar Funcionario";
    }

    nomeControler!.text = funcionarioSelecionado.nome;

    return Scaffold(

      appBar: AppBar(
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaListTarefaPage);
            },
          );
        }),
        centerTitle: true,
        title: Text(nomeControler!.text == "" ? 'Adicionar Funcionario' : nomeControler!.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: _bodyAddFuncionarioPage(),

      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            if(funcionarioSelecionado.nome != ''){
              if(hinttxt == "Editar Funcionario"){
                _snackBarEdit();
                ScaffoldMessenger.of(context).showSnackBar(snackBar!);
                await funcionarioSelecionado.update();
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
    );
  }
}