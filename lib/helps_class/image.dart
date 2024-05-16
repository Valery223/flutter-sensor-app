import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraImage? image;

  const CameraPreviewWidget({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const CircularProgressIndicator(); // Показываем индикатор загрузки, пока нет изображения
    } else {
      // TODO: Добавить логику отображения изображения, например, с использованием виджета Image.memory
      return Image.memory(image!.planes[0].bytes);
    }
  }
}