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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'time': time.toIso8601String(),
    };
  }

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      id: json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      amount: json['amount'] as int? ?? 0,
      time: json['time'] != null
          ? DateTime.tryParse(json['time'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
