import 'package:flutter/material.dart';

import 'main.dart';

class SettingsPage extends StatefulWidget {
  final Settings settings;
  const SettingsPage({Key? key, required this.settings}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BoolEntry(
            icon: Icons.grid_3x3,
            title: const Text("Grid hints"),
            initialValue: widget.settings.gridHints,
            subtitleBuilder: (value) {
              if (value) {
                return const Text("Will darken relevant cells.");
              } else {
                return const Text("No darkening will be applied.");
              }
            },
            onChange: (value) {
              widget.settings.set("grid_hints", value);
            },
          ),
          BoolEntry(
            icon: Icons.flashlight_on,
            title: const Text("Highlight same"),
            initialValue: widget.settings.highlightSame,
            subtitleBuilder: (value) {
              if (value) {
                return const Text("Will highlight values.");
              } else {
                return const Text("Will not highlight values.");
              }
            },
            onChange: (value) {
              widget.settings.set("highlight_same", value);
            },
          ),
          BoolEntry(
            icon: Icons.flashlight_on,
            title: const Text("Pre-fill different color"),
            initialValue: widget.settings.prefillDifferentColor,
            subtitleBuilder: (value) {
              if (value) {
                return const Text("Pre-filled cells will have another color.");
              } else {
                return const Text(
                    "Pre-filled cells will not have another color.");
              }
            },
            onChange: (value) {
              widget.settings.set("prefill_different_color", value);
            },
          ),
        ],
      ),
    );
  }
}

class BoolEntry extends StatefulWidget {
  final IconData icon;
  final Widget title;
  final bool initialValue;
  final Function(bool) subtitleBuilder;
  final Function(bool) onChange;

  const BoolEntry(
      {Key? key,
      required this.icon,
      required this.title,
      required this.initialValue,
      required this.subtitleBuilder,
      required this.onChange})
      : super(key: key);

  @override
  State<BoolEntry> createState() => _BoolEntryState();
}

class _BoolEntryState extends State<BoolEntry> {
  late bool _state;

  @override
  void initState() {
    _state = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon),
      title: widget.title,
      subtitle: widget.subtitleBuilder(_state),
      trailing: Checkbox(
          value: _state,
          onChanged: (value) {
            setState(() {
              _state = value ?? false;
            });
            widget.onChange(_state);
          }),
    );
  }
}
