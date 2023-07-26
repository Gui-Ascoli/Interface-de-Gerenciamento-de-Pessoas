
import 'package:flutter/material.dart';
import 'package:banco/models/Funcionario.dart';

import '../../helpers/RouteNames.dart';
import '../../helpers/database_helper.dart';


class AddFuncionariosPage extends StatefulWidget {
  const AddFuncionariosPage({super.key});

  @override
  State<AddFuncionariosPage> createState() => _AddFuncionariosPageState();
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
  
  TextEditingController? nomeControler = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  Funcionario funcionarioSelecionado = Funcionario();
  String? hinttxt = "";

class _AddFuncionariosPageState extends State<AddFuncionariosPage> {
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
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaListFuncionarioPage);
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
          onPressed: (){
            

            if(funcionarioSelecionado.nome != ''){
              if(hinttxt == "Editar Funcionario"){
                funcionarioSelecionado.update();
              }
              else{
                funcionarioSelecionado.insert(); 
              }
              Navigator.of(context).pushReplacementNamed(RouteNames.rotaListFuncionarioPage);
            }
            else{
               //retornar um aviso que nao é possivel inserir um nome vazio
            }
          }
      ),
    );
  }
}