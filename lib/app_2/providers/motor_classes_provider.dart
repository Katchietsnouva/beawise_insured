import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/data/models/motor_class_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class MotorClassesState {
  final List<MotorClassOption> classes;
  final bool isLoading;
  final String? error;

  const MotorClassesState({
    this.classes = const [],
    this.isLoading = false,
    this.error,
  });

  MotorClassesState copyWith({
    List<MotorClassOption>? classes,
    bool? isLoading,
    String? error,
  }) {
    return MotorClassesState(
      classes: classes ?? this.classes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MotorClassesNotifier extends StateNotifier<MotorClassesState> {
  final Ref ref;
  late final MemoryCacheService _cache;

  MotorClassesNotifier(this.ref) : super(const MotorClassesState()) {
    _cache = ref.read(motorFormCacheProvider);
    final cached = _cache.get('motor_classes');
    if (cached is List) {
      state = MotorClassesState(
        classes: cached
            .whereType<Map<String, dynamic>>()
            .map(MotorClassOption.fromJson)
            .toList(),
      );
    }
    fetch(force: true);
  }

  Future<void> fetch({bool force = false}) async {
    if (state.isLoading) return;
    if (!force && state.classes.isNotEmpty) return;

    final auth = ref.read(authProvider);
    final user = auth.user;
    final token = auth.bearerToken;
    if (user == null || token == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final classes = await ApiService.getMotorClasses(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
      );
      _cache.put(
        'motor_classes',
        classes.map((motorClass) => motorClass.toJson()).toList(),
      );
      state = MotorClassesState(classes: classes);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final motorClassesProvider =
    StateNotifierProvider<MotorClassesNotifier, MotorClassesState>(
      (ref) => MotorClassesNotifier(ref),
    );
