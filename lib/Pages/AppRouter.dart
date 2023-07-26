
import 'package:banco/Pages/AdminOptions/ListFuncionarioPage.dart';
import 'package:banco/Pages/AdminOptions/AddFuncionariosPage.dart';
import 'package:flutter/material.dart';
import 'package:banco/Pages/StartPage.dart';
import 'package:banco/Pages/RegisterPage.dart';
import 'package:banco/Pages/TasksPage.dart';
import '../helpers/RouteNames.dart';
import 'AdminOptions/AddTarefaNoFuncionarioPage.dart';
import 'AdminOptions/AddTarefaPage.dart';
import 'AdminOptions/ListTarefaPage.dart';

class AppRouter extends StatelessWidget{
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/StartPage',
      routes: {
        RouteNames.rotaStartPage :(context) => const StartPage(),
        RouteNames.rotaRegisterPage :(context) => const RegisterPage(),
        RouteNames.rotaTasksPage :(context) => const TasksPage(),
        RouteNames.rotaListFuncionarioPage :(context) => const ListFuncionarioPage(),
        RouteNames.rotaListTarefaPage :(context) => const ListTarefaPage(),
        RouteNames.rotaAddFuncionariosPage :(context) => const AddFuncionariosPage(),
        RouteNames.rotaAddTarefaNoFuncionarioPage :(context) => const AddTarefaNoFuncionarioPage(),
        RouteNames.rotaAddTarefaPage :(context) => const AddTarefaPage(),
      },
    );
    
  

  }
}