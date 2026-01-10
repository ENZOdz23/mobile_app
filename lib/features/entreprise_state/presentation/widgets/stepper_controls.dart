import 'package:flutter/material.dart';

class StepperControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isNextEnabled;
  final bool isPreviousEnabled;
  final bool isFinishStep;

  const StepperControls({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.isNextEnabled,
    required this.isPreviousEnabled,
    required this.isFinishStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFinishStep)
          ElevatedButton(
            onPressed: isNextEnabled ? onNext : null,
            child: Text('Suivant'),
          ),
        
        if (isFinishStep)
          ElevatedButton(
            onPressed: isNextEnabled ? onNext : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Terminer'),
          ),
        SizedBox(width: 12),
        TextButton(
          onPressed: isPreviousEnabled ? onPrevious : null,
          child: Text('Précédent', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
