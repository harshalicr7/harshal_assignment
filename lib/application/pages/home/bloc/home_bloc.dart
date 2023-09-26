import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newassn/data/repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository = UserRepository();
  HomeBloc() : super(HomeInitial()) {
    on<LoadUserEvent>((event, emit) async {
      emit(HomeLoadingState(isLoading: true));
      try {
        final user = await _userRepository.getUserInfo();
        final userList = (await _userRepository.getAllUsers() as List<dynamic>)
            .where((element) => element['username'] != user['username'])
            .toList();
        final otherUser = _userRepository.getOtherUser();
        emit(
          HomeSuccessState(
              username: user, userList: userList, otherUser: otherUser),
        );
      } catch (e) {
        emit(
          HomeErrorState(error: e.toString()),
        );
      }
    });
  }
}
