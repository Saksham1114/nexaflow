import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../models/water_entry.dart';

class WaterNotifier extends StateNotifier<List<WaterEntry>> {
  WaterNotifier(this._storage) : super(_loadFromStorage(_storage));

  final StorageService _storage;
  static const String _storageKey = 'nexaflow_water_entries';

  static List<WaterEntry> _loadFromStorage(StorageService storage) {
    final rawList = storage.getJsonList(_storageKey);
    if (rawList == null || rawList.isEmpty) return const [];

    final allEntries = rawList.map((e) => WaterEntry.fromJson(e)).toList();
    final now = DateTime.now();

    return allEntries.where((e) {
      return e.time.year == now.year &&
          e.time.month == now.month &&
          e.time.day == now.day;
    }).toList();
  }

  void _persist() {
    _storage.setJsonList(_storageKey, state.map((e) => e.toJson()).toList());
  }

  void addWater(int ml) {
    state = [
      WaterEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: ml,
        time: DateTime.now(),
      ),
      ...state,
    ];
    _persist();
  }

  void clearToday() {
    state = [];
    _persist();
  }

  int get totalWater {
    return state.fold(0, (sum, entry) => sum + entry.amount);
  }
}

final waterProvider = StateNotifierProvider<WaterNotifier, List<WaterEntry>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return WaterNotifier(storage);
});

