import 'package:flash_cards/blocs/review/review_bloc.dart';
import 'package:flash_cards/core/theme/colors.dart';
import 'package:flash_cards/models/flashcard_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(ReviewStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ôn tập'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ReviewCompleted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Hoàn thành!'),
                content: const Text('Bạn đã hoàn thành phiên ôn tập hôm nay.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to home
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewSessionActive) {
            final card = state.reviewCards[state.currentIndex];
            final total = state.reviewCards.length;
            final current = state.currentIndex + 1;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Expanded(child: _buildFlashcard(context, card)),
                  _buildControls(context, card),
                  _buildProgressBar(context, current, total),
                ],
              ),
            );
          } else if (state is ReviewCompleted) {
             return const Center(child: Text('Đã hoàn thành ôn tập!'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFlashcard(BuildContext context, FlashCard card) {
    // Use a key to force rebuild when card changes, resetting the flip state
    return FlipCard(
      key: ValueKey(card.id),
      direction: FlipDirection.HORIZONTAL,
      front: _buildCardSide(
        context: context,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.word,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to flip',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtextColor,
                  ),
            ),
          ],
        ),
        showFlipIcon: true,
      ),
      back: _buildCardSide(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, 'Meaning', card.meaning),
              const Divider(height: 24),
              _buildInfoRow(context, 'Example', card.example),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSide({
    required BuildContext context,
    required Widget child,
    bool showFlipIcon = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(child: child),
          if (showFlipIcon)
            Positioned(
              top: 16,
              right: 16,
              child: Icon(Icons.flip_camera_android_outlined, color: AppColors.subtextColor),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.subtextColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, FlashCard card) {
    final cardId = card.id!;
    final currentLevel = card.level;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildReviewButton(
            context,
            'Quên',
            '1 ngày',
            AppColors.error,
            () => context.read<ReviewBloc>().add(ReviewCardRated(
                  cardId: cardId,
                  currentLevel: currentLevel,
                  remembered: false,
                )),
          ),
          _buildReviewButton(
            context,
            'Nhớ',
            'Tăng cấp',
            AppColors.success,
            () => context.read<ReviewBloc>().add(ReviewCardRated(
                  cardId: cardId,
                  currentLevel: currentLevel,
                  remembered: true,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewButton(
    BuildContext context,
    String label,
    String time,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, int current, int total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$current / $total', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: AppColors.inactive,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}