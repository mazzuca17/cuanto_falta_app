import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

///
/// Clase encargada de vista de inicio, al momento de abrir la app
/// en caso de que el usuario no tenga sesión, se define a qué vista se debe
/// de enviar al usuario cliente.
///
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  @override
  bool animate = false;
  void initState() {
    super.initState();
    startAnimation();
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
    await Future.delayed(const Duration(milliseconds: 5000));
    //Get.to(const WelcomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/list_categories_background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(
                  height: _screenSize.height * 0.30,
                ),

                ///height: 50.0
                Image.asset(
                  'assets/img/logo_chasky.png',
                  width: _screenSize.width * 0.45,
                  alignment: Alignment.center,
                ),
                const Expanded(
                  child: SizedBox.shrink(),
                ),
                SpinKitCircle(
                  size: 60.0,
                  color: Colors.white,
                ),
                SizedBox(
                  height: _screenSize.height * 0.16,
                ) //height: 100.0
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}
