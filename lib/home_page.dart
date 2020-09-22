import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

const tfLiteModelPath = "assets/model_unquant.tflite";
const tfLiteLabelPath = "assets/labels.txt";

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  List _output;
  File _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> _classifyImage(File image) async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });
    final output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2, // 2 categories, Cat or Dog
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
    });
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: tfLiteModelPath,
      labels: tfLiteLabelPath,
    );
  }

  Future<void> _pickImage({
    ImageSource source,
  }) async {
    final image = await _picker.getImage(
      source: source ?? ImageSource.gallery,
    );
    if (image == null) {
      return;
    }
    setState(() {
      _image = File(image.path);
    });
    await _classifyImage(_image);
  }

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
            if (_image == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(FontAwesomeIcons.cat, size: 100),
                  SizedBox(width: 10),
                  FaIcon(FontAwesomeIcons.dog, size: 100),
                ],
              )
            else
              Column(
                children: [
                  Container(
                    height: 250,
                    child: Image.file(_image),
                  ),
                  const SizedBox(height: 20),
                  if (_output != null) Text("${_output[0]}")
                ],
              ),
            const SizedBox(height: 30),
            RaisedButton(
              onPressed: () {
                _pickImage(
                  source: ImageSource.camera,
                );
              },
              child: const Text("Take a Photo"),
            ),
            const SizedBox(height: 10),
            RaisedButton(
              onPressed: () {
                _pickImage(
                  source: ImageSource.gallery,
                );
              },
              child: const Text("Get from Galery"),
            ),
          ],
        ),
      ),
    );
  }
}
