import 'package:example/src/switch_widget.dart';
import 'package:example/src/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:info_plus/info_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTop = true;
  bool _isLightTheme = true;
  bool _hasAction = false;
  final _textController = TextEditingController(
    text: '🎉 Congratulations! This is your first animated info.',
  );

  void _showInfo(TypeInfo typeInfo) {
    InfoPlus.show(
      padding: 50,
      context: context,
      text: _textController.text,
      typeInfo: typeInfo,
      position: _isTop ? MessagePosition.top : MessagePosition.bottom,
      action: _hasAction ? 'Undo' : null,
      actionCallback: _hasAction ? () => debugPrint('Undo clicked') : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        themeMode: _isLightTheme ? ThemeMode.light : ThemeMode.dark,
        theme: ThemeService.lightTheme,
        darkTheme: ThemeService.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Info Plus Example'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    ' Message Text Field',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your message...',
                  ),
                ),
                const SizedBox(height: 24),
                ToggleButtonWidget(
                  text: 'Show at Top',
                  initialState: _isTop,
                  callback: (value) => setState(() => _isTop = value),
                ),
                ToggleButtonWidget(
                  text: 'Light Theme',
                  initialState: _isLightTheme,
                  callback: (value) => setState(() => _isLightTheme = value),
                ),
                ToggleButtonWidget(
                  text: 'With Action',
                  initialState: _hasAction,
                  callback: (value) => setState(() => _hasAction = value),
                ),
                const SizedBox(height: 16),
                Divider(),
                const SizedBox(height: 16),
                ...[
                  {'label': 'Simple Info', 'type': TypeInfo.info},
                  {'label': 'Success Info', 'type': TypeInfo.success},
                  {'label': 'Warning Info', 'type': TypeInfo.warning},
                  {'label': 'Error Alert', 'type': TypeInfo.error},
                ].map(
                  (btn) => Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, left: 130, right: 130),
                    child: ElevatedButton(
                      onPressed: () => _showInfo(btn['type'] as TypeInfo),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(btn['label'] as String),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
