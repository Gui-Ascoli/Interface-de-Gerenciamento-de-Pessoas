import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';




class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {


  DatabaseHelper db = DatabaseHelper();
  bool finalizar = false;


  @override
  void initState() {
    super.initState();
      //db.initialize();
    }

  Widget _BodyStartPage(){
    return Row(
        children:<Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:const EdgeInsets.all(10.0), 
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          //primary: Colors.black,//define a cor do texto do botao
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.black, width: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        //Como colorir esse botao?
                        onPressed:(){
                          finalizar = true;
                          Navigator.of(context).pushReplacementNamed ('/RegisterPage',arguments: finalizar);
                        },
                                      
                        child:Image.asset('assets/images/stop4.png')
                                      
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:const EdgeInsets.all(10.0), 
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          //primary: Colors.black,//define a cor do texto do botao
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.black, width: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        //Como colorir esse botao?
                        onPressed:(){
                          finalizar = false;
                          Navigator.of(context).pushReplacementNamed ('/RegisterPage',arguments: finalizar);
                        },
                                      
                        child:Image.asset('assets/images/start1.png')
                        
                        
                        
                        
                          /* const Text(
                          'Iniciar',
                          style: TextStyle(
                            fontSize: 100,
                            color:Colors.black,
                            ),
                          ),*/
                                      
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Axtor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _BodyStartPage(),

      floatingActionButton:
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed("/AdminOptionsPage");
          }
          
      ),
    );
  }
}

