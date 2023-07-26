import 'package:banco/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Funcionario{
  //Conexão com o banco
  final String _funcinaroColunaName = "Funcionario";

  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_funcinaroColunaName,this.toMap());
  
    return resultado;
  }
  Future<int>update() async{
    var db = await database!;
    var resultado = await db.update(_funcinaroColunaName,this.toMap(),
      where: "Id = ?",
      whereArgs: [this.id]);
    return resultado;
  }
  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_funcinaroColunaName,
      where: "Id = ?",
      whereArgs: [this.id]);
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
    _apto = map['APTO'];
  }

   //Fim

  late int? id;
  late String nome;
  late int _apto;

  Funcionario({int? id = null,String nome = '' , bool apto = true}){
    this.id = id;
    this.nome = nome;
    this._apto = (apto == true) ? 1 : 0;
  }

  bool get apto{
    return (_apto == 1);
  }
  set apto(bool value){
    _apto = (value == true) ? 1 : 0;
  }
}