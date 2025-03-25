import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<DeviceInformation> getDeviceInformation() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return await _getIOSDeviceInformation();
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return await _getAndroidDeviceInformation();
      }
      return DeviceInformation(
        model: 'Unknown Device',
        osVersion: 'Unknown OS',
        isESIMSupported: false,
      );
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return DeviceInformation(
        model: 'Error detecting device',
        osVersion: 'Unknown',
        isESIMSupported: false,
      );
    }
  }

  Future<DeviceInformation> _getIOSDeviceInformation() async {
    final iosInfo = await _deviceInfo.iosInfo;
    final modelNumber = int.tryParse(
      iosInfo.name.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    
    return DeviceInformation(
      model: iosInfo.name,
      osVersion: 'iOS ${iosInfo.systemVersion}',
      isESIMSupported: iosInfo.name.contains('iPhone') && 
                      modelNumber != null && 
                      modelNumber >= 10,
    );
  }

  Future<DeviceInformation> _getAndroidDeviceInformation() async {
    final androidInfo = await _deviceInfo.androidInfo;
    
    return DeviceInformation(
      model: androidInfo.model,
      osVersion: 'Android ${androidInfo.version.release}',
      isESIMSupported: _checkAndroidESIMSupport(androidInfo),
    );
  }

  bool _checkAndroidESIMSupport(AndroidDeviceInfo info) {
    final model = info.model.toLowerCase();
    final manufacturer = info.manufacturer.toLowerCase();
    
    if (manufacturer.contains('samsung')) {
      return _checkSamsungSupport(model);
    } else if (manufacturer.contains('google')) {
      return _checkGoogleSupport(model);
    } else if (manufacturer.contains('oneplus')) {
      return _checkOnePlusSupport(model);
    } else if (manufacturer.contains('huawei')) {
      return _checkHuaweiSupport(model);
    }
    
    return false;
  }

  bool _checkSamsungSupport(String model) {
    return model.contains('s20') || 
           model.contains('s21') || 
           model.contains('s22') || 
           model.contains('s23') ||
           model.contains('fold') ||
           model.contains('flip') ||
           model.contains('note20') ||
           model.contains('note21') ||
           model.contains('note22') ||
           model.contains('note23');
  }

  bool _checkGoogleSupport(String model) {
    return model.contains('pixel 3') || 
           model.contains('pixel 4') || 
           model.contains('pixel 5') ||
           model.contains('pixel 6') ||
           model.contains('pixel 7') ||
           model.contains('pixel 8');
  }

  bool _checkOnePlusSupport(String model) {
    return model.contains('9') ||
           model.contains('10') ||
           model.contains('11') ||
           model.contains('12');
  }

  bool _checkHuaweiSupport(String model) {
    return model.contains('p40') ||
           model.contains('p50') ||
           model.contains('mate40') ||
           model.contains('mate50');
  }
}

class DeviceInformation {
  final String model;
  final String osVersion;
  final bool isESIMSupported;

  DeviceInformation({
    required this.model,
    required this.osVersion,
    required this.isESIMSupported,
  });
} 