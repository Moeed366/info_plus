import 'package:flutter/material.dart';
import 'package:info_plus/src/utils/alert_helper.dart';
import 'package:info_plus/src/utils/holder_widget.dart';
import 'package:info_plus/src/widgets/info_plus_animated.dart';

class InfoPlusWidget extends StatefulWidget {
  final VoidCallback onDismissed;
  final InfoPlusHelper helper;

  const InfoPlusWidget({
    super.key,
    required this.onDismissed,
    required this.helper,
  });

  @override
  State<InfoPlusWidget> createState() => _InfoPlusWidgetState();
}

class _InfoPlusWidgetState extends State<InfoPlusWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();
  final Key _dismissKey = UniqueKey();
  bool _isInitialized = false;
  bool _isDismissed = false;
  late double finalHeight;
  late double finalWidth;
  late double textWidth;
  late double textHeight;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final boxSize = _globalKey.currentContext?.size;
      final textSize = _textKey.currentContext?.size;
      if (boxSize == null || textSize == null) return;
      setState(() {
        finalHeight = boxSize.height;
        finalWidth = boxSize.width;
        textWidth = textSize.width;
        textHeight = textSize.height;
        _isInitialized = true;
      });
      _playAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await Future.delayed(Duration(seconds: widget.helper.duration));
      if (!mounted || _isDismissed) return;
      await _hide();
    } on TickerCanceled {
      //Ticker canceled (widget disposed or animation stopped)
    }
  }

  /// Plays the exit animation, then removes the alert from the overlay.
  Future<void> _hide() async {
    try {
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      return;
    }
    _dismiss();
  }

  void _dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;
    _controller.stop();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isInitialized)
          Positioned(
            top: -widget.helper.maxHeight,
            child: HolderWidget(
              globalKey: _globalKey,
              textKey: _textKey,
              helper: widget.helper,
            ),
          ),
        if (_isInitialized)
          InfoPlusAnimated(
            helper: widget.helper,
            controller: _controller.view,
            dismissKey: _dismissKey,
            finalWidth: finalWidth,
            finalHeight: finalHeight,
            textWidth: textWidth,
            textHeight: textHeight,
            onDismissed: _dismiss,
            onActionPressed: () {
              widget.helper.actionCallback?.call();
              if (!_isDismissed) _hide();
            },
          ),
      ],
    );
  }
}
