part of 'word_bloc.dart';

sealed class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

final class WordLoadRequested extends WordEvent {}

final class WordAdded extends WordEvent {
  final String word;
  final String meaning;
  final String example;
  final int level;

  const WordAdded({
    required this.word,
    required this.meaning,
    required this.example,
    this.level = 1,
  });

  @override
  List<Object> get props => [word, meaning, example, level];
}
