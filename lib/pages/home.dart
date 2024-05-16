import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flatter_app_android/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../button.dart';
import '../domain/user.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Duration sensorInterval = const Duration(seconds: 30);
  late Timer? _timer;

  late StreamSubscription<dynamic> _accelerometerSubscription;
  late StreamSubscription<dynamic> _gyroscopeSubscription;
  late StreamSubscription<dynamic> _magnetometerSubscription;
  late StreamSubscription<Position> _positionSubscription;
  late CameraController _controller;

  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;

  Position? _currentPosition;


  @override
  void initState() {
    super.initState();

    initLocation();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> initLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
  }

  void initSensorsSubscription() {
    _accelerometerSubscription =
        accelerometerEventStream(samplingPeriod: sensorInterval).listen((
            AccelerometerEvent event) {
          // Логика обработки событий акселерометра
          setState(() {
            _accelerometerEvent = event;
            // _accelerometerUpdateTime = now;
          });

          // Отправка данных в Firestore
          // sendDataToFirestore('sensors', {
          //   'accelerometer': [event.x, event.y, event.z],
          // });
        });

    _gyroscopeSubscription =
        gyroscopeEventStream(samplingPeriod: sensorInterval).listen((
            GyroscopeEvent event) {
          // Логика обработки событий акселерометра
          setState(() {
            _gyroscopeEvent = event;
            // _accelerometerUpdateTime = now;
          });

          // Отправка данных в Firestore
          // sendDataToFirestore('sensors', {
          //   'accelerometer': [event.x, event.y, event.z],
          // });

        });

    _magnetometerSubscription =
        magnetometerEventStream(samplingPeriod: sensorInterval).listen((
            MagnetometerEvent event) {
          // Логика обработки событий акселерометра
          setState(() {
            _magnetometerEvent = event;
            // _accelerometerUpdateTime = now;
          });

        });

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      // distanceFilter: 10,
      // timeLimit:
    );
    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
          setState(() {
            _currentPosition = position;
          });
        });
  }

  void cancelSensorsSubscription() {
    _accelerometerSubscription.cancel();
    _gyroscopeSubscription.cancel();
    _magnetometerSubscription.cancel();
    _positionSubscription.cancel();

    setState(() {
      _accelerometerEvent = null;
      _gyroscopeEvent = null;
      _magnetometerEvent = null;
      _currentPosition = null;
    });
  }
  //
  // void startRecording() {
  //   // Можно сделать проверку на null
  //   // Запуск записи данных в базу данных
  //   _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
  //     DateTime now = DateTime.now();
  //     String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now); // Форматирование времени
  //     sendDataToFirestore('recordings', {
  //       'accelerometer': [_accelerometerEvent?.x, _accelerometerEvent?.y, _accelerometerEvent?.z],
  //       'gyroscope': [_gyroscopeEvent?.x, _gyroscopeEvent?.y, _gyroscopeEvent?.z],
  //       'magnetometer': [_magnetometerEvent?.x, _magnetometerEvent?.y, _magnetometerEvent?.z],
  //       'latitude': _currentPosition?.latitude,
  //       'longitude': _currentPosition?.longitude,
  //       'speed': _currentPosition?.speed,
  //       'timestamp': formattedTime, // Добавление времени в данные
  //     });
  //   });
  // }

  void startRecording() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      print("Запись!!!!!\n");
      final data = {
        'accelerometer': [_accelerometerEvent?.x, _accelerometerEvent?.y, _accelerometerEvent?.z],
        'gyroscope': [_gyroscopeEvent?.x, _gyroscopeEvent?.y, _gyroscopeEvent?.z],
        'magnetometer': [_magnetometerEvent?.x, _magnetometerEvent?.y, _magnetometerEvent?.z],
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'speed': _currentPosition?.speed,
        'timestamp': formattedTime,
      };

      await saveDataToFile('recordings.json', data);
    });
  }

  Future<void> saveDataToFile(String fileName, Map<String, dynamic> data) async {
    final directory = await getDownloadsDirectory();
    //final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory?.path}/$fileName');

    try {
      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      final encodedData = json.encode(data);
      await file.writeAsString(encodedData, mode: FileMode.append);

      print('Файл успешно сохранен: ${file.path}');
    } catch (e) {
      print('Ошибка сохранения данных в файл: $e');
    }
  }


  void stopRecording() {
    _timer?.cancel(); // Остановка таймера
  }

  void sendDataToFirestore(String collectionName, Map<String, dynamic> data) {
    FirebaseFirestore.instance.collection(collectionName).add(data);
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    final theme = Theme.of(context);
    const String naText = 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton.icon(
              onPressed: () {
                AuthService().logOut();
              },
              icon: const Icon(
                Icons.supervised_user_circle, color: Colors.white,),
              label: const SizedBox.shrink())
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Accelerometer: ", style: theme.textTheme.bodyMedium),
                  Text('Gyroscope: ', style: theme.textTheme.bodyMedium),
                  Text('Magnitometr: ', style: theme.textTheme.bodyMedium),
                  Text('Latitude: ', style: theme.textTheme.bodyMedium),
                  Text('Longitude: ', style: theme.textTheme.bodyMedium),
                  Text('Speed: ', style: theme.textTheme.bodyMedium),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? naText),
                  Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? naText),
                  Text(_magnetometerEvent?.x.toStringAsFixed(1) ?? naText),
                  Text('${_currentPosition?.latitude ?? naText}',
                      style: theme.textTheme.bodyLarge),
                  Text('${_currentPosition?.longitude ?? naText}',
                      style: theme.textTheme.bodyLarge),
                  Text('${_currentPosition?.speed ?? naText}',
                      style: theme.textTheme.bodyLarge),
                ],
              ),
            ],
          ),
          ToggleButtonWidget(
            onPressedFunction1: () {
              debugPrint("sensors: on");
              initSensorsSubscription();
            },
            onPressedFunction2: () {
              debugPrint("sensors: off");
              cancelSensorsSubscription();
            },
            text1: "Включить сенсоры",
            text2: "Выключить сенсоры",
          ),
          ToggleButtonWidget(
            onPressedFunction1: () {
              debugPrint("record: on");
              startRecording();
            },
            onPressedFunction2: () {
              debugPrint("record: off");
              stopRecording();
            },
            text1: "Включить запись",
            text2: "Выключить запись",
          )
        ],
      ),
    );
  }

}



