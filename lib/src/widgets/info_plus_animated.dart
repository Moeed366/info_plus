import 'package:flutter/material.dart';
import 'package:info_plus/src/utils/alert_helper.dart';

class InfoPlusAnimated extends StatelessWidget {
  final InfoPlusHelper helper;
  final double finalWidth;
  final double finalHeight;
  final double textWidth;
  final double textHeight;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<double> topPosition;
  final VoidCallback onDismissed;
  final VoidCallback onActionPressed;
  final Key dismissKey;

  static const sequence1 = 30.0;
  static const sequence23 = 70.0;
  static const sequence2 = 65.0;
  static const sequence3 = 5.0;
  InfoPlusAnimated({
    super.key,
    required this.controller,
    required this.helper,
    required this.finalWidth,
    required this.finalHeight,
    required this.textWidth,
    required this.textHeight,
    required this.onDismissed,
    required this.onActionPressed,
    required this.dismissKey,
  })  : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.200,
              curve: Curves.ease,
            ),
          ),
        ),
        topPosition = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(
                begin: helper.isTop
                    ? -(finalHeight + 10)
                    : helper.maxHeight + finalHeight,
                end: helper.isTop
                    ? helper.padding
                    : helper.maxHeight - helper.padding - finalHeight,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
              weight: sequence1,
            ),
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(
                helper.isTop
                    ? helper.padding
                    : helper.maxHeight - helper.padding - finalHeight,
              ),
              weight: sequence23,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0),
          ),
        ),
        height = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: 55.0, end: 45.0).chain(
                CurveTween(curve: Curves.linear),
              ),
              weight: 20,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: 45.0, end: finalHeight).chain(
                CurveTween(curve: Curves.linear),
              ),
              weight: 10,
            ),
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(finalHeight),
              weight: 70,
            ),
            //
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0),
          ),
        ),
        width = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(44.0),
              weight: sequence1,
            ),
            TweenSequenceItem<double>(
              tween: Tween(
                begin: 44.0,
                end: finalWidth - 40,
              ).chain(
                CurveTween(curve: Curves.easeIn),
              ),
              weight: sequence2 / 2,
            ),
            TweenSequenceItem<double>(
              tween: Tween(
                begin: finalWidth - 40,
                end: finalWidth,
              ).chain(
                CurveTween(curve: Curves.elasticOut),
              ),
              weight: sequence2 / 2,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Positioned(
          left: (helper.maxWidth - width.value) / 2,
          top: topPosition.value,
          child: Material(
            elevation: 4, // gives a shadow
            borderRadius: BorderRadius.circular(40.0),
            color: Colors.transparent,
            child: Dismissible(
              key: dismissKey,
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                onDismissed.call();
              },
              child: Opacity(
                opacity: opacity.value,
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  width: width.value,
                  height: height.value,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    color: helper.backgroundColor,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: helper.backgroundColor.withValues(alpha: 0.3),
                        blurRadius: 11.0,
                        offset: helper.isThemeDark
                            ? const Offset(0, 1)
                            : const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Stack(
                    // clipBehavior: Clip.antiAlias,
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Positioned(
                        left: 10,
                        child: Icon(
                          helper.icon,
                          size: 25.0,
                          color: helper.iconColor,
                        ),
                      ),
                      Positioned(
                        left: 45,
                        child: SizedBox(
                          width: textWidth,
                          height: textHeight,
                          child: Text(
                            helper.text,
                            style: TextStyle(color: helper.textColor),
                            maxLines: 10,
                          ),
                        ),
                      ),
                      if (helper.action != null)
                        Positioned(
                          left: textWidth + 48,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 120,
                              maxHeight: 45,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: helper.actionColor,
                              ),
                              onPressed: onActionPressed,
                              child: Text(
                                helper.action!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
