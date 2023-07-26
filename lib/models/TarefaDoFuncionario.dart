import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';

class TarefaDoFuncionario{

  final String _tarefaTableNome = "TarefaDoFuncionario";
  
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_tarefaTableNome,this.toMap());
  
    return resultado;
  }
  Future<int>update() async{
    var db = await database!;
    var resultado = await db.update(_tarefaTableNome,this.toMap(),
      where: "Id = ?",
      whereArgs: [this.id]);
    return resultado;
  }
  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_tarefaTableNome,
      where: "Id = ?",
      whereArgs: [this.id]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' :id,
      'id_funcionarios' : id_funcionario,
      'id_tarefas' :id_tarefa,
    };
    return map;
  }
  TarefaDoFuncionario.fromMap(Map<String,dynamic> map){
    id = map['Id'];
    id_funcionario = map['Id_Funcionario'];
    id_tarefa = map['Id_Tarefa'];

  }

   //Fim

  late int? id;
  late int? id_funcionario;
  late int? id_tarefa;


  TarefaDoFuncionario({int? id = null,int? id_funcionario = null,int? id_tarefa = null}){
    this.id;
    this.id_funcionario;
    this.id_tarefa;
  }

}