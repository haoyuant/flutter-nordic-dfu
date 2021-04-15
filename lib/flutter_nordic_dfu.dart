import 'dart:async';

import 'package:flutter/services.dart';

import 'android_special_parameter.dart';
import 'ios_special_parameter.dart';

class FlutterNordicDfu {
  static const String NAMESPACE = 'com.tekt.flutter_nordic_dfu';
  static const MethodChannel _channel =
      const MethodChannel('$NAMESPACE/method');

  /// Start dfu handle
  /// [address] android: mac address iOS: device uuid
  /// [filePath] zip file path
  /// [name] device name
  /// [progressListener] Dfu progress listener, You can use [DefaultDfuProgressListenerAdapter]
  /// [fileInAsset] if [filePath] is a asset path like 'asset/file.zip', must set this value to true, else false
  /// [forceDfu] Legacy DFU only, see in nordic library, default is false
  /// [enableUnsafeExperimentalButtonlessServiceInSecureDfu] see in nordic library, default is false
  /// [androidSpecialParameter] this parameters is only used by android lib
  /// [iosSpecialParameter] this parameters is only used by ios lib
  static Future<String> startDfu(
    String address,
    String filePath, {
    String? name,
    DfuProgressListenerAdapter? progressListener,
    bool? fileInAsset,
    bool? forceDfu,
    bool? enablePRNs,
    int? numberOfPackets,
    bool? enableUnsafeExperimentalButtonlessServiceInSecureDfu,
    AndroidSpecialParameter androidSpecialParameter =
        const AndroidSpecialParameter(),
    IosSpecialParameter iosSpecialParameter = const IosSpecialParameter(),
  }) async {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onDeviceConnected":
          progressListener?.onDeviceConnected(call.arguments);
          break;
        case "onDeviceConnecting":
          progressListener?.onDeviceConnecting(call.arguments);
          break;
        case "onDeviceDisconnected":
          progressListener?.onDeviceDisconnected(call.arguments);
          break;
        case "onDeviceDisconnecting":
          progressListener?.onDeviceDisconnecting(call.arguments);
          break;
        case "onDfuAborted":
          progressListener?.onDfuAborted(call.arguments);
          break;
        case "onDfuCompleted":
          progressListener?.onDfuCompleted(call.arguments);
          break;
        case "onDfuProcessStarted":
          progressListener?.onDfuProcessStarted(call.arguments);
          break;
        case "onDfuProcessStarting":
          progressListener?.onDfuProcessStarting(call.arguments);
          break;
        case "onEnablingDfuMode":
          progressListener?.onEnablingDfuMode(call.arguments);
          break;
        case "onFirmwareValidating":
          progressListener?.onFirmwareValidating(call.arguments);
          break;
        case "onError":
          progressListener?.onError(
            call.arguments['deviceAddress'],
            call.arguments['error'],
            call.arguments['errorType'],
            call.arguments['message'],
          );
          break;
        case "onProgressChanged":
          progressListener?.onProgressChanged(
            call.arguments['deviceAddress'],
            call.arguments['percent'],
            call.arguments['speed'],
            call.arguments['avgSpeed'],
            call.arguments['currentPart'],
            call.arguments['partsTotal'],
          );
          break;
        default:
          break;
      }
    });
    return await _channel.invokeMethod('startDfu', <String, dynamic>{
      'address': address,
      'filePath': filePath,
      'name': name,
      'fileInAsset': fileInAsset,
      'forceDfu': forceDfu,
      'enablePRNs': enablePRNs,
      'numberOfPackets': numberOfPackets,
      'enableUnsafeExperimentalButtonlessServiceInSecureDfu':
          enableUnsafeExperimentalButtonlessServiceInSecureDfu,
      'disableNotification': androidSpecialParameter.disableNotification,
      'keepBond': androidSpecialParameter.keepBond,
      'restoreBond': androidSpecialParameter.restoreBond,
      'packetReceiptNotificationsEnabled':
          androidSpecialParameter.packetReceiptNotificationsEnabled,
      'startAsForegroundService':
          androidSpecialParameter.startAsForegroundService,
      'alternativeAdvertisingNameEnabled':
          iosSpecialParameter.alternativeAdvertisingNameEnabled,
    });
  }

  static Future<String> abortDfu() async {
    return await _channel.invokeMethod('abortDfu');
  }
}

abstract class DfuProgressListenerAdapter {
  void onDeviceConnected(String deviceAddress) {}

  void onDeviceConnecting(String deviceAddress) {}

  void onDeviceDisconnected(String deviceAddress) {}

  void onDeviceDisconnecting(String deviceAddress) {}

  void onDfuAborted(String deviceAddress) {}

  void onDfuCompleted(String deviceAddress) {}

