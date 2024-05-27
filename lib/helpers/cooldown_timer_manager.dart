import 'package:flame/components.dart';
import 'package:talacare/components/point.dart';

class CooldownTimerManager {
  final double cooldownDuration;
  final Map<ActivityPoint, Timer> coolDownTimers = {};

  CooldownTimerManager({required this.cooldownDuration});

  void startCooldown(ActivityPoint point, Function onCooldownEnd) {
    coolDownTimers[point] = Timer(cooldownDuration, onTick: () {
      onCooldownEnd();
    });
  }

  void update(double dt) {
    List<ActivityPoint> completedTimers = [];

    coolDownTimers.forEach((point, timer) {
      timer.update(dt);
      if (timer.finished) {
        completedTimers.add(point);
      }
    });

    // Remove the completed timers
    for (final point in completedTimers) {
      coolDownTimers.remove(point);
    }
  }
}
