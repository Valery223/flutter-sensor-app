import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flatter_app_android/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //static const Duration _ignoreDuration = Duration(milliseconds: 20);

  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;

  double _speed = 0.0;
  Position? _currentPosition;

  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;

  DateTime? _accelerometerLastUpdateTime;
  DateTime? _gyroscopeLastUpdateTime;
  DateTime? _magnetometerLastUpdateTime;


  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = const Duration(seconds: 30);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton.icon(
              onPressed: (){
                AuthService().logOut();
              }, icon: const Icon(Icons.supervised_user_circle, color: Colors.white,),
              label: const SizedBox.shrink())
        ],
      ),
      body: Row(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Accelerometer: ", style: theme.textTheme.bodyMedium),
              Text('Gyroscope: ', style: theme.textTheme.bodyMedium),
              Text('Latitude: ', style: theme.textTheme.bodyMedium),
              Text('Longitude: ', style: theme.textTheme.bodyMedium),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
              Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?'),
              Text('${_currentPosition?.latitude ?? 'N/A'}', style: theme.textTheme.bodyLarge),
              Text('${_currentPosition?.longitude ?? 'N/A'}', style: theme.textTheme.bodyLarge),
            ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_accelerometerUpdateTime?.second ?? 'N/A'} Sec'),
              Text('${_gyroscopeUpdateTime?.second ?? 'N/A'} Sec'),
            ],
          ),
        ],
      ),);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    MyUser? user = Provider.of<MyUser?>(context);

    _initLocation();

    _streamSubscriptions.add(
      accelerometerEventStream().listen((AccelerometerEvent event) {
        final now = DateTime.now();

        if (mounted) {
          setState(() {
            _accelerometerEvent = event;
            _accelerometerUpdateTime = now;
          });
        }

        if (_accelerometerLastUpdateTime == null || _accelerometerUpdateTime!.difference(_accelerometerLastUpdateTime!) > sensorInterval) {
          _accelerometerLastUpdateTime = _accelerometerUpdateTime;

          if (user != null) {
            FirebaseFirestore.instance.collection('test_sensors2').add({
              'accelerometer': [user.email, event.x, event.y, event.z, _accelerometerLastUpdateTime!.hour, _accelerometerLastUpdateTime!.minute]
            });
          } else {
            print("Error: user dont find");
          }
        }
      }),
    );

    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen((GyroscopeEvent event) {
        final now = DateTime.now();

        if (mounted) {
          setState(() {
            _gyroscopeEvent = event;
            _gyroscopeUpdateTime = now;
          });
        }

        if (_gyroscopeLastUpdateTime == null || _gyroscopeUpdateTime!.difference(_gyroscopeLastUpdateTime!) > sensorInterval) {
          _gyroscopeLastUpdateTime = _gyroscopeUpdateTime;

          FirebaseFirestore.instance.collection('test_sensors').add({
            'gyroscope': [event.x, event.y, event.z, _gyroscopeLastUpdateTime!.hour, _gyroscopeLastUpdateTime!.minute]
          });
        }
      }),
    );

    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen((MagnetometerEvent event) {
        final now = DateTime.now();

        if (mounted) {
          setState(() {
            _magnetometerEvent = event;
            _magnetometerUpdateTime = now;
          });
        }

        if (_magnetometerLastUpdateTime == null || _magnetometerUpdateTime!.difference(_magnetometerLastUpdateTime!) > sensorInterval) {
          _magnetometerLastUpdateTime = _magnetometerUpdateTime;

          FirebaseFirestore.instance.collection('test_sensors').add({
            'magnetometer': [event.x, event.y, event.z, _magnetometerLastUpdateTime!.hour, _magnetometerLastUpdateTime!.minute]
          });
        }
      }),
    );
  }

// ...

  Future<void> _initLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    if (mounted) {
      setState(() {
        _currentPosition = position;
        if (position.speed != null) {
          _speed = position.speed!;
        }
      });
    }

  }
}