  void onDfuProcessStarted(String deviceAddress) {}

  void onDfuProcessStarting(String deviceAddress) {}

  void onEnablingDfuMode(String deviceAddress) {}

  void onFirmwareValidating(String deviceAddress) {}

  void onError(
    String deviceAddress,
    int error,
    int errorType,
    String message,
  ) {}

  void onProgressChanged(
    String deviceAddress,
    int percent,
    double speed,
    double avgSpeed,
    int currentPart,
    int partsTotal,
  ) {}
}

class DefaultDfuProgressListenerAdapter extends DfuProgressListenerAdapter {
  void Function(String deviceAddress)? onDeviceConnectedHandle;
  void Function(String deviceAddress)? onDeviceConnectingHandle;
  void Function(String deviceAddress)? onDeviceDisconnectedHandle;
  void Function(String deviceAddress)? onDeviceDisconnectingHandle;
  void Function(String deviceAddress)? onDfuAbortedHandle;
  void Function(String deviceAddress)? onDfuCompletedHandle;
  void Function(String deviceAddress)? onDfuProcessStartedHandle;
  void Function(String deviceAddress)? onDfuProcessStartingHandle;
  void Function(String deviceAddress)? onEnablingDfuModeHandle;
  void Function(String deviceAddress)? onFirmwareValidatingHandle;
  void Function(String deviceAddress, int error, int errorType, String message)?
      onErrorHandle;
  void Function(
      String deviceAddress,
      int percent,
      double speed,
      double avgSpeed,
      int currentPart,
      int partsTotal)? onProgressChangedHandle;

  DefaultDfuProgressListenerAdapter({
    this.onDeviceConnectedHandle,
    this.onDeviceConnectingHandle,
    this.onDeviceDisconnectedHandle,
    this.onDeviceDisconnectingHandle,
    this.onDfuAbortedHandle,
    this.onDfuCompletedHandle,
    this.onDfuProcessStartedHandle,
    this.onDfuProcessStartingHandle,
    this.onEnablingDfuModeHandle,
    this.onFirmwareValidatingHandle,
    this.onErrorHandle,
    this.onProgressChangedHandle,
  });

  @override
  void onDeviceConnected(String deviceAddress) {
    super.onDeviceConnected(deviceAddress);
    onDeviceConnectedHandle?.call(deviceAddress);
  }

  @override
  void onDeviceConnecting(String deviceAddress) {
    super.onDeviceConnecting(deviceAddress);
    onDeviceConnectingHandle?.call(deviceAddress);
  }

  @override
  void onDeviceDisconnected(String deviceAddress) {
    super.onDeviceDisconnected(deviceAddress);
    onDeviceDisconnectedHandle?.call(deviceAddress);
  }

  @override
  void onDeviceDisconnecting(String deviceAddress) {
    super.onDeviceDisconnecting(deviceAddress);
    onDeviceDisconnectingHandle?.call(deviceAddress);
  }

  @override
  void onDfuAborted(String deviceAddress) {
    super.onDfuAborted(deviceAddress);
    onDfuAbortedHandle?.call(deviceAddress);
  }

  @override
  void onDfuCompleted(String deviceAddress) {
    super.onDfuCompleted(deviceAddress);
    onDfuCompletedHandle?.call(deviceAddress);
  }

  @override
  void onDfuProcessStarted(String deviceAddress) {
    super.onDfuProcessStarted(deviceAddress);
    onDfuProcessStartedHandle?.call(deviceAddress);
  }

  @override
  void onDfuProcessStarting(String deviceAddress) {
    super.onDfuProcessStarting(deviceAddress);
    onDfuProcessStartingHandle?.call(deviceAddress);
  }

  @override
  void onEnablingDfuMode(String deviceAddress) {
    super.onEnablingDfuMode(deviceAddress);
    onEnablingDfuModeHandle?.call(deviceAddress);
  }

  @override
  void onFirmwareValidating(String deviceAddress) {
    super.onFirmwareValidating(deviceAddress);
    onFirmwareValidatingHandle?.call(deviceAddress);
  }

  @override
  void onError(String deviceAddress, int error, int errorType, String message) {
    super.onError(deviceAddress, error, errorType, message);
    onErrorHandle?.call(deviceAddress, error, errorType, message);
  }

  void onProgressChanged(String deviceAddress, int percent, double speed,
      double avgSpeed, int currentPart, int partsTotal) {
    super.onProgressChanged(
        deviceAddress, percent, speed, avgSpeed, currentPart, partsTotal);
    if (onProgressChangedHandle != null) {
      onProgressChangedHandle?.call(
          deviceAddress, percent, speed, avgSpeed, currentPart, partsTotal);
    }
  }
}
