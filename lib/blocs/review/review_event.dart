part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

final class ReviewStarted extends ReviewEvent {}

final class ReviewCardRated extends ReviewEvent {
  final int cardId;
  final int currentLevel;
  final bool remembered;

  const ReviewCardRated({
    required this.cardId,
    required this.currentLevel,
    required this.remembered,
  });

  @override
  List<Object> get props => [cardId, currentLevel, remembered];
}
