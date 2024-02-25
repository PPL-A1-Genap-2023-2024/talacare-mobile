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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Activity activity = Activity('x');
                gameMap.spawnActivity(activity, 8);
                setState(() {}); // Update UI after spawning activity
              },
              child: Text('Game Start : Spawn Activity'),
            ),
            SizedBox(height: 20),
            Text(
              'Map Status:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display map status
            for (int i = 0; i < gameMap.numRows; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < gameMap.numCols; j++)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(
                          gameMap.grid[i][j]?.name ?? '-',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
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

  void spawnActivity(Activity activity, int numCells) {

    final randomCells = selectRandomCells(numCells);
    clearMap();
    for (final cell in randomCells) {
      final row = cell[0];
      final col = cell[1];

      grid[row][col] = activity;
      print('Spawned ${activity.name} at cell ($row, $col)');
    }
  }

  void clearMap(){
    for(int i=0;i<numRows;i++){
      for(int j=0;j<numCols;j++){
        grid[i][j]=Activity('');
      }
    }
  }

  List<List<int>> selectRandomCells(int numCells) {
    final random = Random();
    final selectedCells = <List<int>>[];

    while (selectedCells.length < numCells) {
      final row = random.nextInt(numRows);
      final col = random.nextInt(numCols);
      final cell = [row, col];

      if (!selectedCells.contains(cell)) {
        selectedCells.add(cell);
      }
    }

    return selectedCells;
  }

  bool isValidCell(int row, int col) {
    return row >= 0 && row < numRows && col >= 0 && col < numCols;
  }
}

class Activity {
  String name;

  Activity(this.name);
}

