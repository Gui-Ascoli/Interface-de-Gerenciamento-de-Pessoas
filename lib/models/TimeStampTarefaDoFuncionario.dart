import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';

class TimeStampTarefaDoFuncionario{

  final String _tarefaTableNome = "TimeStampTarefaDoFuncionario";
  
  Future<Database>? database = DatabaseHelper().database;


  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_tarefaTableNome,this.toMap());
  
    return resultado;
  }

  Future<int>update() async{
    Database db = await database!;
    var resultado = await db.update(_tarefaTableNome,{'stop_timestamp': stop_timestamp},
      where: "id_funcionario = ? and id_tarefa = ? and stop_timestamp is null",
      whereArgs: [this.id_funcionario,this.id_tarefa]);
    return resultado;
  }

/*
  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_tarefaTableNome,
      where: "id = ?",
      whereArgs: [this.id_funcionario,this.id_tarefa]);
    return resultado;
  }

*/
  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'start_timestamp' : start_timestamp,
      'stop_timestamp'  : stop_timestamp,
      'id_funcionario' : id_funcionario,
      'id_tarefa' :id_tarefa,
    };
    return map;
  }
  TimeStampTarefaDoFuncionario.fromMap(Map<String,dynamic> map){
    start_timestamp = map['start_timestamp'];
    stop_timestamp = map['stop_timestamp'];
    id_funcionario = map['id_funcionario'];
    id_tarefa = map['id_tarefa'];

  }

   //Fim

  late int id;
  late String? start_timestamp;
  late String? stop_timestamp;
  late int? id_funcionario;
  late int? id_tarefa;


  TimeStampTarefaDoFuncionario({String? start_timestamp , String? stop_timestamp , int? id_funcionario = null , int? id_tarefa = null}){
    this.start_timestamp = start_timestamp;
    this.stop_timestamp = stop_timestamp;
    this.id_funcionario = id_funcionario;
    this.id_tarefa = id_tarefa;
  }

}