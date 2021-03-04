import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String url='https://instagram-clone-123.herokuapp.com';

class _HomeState extends State<Home> {

  String avatar='assets/5.png';
  var storage = new FlutterSecureStorage();
  List posts=[];

  @override
  initState(){
    super.initState();
    set_profile();


  }

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


  set_profile()async{
    print("asdasdadad");
    String token=await storage.read(key: 'token');print(token);

    try{
      show_loading_dialog();
      var response=await http.post(url+'/auth/get_info', body: {"token": token});
      Navigator.pop(context);
      Map parsed = json.decode(response.body);print(response.body);
      int atr=parsed["avatar"];

      avatar= (atr==1) ? 'assets/1.png' :
      (atr==2) ? 'assets/2.png' :
      (atr==3) ? 'assets/3.png' :
      (atr==4) ? 'assets/4.png' :
      'assets/5.png' ;

      setState(() {

      });

    }catch(error){

    }

    get_posts();

  }

  get_posts() async {

    try {
      show_loading_dialog();
      String token = await storage.read(key: 'token');
      print(token);
      var response = await http.post(url + '/auth/get_all_post', body: {"token": token});
      Navigator.pop(context);
      print(response.body);
      posts = json.decode(response.body);


      setState(() {

      });

    }catch(error){
      print("*********");
      print(error);
    }


  }

  get_avatar(String username)async{

    var response=await http.post(url+'/auth/get_avatar', body: {"username": username});
    print(response.body);
    var ava=json.decode(response.body);
    return(ava["avatar"].toString());


  }

  like_post(String id)async{
    await http.post(url+"/post/likepost",body: {"post_id":id});
  }

  get_tiles(var post){
    var avatar =null;
    return(
      Container(
        margin: EdgeInsets.fromLTRB(5, 7, 5, 7),

        child: Column(
          children: [

            Stack(

              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                  child: GestureDetector(
                    onDoubleTap: (){
                      like_post(post["_id"]);
                      post["likes"]+=1;
                      setState(() {

                      });
                    },
                    child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9),
                              topRight: Radius.circular(9),
                            ),
                            child: Image.network(post["url"])),
                  ),
                ),
                FutureBuilder(
                  future: get_avatar(post['postby']),
                  builder: (context,snapshot){
                    avatar=snapshot.data;
                    if(avatar!=null){
                      return(
                          Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.white.withOpacity(0.5),
                            ),

                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.fromLTRB(15, 8, 15, 15),
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset('assets/'+avatar+'.png',height: 35,width: 35,),
                            ),
                          )
                      );
                    }
                    return(
                    Container()
                    );
                  },

                ),
                Container(
                  margin: EdgeInsets.fromLTRB(60, 14, 15, 0),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    post["postby"],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF323232),
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],

            ),

            Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(9),
                  margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                  ),
                  color: Color(0xFF323232),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        post["likes"].toString()+' likes',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15
                        ),),
                      Text(
                        "-"+post["description"],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 18
                        ),),
                    ],
                  )
                    ),






          ],
        ),

      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        backgroundColor: Color(0xFFf1705b),
        onPressed: () async {
           Navigator.pushNamed(context, '/upload');
        },
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(59),
        child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                width: (MediaQuery.of(context).size.width/100)*80,
                child: AppBar(
                  shadowColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  brightness: Brightness.light,
                  title: Text(
                    'Photogram',
                    style: TextStyle(
                        fontFamily: 'Cookie',
                        color: Color(0xFF323232),
                        fontSize: 35,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 19, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 9, 0, 9),
                width: (MediaQuery.of(context).size.width/100)*20,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(55.0),
                    child: Image.asset(
                      avatar,
                      height: 55.0,
                      width: 55.0,
                    ),
                  ),
                )
              )
            ],
          )
        )
      ),
      body: Container(

        child:ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
          children:[Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 9, 0, 7),
                child: Text(
                  'Double tap to like.',
                  style: TextStyle(
                    color: Color(0xFF323232),
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
              ),
              Column(
                children:
                posts.map<Widget>((e) => get_tiles(e)).toList(),
              )
            ],
          ),
          ]
          ),
        )

      ),
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