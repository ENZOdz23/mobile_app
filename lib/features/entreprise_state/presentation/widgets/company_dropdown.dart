import 'package:flutter/material.dart';
import '../../models/company_model.dart';

class CompanyDropdown extends StatelessWidget {
  final List<CompanyModel> companies;
  final CompanyModel? selectedCompany;
  final ValueChanged<CompanyModel?> onChanged;

  const CompanyDropdown({
    super.key,
    required this.companies,
    required this.selectedCompany,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CompanyModel>(
      decoration: InputDecoration(
        labelText: 'Sélectionner une entreprise',
        border: OutlineInputBorder(),
      ),
      initialValue: selectedCompany,
      items: companies
          .map(
            (company) => DropdownMenuItem(
              value: company,
              child: Text(company.name),
            ),
          )
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
