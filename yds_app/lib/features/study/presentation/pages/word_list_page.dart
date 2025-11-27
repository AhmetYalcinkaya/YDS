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

  @override
  void initState() {
    super.initState();
    _wordsFuture = ref
        .read(studyPlanRepositoryProvider)
        .getWordsByStatus(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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

          final words = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final word = words[index];
              return ListTile(
                title: Text(
                  word.english,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(word.turkish),
                trailing: word.isUserWord
                    ? const Icon(Icons.person, color: Colors.blue, size: 16)
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
