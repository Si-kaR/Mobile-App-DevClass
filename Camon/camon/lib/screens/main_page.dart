import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController cameraController;
  late Future<void> cameraValue;

  void startCamera(int camera) {
    cameraController = CameraController(
        widget.cameras[0], ResolutionPreset.high,
        enableAudio: false);
    cameraValue = cameraController.initialize();
  }

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // Camera button
      floatingActionButton: const FloatingActionButton(
        backgroundColor: Color.fromARGB(
          255,
          255,
          255,
          255,
        ),
        shape: CircleBorder(),
        onPressed: null,
        child: Icon(
          Icons.camera_alt,
          size: 40,
          color: Colors.black87,
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
