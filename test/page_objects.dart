import 'package:flutter/material.dart';
import 'package:flutter_global_summit/main.dart';
import 'package:flutter_test/src/finders.dart';
import 'package:page_object/page_object.dart';

class MyAppPageObject extends PageObject {
  MyAppPageObject() : super(find.byType(MyApp));

  AppBarPageObject get appBar => AppBarPageObject();

  Finder get firstDismissible => dismissible.withTitle('Item 0');

  DismissiblePageObject get dismissible => DismissiblePageObject();

  SnackbarPageObject get snackbar => SnackbarPageObject();

  Finder get addItemFAB => find.descendant(of: find.byType(FloatingActionButton), matching: find.byIcon(Icons.add));
}

class AppBarPageObject extends PageObject {
  AppBarPageObject() : super(find.byType(AppBar));

  Finder title(String text) => find.descendant(of: this, matching: find.text(text));
}

class DismissiblePageObject extends PageObject {
  DismissiblePageObject() : super(find.byType(Dismissible));

  Finder withTitle(String title) => find.descendant(of: this, matching: find.text(title));
}

class SnackbarPageObject extends PageObject {
  SnackbarPageObject() : super(find.byType(SnackBar));

  Finder get undoButton => find.descendant(of: this, matching: find.text('Undo')).hitTestable();
}
