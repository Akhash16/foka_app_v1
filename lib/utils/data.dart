class Data {
  static List<dynamic> _boatData = [];
  static late String _hubId;
  static late String _boatName;
  static late dynamic _devices;
  static late dynamic _settings;
  static late String _deviceId;
  static late String _deviceType;

  static setBoatData(data) => _boatData = data;
  static setBoatName(name) => _boatName = name;
  static setHubId(hubId) => _hubId = hubId;
  static setDevices(devices) => _devices = devices;
  static setSettings(settings) => _settings = settings;
  static setDeviceId(deviceId) => _deviceId = deviceId;
  static setDeviceType(deviceType) => _deviceType = deviceType;

  static List<dynamic> getBoatData() => _boatData;
  static String getBoatName() => _boatName;
  static String getHubId() => _hubId;
  static dynamic getDevices() => _devices;
  static dynamic getSettings() => _settings;
  static String getDeviceId() => _deviceId;
  static String getDeviceType() => _deviceType;

  static void reset() {
    _boatData = [];
    _hubId = '';
    _boatName = '';
    _devices = '';
    _settings = '';
    _deviceId = '';
    _deviceType = '';
  }
}
