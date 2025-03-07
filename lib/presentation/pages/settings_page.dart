import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_clipboard/presentation/blocs/settings/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDarkModeSwitch(context, state),
                const Divider(),
                _buildBackgroundServiceSwitch(context, state),
                const Divider(),
                _buildClipboardRetentionSettings(context, state),
                const Divider(),
                _buildMaxItemsSetting(context, state),
                const Divider(),
                _buildAdvancedSettings(context, state),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDarkModeSwitch(BuildContext context, SettingsLoaded state) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: state.darkMode,
      onChanged: (value) {
        context.read<SettingsBloc>().add(ToggleDarkMode());
      },
    );
  }

  Widget _buildBackgroundServiceSwitch(BuildContext context, SettingsLoaded state) {
    return SwitchListTile(
      title: const Text('Background Service'),
      subtitle: const Text('Keep clipboard monitoring active in background'),
      value: state.backgroundServiceEnabled,
      onChanged: (value) {
        context.read<SettingsBloc>().add(ToggleBackgroundService());
      },
    );
  }

  Widget _buildClipboardRetentionSettings(BuildContext context, SettingsLoaded state) {
    return ListTile(
      title: const Text('Clipboard Retention'),
      subtitle: const Text('Automatically clear old items after X days'),
      trailing: DropdownButton<int>(
        value: state.clipboardRetentionDays,
        items: const [
          DropdownMenuItem(value: 1, child: Text('1 day')),
          DropdownMenuItem(value: 3, child: Text('3 days')),
          DropdownMenuItem(value: 7, child: Text('7 days')),
          DropdownMenuItem(value: 14, child: Text('14 days')),
          DropdownMenuItem(value: 30, child: Text('30 days')),
        ],
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsBloc>().add(SetClipboardRetentionDays(value));
          }
        },
      ),
    );
  }

  Widget _buildMaxItemsSetting(BuildContext context, SettingsLoaded state) {
    return ListTile(
      title: const Text('Maximum Items'),
      subtitle: const Text('Maximum number of items to store'),
      trailing: DropdownButton<int>(
        value: state.maxItems,
        items: const [
          DropdownMenuItem(value: 50, child: Text('50')),
          DropdownMenuItem(value: 100, child: Text('100')),
          DropdownMenuItem(value: 200, child: Text('200')),
          DropdownMenuItem(value: 500, child: Text('500')),
        ],
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsBloc>().add(SetMaxItems(value));
          }
        },
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context, SettingsLoaded state) {
    return ExpansionTile(
      title: const Text('Advanced Settings'),
      children: [
        SwitchListTile(
          title: const Text('Group Similar Items'),
          subtitle: const Text('Group similar clipboard items together'),
          value: state.groupSimilarItems,
          onChanged: (value) {
            context.read<SettingsBloc>().add(ToggleGroupSimilarItems());
          },
        ),
        SwitchListTile(
          title: const Text('Auto-detect Content Types'),
          subtitle: const Text('Automatically detect content types (links, emails, etc.)'),
          value: state.autoDetectTypes,
          onChanged: (value) {
            context.read<SettingsBloc>().add(ToggleAutoDetectTypes());
          },
        ),
      ],
    );
  }
}
