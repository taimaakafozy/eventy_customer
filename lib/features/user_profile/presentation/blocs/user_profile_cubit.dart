import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_user_profile_usecase.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  UserProfileCubit(this.getUserProfileUseCase) : super(UserProfileInitial());

  Future<void> loadProfile() async {
    emit(UserProfileLoading());
    try {
      final profile = await getUserProfileUseCase();
      emit(UserProfileLoaded(profile));
    } catch (e) {
      emit(UserProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}