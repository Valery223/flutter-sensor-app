import 'package:flutter/material.dart';

class ToggleButtonWidget extends StatefulWidget {
  final VoidCallback onPressedFunction1;
  final VoidCallback onPressedFunction2;
  final String text1;
  final String text2;

  const ToggleButtonWidget({
    Key? key,
    required this.onPressedFunction1,
    required this.onPressedFunction2,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  bool _isOn = false;

  void _toggle() {
    setState(() {
      _isOn = !_isOn;
    });
    if (_isOn) {
      widget.onPressedFunction1(); // вызов первой функции при включении
    } else {
      widget.onPressedFunction2(); // вызов второй функции при выключении
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _toggle,
          child: Text(_isOn ? widget.text2 : widget.text1),
        ),
      ],
    );
  }
}