import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  int _incrementValue = 1;
  List<int> _history = [];

  void _incrementCounter() {
    setState(() {
      if (_counter + _incrementValue <= 100) {
        _history.add(_counter);
        _counter += _incrementValue;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Maximum limit reached!"),
          ),
        );
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _history.add(_counter);
        _counter = _counter > 0 ? _counter - _incrementValue : 0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _history.add(_counter);
      _counter = 0;
    });
  }

  void _undoCounter() {
    if (_history.isNotEmpty) {
      setState(() {
        _counter = _history.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: _counter == 0 ? Colors.red : (_counter > 50 ? Colors.green : Colors.blue),
              child: Text(
                '$_counter',
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Custom Increment Value',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int? intValue = int.tryParse(value);
              if (intValue != null) {
                _incrementValue = intValue;
              }
            },
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: _incrementCounter, child: Text('Increment')),
              ElevatedButton(onPressed: _decrementCounter, child: Text('Decrement')),
              ElevatedButton(onPressed: _resetCounter, child: Text('Reset')),
              ElevatedButton(onPressed: _undoCounter, child: Text('Undo')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('Previous value: ${_history[index]}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
