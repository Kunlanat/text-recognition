import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/cropped_camera_preview.dart';
import 'package:flutter_text_recognition/details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UICameraScreen extends StatefulWidget {
  const UICameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  _UICameraScreenState createState() => _UICameraScreenState();
}

class _UICameraScreenState extends State<UICameraScreen> {
  late CameraController cameraController;
  XFile? imageFile;
  @override
  void initState() {
    super.initState();

    cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
    );

    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    TextStyle style = GoogleFonts.inter(
      textStyle: const TextStyle(fontSize: 18),
    );

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: openImageFromGallery,
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'กรุณาวางบัตรให้อยู่ในกรอบที่กำหนด\nให้เห็นตัวอักษรและข้อมูลหน้าบัตรชัดเจน',
            style: style,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _cameraPreview(),
          const SizedBox(height: 30),
          Text(
            'กรุณาถ่ายบัตรด้วยตัวเอง',
            style: style,
          ),
          const SizedBox(height: 30),
          _button(theme),
        ],
      ),
    );
  }

  Widget _button(ThemeData theme) {
    return InkWell(
      onTap: () async {
        await cameraController.takePicture().then(
          (path) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  pickedImage: File(path.path),
                ),
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        backgroundColor: theme.primaryColor,
        child: const Icon(
          FluentIcons.camera_24_regular,
          color: Colors.white,
          size: 32,
        ),
        radius: 30,
      ),
    );
  }

  Widget _cameraPreview() {
    if (!cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: CroppedCameraPreview(
          cameraController: cameraController,
        ),
      );
    }
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        tooltip: 'Back',
        icon: const Icon(FluentIcons.backspace_24_regular));
  }
}
