import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libcalculator.so")
    : throw UnsupportedError("Only Android is supported");

final double Function(double, double) add = nativeLib
    .lookup<NativeFunction<Double Function(Double, Double)>>('add')
    .asFunction();

final double Function(double, double) subtract = nativeLib
    .lookup<NativeFunction<Double Function(Double, Double)>>('subtract')
    .asFunction();

final double Function(double, double) multiply = nativeLib
    .lookup<NativeFunction<Double Function(Double, Double)>>('multiply')
    .asFunction();

final double Function(double, double) divide = nativeLib
    .lookup<NativeFunction<Double Function(Double, Double)>>('divide')
    .asFunction();
