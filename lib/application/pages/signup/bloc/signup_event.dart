part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class OnLoading extends SignupEvent {}

class OnSignupEvent extends SignupEvent {
  final String email;
  final String password;
  final File profileImage;
  final String userName;

  OnSignupEvent(
      {required this.email,
      required this.password,
      required this.profileImage,
      required this.userName});
}
