import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Alice alice = Alice();

final client = Dio()..interceptors.add(alice.getDioInterceptor());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: alice.getNavigatorKey(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _get() {
    client.get(
      'https://jsonplaceholder.typicode.com/todos?type=some-type&weight=10',
      queryParameters: {
        'name': 'anatoly',
        'age': 30,
      },
    );
  }

  _post() {
    client.post('https://6212347701ccdac07434b998.mockapi.io/content');
  }

  _openAlice() {
    alice.showInspector();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: _get,
                child: Text('GET'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _post,
                child: Text('POST'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _openAlice,
                child: Text('OPEN ALICE'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
