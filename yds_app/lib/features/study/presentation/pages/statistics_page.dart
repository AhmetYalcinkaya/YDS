import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/study_plan_repository.dart';
import '../providers/study_plan_controller.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  late Future<Map<String, int>> _weeklyProgressFuture;
  late Future<Map<String, int>> _categoryBreakdownFuture;
  late Future<Map<String, int>> _difficultyBreakdownFuture;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(studyPlanRepositoryProvider);
    _weeklyProgressFuture = repo.getWeeklyProgress();
    _categoryBreakdownFuture = repo.getCategoryBreakdown();
    _difficultyBreakdownFuture = repo.getDifficultyBreakdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detaylı İstatistikler')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeeklyProgressSection(),
            const SizedBox(height: 32),
            _buildCategoryBreakdownSection(),
            const SizedBox(height: 32),
            _buildDifficultyBreakdownSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Haftalık İlerleme',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, int>>(
              future: _weeklyProgressFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Veri yüklenemedi'));
                }

                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Henüz veri yok'),
                    ),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (data.values.reduce((a, b) => a > b ? a : b) + 5)
                          .toDouble(),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < data.keys.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    data.keys.elementAt(index),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: data.entries
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.value.toDouble(),
                                  color: Theme.of(context).primaryColor,
                                  width: 16,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdownSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori Dağılımı',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, int>>(
              future: _categoryBreakdownFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Veri yüklenemedi'));
                }

                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Henüz veri yok'),
                    ),
                  );
                }

                return Column(
                  children: data.entries.map((entry) {
                    final total = data.values.reduce((a, b) => a + b);
                    final percentage = (entry.value / total * 100).toInt();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getCategoryName(entry.key),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${entry.value} ($percentage%)',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: entry.value / total,
                            backgroundColor: Colors.grey[200],
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBreakdownSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zorluk Seviyesi Dağılımı',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, int>>(
              future: _difficultyBreakdownFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Veri yüklenemedi'));
                }

                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Henüz veri yok'),
                    ),
                  );
                }

                final orderedLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
                final orderedData = {
                  for (var level in orderedLevels)
                    if (data.containsKey(level)) level: data[level]!,
                };

                return Column(
                  children: orderedData.entries.map((entry) {
                    final total = data.values.reduce((a, b) => a + b);
                    final percentage = (entry.value / total * 100).toInt();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${entry.value} ($percentage%)',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: entry.value / total,
                            backgroundColor: Colors.grey[200],
                            color: _getDifficultyColor(entry.key),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(String category) {
    const categoryNames = {
      'noun': 'İsim',
      'verb': 'Fiil',
      'adjective': 'Sıfat',
      'adverb': 'Zarf',
      'preposition': 'Edat',
      'conjunction': 'Bağlaç',
      'pronoun': 'Zamir',
      'other': 'Diğer',
    };
    return categoryNames[category] ?? category;
  }

  Color _getDifficultyColor(String level) {
    switch (level) {
      case 'A1':
        return Colors.green;
      case 'A2':
        return Colors.lightGreen;
      case 'B1':
        return Colors.yellow[700]!;
      case 'B2':
        return Colors.orange;
      case 'C1':
        return Colors.deepOrange;
      case 'C2':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
