
import 'package:banco/Pages/AdminOptions/list_funcionario_page.dart';
import 'package:banco/Pages/AdminOptions/add_funcionarios_page.dart';
import 'package:flutter/material.dart';
import 'package:banco/Pages/start_page.dart';
import 'package:banco/Pages/register_page.dart';
import '../helpers/route_names.dart';
import 'AdminOptions/add_tarefa_no_funcionario_page.dart';
import 'AdminOptions/add_tarefa_page.dart';
import 'AdminOptions/adm_options_page.dart';

class AppRouter extends StatelessWidget{
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/StartPage',
      routes: {
        RouteNames.rotaStartPage :(context) => const StartPage(),
        RouteNames.rotaRegisterPage :(context) => const RegisterPage(),
        RouteNames.rotaListFuncionarioPage :(context) => const ListFuncionarioPage(),
        RouteNames.rotaListTarefaPage :(context) => const AdmOptionsPage(),
        RouteNames.rotaAddFuncionariosPage :(context) => const AddFuncionariosPage(),
        RouteNames.rotaAddTarefaNoFuncionarioPage :(context) => const AddTarefaNoFuncionarioPage(),
        RouteNames.rotaAddTarefaPage :(context) => const AddTarefaPage(),
      },
    );
  }
}