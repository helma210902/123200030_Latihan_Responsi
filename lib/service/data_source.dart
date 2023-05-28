import 'package:latresponsi/service/base_network.dart';

class DataSource {
  static DataSource instance = DataSource();

  Future<List<dynamic>> loadChar() {
    return BaseNetwork.getList("characters");
  }

  Future<Map<String, dynamic>> loadCharDet(String name) {
    String nama = name;
    return BaseNetwork.get("characters/" + nama);
  }

  Future<List<dynamic>> loadWeapons() {
    return BaseNetwork.getList("weapons");
  }

  Future<Map<String, dynamic>> loadWeapDet(String name) {
    String nama = name;
    return BaseNetwork.get("weapons/" + nama);
  }
}
