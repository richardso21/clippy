import 'dart:async';

import 'package:flutter/material.dart';
// Clipboard
import 'package:flutter/services.dart';
// Socket + utf-8 decode
import 'dart:io';
import 'dart:convert';

void main() async {
  // run app
  runApp(MyApp());
  // close socket
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Clippy Mobile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool switchBool = true;
  String _currentClip = "No clip yet!";
  String ip = '127.0.1.1';
  int port = 8080;
  Socket s;

  @override
  void initState() {
    super.initState();
    // setup listener
    _setListener(ip, port);
  }

  void _setListener(ip, port) async {
    if (s != null) {
      await s.close();
    }

    s = await Socket.connect(ip, port);
    
    s.listen((event) {
      setState(() {
        if (switchBool) {
          _currentClip = utf8.decode(event);
          print(_currentClip);
        }
      });
    });
    // Socket.connect(ip, port).then((socket) => {
    //       s = socket.listen((event) {
    //         setState(() {
    //           if (switchBool) {
    //             _currentClip = utf8.decode(event);
    //             print(_currentClip);
    //           }
    //         });
    //       })
    //     });
  }

  void _updateCurrentClip() {
    Clipboard.setData(new ClipboardData(text: _currentClip));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Switch(
              value: switchBool,
              onChanged: (value) {
                setState(() {
                  switchBool = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            Text(
              '$_currentClip',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            OutlineButton(
              onPressed: () {
                ip = '127.0.1.1';
                port = 8080;
                _setListener(ip, port);
                // setState(() {
                //   _currentClip = 'lol';
                // });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCurrentClip,
        tooltip: 'Add to Clipboard',
        child: Icon(Icons.assignment),
      ),
    );
  }
}
