import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';
import 'page_objects.dart';

final app = MyAppPageObject();
void main() {
  testWidgets('Should start with 5 items and a FAB', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userFindsOne(app.appBar.title('Flutter Global Summit Demo'));
    then.userFindsMany(app.dismissible, count: 5);
    then.userFindsOnePerIndex((i) => app.dismissible.withTitle('Item $i'), count: 5);
    then.userFindsOne(app.addItemFAB);
  }));

  testWidgets('Should not remove an item when swiping right to left', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userFindsOne(app.firstDismissible);

    await when.userSwipesRightToLeft(app.firstDismissible);
    then.userFindsOne(app.firstDismissible);
  }));

  testWidgets('Should remove an item when swiping left to right', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userFindsOne(app.firstDismissible);

    await when.userSwipesLeftToRight(app.firstDismissible);
    then.userCannotFind(app.firstDismissible);
  }));

  testWidgets('Should see the option to undo for 3 seconds after removing an item', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userCannotFind(app.snackbar.undoButton);

    await when.userSwipesLeftToRight(app.firstDismissible);
    then.userFindsOne(app.snackbar.undoButton);

    // wait for the snackbar duration to pass
    await when.pump(Duration(seconds: 3));
    then.userFindsOne(app.snackbar.undoButton);

    // complete snackbar exit animation
    await when.pumpAndSettle();
    then.userCannotFind(app.snackbar.undoButton);
  }));

  testWidgets('Should add an item back to the list when Undo tapped', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userFindsOne(app.firstDismissible);

    await when.userSwipesLeftToRight(app.firstDismissible);
    then.userCannotFind(app.firstDismissible);

    await when.userTaps(app.snackbar.undoButton);
    then.userFindsOne(app.firstDismissible);
  }));

  testWidgets('Should dismiss Undo snackbar after tapping undo', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userCannotFind(app.snackbar.undoButton);

    await when.userSwipesLeftToRight(app.firstDismissible);
    await when.userTaps(app.snackbar.undoButton);

    // wait for the snackbar animation duration to pass
    await when.pump(Duration(milliseconds: 200));
    then.userCannotFind(app.snackbar.undoButton);
  }));

  testWidgets('Should add items to the end of the list when tapping FAB', harness((given, when, then) async {
    await given.myAppIsLaunched();
    then.userFindsMany(app.dismissible, count: 5);

    final newItem = app.dismissible.withTitle('Item 5');
    then.userCannotFind(newItem);

    await when.userTaps(app.addItemFAB);
    then.userFindsMany(app.dismissible, count: 6);
    then.userFindsOne(newItem);
  }));
}
