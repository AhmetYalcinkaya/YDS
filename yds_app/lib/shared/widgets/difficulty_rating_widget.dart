import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

/// Difficulty rating widget with three buttons
class DifficultyRatingWidget extends StatelessWidget {
  const DifficultyRatingWidget({required this.onRatingSelected, super.key});

  final void Function(Difficulty difficulty) onRatingSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _DifficultyButton(
          label: 'Kolay',
          color: Colors.green,
          icon: Icons.sentiment_very_satisfied,
          onPressed: () => onRatingSelected(Difficulty.easy),
        ),
        _DifficultyButton(
          label: 'Orta',
          color: Colors.orange,
          icon: Icons.sentiment_neutral,
          onPressed: () => onRatingSelected(Difficulty.medium),
        ),
        _DifficultyButton(
          label: 'Zor',
          color: Colors.red,
          icon: Icons.sentiment_very_dissatisfied,
          onPressed: () => onRatingSelected(Difficulty.hard),
        ),
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            minimumSize: const Size(0, 36),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
