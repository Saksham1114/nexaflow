import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/water_entry.dart';

class WaterNotifier extends StateNotifier<List<WaterEntry>> {
  WaterNotifier() : super(const []);

  void addWater(int ml) {
    state = [
      WaterEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: ml,
        time: DateTime.now(),
      ),
      ...state,
    ];
  }

  void clearToday() {
    state = [];
  }

  int get totalWater {
    return state.fold(0, (sum, entry) => sum + entry.amount);
  }
}

final waterProvider = StateNotifierProvider<WaterNotifier, List<WaterEntry>>(
  (ref) => WaterNotifier(),
);
