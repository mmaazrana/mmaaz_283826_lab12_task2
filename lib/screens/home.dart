import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../streams/number_stream.dart';

class StreamHomePage extends StatefulWidget {
  @override
  _StreamHomePageState createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  // Initializating of variables
  int? lastNumber;
  late StreamController numberStreamController;
  late NumberStream numberStream;
  late StreamSubscription subscription;
  late StreamTransformer transformer;
  String values = '';

  @override
  void initState() {
    // Making initializations
    numberStream = NumberStream();
    numberStreamController = numberStream.controller;
    Stream stream = numberStreamController.stream;

    // Initializing the Stream Transformer
    transformer = StreamTransformer<int, dynamic>.fromHandlers(
      handleData: (value, sink) => sink.add(value * 10),
      handleError: (error, trace, sink) => sink.add(-1),
      handleDone: (sink) => sink.close(),
    );

    // Starting listening to the stream with the transformer
    // as defined above
    subscription = stream.transform(transformer).listen((event) {
      setState(() {
        lastNumber = event;
      });
    });
    // Handling for errors in stream
    subscription.onError((error) {
      setState(() {
        lastNumber = -1;
      });
    });
    // Handling when stream is closed
    subscription.onDone(() {
      if (kDebugMode) {
        print('OnDone was called');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 12: Task 4'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Displaying the numbers from stream
            Text(
              '${lastNumber ?? ""} ',
            ),
            // Button for inserting numbers to stream
            ElevatedButton(
              onPressed: () => addRandomNumber(),
              child: const Text('New Random Number'),
            ),
            // Button for stopping the stream
            ElevatedButton(
              onPressed: () => stopStream(),
              child: const Text('Stop Stream'),
            ),
          ],
        ),
      ),
    );
  }
  // Method to add random no. to stream
  void addRandomNumber() {
    int randomNo = Random().nextInt(10);
    // Checking if stream is closed
    if (!numberStreamController.isClosed) {
      // If stream is open, insert no to the stream
      numberStream.addNumberToSink(randomNo);
    } else {
      setState(() {
        lastNumber = -1;
      });
    }
  }

  // Method for closing the stream
  void stopStream() {
    numberStreamController.close();
  }
}
