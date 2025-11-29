import 'package:flash_cards/blocs/auth/auth_bloc.dart';
import 'package:flash_cards/blocs/word/word_bloc.dart';
import 'package:flash_cards/core/theme/colors.dart';
import 'package:flash_cards/models/flashcard_model.dart';
import 'package:flash_cards/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WordBloc>().add(WordLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<WordBloc, WordState>(
          builder: (context, state) {
            if (state is WordLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WordError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is WordLoaded) {
              return ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildChart(context, state.words),
                  const SizedBox(height: 24),
                  _ActivityTimeline(activity: state.activity),
                  const SizedBox(height: 24),
                  _buildStartReviewCard(context),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Thống kê học tập',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(AuthLogoutRequested());
          },
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<FlashCard> words) {
    // Calculate counts based on levels
    int level1 = 0, level2 = 0, level3 = 0, level4 = 0, level5 = 0;
    for (var word in words) {
      final level = word.level;
      if (level == 1) {
        level1++;
      } else if (level == 2)
        level2++;
      else if (level == 3)
        level3++;
      else if (level == 4)
        level4++;
      else if (level >= 5) level5++;
    }

    final chartData = [
      {'level': 'Mới', 'count': level1, 'color': AppColors.level1},
      {'level': 'Đang học', 'count': level2, 'color': AppColors.level2},
      {'level': 'Biết', 'count': level3, 'color': AppColors.level3},
      {'level': 'Thành thạo', 'count': level4, 'color': AppColors.level4},
      {'level': 'Thành thạo cao', 'count': level5, 'color': AppColors.level5},
    ];

    // Find the max count to normalize bar heights (e.g., max height is 150)
    int maxCount = 0;
    for (var d in chartData) {
      final count = d['count'] as int;
      if (count > maxCount) maxCount = count;
    }
    if (maxCount == 0) maxCount = 1; // Avoid division by zero

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chartData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = chartData[index];
          final count = item['count'] as int;
          final barHeight = count / maxCount * 150.0;
          return _BarChartColumn(
            level: item['level'] as String,
            count: count,
            color: item['color'] as Color,
            height: barHeight,
          );
        },
      ),
    );
  }

  Widget _buildStartReviewCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chuẩn bị ôn tập',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bắt đầu phiên ôn tập ngay bây giờ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtextColor,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Bắt đầu ôn tập'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BarChartColumn extends StatelessWidget {
  final String level;
  final int count;
  final Color color;
  final double height;

  const _BarChartColumn({
    required this.level,
    required this.count,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: height > 0 ? height : 4, // Minimum height for visibility
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          level,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtextColor,
              ),
        ),
      ],
    );
  }
}

class _ActivityTimeline extends StatelessWidget {
  final Map<DateTime, int> activity;

  const _ActivityTimeline({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lịch sử hoạt động',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
        ),
        const SizedBox(height: 16),
        _buildGrid(activity),
      ],
    );
  }

  Widget _buildGrid(Map<DateTime, int> data) {
    final today = DateTime.now();
    final days = List.generate(365, (index) {
      final date = today.subtract(Duration(days: 364 - index));
      return DateTime(date.year, date.month, date.day);
    });

    return SizedBox(
      height: 100, // 7 rows * (10px cell + 4px spacing)
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 days a week
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: 365,
        itemBuilder: (context, index) {
          final date = days[index];
          final count = data[date] ?? 0;
          return _buildCell(count);
        },
      ),
    );
  }

  Widget _buildCell(int count) {
    Color color;
    if (count > 4) {
      color = const Color(0xFF196127); // Dark green
    } else if (count > 0) {
      color = const Color(0xFF44a340); // Light green
    } else {
      color = Colors.grey[200]!; // Grey for empty
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
