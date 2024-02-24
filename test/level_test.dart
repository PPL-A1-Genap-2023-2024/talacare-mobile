import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:talacare/levels/level.dart';
import 'package:talacare/talacare.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Game Map Tests', () {
    testWidgets('Map loads correctly in the game', (WidgetTester tester) async {
      await tester.pumpWidget(GameWidget(game: TalaCare()));

      await tester.pumpAndSettle();

      final gameWidget = tester.widget<GameWidget>(find.byType(GameWidget));
      final game = gameWidget.game as TalaCare;
      final level = game.descendants().whereType<Level>().first;
      expect(level.level.tileMap, isNotNull);
    });
  });
}
