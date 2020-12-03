// @dart=2.9
import 'dart:io';

import 'package:test/test.dart';
import 'package:simple_pid/simple_pid.dart';

void main() {
  group('pid construction', () {
    test('pid defaults', () {
      var p = PID();

      expect(p.Kp, 1.0);
      expect(p.Ki, 0.0);
      expect(p.Kd, 0.0);
      expect(p.setPoint, 0.0);
      expect(p.sampleTime, 0.01);
      expect(p.autoMode, true);
      expect(p.proportionalOnMeasurement, false);
    });

    test('pid with values', () {
      var p = PID(
          Kp: 100,
          Ki: 10,
          Kd: 1,
          setPoint: 10,
          sampleTime: 0.1,
          autoMode: false,
          proportionalOnMeasurement: true);

      expect(p.Kp, 100.0);
      expect(p.Ki, 10.0);
      expect(p.Kd, 1.0);
      expect(p.setPoint, 10.0);
      expect(p.sampleTime, 0.1);
      expect(p.autoMode, false);
      expect(p.proportionalOnMeasurement, true);
    });
  });

  group('getter and setters', () {
    test('tunings getter', () {
      var p = PID();
      var t = p.tunings;
      expect(t[0], 1);
      expect(t[2], 0);
    });
    test('tunings setter', () {
      var p = PID();
      p.tunings = [10, 20, 30];
      var t = p.tunings;
      expect(t[0], 10);
      expect(t[2], 30);
    });
    test('components getter', () {
      var p = PID();
      var c = p.components;
      expect(c[0], 0);
      expect(c[2], 0);
    });
    test('autoMode getter', () {
      var p = PID();
      var a = p.autoMode;
      expect(a, true);
    });
    test('autoMode getter', () {
      var p = PID(autoMode: false);
      p.derivative = 1000;
      p.autoMode = true;
      expect(p.derivative, 0);
      var a = p.autoMode;
      expect(a, true);
    });
  });
  group('callable', () {
    test('calling the class', () {
      var p = PID();
      var v = p(0);
      expect(v, 0);
    });
    test('calling when autoMode is off', () {
      var p = PID(autoMode: false);
      var v = p(0);
      expect(v, 0);
    });

    test('calling with neg dt', () {
      var p = PID();
      expect(() {
        p(0, dt: Duration(milliseconds: -10));
      }, throwsArgumentError);
    });

    test('calling with small dt', () {
      var p = PID();
      p.lastOutput = 2000;
      var v = p(0, dt: Duration(milliseconds: 1));
      expect(v, 2000);
    });
    test('calling with a positive input', () {
      var p = PID(sampleTime: 0);
      var v = p(100);
      expect(v, -100);
    });
    test('calling with a negative input', () {
      var p = PID(sampleTime: 0);
      var v = p(-100);
      expect(v, 100);
    });

    test('calling with integral positive input', () {
      var p = PID(Kp: 0, Ki: 1);
      sleep(Duration(milliseconds: 20));
      var v = p(100);
      expect(v, lessThan(0));
    });
    test('calling with integral negative input', () {
      var p = PID(Kp: 0, Ki: 1);
      sleep(Duration(milliseconds: 20));
      var v = p(-100);
      expect(v, greaterThan(0));
    });
    test('calling with derivative input', () {
      var p = PID(Kp: 0, Ki: 0, Kd: 1);
      sleep(Duration(milliseconds: 20));
      var v = p(100);
      expect(v, lessThan(0));
    });
  });
}
