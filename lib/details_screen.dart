import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class DetailsPage extends StatefulWidget {
  final File pickedImage;
  const DetailsPage({
    Key? key,
    required this.pickedImage,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String text = '';
  File? pickedImage;

  bool isImageLoaded = false;

  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> openImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage = File(image.path);
        isImageLoaded = true;
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              pickedImage: File(image.path),
            ),
          ),
        );
      }
    } catch (e) {
      pickedImage = null;
      isImageLoaded = false;
      setState(() {});
    }
  }

  Future<void> readTextFromImage() async {
    final GoogleVisionImage visionImage =
        GoogleVisionImage.fromFile(widget.pickedImage);

    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          text = text + '${element.text}';
        }
        text = text + '\n';
      }
    }
  }

  @override
  void initState() {
    readTextFromImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: openImageFromGallery,
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(widget.pickedImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(text),
          ],
        ),
      ),
    );
  }
}
