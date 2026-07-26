import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_to_favorite_usecase.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final AddToFavoriteUseCase addToFavoriteUseCase;

  FavoriteCubit(this.addToFavoriteUseCase) : super(const FavoriteInitial());

  final Set<String> _loadingItems = {};

  Future<void> addToFavorite({
    required String targetType,
    required String targetId,
  }) async {
    if (_loadingItems.contains(targetId)) return;

    _loadingItems.add(targetId);

    emit(FavoriteLoading(targetId));

    try {
      await addToFavoriteUseCase(targetType: targetType, targetId: targetId);

      emit(FavoriteSuccess(targetId: targetId, isFavorite: true));
    } catch (e) {
      emit(
        FavoriteError(
          targetId: targetId,
          message: e.toString().replaceFirst("Exception: ", ""),
        ),
      );
      print("Error adding to favorite: ${e.toString()}");
    }

    _loadingItems.remove(targetId);
  }
}
