import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class TarefaDoFuncionario{

  final String _tarefaTableNome = "TarefaDoFuncionario";
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_tarefaTableNome,toMap());
    return resultado;
  }

  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_tarefaTableNome,
      where: "id_funcionario = ? and id_tarefa = ?",
      whereArgs: [idFuncionario,idTarefa]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id_funcionario' : idFuncionario,
      'id_tarefa' :idTarefa,
    };
    return map;
  }

  TarefaDoFuncionario.fromMap(Map<String,dynamic> map){
    idFuncionario = map['id_funcionario'];
    idTarefa = map['id_tarefa'];
  }

  late String createScript = '''CREATE TABLE IF NOT EXISTS TarefaDoFuncionario (
                                  id_funcionario INTEGER,
                                  id_tarefa INTEGER
                                )''';
                                
  late String dropScript = 'DROP TABLE IF EXISTS TarefaDoFuncionario ';

   //Fim

  late int? idFuncionario;
  late int? idTarefa;

  TarefaDoFuncionario({this.idFuncionario,this.idTarefa});
}