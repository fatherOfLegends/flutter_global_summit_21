import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';
import 'page_objects.dart';

final app = MyAppPageObject();
void main() {
  testWidgets('Should start with 5 items and a FAB', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsOneWidget(app.appBar.title('Flutter Global Summit Demo'));
    then.findsWidgets(app.dismissible, count: 5);
    then.findsOneWidgetPerIndex(5, (i) => app.dismissible.withTitle('Item $i'));
    then.findsOneWidget(app.addItemFAB);
  }));

  testWidgets('Should not remove an item when swiping right to left', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsOneWidget(app.firstDismissible);

    await when.userSwipesRightToLeft(app.firstDismissible);

    then.findsOneWidget(app.firstDismissible);
  }));

  testWidgets('Should remove an item when swiping left to right', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsOneWidget(app.firstDismissible);

    await when.userSwipesLeftToRight(app.firstDismissible);

    then.findsNothing(app.firstDismissible);
  }));

  testWidgets('Should see the option to undo for 3 seconds after removing an item', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsNothing(app.snackbar.undoButton);

    await when.userSwipesLeftToRight(app.firstDismissible);

    then.findsOneWidget(app.snackbar.undoButton);

    // wait for the snackbar duration to pass
    await when.pump(Duration(seconds: 3));

    then.findsOneWidget(app.snackbar.undoButton);

    // complete snackbar exit animation
    await when.pumpAndSettle();

    then.findsNothing(app.snackbar.undoButton);
  }));

  testWidgets('Should add an item back to the list when Undo tapped', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsOneWidget(app.firstDismissible);

    await when.userSwipesLeftToRight(app.firstDismissible);

    then.findsNothing(app.firstDismissible);

    await when.userTaps(app.snackbar.undoButton);

    then.findsOneWidget(app.firstDismissible);
  }));

  testWidgets('Should dismiss Undo snackbar after tapping undo', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsNothing(app.snackbar.undoButton);

    await when.userSwipesLeftToRight(app.firstDismissible);

    await when.userTaps(app.snackbar.undoButton);

    // wait for the snackbar animation duration to pass
    await when.pump(Duration(milliseconds: 200));

    then.findsNothing(app.snackbar.undoButton);
  }));

  testWidgets('Should add items to the end of the list when tapping FAB', harness((given, when, then) async {
    await given.pumpMyApp();

    then.findsWidgets(app.dismissible, count: 5);

    final newItem = app.dismissible.withTitle('Item 5');
    then.findsNothing(newItem);

    await when.userTaps(app.addItemFAB);

    then.findsWidgets(app.dismissible, count: 6);

    then.findsOneWidget(newItem);
  }));
}
