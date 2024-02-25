import 'package:talacare/spawnactivity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Map', () {
    test('initializeMap should create a grid with the specified size', () {
      final map = Map(5, 5);
      map.initializeMap();

      expect(map.grid.length, equals(5));
      expect(map.grid.every((row) => row.length == 5), isTrue);
    });

    test('clearMap should set all cells to an empty Activity', () {
      final map = Map(5, 5);
      map.initializeMap();
      map.clearMap();

      expect(map.grid.every((row) => row.every((cell) => cell!.name.isEmpty)), isTrue);
    });

    test('isValidCell should return true for valid cell coordinates', () {
      final map = Map(5, 5);
      map.initializeMap();

      expect(map.isValidCell(0, 0), isTrue);
      expect(map.isValidCell(4, 4), isTrue);
    });

    test('isValidCell should return false for invalid cell coordinates', () {
      final map = Map(5, 5);
      map.initializeMap();

      expect(map.isValidCell(-1, 0), isFalse);
      expect(map.isValidCell(0, -1), isFalse);
      expect(map.isValidCell(5, 0), isFalse);
      expect(map.isValidCell(0, 5), isFalse);
    });

    test('spawnActivity should spawn activities in random cells', () {
      final map = Map(10, 10);
      map.initializeMap();
      map.spawnActivity(Activity('x'), 8);

      final activityCount = map.grid.expand((row) => row.where((cell) => cell!.name.isNotEmpty)).length;
      expect(activityCount, equals(8));
    });
  });
}
