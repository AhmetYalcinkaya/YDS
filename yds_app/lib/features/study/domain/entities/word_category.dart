enum WordCategory {
  noun('İsim', 'noun'),
  verb('Fiil', 'verb'),
  adjective('Sıfat', 'adjective'),
  adverb('Zarf', 'adverb'),
  preposition('Edat', 'preposition'),
  conjunction('Bağlaç', 'conjunction'),
  pronoun('Zamir', 'pronoun'),
  other('Diğer', 'other');

  final String displayName;
  final String value;

  const WordCategory(this.displayName, this.value);

  static WordCategory fromString(String value) {
    return WordCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WordCategory.noun,
    );
  }
}
