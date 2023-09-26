import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newassn/data/repository/post_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;
  SignupBloc({required this.authRepository}) : super(SignupInitial()) {
    on<OnSignupEvent>((event, emit) async {
      emit(SignupLoadingState(isLoading: true));
      try {
        await authRepository.signup(
            event.email, event.password, event.userName, event.profileImage);

        emit(SignupSuccessState(
            data: const {'message': 'User signed up successfully!'}));
      } on Exception catch (e) {
        emit(SignupErrorState(error: e));
      }
    });
  }
}
