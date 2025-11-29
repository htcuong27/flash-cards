import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flash_cards/models/flashcard_model.dart';
import 'package:flash_cards/supabase_client.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<ReviewStarted>(_onReviewStarted);
    on<ReviewCardRated>(_onReviewCardRated);
  }

  Future<void> _onReviewStarted(
    ReviewStarted event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(const ReviewError('User not logged in'));
        return;
      }

      final response = await supabase
          .from('words')
          .select()
          .eq('user_id', userId)
          .lte('next_review_at', DateTime.now().toIso8601String())
          .limit(10);

      final reviewCards = (response as List)
          .map((e) => FlashCard.fromJson(e as Map<String, dynamic>))
          .toList();

      if (reviewCards.isEmpty) {
        emit(ReviewCompleted());
      } else {
        emit(ReviewSessionActive(reviewCards: reviewCards));
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onReviewCardRated(
    ReviewCardRated event,
    Emitter<ReviewState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ReviewSessionActive) return;

    try {
      int newLevel = event.currentLevel;
      DateTime nextReview;

      if (event.remembered) {
        newLevel = (newLevel < 5) ? newLevel + 1 : 5;
      } else {
        newLevel = 1;
      }

      switch (newLevel) {
        case 1:
          nextReview = DateTime.now().add(const Duration(days: 1));
          break;
        case 2:
          nextReview = DateTime.now().add(const Duration(days: 3));
          break;
        case 3:
          nextReview = DateTime.now().add(const Duration(days: 7));
          break;
        case 4:
          nextReview = DateTime.now().add(const Duration(days: 14));
          break;
        case 5:
          nextReview = DateTime.now().add(const Duration(days: 30));
          break;
        default:
          nextReview = DateTime.now().add(const Duration(days: 1));
      }

      await supabase.from('words').update({
        'level': newLevel,
        'next_review_at': nextReview.toIso8601String(),
      }).eq('id', event.cardId);

      final nextIndex = currentState.currentIndex + 1;
      if (nextIndex < currentState.reviewCards.length) {
        emit(ReviewSessionActive(
          reviewCards: currentState.reviewCards,
          currentIndex: nextIndex,
        ));
      } else {
        emit(ReviewCompleted());
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
