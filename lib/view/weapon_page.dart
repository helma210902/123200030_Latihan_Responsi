import 'package:flutter/material.dart';
import 'package:latresponsi/service/data_source.dart';
import 'package:latresponsi/view/weapondetail.dart';

class WeaponPage extends StatefulWidget {
  const WeaponPage({Key? key}) : super(key: key);
  @override
  State<WeaponPage> createState() => _WeaponPageState();
}

class _WeaponPageState extends State<WeaponPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Weapon List"),
      ),
      body: Container(child: _buildListWeapBody()),
    ));
  }
}

Widget _buildErrorSection() {
  return Container(
    child: const Text("Ada Error nih"),
  );
}

Widget _buildLoadingSection() {
  return CircularProgressIndicator();
}

Widget _buildListWeapBody() {
  return Container(
      child: FutureBuilder(
    future: DataSource.instance.loadWeapons(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> ss) {
      if (ss.hasError) {
        return _buildErrorSection();
      }
      if (ss.hasData) {
        // List<String> chara = ss.data;
        return _buildSuccessWeapBody(context, ss.data);
      }
      return _buildLoadingSection();
    },
  ));
}

Widget _buildSuccessWeapBody(BuildContext context, List<dynamic> weapon) {
  return Container(
    child: ListView.builder(
        itemCount: weapon.length,
        itemBuilder: (BuildContext context, index) {
          return _buildWeapItem(context, weapon[index]);
        }),
  );
}

Widget _buildWeapItem(BuildContext context, String name) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WeaponDetails(
                    weapon: name,
                  )));
    },
    child: ListTile(
      leading:
          Image.network("https://api.genshin.dev/weapons/" + name + "/icon"),
      title: Text(name.toUpperCase()),
    ),
  );
}
