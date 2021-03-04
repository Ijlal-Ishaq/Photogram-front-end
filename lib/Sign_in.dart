import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Sign_in extends StatefulWidget {
  @override
  _Sign_inState createState() => _Sign_inState();
}

String url='https://instagram-clone-123.herokuapp.com/auth';


class _Sign_inState extends State<Sign_in> {

  final storage = new FlutterSecureStorage();

  String msg='*Enter Username and Password';

  final username_Controller=TextEditingController();
  final password_Controller=TextEditingController();

  show_loading_dialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return(
        Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,

          child: Center(

             child: CircularProgressIndicator(

                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf4ad55)),

            ),
          ),
        )
        );
      }
    );
  }

  login()async{
    String username=username_Controller.value.text;

    String password=password_Controller.value.text;

    if(username == '' || password == ''){

      setState(() {
        msg='*Enter Username and Password';
      });
      return;
    }

    show_loading_dialog();

    var response = await http.post(url+'/login', body: {'username': username, 'password': password});

    Navigator.pop(context);

    Map parsed = json.decode(response.body);

    String token=parsed["token"];
    String err=parsed["message"];

    if(err=="user not found"){
      setState(() {
        msg='*User not found, make sure to register first.';
      });
    }
    else if(token!='' && token!=null){
      await storage.write(key: 'token', value: token);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }else{
      setState(() {
        msg='*Wrong username or password';
      });
    }



  }

  register() async {

    String username=username_Controller.value.text;
    String password=password_Controller.value.text;

    if(username == '' || password == ''){

      setState(() {
        msg='*Enter Username and Password';
      });
      return;
    }

    show_loading_dialog();

    var response = await http.post(url+'/register', body: {'username': username, 'password': password});

    Navigator.pop(context);

    Map parsed = json.decode(response.body);


    String message=parsed["message"];

    if(message=="username is taken"){
      setState(() {
        msg='*Username is taken, try another.';
      });
    }
    else if(message=="User Added"){
        login();
    }else{
      setState(() {
        msg='*Some Error occurred, try again. ';
      });
    }


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: (
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Center(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(

                shrinkWrap: true,
                children: [

                  Container(

                    child: Text(
                      'Photogram',
                      style: TextStyle(
                          fontFamily: 'Cookie',
                          fontSize: 59,
                          color: Color(0xFF323232),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 19, 0, 50),
                    alignment: Alignment.center,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(13, 0, 13, 7),
                    child: TextField(
                      controller: username_Controller,
                      cursorColor: Color(0xFF323232),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 19,
                          color: Color(0xFF323232),
                          fontWeight: FontWeight.normal
                      ),
                      decoration: InputDecoration(

                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Color(0xFF323232),
                          fontFamily: 'Roboto'
                        ),
                        fillColor: Color(0xFF323232),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),

                         borderSide: BorderSide(
                          color: Color(0xFF323232),

                           )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: BorderSide(
                              color: Color(0xFF323232),

                            )
                        )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(13, 7, 13, 7),
                    child: TextField(
                      controller: password_Controller,
                      obscureText: true,
                      cursorColor: Color(0xFF323232),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 19,
                          color: Color(0xFF323232),
                          fontWeight: FontWeight.normal
                      ),
                      decoration: InputDecoration(

                          labelText: 'Password',

                          labelStyle: TextStyle(
                              color: Color(0xFF323232),
                              fontFamily: 'Roboto'
                          ),
                          fillColor: Color(0xFF323232),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),

                              borderSide: BorderSide(
                                color: Color(0xFF323232),

                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: BorderSide(
                                color: Color(0xFF323232),

                              )
                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(23, 5, 7, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      msg,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color:  Color(0xFFf1705b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(19, 45, 19, 0),

                    child: SizedBox(

                      height: 50,
                      child: RaisedButton(
                        onPressed: (){
                          login();
                        },
                        color: Color(0xFFf4ad55),
                        disabledColor: Color(0xFFf4ad55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,

                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(35, 25, 35, 0),
                    color: Colors.grey,
                    height: 1,

                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(19, 25, 19, 19),

                    child: SizedBox(

                      height: 50,

                      child: RaisedButton(
                        onPressed: (){
                          register();
                        },
                        color: Color(0xFFf1705b),
                        disabledColor: Color(0xFFf1705b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,

                    ),
                  ),
      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
      )

    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}