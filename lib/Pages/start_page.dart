import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../helpers/route_names.dart';
import '../helpers/database_helper.dart';
import '../models/screenshot.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  DatabaseHelper db = DatabaseHelper();
  bool finalizar = false;
  final ScreenshotController _screenshotController = ScreenshotController();
  final ScreenshotOps _screenshot = ScreenshotOps();

  Widget _bodyStartPage() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.black, width: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          finalizar = true;
                          Navigator.of(context).pushReplacementNamed(
                              RouteNames.rotaRegisterPage,
                              arguments: finalizar);
                        },
                        child: Image.asset('assets/images/stop4.png')),
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
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.black, width: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          finalizar = false;
                          Navigator.of(context).pushReplacementNamed(
                              RouteNames.rotaRegisterPage,
                              arguments: finalizar);
                        },
                        child: Image.asset('assets/images/start1.png')),
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
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
          backgroundColor: Colors.lightBlue.shade100,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Axtor',
              style: TextStyle(
                color: Colors.black,
                fontSize: 50.0,
              ),
            ),
            backgroundColor: Colors.blue,
          ),
          body: _bodyStartPage(),
          floatingActionButton: Stack(
            children: [
              Positioned(
                right: 16.0,
                bottom: 20.0,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        RouteNames.rotaListFuncionarioPage);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              Positioned(
                right: 16.0,
                bottom: 90.0,
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RouteNames.rotaListTarefaPage);
                  },
                  child: const Icon(Icons.inbox_sharp),
                ),
              ),
              Positioned(
                right: 16.0,
                bottom: 160.0,
                child: FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        RouteNames.rotaAddTarefaNoFuncionarioPage);
                  },
                  child: const Icon(Icons.access_alarms),
                ),
              ),
              Positioned(
                right: 16.0,
                bottom: 230.0,
                child: FloatingActionButton(
                  heroTag: "btn4",
                  onPressed: () async {
                    _screenshotController
                        .captureAndSave(await _screenshot.takePath());
                    print('screenshot registrada!');
                  },
                  child: const Icon(Icons.screenshot),
                ),
              ),
            ],
          )),
    );
  }
}
