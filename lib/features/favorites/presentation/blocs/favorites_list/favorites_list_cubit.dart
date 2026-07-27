import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/favorites_list_model.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import 'favorites_list_state.dart';

class FavoritesListCubit extends Cubit<FavoritesListState> {
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoritesListCubit(this.getFavoritesUseCase) : super(FavoritesListInitial());

  final List<FavoriteItemModel> _items = [];
  int _page = 1;
  final int _limit = 10;
  bool _hasReachedEnd = false;
  bool _isLoading = false;
  String? _targetType;

  Future<void> loadFavorites({String? targetType}) async {
    if (_isLoading) return;

    _targetType = targetType;
    _page = 1;
    _hasReachedEnd = false;
    _items.clear();
    _isLoading = true;

    emit(FavoritesListLoading());

    try {
      final response = await getFavoritesUseCase(page: _page, limit: _limit, targetType: targetType);

      _items.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(FavoritesListLoaded(items: List.from(_items), hasReachedEnd: _hasReachedEnd));
    } catch (e) {
      emit(FavoritesListError(e.toString().replaceFirst('Exception: ', '')));
    }

    _isLoading = false;
  }

  Future<void> loadMore() async {
    if (_isLoading || _hasReachedEnd) return;

    final currentState = state;
    if (currentState is! FavoritesListLoaded) return;

    _isLoading = true;

    try {
      final response = await getFavoritesUseCase(page: _page + 1, limit: _limit, targetType: _targetType);

      _page++;
      _items.addAll(response.items);
      _hasReachedEnd = response.meta.page >= response.meta.totalPages;

      emit(FavoritesListLoaded(items: List.from(_items), hasReachedEnd: _hasReachedEnd));
    } catch (_) {}

    _isLoading = false;
  }

  /// إزالة عنصر محليًا فور الحذف الناجح — بدون انتظار إعادة تحميل كامل القائمة
  void removeLocally(String targetType, String targetId) {
    _items.removeWhere((e) => e.targetType == targetType && e.targetId == targetId);
    emit(FavoritesListLoaded(items: List.from(_items), hasReachedEnd: _hasReachedEnd));
  }

  Future<void> refresh() => loadFavorites(targetType: _targetType);
}