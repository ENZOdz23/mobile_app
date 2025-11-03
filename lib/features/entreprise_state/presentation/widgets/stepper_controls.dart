import 'package:flutter/material.dart';

class StepperControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isNextEnabled;
  final bool isPreviousEnabled;
  final bool isFinishStep;

  const StepperControls({
    Key? key,
    required this.onNext,
    required this.onPrevious,
    required this.isNextEnabled,
    required this.isPreviousEnabled,
    required this.isFinishStep,
  }) : super(key: key);

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
            child: Text('Terminer'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
