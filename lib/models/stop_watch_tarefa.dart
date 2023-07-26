import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class StopWatchTarefa{

  final String _tarefaTableNome = "StopWatchTarefa";
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_tarefaTableNome,toMap());
    return resultado;
  }

  //todo: criar update
  Future<int?>inserirTimeStamp() async{
    Database db = await database!;
    var map = <String,dynamic>{
      'start_timestamp' : 'datetime("now")',
      'id_funcionario' : idFuncionario,
      'id_tarefa' :idTarefa,
    };
    var resultado = await db.insert(_tarefaTableNome,map);
    return resultado;
  }

  Future<int>fecharTarefasAbertas() async{
    Database db = await database!;
    var resultado = await db.update(_tarefaTableNome,{'stop_timestamp': 'datetime("now")'},
      where: "id_funcionario = ? and stop_timestamp is null",
      whereArgs: [idFuncionario]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'start_timestamp' : startTimestamp,
      'stop_timestamp'  : stopTimestamp,
      'id_funcionario' : idFuncionario,
      'id_tarefa' :idTarefa,
    };
    return map;
  }

  StopWatchTarefa.fromMap(Map<String,dynamic> map){
    startTimestamp = map['start_timestamp'];
    stopTimestamp = map['stop_timestamp'];
    idFuncionario = map['id_funcionario'];
    idTarefa = map['id_tarefa'];
  }


  late String createScript = '''CREATE TABLE IF NOT EXISTS StopWatchTarefa (
                                  Id INTEGER PRIMARY KEY AUTOINCREMENT,
                                  start_timestamp DATETIME,
                                  stop_timestamp DATETIME,
                                  id_funcionario INTEGER,
                                  id_tarefa INTEGER
                                )''';
                                
  late String dropScript = 'DROP TABLE IF EXISTS StopWatchTarefa';

   //Fim

  late int id;
  late DateTime? startTimestamp;
  late DateTime? stopTimestamp;
  late int? idFuncionario;
  late int? idTarefa;

  StopWatchTarefa({this.startTimestamp , this.stopTimestamp , this.idFuncionario , this.idTarefa});
}