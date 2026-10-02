import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/heatmap_day_data.dart';
import '../../providers/heatmap_provider.dart';

class ProductivityHeatmapCard extends ConsumerWidget {
  const ProductivityHeatmapCard({super.key});

  Color _getCellColor(int score, bool isDark) {
    if (score == 0) {
      return isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.05);
    } else if (score <= 2) {
      return const Color(0xFF34D399).withValues(alpha: 0.45);
    } else if (score <= 4) {
      return const Color(0xFF10B981);
    } else {
      return const Color(0xFF059669);
    }
  }

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  String _formatDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _months[date.month - 1];
    return '$weekday, $month ${date.day}, ${date.year}';
  }

  void _showDayDetails(BuildContext context, HeatmapDayData dayData) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateStr = _formatDate(dayData.date);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getCellColor(dayData.score, isDark),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  dateStr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (dayData.score == 0)
              Text(
                'No productivity contributions logged on this day.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              )
            else ...[
              _buildMetricTile(
                icon: Icons.check_circle_rounded,
                color: Colors.blue,
                label: 'Tasks Completed',
                value: '${dayData.tasksCompleted}',
              ),
              const SizedBox(height: 10),
              _buildMetricTile(
                icon: Icons.repeat_rounded,
                color: Colors.purple,
                label: 'Habits Checked',
                value: '${dayData.habitsCompleted}',
              ),
              const SizedBox(height: 10),
              _buildMetricTile(
                icon: Icons.timer_rounded,
                color: Colors.amber,
                label: 'Focus Time',
                value: '${dayData.focusMinutes} mins',
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matrix = ref.watch(heatmapMatrixProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sortedDates = matrix.days.keys.toList()..sort();
    final int totalWeeks = (sortedDates.length / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.grid_on_rounded, color: Color(0xFF10B981), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Activity Heatmap',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${matrix.totalContributions} Contributions',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Scrollable Grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Scroll to newest weeks by default
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekday labels
                Padding(
                  padding: const EdgeInsets.only(right: 6, top: 2),
                  child: Column(
                    children: [
                      _buildWeekdayLabel('M'),
                      const SizedBox(height: 3),
                      _buildWeekdayLabel('T'),
                      const SizedBox(height: 3),
                      _buildWeekdayLabel('W'),
                      const SizedBox(height: 3),
                      _buildWeekdayLabel('T'),
                      const SizedBox(height: 3),
                      _buildWeekdayLabel('F'),
                      const SizedBox(height: 3),
                      _buildWeekdayLabel('S'),
                      const SizedBox(height: 3),
                      _buildWeekdayLabel('S'),
                    ],
                  ),
                ),

                // Heatmap Weeks
                Row(
                  children: List.generate(totalWeeks, (colIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: List.generate(7, (rowIndex) {
                          final dateIndex = colIndex * 7 + rowIndex;
                          if (dateIndex >= sortedDates.length) {
                            return const SizedBox(width: 14, height: 14);
                          }
                          final date = sortedDates[dateIndex];
                          final dayData = matrix.days[date]!;
                          final cellColor = _getCellColor(dayData.score, isDark);

                          return GestureDetector(
                            onTap: () => _showDayDetails(context, dayData),
                            child: Container(
                              width: 14,
                              height: 14,
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: cellColor,
                                borderRadius: BorderRadius.circular(3.5),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.04),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Legend and Metrics Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${matrix.totalActiveDays} active days',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Legend
              Row(
                children: [
                  Text(
                    'Less',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildLegendCell(_getCellColor(0, isDark)),
                  const SizedBox(width: 2),
                  _buildLegendCell(_getCellColor(2, isDark)),
                  const SizedBox(width: 2),
                  _buildLegendCell(_getCellColor(4, isDark)),
                  const SizedBox(width: 2),
                  _buildLegendCell(_getCellColor(6, isDark)),
                  const SizedBox(width: 4),
                  Text(
                    'More',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabel(String text) {
    return SizedBox(
      height: 14,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLegendCell(Color color) {
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
