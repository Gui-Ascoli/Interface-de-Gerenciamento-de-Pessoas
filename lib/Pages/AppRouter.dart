
import 'package:banco/Pages/AdminOptions/AdminOptionsPage.dart';
import 'package:banco/Pages/AdminOptions/AddFuncionariosPage.dart';
import 'package:flutter/material.dart';
import 'package:banco/Pages/StartPage.dart';
import 'package:banco/Pages/RegisterPage.dart';
import 'package:banco/Pages/TasksPage.dart';
import 'AdminOptions/AddTarefaNoFuncionarioPage.dart';
import 'AdminOptions/AddTarefaPage.dart';

class AppRouter extends StatelessWidget{
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/StartPage',
      routes: {
        '/AddTarefaNoFuncionarioPage' :(context) => const AddTarefaNoFuncionarioPage(),
        '/AddTarefaPage' :(context) => const AddTarefaPage(),
        '/StartPage' :(context) => const StartPage(),
        '/RegisterPage' :(context) => const RegisterPage(),
        '/TasksPage' :(context) => const TasksPage(),
        '/AdminOptionsPage' :(context) => const AdminOptionsPage(),
        '/AddFuncionariosPage' :(context) => const AddFuncionariosPage(),
      },
    );
  }
}