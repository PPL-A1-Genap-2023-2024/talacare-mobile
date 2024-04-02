class Schedule {
  final int id;
  final int hour;
  final int minute;

  Schedule({required this.id, required this.hour, required this.minute});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      hour: json['hour'],
      minute: json['minute'],
    );
  }
}