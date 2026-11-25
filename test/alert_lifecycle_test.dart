import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:info_plus/info_plus.dart';

import 'helpers_widgets.dart';

/// Taps the trigger button and pumps frames until the entrance animation
/// (400ms) has finished.
Future<void> _showAlert(WidgetTester tester) async {
  await tester.tap(find.text('Display alert'));
  await tester.pump(); // measure frame
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Waits for the auto-hide delay (3s) and the exit animation.
Future<void> _waitForAutoHide(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Alert is removed from the overlay after it hides',
      (WidgetTester tester) async {
    await tester.pumpWidget(AlertHelperTest.infoWidget);
    await _showAlert(tester);
    expect(find.text('Test alert info'), findsOneWidget);

    await _waitForAutoHide(tester);
    expect(find.text('Test alert info'), findsNothing);
  });

  testWidgets('Pressing the action calls back, uses actionColor and dismisses',
      (WidgetTester tester) async {
    var pressed = 0;
    await tester.pumpWidget(widgetCreator(
      onPressed: (context) => InfoPlus.show(
        context: context,
        text: 'With action',
        action: 'Undo',
        actionColor: Colors.pink,
        actionCallback: () => pressed++,
      ),
    ));
    await _showAlert(tester);

    final button = tester.widget<TextButton>(
      find.ancestor(of: find.text('Undo'), matching: find.byType(TextButton)),
    );
    expect(
      button.style?.foregroundColor?.resolve(<WidgetState>{}),
      Colors.pink,
    );

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(pressed, 1);
    expect(find.text('With action'), findsNothing);

    // Let the pending auto-hide delay elapse; it must be a no-op.
    await _waitForAutoHide(tester);
  });

  testWidgets('Swiping dismisses the alert', (WidgetTester tester) async {
    await tester.pumpWidget(AlertHelperTest.infoWidget);
    await _showAlert(tester);

    await tester.fling(
        find.text('Test alert info'), const Offset(500, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Test alert info'), findsNothing);

    await _waitForAutoHide(tester);
  });

  testWidgets('A new alert replaces the previous one',
      (WidgetTester tester) async {
    await tester.pumpWidget(AlertHelperTest.infoWidget);
    await _showAlert(tester);
    await _showAlert(tester);
    expect(find.text('Test alert info'), findsOneWidget);

    await _waitForAutoHide(tester);
    expect(find.text('Test alert info'), findsNothing);
  });
}
