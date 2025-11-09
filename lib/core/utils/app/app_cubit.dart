import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/services/cache/cache_helper.dart';
import 'package:nti_final_project_new/core/services/cache/cache_helper_key.dart';
import 'package:nti_final_project_new/core/utils/app/app_state.dart';

enum ThemeModeState { light, dark, system }

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState()) {
    _loadTheme();
  }

  // 1. Select Theme (light,dark,system)
  // 2. get Theme (ThemeMode)
  // 3. Load Theme

  static AppCubit get(context) => BlocProvider.of(context);

  ThemeModeState currentTheme = ThemeModeState.system;

  Future<void> selectTheme(ThemeModeState theme) async {
    currentTheme = theme;

    await CacheHelper().saveData(
      key: CacheHelperKey.themeMode,
      value: currentTheme.name,
    );

    emit(ThemeChangedState());
  }

  ThemeMode getTheme() {
    switch (currentTheme) {
      case ThemeModeState.light:
        return ThemeMode.light;
      case ThemeModeState.dark:
        return ThemeMode.dark;
      case ThemeModeState.system:
        return ThemeMode.system;
    }
  }

  Future<void> _loadTheme() async {
    String? savedTheme = await CacheHelper().getData(
      key: CacheHelperKey.themeMode,
    );

    if (savedTheme != null) {
      currentTheme = ThemeModeState.values.firstWhere(
        (element) => element.name == savedTheme,
        orElse: () => ThemeModeState.system,
      );
    }
    emit(ThemeChangedState());
  }
}
