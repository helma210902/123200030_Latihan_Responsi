import 'package:flutter/material.dart';
import 'package:latresponsi/service/data_source.dart';

import 'characterdetail.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Character List"),
      ),
      body: Container(
        child: _buildListCharBody(),
      ),
    ));
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

Widget _buildListCharBody() {
  return Container(
      child: FutureBuilder(
    future: DataSource.instance.loadChar(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> ss) {
      if (ss.hasError) {
        // print(ss.error);
        return _buildErrorSection();
      }
      if (ss.hasData) {
        // print(ss.data);
        // List<String> chara = ss.data;
        return _buildSuccessCharSection(context, ss.data);
      }
      return _buildLoadingSection();
    },
  ));
}

Widget _buildSuccessCharSection(BuildContext context, List<dynamic> chara) {
  return Container(
    child: ListView.builder(
        itemCount: chara.length,
        itemBuilder: (BuildContext context, index) {
          return _buildCharItem(context, chara[index]);
        }),
  );
}

Widget _buildCharItem(BuildContext context, String name) {
  return InkWell(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CharacterDetail(name: name)));
    },
    child: ListTile(
      leading:
          Image.network("https://api.genshin.dev/characters/" + name + "/icon"),
      title: Text(name.toUpperCase()),
    ),
  );
}
