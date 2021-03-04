import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

String url='https://instagram-clone-123.herokuapp.com';

class _ProfileState extends State<Profile> {

  String avatar='assets/5.png';
  String name='Username';
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

      name=parsed["username"];

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

    try{
      show_loading_dialog();
      String token=await storage.read(key: 'token');print(token);
      var response=await http.post(url+'/auth/get_all_my_post', body: {"token": token});
      Navigator.pop(context);
      print(response.body);
      posts=json.decode(response.body);


      setState(() {

      });
    }catch(error){
      print("*********");
      print(error);
    }


  }

  change_avatar(int a) async {

    String token=await storage.read(key: 'token');print(token);
    show_loading_dialog();
    var res=await http.post(url+'/auth/change_profile', body: {"token": token,"avatar": a.toString()});
    Navigator.pop(context);

//    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    Navigator.pop(context);
    setState(() {
      avatar='assets/'+a.toString()+'.png';
    });

  }

  get_tiles(var post){

    return(
        Container(
          margin: EdgeInsets.fromLTRB(5, 7, 5, 7),

          child: Column(
            children: [

              Stack(

                children: [
                  GestureDetector(
                    onDoubleTap: () async {
                      show_loading_dialog();
                      await http.post(url+"/post/deletepost",body: {"post_id": post["_id"], "token": await storage.read(key: "token")});
                      Navigator.pop(context);
                      posts.remove(post);
                      setState(() {
                        
                      });

                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                      child: GestureDetector(
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9),
                              topRight: Radius.circular(9),
                            ),
                            child: Image.network(post["url"])),
                      ),
                    ),
                  ),
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
                      child: Image.asset(avatar,height: 35,width: 35,),
                    ),
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

  get_dialog(){

      showDialog(
        context: context,
        builder: (BuildContext context){
          return(
              Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)
                ),
                child: Container(

                    child: Container(

                      child: Wrap(
                        children: [Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                              child: Text(
                                'Select an Avatar.',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Color(0xFF323232)
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 170,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            change_avatar(1);
                                          },
                                          child: Column(
                                              children:[
                                                Container(
                                                    margin: EdgeInsets.only(left: 13),
                                                    padding: EdgeInsets.all(9),
                                                    child: Image.asset('assets/1.png',height: 90,width: 90,)
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
                                                  child: Text(
                                                    'Avatar 01',
                                                    style: TextStyle(
                                                        fontFamily: 'Cookie',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Color(0xFF323232)
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            change_avatar(2);
                                          },
                                          child: Column(
                                              children:[
                                                Container(
                                                    padding: EdgeInsets.all(9),
                                                    child: Image.asset('assets/2.png',height: 90,width: 90,)
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
                                                  child: Text(
                                                    'Avatar 02',
                                                    style: TextStyle(
                                                        fontFamily: 'Cookie',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Color(0xFF323232)
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            change_avatar(3);
                                          },
                                          child: Column(
                                              children:[
                                                Container(
                                                    padding: EdgeInsets.all(9),
                                                    child: Image.asset('assets/3.png',height: 90,width: 90,)
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
                                                  child: Text(
                                                    'Avatar 03',
                                                    style: TextStyle(
                                                        fontFamily: 'Cookie',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Color(0xFF323232)
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            change_avatar(4);
                                          },
                                          child: Column(
                                              children:[
                                                Container(
                                                    padding: EdgeInsets.all(9),
                                                    child: Image.asset('assets/4.png',height: 90,width: 90,)
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
                                                  child: Text(
                                                    'Avatar 04',
                                                    style: TextStyle(
                                                        fontFamily: 'Cookie',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Color(0xFF323232)
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            change_avatar(5);
                                          },
                                          child: Column(
                                              children:[
                                                Container(
                                                    margin: EdgeInsets.only(right: 13),
                                                    padding: EdgeInsets.all(9),
                                                    child: Image.asset('assets/5.png',height: 90,width: 90,)
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
                                                  child: Text(
                                                    'Avatar 05',
                                                    style: TextStyle(
                                                        fontFamily: 'Cookie',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Color(0xFF323232)
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                        ),
                                      ],
                                    ),

                                  ]
                              ),
                            ),
                          ],
                        )],
                      )

                      ),
                    ),
                )

          );

        }
      );

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
//                  Container(
//                      margin: EdgeInsets.fromLTRB(0, 19, 0, 0),
//                      padding: EdgeInsets.fromLTRB(0, 9, 0, 9),
//                      width: (MediaQuery.of(context).size.width/100)*20,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(55.0),
//                        child: Image.asset(
//                          avatar,
//                          height: 55.0,
//                          width: 55.0,
//                        ),
//                      )
//                  )
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

                    GestureDetector(
                      onTap: (){
                        get_dialog();
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 9, 0, 9),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Image.asset(avatar,height: 90,width: 90,),
                          )
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 9),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'Cookie',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF323232)

                          ),

                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width/100*80,
                          child: SizedBox(

                            height: 50,

                            child: RaisedButton(
                              onPressed: () async {
                                show_loading_dialog();
                                await storage.delete(key: 'token');
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

                              },
                              color: Color(0xFFf1705b),
                              disabledColor: Color(0xFFf1705b),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'LOGOUT',
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

                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 13, 0, 7),
                        child: Text(
                          posts.length==0 ? 'No posts yet.' : 'Double tap to delete.',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF323232)

                          ),

                        )
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
