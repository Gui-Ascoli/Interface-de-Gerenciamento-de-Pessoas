import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class StopWatchTarefa{

  final String _tarefaTableNome = "StopWatchTarefa";
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_tarefaTableNome,this.toMap());
    return resultado;
  }

  //todo: criar update
  Future<int?>inserirTimeStamp() async{
    Database db = await database!;
    var map = <String,dynamic>{
      'start_timestamp' : 'datetime("now")',
      'id_funcionario' : id_funcionario,
      'id_tarefa' :id_tarefa,
    };
    var resultado = await db.insert(_tarefaTableNome,map);
    return resultado;
  }

  Future<int>fecharTarefasAbertas() async{
    Database db = await database!;
    var resultado = await db.update(_tarefaTableNome,{'stop_timestamp': 'datetime("now")'},
      where: "id_funcionario = ? and stop_timestamp is null",
      whereArgs: [this.id_funcionario]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'start_timestamp' : start_timestamp,
      'stop_timestamp'  : stop_timestamp,
      'id_funcionario' : id_funcionario,
      'id_tarefa' :id_tarefa,
    };
    return map;
  }

  StopWatchTarefa.fromMap(Map<String,dynamic> map){
    start_timestamp = map['start_timestamp'];
    stop_timestamp = map['stop_timestamp'];
    id_funcionario = map['id_funcionario'];
    id_tarefa = map['id_tarefa'];
  }

   //Fim

  late int id;
  late DateTime? start_timestamp;
  late DateTime? stop_timestamp;
  late int? id_funcionario;
  late int? id_tarefa;

  StopWatchTarefa({DateTime? start_timestamp , DateTime? stop_timestamp , int? id_funcionario = null , int? id_tarefa = null}){
    this.start_timestamp = start_timestamp;
    this.stop_timestamp = stop_timestamp;
    this.id_funcionario = id_funcionario;
    this.id_tarefa = id_tarefa;
  }
}