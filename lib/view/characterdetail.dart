import 'package:flutter/material.dart';
import 'package:latresponsi/model/model_character.dart';
import 'package:latresponsi/service/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterDetail extends StatefulWidget {
  final String name;
  const CharacterDetail({Key? key, required this.name}) : super(key: key);
  @override
  State<CharacterDetail> createState() => _CharacterDetailState();
}

class _CharacterDetailState extends State<CharacterDetail> {
  Future<void> _setLastSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_seen', widget.name);
    prefs.setString('code', 'characters');
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
            appBar: AppBar(
              title: Text(widget.name.toUpperCase() + " Detail"),
            ),
            body: Container(
              child: _buildDetailedCharBody(widget.name),
            )));
  }
}

Widget _buildErrorSection() {
  return Container(
    child: const Text("Error"),
  );
}

Widget _buildLoadingSection() {
  return CircularProgressIndicator();
}

Widget _buildDetailedCharBody(String name) {
  return Container(
    child: FutureBuilder(
        future: DataSource.instance.loadCharDet(name),
        builder: (BuildContext context, AsyncSnapshot<dynamic> ss) {
          if (ss.hasError) {
            return _buildErrorSection();
          }
          if (ss.hasData) {
            Character charDetail = Character.fromJson(ss.data);
            return _buildSuccessSection(context, charDetail);
          }
          return _buildLoadingSection();
        }),
  );
}

Widget _buildSuccessSection(BuildContext context, Character char) {
  String nama = char.name!.toLowerCase();
  String nation = char.nation!.toLowerCase();
  String vision = char.vision!.toLowerCase();
  return SingleChildScrollView(
    child: Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //gacha-splash
            width: MediaQuery.of(context).size.width,
            child: Image.network(
                "https://api.genshin.dev/characters/" + nama + "/gacha-splash"),
            // decoration: BoxDecoration(
            // color: Colors.white,
            // ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://api.genshin.dev/nations/" + nation + "/icon",
                width: 50,
                height: 50,
              ), //nation
              Image.network(
                "https://api.genshin.dev/elements/" + vision + "/icon",
                width: 50,
                height: 50,
              ), //element
              Text(
                char.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ) //name
            ],
          ),
          _starGenerator(char.rarity!),
          Text(
            char.affiliation!,
            style: const TextStyle(color: Colors.white),
          ), //organisasi
          const SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(char.description!,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.justify)), //deskripsi
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Image.network(
                "https://api.genshin.dev/characters/" + nama + "/talent-na",
                width: 80,
                height: 80,
              ),
              Expanded(
                  child: Text(char.skillTalents![0].description!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          Row(
            children: [
              Image.network(
                "https://api.genshin.dev/characters/" + nama + "/talent-na",
                width: 80,
                height: 80,
              ),
              Expanded(
                  child: Text(char.skillTalents![1].description!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          Row(
            children: [
              Image.network(
                "https://api.genshin.dev/characters/" + nama + "/talent-na",
                width: 80,
                height: 80,
              ),
              Expanded(
                  child: Text(char.skillTalents![2].description!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    ),
  );
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
