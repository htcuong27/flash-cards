part of 'word_bloc.dart';

sealed class WordState extends Equatable {
  const WordState();
  
  @override
  List<Object> get props => [];
}

final class WordInitial extends WordState {}

final class WordLoading extends WordState {}

final class WordLoaded extends WordState {
  final List<FlashCard> words;
  final Map<DateTime, int> activity;

  const WordLoaded({required this.words, required this.activity});

  @override
  List<Object> get props => [words, activity];
}

final class WordError extends WordState {
  final String message;

  const WordError(this.message);

  @override
  List<Object> get props => [message];
}
