import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_clone/profile.dart';

import 'Home.dart';
import 'Sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Upload.dart';



void main() {

  HttpOverrides.global = new MyHttpOverrides();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
    );

    runApp(MyApp());

}

String value;

check_login()async{
  final storage = new FlutterSecureStorage();
  value = await storage.read(key: 'token');

  if(value == null){
    value='null';
  }



}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: check_login(),
      builder: (context,snap){
      if(value != null){
        return  MaterialApp(
          
          debugShowCheckedModeBanner: false,
          initialRoute: value == 'null' ? '/login' : '/home' ,

          routes: {
            '/login' : (context)=> Sign_in(),
            '/home' : (context)=> Home(),
            '/profile' : (context)=> Profile(),
            '/upload' : (context)=> Upload(),

          },

        );
      }
      return Container(
        color: Colors.white,
      );
      }
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
