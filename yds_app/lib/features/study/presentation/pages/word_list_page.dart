import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yds_app/features/study/domain/entities/study_word.dart';
import 'package:yds_app/features/study/domain/repositories/study_plan_repository.dart';
import 'package:yds_app/features/study/presentation/providers/study_plan_controller.dart';
import 'package:yds_app/core/theme/theme_provider.dart';

class WordListPage extends ConsumerStatefulWidget {
  const WordListPage({super.key, required this.status, required this.title});

  final WordStatus status;
  final String title;

  @override
  ConsumerState<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends ConsumerState<WordListPage> {
  late Future<List<StudyWord>> _wordsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  String? _selectedCategory;
  String? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _wordsFuture = ref
        .read(studyPlanRepositoryProvider)
        .getWordsByStatus(widget.status);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme mode to force rebuild when theme changes
    ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Kelime ara...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : Text(widget.title),
        actions: [
          // Filter button
          if (!_isSearching)
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color:
                    (_selectedCategory != null || _selectedDifficulty != null)
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: () => _showFilterDialog(),
            ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<StudyWord>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bu kategoride kelime yok.'));
          }

          final allWords = snapshot.data!;
          final filteredWords = allWords.where((word) {
            final matchesSearch =
                word.english.toLowerCase().contains(_searchQuery) ||
                word.turkish.toLowerCase().contains(_searchQuery);
            final matchesCategory =
                _selectedCategory == null || word.category == _selectedCategory;
            final matchesDifficulty =
                _selectedDifficulty == null ||
                word.difficultyLevel == _selectedDifficulty;
            return matchesSearch && matchesCategory && matchesDifficulty;
          }).toList();

          if (filteredWords.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredWords.length,
            itemBuilder: (context, index) {
              final word = filteredWords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word.english,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  word.turkish,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (word.isUserWord)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  onPressed: () => _showEditDialog(word),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  onPressed: () => _showDeleteDialog(word),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (word.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                word.category!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          if (word.difficultyLevel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                word.difficultyLevel!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(StudyWord word) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kelimeyi Sil'),
        content: Text(
          '${word.english} kelimesini silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(studyPlanRepositoryProvider).deleteUserWord(word.id);
      _refreshList();
    }
  }

  Future<void> _showEditDialog(StudyWord word) async {
    final englishController = TextEditingController(text: word.english);
    final turkishController = TextEditingController(text: word.turkish);
    final sentenceController = TextEditingController(
      text: word.exampleSentence,
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kelimeyi Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: englishController,
              decoration: const InputDecoration(labelText: 'İngilizce'),
            ),
            TextField(
              controller: turkishController,
              decoration: const InputDecoration(labelText: 'Türkçe'),
            ),
            TextField(
              controller: sentenceController,
              decoration: const InputDecoration(labelText: 'Örnek Cümle'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result == true) {
      final updatedWord = word.copyWith(
        english: englishController.text,
        turkish: turkishController.text,
        exampleSentence: sentenceController.text,
      );
      await ref.read(studyPlanRepositoryProvider).updateUserWord(updatedWord);
      _refreshList();
    }
  }

  void _refreshList() {
    setState(() {
      _wordsFuture = ref
          .read(studyPlanRepositoryProvider)
          .getWordsByStatus(widget.status);
    });
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrele'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Tümü', null, _selectedCategory, (value) {
                  setState(() => _selectedCategory = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('İsim', 'noun', _selectedCategory, (value) {
                  setState(() => _selectedCategory = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('Fiil', 'verb', _selectedCategory, (value) {
                  setState(() => _selectedCategory = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('Sıfat', 'adjective', _selectedCategory, (
                  value,
                ) {
                  setState(() => _selectedCategory = value);
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Zorluk', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Tümü', null, _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('A1', 'A1', _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('A2', 'A2', _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('B1', 'B1', _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('B2', 'B2', _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('C1', 'C1', _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
                _buildFilterChip('C2', 'C2', _selectedDifficulty, (value) {
                  setState(() => _selectedDifficulty = value);
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String? value,
    String? currentValue,
    Function(String?) onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: currentValue == value,
      onSelected: (selected) => onSelected(selected ? value : null),
    );
  }
}
