import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newassn/data/repository/post_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<OnLoginEvent>((event, emit) async {
      emit(LoginLoadingState(isLoading: true));
      try {
        await authRepository.login(event.email, event.password);
        emit(LoginSuccessState(
            data: const {'message': 'User logged in successfully!'}));
      } on Exception catch (e) {
        emit(LoginErrorState(error: e));
      }
    });
  }
}
