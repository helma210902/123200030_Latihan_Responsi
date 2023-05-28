import 'package:flutter/material.dart';
import 'package:latresponsi/model/model_weapondet.dart';
import 'package:latresponsi/service/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeaponDetails extends StatefulWidget {
  final String weapon;
  const WeaponDetails({Key? key, required this.weapon}) : super(key: key);

  @override
  State<WeaponDetails> createState() => _WeaponDetailsState();
}

class _WeaponDetailsState extends State<WeaponDetails> {
  Future<void> _setLastSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_seen', widget.weapon);
    prefs.setString('code', 'weapons');
  }

  @override
  void initState() {
    super.initState();
    _setLastSeen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        title: Text(widget.weapon.toUpperCase() + " Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              "https://api.genshin.dev/weapons/" + widget.weapon + "/icon"),
          _buildDetailedWeaponBody(widget.weapon)
        ],
      ),
    ));
  }
}

Widget _buildDetailedWeaponBody(String name) {
  return Container(
    child: FutureBuilder(
      future: DataSource.instance.loadWeapDet(name),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          WeaponModel weapon = WeaponModel.fromJson(snapshot.data);
          return _buildSuccessBody(weapon);
        }
        return Text("Error");
      },
    ),
  );
}

Widget _buildSuccessBody(WeaponModel weap) {
  return Column(
    children: [
      Text(
        weap.name,
        style: TextStyle(color: Colors.white),
      ),
      _starGenerator(weap.rarity),
    ],
  );
}

Widget _buildErrorSection() {
  return Container(
    child: const Text("Error"),
  );
}

Widget _buildLoadingSection() {
  return CircularProgressIndicator();
}

Widget _starGenerator(int num) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      num,
      (index) => const Icon(
        Icons.star,
        color: Colors.white,
      ),
    ),
  );
}
