import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final CameraType type;

  const CameraView({
    Key? key,
    this.type = CameraType.front,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraType description = widget.type;
  late CameraController controller;
  late Future<void> value;

  @override
  void initState() {
    controller = CameraController(
      widget.type.value,
      ResolutionPreset.high,
    );
    value = controller.initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CameraView oldWidget) {
    controller = CameraController(
      widget.type.value,
      ResolutionPreset.high,
    );
    value = controller.initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(controller);
        } else {
          return Container(
            color: Colors.black,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

enum CameraType {
  back(CameraDescription(
    name: "0",
    lensDirection: CameraLensDirection.back,
    sensorOrientation: 90,
  )),
  front(CameraDescription(
    name: "1",
    lensDirection: CameraLensDirection.front,
    sensorOrientation: 270,
  )),
  external(CameraDescription(
    name: "2",
    lensDirection: CameraLensDirection.external,
    sensorOrientation: 270,
  ));

  final CameraDescription value;

  const CameraType(this.value);
}
