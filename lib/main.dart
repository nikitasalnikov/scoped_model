import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScopedModel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ScopedModel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int get counterValue => _counter;
  void incrementCounter() => setState(() => _counter++);
  void decrementCounter() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScopedModel'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          MyInheritedWidget(
            myState: this,
            child: AppRootWidget(),
          ),
        ],
      ),
    );
  }
}

class AppRootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootWidgetState = MyInheritedWidget.of(context)?.myState;

    return Card(
      elevation: 20,
      child: Column(
        children: <Widget>[
          Text(
            'Root Widget',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            '${rootWidgetState?.counterValue}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            /* почему если убрать const обновляться 
            счетчик будет у всех, если есть const то у одного*/
            children: const <Widget>[
              Counter(),
              Counter(),
            ],
          )
        ],
      ),
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rootWidgetState = MyInheritedWidget.of(context)?.myState;

    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(4).copyWith(bottom: 32),
      color: Colors.yellowAccent,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Text(
              'Child Widget',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '${rootWidgetState?.counterValue}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            ButtonBar(
              children: <Widget>[
                IconButton(
                  onPressed: () => rootWidgetState?.decrementCounter(),
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () => rootWidgetState?.incrementCounter(),
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final _MyHomePageState? myState;

  MyInheritedWidget({Key? key, Widget? child, @required this.myState})
      : super(key: key, child: child as Widget);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return myState?.counterValue != myState?.counterValue;
  }

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}
