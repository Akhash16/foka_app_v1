class Data {
  static List<dynamic> _boatData = [];
  static late String _hubId;
  static late String _boatName;
  static late dynamic _devices;
  static late dynamic _settings;

  setBoatData(data) => _boatData = data;
  setBoatName(name) => _boatName = name;
  setHubId(hubId) => _hubId = hubId;
  setDevices(devices) => _devices = devices;
  setSettings(settings) => _settings = settings;

  List<dynamic> getBoatData() => _boatData;
  String getBoatName() => _boatName;
  String getHubId() => _hubId;
  dynamic getDevices() => _devices;
  dynamic getSettings() => _settings;
}
