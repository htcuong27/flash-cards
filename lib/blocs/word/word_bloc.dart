import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flash_cards/models/flashcard_model.dart';
import 'package:flash_cards/supabase_client.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  WordBloc() : super(WordInitial()) {
    on<WordLoadRequested>(_onWordLoadRequested);
    on<WordAdded>(_onWordAdded);
  }

  Future<void> _onWordLoadRequested(
    WordLoadRequested event,
    Emitter<WordState> emit,
  ) async {
    emit(WordLoading());
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(const WordError('User not logged in'));
        return;
      }

      // Fetch words
      final response = await supabase
          .from('words')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      final words = (response as List)
          .map((e) => FlashCard.fromJson(e as Map<String, dynamic>))
          .toList();

      // Fetch activity
      final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
      final activityResponse = await supabase
          .from('words')
          .select('created_at')
          .eq('user_id', userId)
          .gte('created_at', oneYearAgo.toIso8601String());

      final activity = <DateTime, int>{};
      for (final record in activityResponse) {
        final createdAt = DateTime.parse(record['created_at'] as String);
        final date = DateTime(createdAt.year, createdAt.month, createdAt.day);
        activity[date] = (activity[date] ?? 0) + 1;
      }

      emit(WordLoaded(words: words, activity: activity));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onWordAdded(
    WordAdded event,
    Emitter<WordState> emit,
  ) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(const WordError('User not logged in'));
        return;
      }

      await supabase.from('words').insert({
        'user_id': userId,
        'word': event.word,
        'meaning': event.meaning,
        'example': event.example,
        'level': event.level,
      });

      add(WordLoadRequested());
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }
}
