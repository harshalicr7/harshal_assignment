part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoadingState extends ChatState {
  final bool isLoading;

  ChatLoadingState({required this.isLoading});
}

final class ChatSuccessState extends ChatState {
  ChatSuccessState();
}

final class ChatErrorState extends ChatState {
  final String error;

  ChatErrorState({required this.error});
}
