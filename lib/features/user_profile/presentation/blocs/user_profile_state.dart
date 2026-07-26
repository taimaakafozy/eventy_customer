import '../../data/models/user_profile_model.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileModel profile;
  UserProfileLoaded(this.profile);
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}