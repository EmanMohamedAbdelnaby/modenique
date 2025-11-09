import 'package:flutter/material.dart';
import 'core/utils/app/app_cubit.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Themes In Flutter'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AppCubit.get(context).selectTheme(ThemeModeState.light);
              },
              child: Text('Light Mode'),
            ),
            ElevatedButton(
              onPressed: () {
                AppCubit.get(context).selectTheme(ThemeModeState.dark);
              },
              child: Text('Dark Mode'),
            ),
            ElevatedButton(
              onPressed: () {
                AppCubit.get(context).selectTheme(ThemeModeState.system);
              },
              child: Text('System Default'),
            ),
          ],
        ),
      ),
    );
  }
}
