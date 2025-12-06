import 'package:flutter/material.dart';
import '../../models/state_model.dart';

class StatusDropdown extends StatelessWidget {
  final List<StateModel> states;
  final StateModel? selectedState;
  final ValueChanged<StateModel?> onChanged;

  const StatusDropdown({
    super.key,
    required this.states,
    required this.selectedState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<StateModel>(
      decoration: InputDecoration(
        labelText: 'Sélectionner un état',
        border: OutlineInputBorder(),
      ),
      initialValue: selectedState,
      items: states
          .map(
            (state) => DropdownMenuItem(
              value: state,
              child: Text(state.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
