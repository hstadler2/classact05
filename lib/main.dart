import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Widget App',
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
  int counter = 0; // Track the current counter
  int incrementStep = 1; // How much we increase or decrease
  List<int> history = []; // Keep track of all changes

  // Increase the counter based on the incrementStep
  void increaseCounter() {
    setState(() {
      if (counter + incrementStep <= 100) { // Don't go over 100
        history.add(counter); // Save current value
        counter += incrementStep;
      } else {
        // Pop up if max is reached
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text("You've hit the limit!"),
          ),
        );
      }
    });
  }

  // Decrease the counter but no less than 0
  void decreaseCounter() {
    setState(() {
      if (counter > 0) {
        history.add(counter);
        counter = counter - incrementStep > 0 ? counter - incrementStep : 0;
      }
    });
  }

  // Reset everything back to zero
  void resetCounter() {
    setState(() {
      history.add(counter); // save before resetting
      counter = 0;
    });
  }

  // Go back to the last number if possible
  void undoAction() {
    if (history.isNotEmpty) {
      setState(() {
        counter = history.removeLast(); // go back to the last one
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fun With Counters'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              // Change color based on the counter value
              color: counter == 0 ? Colors.red : (counter > 50 ? Colors.green : Colors.blue),
              child: Text(
                '$counter',
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: 100,
            value: counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                counter = value.toInt(); // Set counter to slider value
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),
          // Custom increment input
          TextField(
            decoration: InputDecoration(
              labelText: 'Set Step Size',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int? newStep = int.tryParse(value); // Make sure it's a number
              if (newStep != null) {
                incrementStep = newStep; // Set new step size
              }
            },
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: increaseCounter, child: Text('Increase')),
              ElevatedButton(onPressed: decreaseCounter, child: Text('Decrease')),
              ElevatedButton(onPressed: resetCounter, child: Text('Reset')),
              ElevatedButton(onPressed: undoAction, child: Text('Undo')),
            ],
          ),
          Expanded(
            // Display history of values
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('Was: ${history[index]}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
