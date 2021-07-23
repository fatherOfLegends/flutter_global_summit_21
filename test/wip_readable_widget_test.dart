import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';
import 'page_objects.dart';

final app = MyAppPageObject();
void main() {
  testWidgets('Should start with 5 items and a FAB', harness((given, when, then) async {}));

  testWidgets('Should not remove an item when swiping right to left', harness((given, when, then) async {}));

  testWidgets('Should remove an item when swiping left to right', harness((given, when, then) async {}));

  testWidgets(
      'Should see the option to undo for 3 seconds after removing an item', harness((given, when, then) async {}));

  testWidgets('Should add an item back to the list when Undo tapped', harness((given, when, then) async {}));

  testWidgets('Should dismiss Undo snackbar after tapping undo', harness((given, when, then) async {}));

  testWidgets('Should add items to the end of the list when tapping FAB', harness((given, when, then) async {}));
}
