import 'dart:async';

import 'package:flutter_global_summit/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';

Future<void> Function(WidgetTester) harness(WidgetTestHarnessCallback<ExampleWidgetTestHarness> callback) {
  return (tester) => givenWhenThenWidgetTest(ExampleWidgetTestHarness(tester), callback);
}

class ExampleWidgetTestHarness extends WidgetTestHarness {
  ExampleWidgetTestHarness(WidgetTester tester) : super(tester);
}

extension ExampleGiven on WidgetTestGiven<ExampleWidgetTestHarness> {
  Future<void> myAppIsLaunched() async => tester.pumpWidget(MyApp());
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
  void userFindsOne(Finder finder, {String? reason}) => expect(finder, findsOneWidget, reason: reason);

  void userCannotFind(Finder finder1) => expect(finder1, findsNothing);

  void userFindsMany(Finder finder, {required int count}) => expect(finder, findsNWidgets(count));

  void userFindsOnePerIndex(Finder Function(int) finderBuilder, {required int count}) {
    for (int i = 0; i < count; i++) {
      userFindsOne(finderBuilder(i));
    }
  }
}
