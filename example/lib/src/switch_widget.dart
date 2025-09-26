import 'package:flutter/material.dart';

class ToggleButtonWidget extends StatefulWidget {
  final String text;
  final ValueChanged<bool> callback;
  final bool initialState;

  const ToggleButtonWidget({
    super.key,
    required this.text,
    required this.callback,
    this.initialState = true,
  });

  @override
  State<ToggleButtonWidget> createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  late bool currentState;

  @override
  void initState() {
    super.initState();
    currentState = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: currentState
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          foregroundColor:
              currentState ? Colors.white : theme.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          setState(() => currentState = !currentState);
          widget.callback(currentState);
        },
        icon: Icon(
          currentState ? Icons.check_circle : Icons.radio_button_unchecked,
        ),
        label: Text(widget.text),
      ),
    );
  }
}
