// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:banco/models/Categoria.dart';
import 'package:banco/models/Funcionario.dart';
import 'package:banco/models/StopWatchTarefa.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/Tarefa.dart';
import '../models/TarefaDoFuncionario.dart';

class DatabaseHelper {
  DatabaseHelper._();

  FutureOr<void> initConection() async{
    this.database;
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

  Future<FutureOr<void>> CreateTable() async {
    var db = await database;
    db.transaction((txn) async {
      await txn.execute(Funcionario().CreateScript);
      await txn.execute(StopWatchTarefa().CreateScript);
      await txn.execute(Tarefa().CreateScript);
      await txn.execute(TarefaDoFuncionario().CreateScript);
    });
  }
  
   FutureOr<void> dropDB()async{
    var db = await database;
    await db.transaction((txn) async{
      await txn.execute(Funcionario().DropScript);
      await  txn.execute(StopWatchTarefa().DropScript);
      await  txn.execute(Tarefa().DropScript);
      await  txn.execute(TarefaDoFuncionario().DropScript);
    }
    );
  }
  Future<Database?> initialize() async {
    //final dbPath = await getApplicationDocumentsDirectory(); windows
    Directory? dbPath = await getExternalStorageDirectory(); //android
    if(dbPath != null){
      final path = join(dbPath.path, 'my_database.db');
      final dbi =  await databaseFactoryFfi.openDatabase(path, 
        
        );
      
      return dbi;
    }else{
      return null;
    }

  }
/*
  void preencherTabelas(){
    Funcionario f = Funcionario(id:1,nome:"anderson", apto: true);
    
  }
*/
/*
  Future<Database> createAllTables() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'my_database.db');
  final database = openDatabase(
    join(path),
    onCreate: (db, version) {
      // Código para criar tabelas e definir esquemas
    },
    version: 1,
  );
}
  }
*/

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

  Future<Categoria?> getCategoria(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      "Categoria",
      columns: ['Id', 'Descricao'],
      where: 'Id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Categoria.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Categoria>>getAllCategorias() async{
    Database db = await database;
    var resultado = await db.query("Categoria");
    List<Categoria>lista = 
    resultado.isNotEmpty ? resultado.map((c) => Categoria.fromMap(c)).toList() : [];
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
