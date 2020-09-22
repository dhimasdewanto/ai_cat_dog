import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect Cats and Dogs"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(FontAwesomeIcons.cat, size: 100),
                SizedBox(width: 10),
                FaIcon(FontAwesomeIcons.dog, size: 100),
              ],
            ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {},
              child: const Text("Take a Photo"),
            ),
            const SizedBox(height: 10),
            RaisedButton(
              onPressed: () {},
              child: const Text("Camera Roll"),
            ),
          ],
        ),
      ),
    );
  }
}
