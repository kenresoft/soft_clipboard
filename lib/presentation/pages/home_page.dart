import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_clipboard/presentation/blocs/clipboard/clipboard_bloc.dart';
import 'package:soft_clipboard/presentation/blocs/settings/settings_bloc.dart';
import 'package:soft_clipboard/presentation/pages/clipboard_history_page.dart';
import 'package:soft_clipboard/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [
    ClipboardHistoryPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();

    // Start listening to clipboard changes
    context.read<ClipboardBloc>().add(StartListeningToClipboard());
  }

  @override
  void dispose() {
    // Stop listening to clipboard changes
    context.read<ClipboardBloc>().add(StopListeningToClipboard());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get theme from settings
    final settingsState = context.watch<SettingsBloc>().state;
    bool isDarkMode = false;

    if (settingsState is SettingsLoaded) {
      isDarkMode = settingsState.darkMode;
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            label: 'Clipboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
