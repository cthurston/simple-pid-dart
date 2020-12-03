# simple-pid-dart
A simple PID controller. If you want a PID controller without external dependencies that just works, this is for you!

## Credit
This PID code was ported from https://github.com/m-lundberg/simple-pid. Thanks!

## Example
Usage is very simple:

```dart

var pid = PID(Kp: 1, Ki: 0.1, Kd: 0.05, setPoint: 1);

// assume we have a system we want to control in controlled_system
var v = controlledSystem.update(0);

while (true) {
    // compute new ouput from the PID according to the systems current value
    var control = pid(v);
    
    // feed the PID output to the system and get its current value
    v = controlledSystem.update(control);
}
```

Complete API documentation from the original python library can be found [here](https://simple-pid.readthedocs.io/en/latest/simple_pid.html#module-simple_pid.PID).

## Installation
To install, add to pub spec.
This library is null safe.

## Usage
The `PID` class implements `call()`, which means that to compute a new output value, you simply call the object like this:
```dart
var output = pid(currentValue);
```

### The basics
The PID works best when it is updated at regular intervals. To achieve this, set `sample_time` to the amount of time there should be between each update and then call the PID every time in the program loop. A new output will only be calculated when `sample_time` seconds has passed:
```dart
var pid = PID(sampleTime: 0.01); // update every 0.01 seconds (default)

while (true) {
    var output = pid(currentValue);
}
```

To set the setpoint, ie. the value that the PID is trying to achieve, simply set it like this:
```dart
pid.setPoint = 10;
```

The tunings can be changed any time when the PID is running. They can either be set individually or all at once:
```dart
pid.Ki = 1.0;
pid.tunings = [1.0, 0.2, 0.4];
```

To use the PID in [reverse mode](https://brettbeauregard.com/blog/2011/04/improving-the-beginners-pid-direction/), meaning that an increase in the input leads to a decrease in the output (like when cooling for example), you can set the tunings to negative values:

```dart
pid.tunings = [-1.0, -0.1, 0];
```

Note that all the tunings should have the same sign.

In order to get output values in a certain range, and also to avoid [integral windup](https://en.wikipedia.org/wiki/Integral_windup) (since the integral term will never be allowed to grow outside of these limits), the output can be limited to a range:
```dart
var pid = PID(minOutput: 0, maxOutput: 10);
```

### Other features
#### Auto mode
To disable the PID so that no new values are computed, set auto mode to False:
```dart
pid.autoMode = false; // no new values will be computed when pid is called
pid.autoMode = true; // pid is enabled again
```


#### Observing separate components
When tuning the PID, it can be useful to see how each of the components contribute to the output. They can be seen like this:
```dart
List<double> c = pid.components; // the separate terms are now in [p, i, d]
```

#### Proportional on measurement
To eliminate overshoot in certain types of systems, you can calculate the [proportional term directly on the measurement](https://brettbeauregard.com/blog/2017/06/introducing-proportional-on-measurement/) instead of the error. This can be enabled like this:
```dart
proportionalOnMeasurement: true
```

## Tests
Use the following to run tests:
```
flutter pub run test
```

## License
Licensed under the [BSD License](https://github.com/cthurston/simple-pid-dart/blob/master/LICENSE).
Original python simple-pid: Licensed under the [MIT License](https://github.com/m-lundberg/simple-pid/blob/master/LICENSE.md).