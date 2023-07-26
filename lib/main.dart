import 'package:flutter/material.dart';
import 'package:banco/Pages/AppRouter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const AppRouter());
}

