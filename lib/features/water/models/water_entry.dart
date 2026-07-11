class WaterEntry {
  const WaterEntry({
    required this.id,
    required this.amount,
    required this.time,
  });

  final String id;
  final int amount;
  final DateTime time;

  WaterEntry copyWith({String? id, int? amount, DateTime? time}) {
    return WaterEntry(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      time: time ?? this.time,
    );
  }
}
