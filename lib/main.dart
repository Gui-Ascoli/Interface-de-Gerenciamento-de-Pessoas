import 'package:flutter/material.dart';
import 'package:banco/Pages/app_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'helpers/database_helper.dart';

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp( const AppRouter());
  var db = DatabaseHelper();
  await db.initConection();
  await db.createTable();
}