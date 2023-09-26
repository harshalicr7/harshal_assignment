part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class OnLoginEvent extends LoginEvent {
  final String email;
  final String password;

  OnLoginEvent({required this.email, required this.password});
}
