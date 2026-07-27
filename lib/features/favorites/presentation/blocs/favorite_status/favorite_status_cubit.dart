import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_to_favorite_usecase.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/usecases/remove_from_favorite_usecase.dart';
import 'favorite_status_state.dart';

class FavoriteStatusCubit extends Cubit<FavoriteStatusState> {
  final AddToFavoriteUseCase addToFavoriteUseCase;
  final RemoveFromFavoriteUseCase removeFromFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoriteStatusCubit(
    this.addToFavoriteUseCase,
    this.removeFromFavoriteUseCase,
    this.getFavoritesUseCase,
  ) : super(const FavoriteStatusState());

  bool _isFetching = false;
  static const int _maxPagesSafety = 20; // ⚠️ حد أمان لمنع حلقة لا نهائية

  static String keyOf(String targetType, String targetId) => '$targetType:$targetId';

  bool isFavorite(String targetType, String targetId) =>
      state.favoriteKeys.contains(keyOf(targetType, targetId));

  Future<void> loadFavoriteIds() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final keys = <String>{};
      int page = 1;
      const limit = 50;

      while (page <= _maxPagesSafety) {
        final response = await getFavoritesUseCase(page: page, limit: limit);

        for (final item in response.items) {
          keys.add(keyOf(item.targetType, item.targetId));
        }

        if (page >= response.meta.totalPages || response.items.isEmpty) break;
        page++;
      }

      emit(state.copyWith(favoriteKeys: keys));
    } catch (_) {
      // فشل التحميل الأولي لا يوقف التطبيق — الأيقونات تبقى بحالتها الافتراضية
    }

    _isFetching = false;
  }

  /// ⚠️ جديد: يعيد التحميل بالقوة حتى لو كان _isFetching فعّال سابقًا
  Future<void> refreshFavoriteIds() async {
    _isFetching = false;
    await loadFavoriteIds();
  }

  /// ⚠️ جديد: تصفير كامل — يُستدعى عند Logout لمنع تسرب مفضلات مستخدم سابق
  void clear() {
    _isFetching = false;
    emit(const FavoriteStatusState());
  }

  Future<void> toggleFavorite({required String targetType, required String targetId}) async {
    final key = keyOf(targetType, targetId);
    if (state.loadingKeys.contains(key)) return;

    final wasFavorite = state.favoriteKeys.contains(key);

    final optimisticKeys = Set<String>.from(state.favoriteKeys);
    wasFavorite ? optimisticKeys.remove(key) : optimisticKeys.add(key);

    emit(state.copyWith(
      favoriteKeys: optimisticKeys,
      loadingKeys: {...state.loadingKeys, key},
    ));

    try {
      if (wasFavorite) {
        await removeFromFavoriteUseCase(targetType: targetType, targetId: targetId);
      } else {
        await addToFavoriteUseCase(targetType: targetType, targetId: targetId);
      }

      emit(state.copyWith(loadingKeys: Set.from(state.loadingKeys)..remove(key)));
    } on DioException catch (e) {
      if (!wasFavorite && e.response?.statusCode == 409) {
        emit(state.copyWith(loadingKeys: Set.from(state.loadingKeys)..remove(key)));
        return;
      }

      final rollback = Set<String>.from(state.favoriteKeys);
      wasFavorite ? rollback.add(key) : rollback.remove(key);

      emit(state.copyWith(
        favoriteKeys: rollback,
        loadingKeys: Set.from(state.loadingKeys)..remove(key),
      ));

      final message = e.response?.data is Map
          ? (e.response?.data['message'] ?? 'Something went wrong')
          : (e.message ?? 'Something went wrong');
      throw Exception(message);
    }
  }

  /// ⚠️ جديد: حذف صريح بدون الاعتماد على state.favoriteKeys كمصدر للحقيقة —
/// يُستخدم من صفحة المفضلة حيث نعرف بشكل مؤكد أن العنصر مفضّل حاليًا
Future<void> removeFavorite({required String targetType, required String targetId}) async {
  final key = keyOf(targetType, targetId);
  if (state.loadingKeys.contains(key)) return;

  final optimisticKeys = Set<String>.from(state.favoriteKeys)..remove(key);
  emit(state.copyWith(favoriteKeys: optimisticKeys, loadingKeys: {...state.loadingKeys, key}));

  try {
    await removeFromFavoriteUseCase(targetType: targetType, targetId: targetId);
    emit(state.copyWith(loadingKeys: Set.from(state.loadingKeys)..remove(key)));
  } catch (e) {
    final rollback = Set<String>.from(state.favoriteKeys)..add(key);
    emit(state.copyWith(favoriteKeys: rollback, loadingKeys: Set.from(state.loadingKeys)..remove(key)));
    rethrow;
  }
}
}