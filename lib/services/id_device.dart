import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class IdDevice {
  static Future<String?> get idDevice async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    BaseDeviceInfo? deviceInfo = await info.deviceInfo;

    (deviceInfo as IosDeviceInfo).identifierForVendor;
    if (Platform.isAndroid) {
      return (deviceInfo as AndroidDeviceInfo).id;
    } else if (Platform.isIOS) {
      return deviceInfo.identifierForVendor;
    }
    return null;
  }
}
