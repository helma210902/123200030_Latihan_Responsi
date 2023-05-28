import 'package:flutter/material.dart';
import 'package:latresponsi/view/character_page.dart';
import 'package:latresponsi/view/weapon_page.dart';
import 'package:latresponsi/view/weapondetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'characterdetail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _lastseen;
  String? _code;

  Future<void> _getLastSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastseen = prefs.getString("last_seen");
      _code = prefs.getString("code");
    });
  }

  @override
  void initState() {
    super.initState();
    _lastseen = "";
    _code = "";
    _getLastSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/genshin.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/genshin_impact_logo.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  if (_lastseen != null && _lastseen != "")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: Card(
                        child: ListTile(
                          onTap: () async {
                            if (_code == "characters") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CharacterDetail(name: _lastseen!),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WeaponDetails(weapon: _lastseen!),
                                  ));
                            }
                          },
                          leading: Image.network(
                              'https://api.genshin.dev/${_code}/${_lastseen!.toLowerCase()}/icon'),
                          title: Text(_lastseen.toString().toUpperCase()),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 230,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CharacterPage()));
                            },
                            child: const Text("Characters")),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 230,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WeaponPage()));
                            },
                            child: const Text("Weapons")),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
