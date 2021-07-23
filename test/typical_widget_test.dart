import 'package:flutter/material.dart';
import 'package:flutter_global_summit/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should start with 5 items and a FAB', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that my title is correct
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Flutter Global Summit Demo')), findsOneWidget);

    // Verify that we have 5 items in the list
    expect(find.byType(Dismissible), findsNWidgets(5));

    // Verify that those item have the right values displayed
    for (int i = 0; i < 5; i++) {
      expect(find.descendant(of: find.byType(Dismissible), matching: find.text('Item $i')), findsOneWidget);
    }

    // Verify the '+' icon in the FAB.
    expect(find.descendant(of: find.byType(FloatingActionButton), matching: find.byIcon(Icons.add)), findsOneWidget);
  });

  testWidgets('Should not remove an item when swiping right to left', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the item is on screen
    final dismissibleItem = find.descendant(of: find.byType(Dismissible), matching: find.text('Item 0'));
    expect(dismissibleItem, findsOneWidget);

    // Swipe to dismiss the item (right to left) and wait until the animation completes
    await tester.fling(dismissibleItem, Offset(-400, 0), 300);
    await tester.pumpAndSettle();

    // Verify the item is still on the screen
    expect(dismissibleItem, findsOneWidget);
  });

  testWidgets('Should remove an item when swiping left to right', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the item is on screen
    final dismissibleItem = find.descendant(of: find.byType(Dismissible), matching: find.text('Item 0'));
    expect(dismissibleItem, findsOneWidget);

    // Swipe to dismiss the item (left to right) and wait until the animation completes
    await tester.fling(dismissibleItem, Offset(400, 0), 300);
    await tester.pumpAndSettle();

    // Verify the item is no longer on the screen
    expect(dismissibleItem, findsNothing);
  });

  testWidgets('Should see the option to undo for 3 seconds after removing an item', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the undo button is not on the screen
    final snackbarUndoButton = find.descendant(of: find.byType(SnackBar), matching: find.text('Undo')).hitTestable();
    expect(snackbarUndoButton, findsNothing);

    // Swipe to dismiss the item (left to right)
    final dismissibleItem = find.descendant(of: find.byType(Dismissible), matching: find.text('Item 0'));
    await tester.fling(dismissibleItem, Offset(400, 0), 300);
    // complete snackbar entry animation
    await tester.pumpAndSettle();

    // Verify the undo button is on the screen
    expect(snackbarUndoButton, findsOneWidget);

    // wait for the snackbar duration to pass
    await tester.pump(Duration(seconds: 3));

    // Verify the undo button is on the screen
    expect(snackbarUndoButton, findsOneWidget);

    // complete snackbar exit animation
    await tester.pumpAndSettle();

    // Verify the undo button is not on the screen
    expect(snackbarUndoButton, findsNothing);
  });

  testWidgets('Should add an item back to the list when Undo tapped', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the item is on the screen
    final dismissibleItem = find.descendant(of: find.byType(Dismissible), matching: find.text('Item 0'));
    expect(dismissibleItem, findsOneWidget);

    // Swipe to dismiss the item (left to right)
    await tester.fling(dismissibleItem, Offset(400, 0), 300);
    await tester.pumpAndSettle();

    // Verify the item is no longer on the screen
    expect(dismissibleItem, findsNothing);

    // Tap the undo button
    final snackbarUndoButton = find.descendant(of: find.byType(SnackBar), matching: find.text('Undo')).hitTestable();
    await tester.tap(snackbarUndoButton);
    await tester.pump();

    // Verify the item is on the screen again
    expect(dismissibleItem, findsOneWidget);
  });

  testWidgets('Should dismiss Undo snackbar after tapping undo', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the undo button is not on the screen
    final snackbarUndoButton = find.descendant(of: find.byType(SnackBar), matching: find.text('Undo')).hitTestable();
    expect(snackbarUndoButton, findsNothing);

    // Swipe to dismiss the item (left to right)
    final dismissibleItem = find.descendant(of: find.byType(Dismissible), matching: find.text('Item 0'));
    await tester.fling(dismissibleItem, Offset(400, 0), 300);
    await tester.pumpAndSettle();

    // Tap the undo button
    await tester.tap(snackbarUndoButton);
    await tester.pump();

    // wait for the snackbar animation duration to pass
    await tester.pump(Duration(milliseconds: 200));

    // Verify the undo button is not on the screen
    expect(snackbarUndoButton, findsNothing);
  });

  testWidgets('Should add items to the end of the list when tapping FAB', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify items exist
    expect(find.byType(Dismissible), findsNWidgets(5));

    // Verify new item does not exist yet
    final newItem = find.descendant(of: find.byType(Dismissible), matching: find.text('Item 5'));
    expect(newItem, findsNothing);

    // Tap FAB
    final floatingActionButton =
        find.descendant(of: find.byType(FloatingActionButton), matching: find.byIcon(Icons.add));
    await tester.tap(floatingActionButton);
    await tester.pump();

    // Verify we have added an item to the list
    expect(find.byType(Dismissible), findsNWidgets(6));

    // Verify new item exists
    expect(newItem, findsOneWidget);
  });
}
