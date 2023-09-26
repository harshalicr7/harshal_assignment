import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:newassn/data/repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository = ChatRepository();
  ChatBloc() : super(ChatInitial()) {
    on<AddNewMessageEvent>((event, emit) async {
      emit(ChatLoadingState(isLoading: true));
      try {
        await _chatRepository.addNewMessage(event.message);
        emit(ChatSuccessState());
      } catch (e) {
        emit(ChatErrorState(error: e.toString()));
      }
    });
  }
}
