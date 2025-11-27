import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yds_app/features/study/domain/entities/study_word.dart';
import 'package:yds_app/features/study/domain/repositories/study_plan_repository.dart';
import 'package:yds_app/features/study/presentation/providers/study_plan_controller.dart';

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
            return word.english.toLowerCase().contains(_searchQuery) ||
                word.turkish.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredWords.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredWords.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final word = filteredWords[index];
              return ListTile(
                title: Text(
                  word.english,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(word.turkish),
                trailing: word.isUserWord
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditDialog(word),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(word),
                          ),
                        ],
                      )
                    : null,
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
}
