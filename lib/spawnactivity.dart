import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySpawnPage(title: 'Adventure Game Demo'),
    );
  }
}

class MySpawnPage extends StatefulWidget {
  const MySpawnPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySpawnPage> createState() => _MySpawnPageState();
}

class _MySpawnPageState extends State<MySpawnPage> {
  Map gameMap = Map(10, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        Text('SKELETON')
      ),
    );
  }
}

class Map {
  late List<List<Activity?>> grid;
  int numRows;
  int numCols;

  Map(this.numRows, this.numCols) {
    initializeMap();
  }

  void initializeMap() {
    grid = List.generate(numRows, (row) => List.filled(numCols, null));
  }

  bool isValidCell(int row, int col) {
    return row >= 0 && row < numRows && col >= 0 && col < numCols;
  }
}

class Activity {
  String name;

  Activity(this.name);
}

