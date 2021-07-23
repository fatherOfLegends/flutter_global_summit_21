import 'dart:async';

import 'package:flutter_global_summit/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';

const _expect = expect;
const _findsOneWidget = findsOneWidget;
const _findsNothing = findsNothing;
const _findsNWidgets = findsNWidgets;

Future<void> Function(WidgetTester) harness(WidgetTestHarnessCallback<ExampleWidgetTestHarness> callback) {
  return (tester) => givenWhenThenWidgetTest(ExampleWidgetTestHarness(tester), callback);
}

class ExampleWidgetTestHarness extends WidgetTestHarness {
  ExampleWidgetTestHarness(WidgetTester tester) : super(tester);
}

extension ExampleGiven on WidgetTestGiven<ExampleWidgetTestHarness> {
  Future<void> pumpMyApp() async => tester.pumpWidget(MyApp());
}

extension ExampleWhen on WidgetTestWhen<ExampleWidgetTestHarness> {
  Future<void> userTaps(Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> userSwipesRightToLeft(Finder finder) async {
    await tester.fling(finder, Offset(-400, 0), 300);
    await tester.pumpAndSettle();
  }

  Future<void> userSwipesLeftToRight(Finder finder) async {
    await tester.fling(finder, Offset(400, 0), 300);
    await tester.pumpAndSettle();
  }

  Future<void> pump([Duration? duration]) => tester.pump(duration);

  Future<void> pumpNumberOfTimes(int times, {Duration? duration}) async {
    for (var i = 0; i < times; i++) {
      await tester.pump(duration);
    }
  }

  Future<int> pumpAndSettle([Duration duration = const Duration(milliseconds: 100)]) => tester.pumpAndSettle(duration);
}

extension ExampleThen on WidgetTestThen<ExampleWidgetTestHarness> {
  void findsOneWidget(Finder finder, {String? reason}) => _expect(finder, _findsOneWidget, reason: reason);

  void findsNothing(Finder finder1) => _expect(finder1, _findsNothing);

  void findsWidgets(Finder finder, {required int count}) => _expect(finder, _findsNWidgets(count));

  void findsOneWidgetPerIndex(int count, Finder Function(int) finderBuilder) {
    for (int i = 0; i < count; i++) {
      findsOneWidget(finderBuilder(i));
    }
  }
}
