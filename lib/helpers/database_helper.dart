// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:banco/models/funcionario.dart';
import 'package:banco/models/stop_watch_tarefa.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/tarefa.dart';
import '../models/tarefa_do_funcionario.dart';

class DatabaseHelper {
  DatabaseHelper._();

  FutureOr<void> initConection() async{
    database;
}
  //static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._();
  factory DatabaseHelper() {
    return _instance;
  }
  static DatabaseHelper get instance {
    return DatabaseHelper();
  }

  //verifica se existe uma base de dados salva/caso nao exista cria uma.
  //inicializado por "sqfliteFfiInit();"
  static Database? _database;
  Future<Database> get database async {
    _database ??= await initialize();
    return _database!;
  }

  Future<FutureOr<void>> createTable() async {
    var db = await database;
    db.transaction((txn) async {
      await txn.execute(Funcionario().createScript);
      await txn.execute(StopWatchTarefa().createScript);
      await txn.execute(Tarefa().createScript);
      await txn.execute(TarefaDoFuncionario().createScript);
    });
  }
  
   FutureOr<void> dropDB()async{
    var db = await database;
    await db.transaction((txn) async{
      await txn.execute(Funcionario().dropScript);
      await  txn.execute(StopWatchTarefa().dropScript);
      await  txn.execute(Tarefa().dropScript);
      await  txn.execute(TarefaDoFuncionario().dropScript);
    }
    );
  }
  Future<Database?> initialize() async {
    //final dbPath = await getApplicationDocumentsDirectory(); windows
    Directory? dbPath = await getExternalStorageDirectory(); //android
    if(dbPath != null){
      final path = join(dbPath.path, 'my_database.db');
      final dbi =  await databaseFactoryFfi.openDatabase(path);
      return dbi;
    }else{
      return null;
    }
  }

//metodo retorna um item da lista (VIDEO)/ o primeiro item da lista
  Future<Funcionario?> getFuncionario(int id) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      "Funcionario",
      columns: ['Id', 'Nome', 'Apto'],
      where: 'Id = ?',
      whereArgs: [id],
    );
  //maps.length
    if (maps.isNotEmpty) {
      return Funcionario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Funcionario>>getAllFuncionarios() async{
    Database db = await database;
    var resultado = await db.query("Funcionario");
    List<Funcionario>lista = 
    resultado.isNotEmpty ? resultado.map((c) => Funcionario.fromMap(c)).toList() : [];
    return lista;
  }

  Future<List<Tarefa>>getAllTarefas() async{
    Database db = await database;
    var resultado = await db.query("Tarefa");
    List<Tarefa>lista = 
    resultado.isNotEmpty ? resultado.map((c) => Tarefa.fromMap(c)).toList() : [];
    return lista;
  }

  Future<List<TarefaDoFuncionario>>getAllTarefasDoFuncionario() async{
    Database db = await database;
    var resultado = await db.query("TarefaDoFuncionario");
    List<TarefaDoFuncionario>lista = 
    resultado.isNotEmpty ? resultado.map((c) => TarefaDoFuncionario.fromMap(c)).toList() : [];
    return lista;
  }

  Future<List<StopWatchTarefa>>getAllTimeStampTarefaDoFuncionario() async{
    Database db = await database;
    var resultado = await db.query("TimeStampTarefaDoFuncionario");
    List<StopWatchTarefa> lista = resultado.isNotEmpty ? resultado.map((c) => StopWatchTarefa.fromMap(c)).toList() : [];
    return lista;
  }

  //metodo obtem o numero de objetos nome no banco de dados
  Future<int?>getNomesCount() async{
    Database db = await database;
    List<Map<String,dynamic>> x = await db.rawQuery("SELECT COUNT (*) from Funcionario");
    int? resultado = Sqflite.firstIntValue(x);
    return resultado;
  }
}
