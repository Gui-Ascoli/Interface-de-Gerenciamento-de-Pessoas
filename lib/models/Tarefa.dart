import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class Tarefa{

  final String _tarefaTableNome = "Tarefa";
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_tarefaTableNome,toMap());
    return resultado;
  }

  Future<int>update() async{
    var db = await database!;
    var resultado = await db.update(_tarefaTableNome,toMap(),
      where: "Id = ?",
      whereArgs: [id]);
    return resultado;
  }

  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_tarefaTableNome,
      where: "Id = ?",
      whereArgs: [id]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' :id,
      'descricao' :descricao,
    };
    return map;
  }

  Tarefa.fromMap(Map<String,dynamic> map){
    id = map['Id'];
    descricao = map['Descricao'];
  }

  late String createScript = '''CREATE TABLE IF NOT EXISTS Tarefa (
                                  Id INTEGER PRIMARY KEY AUTOINCREMENT,
                                  Descricao TEXT
                                )''';
                                
  late String dropScript = 'DROP TABLE IF EXISTS Tarefa ';

   //Fim

  late int? id;
  late String descricao;

  Tarefa({this.id,this.descricao = ''});
}