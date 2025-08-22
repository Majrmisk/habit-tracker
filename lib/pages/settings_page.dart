import 'package:flutter/material.dart';
import 'package:habit_tracker/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../utils/grid_color_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: scheme.surface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Theme', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),

              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('auto')),
                  ButtonSegment(value: ThemeMode.light, label: Text('light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('dark')),
                ],
                showSelectedIcon: false,
                selected: {themeProv.mode},
                onSelectionChanged: (s) => themeProv.setMode(s.first),
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.selected)
                        ? scheme.primary : scheme.surfaceContainerHighest;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.selected)
                        ? scheme.onPrimary : scheme.onSurfaceVariant;
                  }),
                  side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
                ),
              ),

              const SizedBox(height: 18),

              SwitchListTile(
                title: const Text('Auto color (Material You)'),
                subtitle: const Text('Use system palette'),
                value: themeProv.useDynamic,
                onChanged: (v) => themeProv.setUseDynamic(v),
              ),

              const SizedBox(height: 8),

              if (!themeProv.useDynamic)
                GridColorPicker(
                  palette: themePalette,
                  picked: themeProv.seed,
                  onPick: themeProv.setSeed,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
