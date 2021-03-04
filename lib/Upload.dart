import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'Sign_in.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

String url='https://instagram-clone-123.herokuapp.com';


class _UploadState extends State<Upload> {

  String msg="*No Image Selected";
  File image;
  var picker=ImagePicker();
  var storage = new FlutterSecureStorage();
  final description_Controller=TextEditingController();



  @override
  initState(){
    super.initState();
  }

  show_loading_dialog(){
    showDialog(
        context: this.context,
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


  upload()async{

    if(image!=null && description_Controller.text.toString()!='') {


      show_loading_dialog();

      var stream =
      // ignore: deprecated_member_use
      new http.ByteStream(DelegatingStream.typed(image.openRead()));
      // get file length
      var length = await image.length();

      // string to uri
      var uri = Uri.parse(url+'/post/post');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: basename(image.path));

      request.fields['token'] = await storage.read(key: 'token');
      request.fields['description'] = description_Controller.text;

      // add file to multipart
      request.files.add(multipartFile);

      // send
      var response = await request.send();

      Navigator.pop(this.context);

      Navigator.pushNamedAndRemoveUntil(this.context, '/home', (route) => false);



    }

  }

  select_image() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print("*****************");
    print(pickedFile.path);
    setState(() {
      image=File(pickedFile.path);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            shrinkWrap: true,
            children: [

              Container(

                child: Text(
                  'Upload',
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
                  controller: description_Controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 3,
                  cursorColor: Color(0xFF323232),
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 19,
                      color: Color(0xFF323232),
                      fontWeight: FontWeight.normal
                  ),
                  decoration: InputDecoration(

                      labelText: 'Caption',
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
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(23,23, 23, 23),
                child: image==null ? Text(
                  msg,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf1705b)
                  ),
                ) : ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.file(File(image.path))),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(19, 7, 19, 0),

                child: SizedBox(

                  height: 50,
                  child: RaisedButton(
                    onPressed: (){
                        select_image();
                    },
                    color: Color(0xFFf4ad55),
                    disabledColor: Color(0xFFf4ad55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Select an Image' ,
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
                      upload();
                    },
                    color: Color(0xFFf1705b),
                    disabledColor: Color(0xFFf1705b),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'UPLOAD',
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
    );
  }
}
