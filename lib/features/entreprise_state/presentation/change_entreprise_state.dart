import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../../../shared/components/base_scaffold.dart';
import '../domain/get_companies_use_case.dart';
import '../domain/get_states_use_case.dart';
import '../domain/update_company_state_use_case.dart';
import '../models/company_model.dart';
import 'widgets/status_dropdown.dart';
import '../models/state_model.dart';
import 'widgets/stepper_controls.dart';
import 'widgets/company_dropdown.dart';
import 'widgets/confirmation_message.dart';

class ChangeEntrepriseStatePage extends StatefulWidget {
  final GetCompaniesUseCase getCompaniesUseCase;
  final GetStatesUseCase getStatesUseCase;
  final UpdateCompanyStateUseCase updateCompanyStateUseCase;

  const ChangeEntrepriseStatePage({
    Key? key,
    required this.getCompaniesUseCase,
    required this.getStatesUseCase,
    required this.updateCompanyStateUseCase,
  }) : super(key: key);

  @override
  _ChangeEntrepriseStatePageState createState() =>
      _ChangeEntrepriseStatePageState();
}

class _ChangeEntrepriseStatePageState extends State<ChangeEntrepriseStatePage> {
  int _currentStep = 0;
  CompanyModel? _selectedCompany;
  StateModel? _selectedState;
  bool _showConfirmationMessage = false;

  late Future<List<CompanyModel>> _companiesFuture;
  late Future<List<StateModel>> _statesFuture;

  @override
  void initState() {
    super.initState();
    _companiesFuture = widget.getCompaniesUseCase.execute();
    _statesFuture = widget.getStatesUseCase.execute();
  }

  void _onNext() async {
    if (_currentStep == 0) {
      if (_selectedCompany != null) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_selectedState != null && _selectedCompany != null) {
        final success = await widget.updateCompanyStateUseCase.execute(
          _selectedCompany!.id,
          _selectedState!.id,
        );
        if (success) {
          setState(() {
            _showConfirmationMessage = true;
          });
        }
      }
    }
  }

  void _onPrevious() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Nouvel état!',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Une entreprise a changé d\'état aujourd\'hui ! Veuillez le mettre à jour maintenant.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: 10),
            Stepper(
              currentStep: _currentStep,
              physics: NeverScrollableScrollPhysics(),
              controlsBuilder: (context, details) {
                return StepperControls(
                  onNext: _onNext,
                  onPrevious: _onPrevious,
                  isNextEnabled:
                      (_currentStep == 0 && _selectedCompany != null) ||
                      (_currentStep == 1 && _selectedState != null),
                  isPreviousEnabled: _currentStep > 0,
                  isFinishStep: _currentStep == 1,
                );
              },
              steps: [
                Step(
                  title: Text('Entreprise'),
                  isActive: _currentStep >= 0,
                  state: _selectedCompany != null
                      ? StepState.complete
                      : StepState.indexed,
                  content: FutureBuilder<List<CompanyModel>>(
                    future: _companiesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Erreur: ${snapshot.error}');
                      }
                      final companies = snapshot.data ?? [];
                      SizedBox(height: 30);
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          CompanyDropdown(
                            companies: companies,
                            selectedCompany: _selectedCompany,
                            onChanged: (company) {
                              setState(() => _selectedCompany = company);
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                ),

                Step(
                  title: Text('Etat'),
                  isActive: _currentStep >= 1,
                  state: _selectedState != null
                      ? StepState.complete
                      : StepState.indexed,
                  content: FutureBuilder<List<StateModel>>(
                    future: _statesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Erreur: ${snapshot.error}');
                      }
                      final states = snapshot.data ?? [];
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          StatusDropdown(
                            states: states,
                            selectedState: _selectedState,
                            onChanged: (state) {
                              setState(() => _selectedState = state);
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ConfirmationMessageBar(
              visible: _showConfirmationMessage,
              message: 'Vous avez changé l\'état d\'une entreprise!',
            ),
          ],
        ),
      ),
      currentIndex: 0,
      onNavTap: (int index) {},
    );
  }
}
