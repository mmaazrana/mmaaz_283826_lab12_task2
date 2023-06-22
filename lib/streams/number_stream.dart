import 'dart:async';
// Creating a number stream

class NumberStream {
  
  // Creating a stream controller
  StreamController<int> controller = StreamController<int>();
  // Method for inserting new number
  addNumberToSink(int newNumber) {
    controller.sink.add(newNumber);
  }
  // Method for inserting error in the sink
  addError() {
    controller.sink.addError('error');
  }
  // Method for closing the stream
  close() {
    controller.close();
  }
}