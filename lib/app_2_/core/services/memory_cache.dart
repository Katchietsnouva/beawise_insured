import 'package:flutter_riverpod/flutter_riverpod.dart';

// void _updateCache(String key, dynamic value) {
//   ref.read(memoryCacheProvider)[key] = value;
// }

class MemoryCacheService {
  final Map<String, dynamic> _cache = {};

  void put(String key, dynamic value) {
    _cache[key] = value;
  }

  dynamic get(String key) => _cache[key];
  bool containsKey(String key) => _cache.containsKey(key);
  void remove(String key) => _cache.remove(key);
  void clear() => _cache.clear();
  Map<String, dynamic> getAll() => Map.unmodifiable(_cache);
}

// final memoryCacheProvider = Provider<Map<String, dynamic>>((ref) => {});
final memoryCacheProvider = Provider<MemoryCacheService>((ref) {
  return MemoryCacheService();
});

final signUpCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);
final loginCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);
final dashboardCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);
final clientsCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);

final clientAddPopupCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);

final motorFormCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);

final motorSaveCacheProvider = Provider<MemoryCacheService>(
  (ref) => MemoryCacheService(),
);


// final dashboardCache = ref.read(dashboardCacheProvider);
// // Store  selected filter, scroll position 
// dashboardCache.put('selectedFilter', 'active');