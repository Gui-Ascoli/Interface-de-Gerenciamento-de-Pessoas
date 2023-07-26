import 'package:banco/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Categoria{

  //conexão com o banco e inserts/updates/deletes
  final String _categoriaTableNome = "Categoria";
  Future<Database>? database = DatabaseHelper().database;

  Future<int?>insert() async{
    Database db = await database!;
    var resultado = await db.insert(_categoriaTableNome,this.toMap());
    return resultado;
  }

  Future<int>update() async{
    Database db = await database!;
    var resultado = await db.update(_categoriaTableNome,this.toMap(),
      where: "Id = ?",
      whereArgs: [this.id]);
    return resultado;
  }

  Future<int>delete() async{
    Database db = await database!;
    var resultado = await db.delete(_categoriaTableNome,
      where: "Id = ?",
      whereArgs: [this.id]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' :id,
      'descricao':descricao
    };
    return map;
  }

  Categoria.fromMap(Map<String,dynamic> map){
    id = map['id'];
    descricao = map['Descricao'];
  }

  //Fim conexões banco 
  
  late int? id;
  late String descricao;

  Categoria({int? id = null,String descricao = ''}){
    this.id = id;
    this.descricao = descricao;
  }
}


  

