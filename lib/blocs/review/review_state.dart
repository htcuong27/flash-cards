part of 'review_bloc.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  
  @override
  List<Object> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewSessionActive extends ReviewState {
  final List<FlashCard> reviewCards;
  final int currentIndex;

  const ReviewSessionActive({
    required this.reviewCards,
    this.currentIndex = 0,
  });

  @override
  List<Object> get props => [reviewCards, currentIndex];
}

final class ReviewCompleted extends ReviewState {}

final class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object> get props => [message];
}
