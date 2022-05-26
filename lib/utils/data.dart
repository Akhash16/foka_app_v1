class Data {
  static List<dynamic> _boatData = [];
  static late String _hubId;
  static late String _boatName;
  static late dynamic _devices;
  static late dynamic _settings;
  static late String _deviceId;
  static late String _deviceType;

  setBoatData(data) => _boatData = data;
  setBoatName(name) => _boatName = name;
  setHubId(hubId) => _hubId = hubId;
  setDevices(devices) => _devices = devices;
  setSettings(settings) => _settings = settings;
  setDeviceId(deviceId) => _deviceId = deviceId;
  setDeviceType(deviceType) => _deviceType = deviceType;

  List<dynamic> getBoatData() => _boatData;
  String getBoatName() => _boatName;
  String getHubId() => _hubId;
  dynamic getDevices() => _devices;
  dynamic getSettings() => _settings;
  String getDeviceId() => _deviceId;
  String getDeviceType() => _deviceType;
}
