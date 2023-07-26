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

  Future<int>delete() async{
    var db = await database!;
    var resultado = await db.delete(_tarefaTableNome,
      where: "id_funcionario = ? and id_tarefa = ?",
      whereArgs: [this.id_funcionario,this.id_tarefa]);
    return resultado;
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id_funcionario' : id_funcionario,
      'id_tarefa' :id_tarefa,
    };
    return map;
  }

  TarefaDoFuncionario.fromMap(Map<String,dynamic> map){
    id_funcionario = map['id_funcionario'];
    id_tarefa = map['id_tarefa'];
  }

   //Fim

  late int? id_funcionario;
  late int? id_tarefa;

  TarefaDoFuncionario({int? id_funcionario = null,int? id_tarefa = null}){
    this.id_funcionario = id_funcionario;
    this.id_tarefa = id_tarefa;
  }
}