
import 'package:flutter/material.dart';


class CustomAppBar {
  static AppBar createAppBar({
    required BuildContext context, 
    String backRoute = '',
  }) {
    return AppBar(
        leading: Builder(builder: (BuildContext context){
          return BackButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(backRoute);
            },
          );
        }),
        centerTitle: true,
        title: const Text('Axtor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.blue,
      );
  }
}