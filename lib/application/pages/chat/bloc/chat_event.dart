part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class AddNewMessageEvent extends ChatEvent {
  final String message;

  AddNewMessageEvent({required this.message});
}
