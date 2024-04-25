import 'package:flatter_app_android/domain/user.dart';
import 'package:flatter_app_android/pages/auth.dart';
import 'package:flatter_app_android/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    final bool isLoggedIn = user != null;
    return isLoggedIn ? const Home() : const AutorizationPage();
  }
}