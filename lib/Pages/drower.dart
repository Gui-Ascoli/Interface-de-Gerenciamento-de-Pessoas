import 'package:banco/models/Funcionario.dart';
import 'package:flutter/material.dart';

class CustomDrawer {
  final TextEditingController _controller = TextEditingController();
  String _text = '';
  Funcionario _funcionario = Funcionario();

  CustomDrawer();

  ClipRRect drawerAdd(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Drawer(
        elevation: 12.0,
        child: Column(
          children: [
            Expanded(
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    controller: _controller,
                    decoration: const InputDecoration(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (value) {
                      _text = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      if (text.contains('Funcionario')) {
                        _funcionario.insert();
                      } else if (text.contains('Tarefa')) {
                        _funcionario.insert();
                      }
                    },
                    color: Colors.black,
                    icon: Icon(
                      Icons.control_point,
                      color: Colors.greenAccent.shade400,
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              flex: 60,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  ClipRRect drawerEdit(
    String text,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Drawer(
        //shape: const CircleBorder(side: BorderSide(width: 2)),
        elevation: 12.0,
        child: Column(
          children: [
            Expanded(
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    controller: _controller,
                    decoration: const InputDecoration(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (value) {
                      _funcionario.nome = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (text.contains('Funcionario')) {
                        await _funcionario.update();
                      } else if (text.contains('Tarefa')) {
                        await _funcionario.update();
                      }
                    },
                    color: Colors.black,
                    icon: Icon(
                      Icons.check,
                      color: Colors.greenAccent.shade400,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 60,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
