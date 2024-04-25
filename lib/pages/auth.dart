import 'package:flatter_app_android/domain/user.dart';
import 'package:flatter_app_android/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AutorizationPage extends StatefulWidget {
  const AutorizationPage({super.key});

  @override
  State<AutorizationPage> createState() => _AutorizationPageState();
}

class _AutorizationPageState extends State<AutorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late String _email;
  late String _password;
  bool showLogin = true;

  AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {

    Widget _logo(){
      return const Padding(
          padding: EdgeInsets.only(top: 100),
          child: Align(
            child: Text("NAME1", style: TextStyle(fontSize: 45, fontWeight:FontWeight.bold, color: Colors.white))

          ),
        );
    }

    Widget input(Icon icon, String hint, TextEditingController controller, bool obsecure){
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller:  controller,
          obscureText: obsecure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3)
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1)
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left:10, right: 10) ,
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: icon,
              ),
            )
          ) ,
      ),
      );
    };

    Widget button(String text, void func()){
      return ElevatedButton(
          onPressed: (){
            func();
          },
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 20)
      ),
      );
    }

    Widget form(String label, void func()) {
      return Container(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 28, top: 10),
                child: input(Icon(Icons.email),"EMAIL", _emailController,false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 28),
              child: input(Icon(Icons.lock),"PASSWORD", _passwordController,true),
            ),
            const SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: button(label,func),
                ),
            )
          ],
        ),
      );
    }

    void _loginButtonAction() async{
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;

      MyUser? user = await _authService.signInWithEmailAndPassword(_email.trim(), _password);

      if(user == null) {
        Fluttertoast.showToast(
            msg: "Can't SignIn you! Please check your email/password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        _emailController.clear();
        _passwordController.clear();
      }
    }

    void _registerButtonAction() async{
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;

      MyUser? user = await _authService.registerWithEmailAndPassword(_email.trim(), _password);

      if(user == null) {
        Fluttertoast.showToast(
            msg: "Can't Register you! Please check your email/password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        _emailController.clear();
        _passwordController.clear();
      }
    }




    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          _logo(),
          (showLogin
          ? Column(
            children: [
            form('LOGIN', _loginButtonAction),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                child: const Text("Not registered yet? Register!", style: TextStyle(fontSize: 20, color:Colors.white)),
                onTap: (){
                  setState(() {
                    showLogin = false;

                  });
                },
              ),
            )
            ],
          )
          :
          Column(
            children: [
              form('REGISTER', _registerButtonAction),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: const Text("Already registred? Login!", style: TextStyle(fontSize: 20, color:Colors.white)),
                  onTap: (){
                    setState(() {
                      showLogin = true;

                    });
                  },
                ),
              )
            ],
          ))

        ],
      )
    );
  }
}
