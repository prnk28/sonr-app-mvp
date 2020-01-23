import 'dart:collection';
import 'dart:async';

class ThresholdList<double> extends ListBase<double> {
  // Initial Value
  List _innerList = new List<double>();
  bool _thresholdValid = false;

  // List Options
  final double threshold;
  final Duration timeout;
  final Duration delay;
  final int maxElements;
  final bool clearListOnFail;
  final bool timeoutEnabled;
  final bool delayEnabled;

  // Constructor
  ThresholdList(this.threshold,
      {this.clearListOnFail = true,
      this.timeoutEnabled = true,
      this.delayEnabled = false,
      this.timeout = const Duration(seconds: 1, milliseconds: 500),
      this.delay = const Duration(milliseconds: 100),
      this.maxElements = 5});

  // **************************
  // *** Threshold Methods ****
  // **************************
  // Add Element to List: Returns True if List is Valid
  void add(double value) {
    // Empty List
    if (_innerList.length == 0) {
      _innerList.add(value);
      _thresholdValid = false;
    }
    // Full List
    else if (_innerList.length == maxElements) {
      // Timeout Enabled
      if (timeoutEnabled) {
        if(_startTimeout(value)){
          print("List is Full, Timer Enabled");
          _thresholdValid = true;
        }else{
          _thresholdValid = false;
        }
      }
      else{
        print("List is Full, Timer Not Enabled");
        _thresholdValid = true;
      }
    }
    // Add Value
    else {
      // Value in Threshold
      if (_checkBounds(value)) {
        _innerList.add(value);
        
      } else {
        // Check List Options
        if (clearListOnFail) {
          _innerList.clear();
        }
      }
      _thresholdValid = false;
    }
  }

  // Begin Timeout
  _startTimeout(double newValue) async {
    await new Future.delayed(timeout);
    // Check if Final Value in Threshold
    if(_checkBounds(newValue)){
      return true;
    }else{
      return false;
    }
  }

  // Get Threshold Bounds
  bool _checkBounds(value) {
    // Verify Nonempty
    if (_innerList.length > 0)
    {
      // Get Values
      var difference = _innerList.first - value;
      var diffAbs = difference.abs();

      // Check Threshold
      if(diffAbs < threshold){
        return true;
      }else{
        return false;
      }
    }
    // If Empty Throw Exception
    else{
      throw FormatException('Threshold List is Empty');
    }
  }

  // Check if List is Full
  bool get isFull {
    if (_innerList.length == maxElements) {
      return true;
    } else {
      return false;
    }
  }

  bool get isValidated {
    return _thresholdValid;
  }

  // ************************
  // *** Default Methods ****
  // ************************

  void addAll(Iterable<double> all) => _innerList.addAll(all);

  int get length => _innerList.length;

  set length(int length) {
    _innerList.length = length;
  }

  void operator []=(int index, double value) {
    _innerList[index] = value;
  }

  double operator [](int index) => _innerList[index];
}
