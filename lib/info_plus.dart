import 'package:flutter/material.dart';
import 'package:info_plus/src/utils/alert_helper.dart';
import 'package:info_plus/src/widgets/info_plus_widget.dart';

enum MessagePosition { top, bottom }

enum TypeInfo { warning, error, success, info }

OverlayEntry? _previousEntry;

/// Displays an animated alert info. Use [InfoPlus.show].
abstract final class InfoPlus {
  ///Display an animated Alert info
  ///
  ///Require the context and the text to be displayed
  ///
  ///There a four type of alert `warning`, `error`, `success`, `info`
  ///
  /// ```dart
  /// InfoPlus.show(
  ///   context: context,
  ///   text: 'Alert info demo',
  /// );
  /// ```
  ///
  /// - [text] : the text to be displayed
  /// - [position] : `MessagePosition.top` (default) or `MessagePosition.bottom`
  /// - [padding] : the padding from top or bottom, by default `30`
  /// - [duration] : the duration in seconds the alert stays visible, by default `3`
  /// - [typeInfo] : the type of the alert, by default `TypeInfo.info`.
  ///   It changes the default [icon] and [iconColor]:
  ///   - [TypeInfo.info] : `Icons.info_outline`, green
  ///   - [TypeInfo.success] : `Icons.check_circle_outline`, green
  ///   - [TypeInfo.warning] : `Icons.warning_amber_rounded`, orange
  ///   - [TypeInfo.error] : `Icons.error_outline`, red
  ///
  ///   The icon color uses the accent shade (e.g. `greenAccent`) when the
  ///   app theme is light (dark alert), and the regular shade (e.g. `green`)
  ///   when the app theme is dark (light alert).
  /// - [backgroundColor] : by default the surface color of the inverse theme
  /// - [textColor] : by default the onSurface color of the inverse theme
  /// - [action] : optional label of an action button
  /// - [actionColor] : text color of the action, by default the primary
  ///   color of the inverse theme
  /// - [actionCallback] : called when the [action] is pressed; the alert is
  ///   then dismissed
  static void show({
    required BuildContext context,
    required String text,
    MessagePosition position = MessagePosition.top,
    double padding = 30.0,
    int duration = 3,
    TypeInfo typeInfo = TypeInfo.info,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    String? action,
    VoidCallback? actionCallback,
    IconData? icon,
  }) {
    final OverlayState? overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return;

    final helper = InfoPlusHelper(
      context: context,
      text: text,
      position: position,
      padding: padding,
      duration: duration,
      action: action,
      actionCallback: actionCallback,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      actionColor: actionColor,
      typeInfo: typeInfo,
      icon: icon,
    );

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return InfoPlusWidget(
          helper: helper,
          onDismissed: () {
            if (overlayEntry.mounted) {
              overlayEntry.remove();
            }
            if (_previousEntry == overlayEntry) {
              _previousEntry = null;
            }
          },
        );
      },
    );
    if (_previousEntry != null && _previousEntry!.mounted) {
      _previousEntry!.remove();
    }
    overlayState.insert(overlayEntry);
    _previousEntry = overlayEntry;
  }
}
