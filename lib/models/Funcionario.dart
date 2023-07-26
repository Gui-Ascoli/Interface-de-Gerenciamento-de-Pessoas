import 'package:banco/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Funcionario{
  //Conexão com o banco
  final String _funcinaroTableName = "Funcionario";
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_funcinaroTableName,toMap());
    return resultado;
  }

  Future<int>update() async{
    var db = await database!;
    var resultado = await db.update(_funcinaroTableName,toMap(),
      where: "Id = ?",
      whereArgs: [id]);
    return resultado;
  }

  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_funcinaroTableName,
      where: "Id = ?",
      whereArgs: [id]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' :id,
      'nome':nome,
      'apto' :_apto
    };
    return map;
  }

  Funcionario.fromMap(Map<String,dynamic> map){
    id = map['Id'];
    nome = map['Nome'];
    _apto = map['Apto'];
  }

  late String createScript = '''CREATE TABLE IF NOT EXISTS Funcionario (
                                  Id INTEGER PRIMARY KEY AUTOINCREMENT,
                                  Nome TEXT,
                                  Apto INTEGER
                                )''';
                                
  late String dropScript = 'DROP TABLE IF EXISTS Funcionario';
   //Fim

  late int? id;
  late String nome;
  late int _apto;

  Funcionario({this.id,this.nome = '' , bool apto = true}){
    _apto = (apto == true) ? 1 : 0;
  }

  bool get apto{
    return (_apto == 1);
  }
  
  set apto(bool value){
    _apto = (value == true) ? 1 : 0;
  }


}