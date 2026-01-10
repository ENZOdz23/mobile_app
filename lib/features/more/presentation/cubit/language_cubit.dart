import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage_service.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LocalStorageService _localStorageService;

  LanguageCubit(this._localStorageService) : super(const LanguageState(Locale('en')));

  Future<void> loadLanguage() async {
    final languageCode = _localStorageService.getLanguage();
    if (languageCode != null) {
      emit(LanguageState(Locale(languageCode)));
    } else {
      emit(const LanguageState(Locale('en')));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await _localStorageService.saveLanguage(languageCode);
    emit(LanguageState(Locale(languageCode)));
  }
}
