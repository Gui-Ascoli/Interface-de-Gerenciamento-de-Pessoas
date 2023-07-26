import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

  List<String> itens = ['A','B',' C'];
  List<int> colorCodes = [600, 500, 100];

  Widget _BodyTaskPage(){
    return ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: itens.length,
        itemBuilder: (context, index){
          return Container(
            height: 100,
            color: Colors.amber[colorCodes[index]],
            child: Center(
              child: InkWell(
                child: Text(
                  'Tarefa ${itens[index]}',
                  style:const TextStyle(fontSize: 50),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed ('/StartPage');

                },
              ),
            ),
          );
        },
      );
  }

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Tarefas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _BodyTaskPage(),
      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed("/AddTarefaPage");
          }
          
      ),
    );
  }
}