part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {
  final bool isLoading;

  HomeLoadingState({required this.isLoading});
}

final class HomeSuccessState extends HomeState {
  final dynamic username;
  final dynamic userList;
  final dynamic otherUser;

  HomeSuccessState(
      {required this.username,
      required this.userList,
      required this.otherUser});
}

final class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error});
}
