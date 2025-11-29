import 'package:flutter/material.dart';
import '../core/theme/colors.dart';

class AddWordScreen extends StatelessWidget {
  const AddWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thêm từ mới'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 24),
          _buildAiCard(context),
          const SizedBox(height: 32),
          _buildRecentWordsHeader(context),
          const SizedBox(height: 16),
          _buildRecentWordsList(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Nhập từ tiếng Anh hoặc tiếng Việt...',
        prefixIcon: const Icon(Icons.search, color: AppColors.subtextColor),
        filled: true,
        fillColor: AppColors.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildAiCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Tạo từ vựng bằng AI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Mô tả ý nghĩa bạn muốn, AI sẽ tạo từ + nghĩa + ví dụ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtextColor,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Bắt đầu với AI'),
          )
        ],
      ),
    );
  }

  Widget _buildRecentWordsHeader(BuildContext context) {
    return Text(
      'Đã thêm gần đây',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildRecentWordsList(BuildContext context) {
    final recentWords = [
      {'word': 'Ephemeral', 'meaning': 'Lasting for a very short time.'},
      {'word': 'Ubiquitous', 'meaning': 'Present, appearing, or found everywhere.'},
      {'word': 'Mellifluous', 'meaning': 'A sound that is sweet and smooth.'},
    ];

    return Column(
      children: recentWords.map((item) {
        return Dismissible(
          key: Key(item['word']!),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Handle delete action
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['word']!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      item['meaning']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.subtextColor,
                          ),
                    ),
                  ],
                ),
                const Icon(Icons.drag_handle, color: AppColors.inactive),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}