// ignore_for_file: unnecessary_string_interpolations

import 'package:banco/models/Categoria.dart';
import 'package:banco/models/Funcionario.dart';
import 'package:banco/models/TimeStampTarefaDoFuncionario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/Tarefa.dart';
import '../models/TarefaDoFuncionario.dart';

class DatabaseHelper {
  DatabaseHelper._();

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
    if (_database == null) {
      _database = await initialize();
    }
    return _database!;
  }

    Future<Database> initialize() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'my_database.db');

      return await openDatabase(path, version: 1, onCreate: (db, version) {});
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

  Future<String> getTempoAtual() async {
    Database db = await database;

    final result = await db.rawQuery('SELECT datetime("now")');
    final currentTimestamp = result.first.values.first as String;

    return currentTimestamp;
    //print('Timestamp atual: $currentTimestamp');
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
      columns: ['Id', 'Descricai'],
      where: 'Id = ?',
      whereArgs: [id],
    );

  //maps.length
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

  Future<List<TimeStampTarefaDoFuncionario>>getAllTimeStampTarefaDoFuncionario() async{
    Database db = await database;
    var resultado = await db.query("TimeStampTarefaDoFuncionario");
    List<TimeStampTarefaDoFuncionario> lista = resultado.isNotEmpty ? resultado.map((c) => TimeStampTarefaDoFuncionario.fromMap(c)).toList() : [];

    return lista;
  }



//metodo retorna toda a lista funcionarios
  //metodo obtem o numero de objetos nome no banco de dados
  Future<int?>getNomesCount() async{
    Database db = await database;
    List<Map<String,dynamic>> x = await db.rawQuery("SELECT COUNT (*) from Funcionario");

      int? resultado = Sqflite.firstIntValue(x);
      return resultado;

  }
}
