import 'package:flutter/material.dart';
import 'package:info_plus/info_plus.dart';

class AlertHelperTest {
  static get infoWidget => widgetCreator(
        onPressed: (context) {
          InfoPlus.show(context: context, text: 'Test alert info');
        },
      );
  static get warningWidget => widgetCreator(
        onPressed: (context) {
          InfoPlus.show(
            context: context,
            text: 'Test alert warning',
            typeInfo: TypeInfo.warning,
          );
        },
      );
  static get errorWidget => widgetCreator(
        onPressed: (context) {
          InfoPlus.show(
            context: context,
            text: 'Test alert error',
            typeInfo: TypeInfo.error,
          );
        },
      );
  static get successWidget => widgetCreator(
        onPressed: (context) {
          InfoPlus.show(
            context: context,
            text: 'Test alert success',
            typeInfo: TypeInfo.success,
          );
        },
      );
}

widgetCreator({required Function onPressed}) => MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                onPressed(context);
              },
              child: const Text('Display alert'),
            );
          },
        ),
      ),
    );
