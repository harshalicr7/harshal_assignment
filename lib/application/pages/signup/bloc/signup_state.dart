part of 'signup_bloc.dart';

abstract class SignupState {
  bool isLoading;
  Map<String, dynamic>? data;
  Exception? error;

  SignupState({this.isLoading = false, this.error, this.data});
}

class SignupInitial extends SignupState {
  SignupInitial({super.isLoading, super.data, super.error});
}

class SignupLoadingState extends SignupState {
  SignupLoadingState({super.isLoading, super.data, super.error});
}

class SignupErrorState extends SignupState {
  SignupErrorState({super.isLoading, super.data, super.error});
}

class SignupSuccessState extends SignupState {
  SignupSuccessState({super.isLoading, super.data, super.error});
}
