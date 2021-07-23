import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Global Summit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Global Summit Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> items = List<int>.generate(5, (int index) => index);

  void _addItem() {
    setState(() {
      final lastValue = items.lastWhere((element) => true, orElse: () => -1);
      items.add(lastValue + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          final title = 'Item $item';
          return Dismissible(
            direction: DismissDirection.startToEnd,
            child: ListTile(
              key: ValueKey(item),
              title: Text(title),
            ),
            background: Container(
              alignment: Alignment.centerLeft,
              color: theme.errorColor,
              padding: EdgeInsets.only(left: 16),
              child: Icon(
                Icons.delete_forever,
                color: theme.colorScheme.surface,
              ),
            ),
            key: ValueKey<int>(items[index]),
            onDismissed: (DismissDirection direction) {
              setState(() => items.removeAt(index));
              showUndoSnackbar(title, index, item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void showUndoSnackbar(String title, int index, int item) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Text('$title removed!'),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  items.insert(index, item);
                });
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Text(
                'Undo',
                style: textTheme.bodyText1?.copyWith(color: theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
