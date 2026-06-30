import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'apps/captain/home_page.dart';
import 'apps/captain/login.dart';
import 'camera.dart';
import 'core/themes/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Splash(),
      theme: buildTheme(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if(GetStorage().read('userId') != null){
        Get.offAll(()=>CaptainHome());
      }else{
        Get.offAll(()=>Login());
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor, // Your brand color
      body: SafeArea(
        child: Column(
          children: [
            // Expanded(flex: 2, child: Container()),

            // Logo section
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Image.asset(
                      'assets/large-logo.png',
                      width: 300,
                      height: 300,
                    ),




                  ],
                ),
              ),
            ),

            // Bottom progress section
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),


                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



