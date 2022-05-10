import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static const String gas = 'gas';
  static const String temperature = 'temperature';
  static const String humidity = 'humidity';

  static const String fluidValue = 'fluidValue';

  static const String floatValue = 'floatValue';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setTHS(int gas, double temperature, double humidity) async {
    await _preferences.setInt(Preferences.gas, gas);
    await _preferences.setDouble(Preferences.temperature, temperature);
    await _preferences.setDouble(Preferences.humidity, humidity);
  }

  static Future setFluidValue(int fluidValue) async => await _preferences.setInt(Preferences.fluidValue, fluidValue);

  static Future setFloatValue(int floatValue) async => await _preferences.setInt(Preferences.floatValue, floatValue);

  static int? getGas() => _preferences.getInt(Preferences.gas);
  static double? getTemperature() => _preferences.getDouble(Preferences.temperature);
  static double? getHumidity() => _preferences.getDouble(Preferences.humidity);

  static int? getFluidValue() => _preferences.getInt(Preferences.fluidValue);

  static int? getFloatValue() => _preferences.getInt(Preferences.floatValue);
}
