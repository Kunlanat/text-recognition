import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_recognition/card_scanner_overlay_shape.dart';

class CroppedCameraPreview extends StatelessWidget {
  const CroppedCameraPreview({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          ClipRect(
            child: Transform.scale(
              scale: cameraController.value.aspectRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1 / cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
              ),
            ),
          ),
          Container(
            decoration: const ShapeDecoration(
              shape: CardScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 12,
                borderLength: 32,
                borderWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
