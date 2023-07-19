
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:churchIn/OfferingPage.dart';
import 'package:churchIn/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ProfileEditPage.dart';
import 'helpers/encrypter.dart';
import 'helpers/helper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage() ;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  String successtxt="",errtxt="";
  bool _loading = true;
  int? user_id=0;

  @override
  void initState() {

    // Initialize notifications
    // PushNotificationsManager(context).init();
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
    checkLoggedIn();

  }
  void checkLoggedIn() async{
    SharedPreferences sp=await SharedPreferences.getInstance();
    //registered=sp.containsKey("registered")?sp.getBool("registered"):false;
    //loggedin=sp.containsKey("loggedin")?sp.getBool("loggedin"):false;
    user_id=sp.containsKey("user_id")?sp.getInt("user_id"):0;
  }
  _launchURL() async {
    const url = 'https://staging.churchinapp.com/privacypolicy';
    try {
      final uri = Uri.parse(url);

      await launchUrl(uri);

    }on Exception catch (e){
      print("Exception in launching the url");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic>  eventid = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //centerTitle: true,
        title: const Text(
          'ChurchIn',
        ),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
              ),
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: SvgPicture.asset("assets/images/newlogo.svg", width: 50, height: 50,fit: BoxFit.fitHeight,),

              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle_rounded,
              ),
              title: const Text('My Profile'),
              onTap: () async{
                SharedPreferences sp=await SharedPreferences.getInstance();

    var url = 'https://staging.churchinapp.com/api/userprofile';
    final Map<String,String> data = {"user_id":sp.getInt("user_id").toString()};
    print("testing data"+data.toString());
    /*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/
    Map<String,String> dat={"data":encryption(json.encode(data))};
    print("testing data"+dat.toString());
    try{
    final response = await http.post(Uri.parse(url),
    body: json.encode(dat),
    headers:{
    "CONTENT-TYPE":"application/json"
    }).timeout(const Duration(seconds: 20));/*setState(() {
    vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
    });*/
    print("status code:"+response.statusCode.toString());
    if (response.statusCode == 200) {

      String a=decryption(response.body.toString().trim()).split("}").length>2?decryption(response.body.toString().trim()).split("}")[0]+"}}":decryption(response.body.toString().trim()).split("}")[0]+"}";
      Map<String,dynamic> result=jsonDecode(a) as Map<String,dynamic>;

     // Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}}") as Map<String,dynamic>;
    if(result["status"]=="success")
      Navigator.push(context, MaterialPageRoute( builder: (BuildContext context)=>ProfileEditPage(result["results"],eventid)));
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
    }else{
      Navigator.of(context).pop();
      setState((){
        successtxt="";
        errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data - 1";
      });
    }
    }on TimeoutException catch(e) {
      Navigator.of(context).pop();
      setState((){
        errtxt="Please Check your Internet Connection And data - 2"
        ;successtxt="";

      });

    }on Exception catch(e){
    }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.password,
              ),
              title: const Text('Change Password'),
              onTap: () async{
                /* SharedPreferences sp=await SharedPreferences.getInstance();
                  sp.setBool("stay_signed",false);
                  sp.setInt("user_id",0);
                  Navigator.of(context).pushNamedAndRemoveUntil("/login",(route) => route.isFirst);*/
                Navigator.pushNamed(context, "/change",arguments:eventid);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: const Text('Logout'),
              onTap: ()  async{
                SharedPreferences sp=await SharedPreferences.getInstance();
                sp.setBool("stay_signed",false);
                sp.setInt("user_id",0);
                Navigator.of(context).pushNamedAndRemoveUntil("/login",(route) => route.isFirst);

              },
            ),
          ],
        ),
      ),
      body:Center(
    child:_loading?CircularProgressIndicator():SingleChildScrollView(
          child:Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
            /*Container(
          color: lightening_yellow,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                "assets/images/peep_standing_left.svg",
                width: 370,
                height: 590,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SvgPicture.asset(
                "assets/images/peep_standing_right.svg",
                width: 370,
                height: 590,
              ),
            ],
          ),
        ),
        Positioned(
          left: 24,
          top: 56,
          child: ButtonRoundWithShadow(
            size: 48,
            iconPath: "assets/icons/close.svg",
            borderColor: black,
            shadowColor: black,
            color: white,
            callback: () {
              Navigator.of(context).pop();
            },
          ),
        ),*/

            Container(
              height: 700,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              // margin: EdgeInsets.all(24),
              padding: EdgeInsets.all(24),
              /* decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: white),*/
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /*Column(
                children: [

                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                       /* SvgPicture.asset(
                          "assets/images/logo.svg",
                          width: 370,
                          height: 590,
                        ),*/

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Alfa For Everyone",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Start now by selecting a status .",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: trout,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //FlutterLogo(size: 100,),
                      SvgPicture.asset(
                        "assets/images/alfanewlogo.svg",
                        width: 200,
                        height: 250,
                      ),
                     // SizedBox(),
                     /* Flexible(

                          child: Text("Alpha For \nEveryone",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight:FontWeight.bold,
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              color: Colors.blue.shade900,

                            ),
                          )
                      ),*/
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    (errtxt!="" && errtxt!=null)?Text(errtxt,
    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),textAlign: TextAlign.center
    ):(successtxt!="")?Text(successtxt,
    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),textAlign: TextAlign.center
    ):Text("",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),textAlign: TextAlign.center
    ),
    SizedBox(
    height: 10,
    ),
                      ElevatedButton(
                        // color: wood_smoke,
                        // textColor: white,
                        // borderColor: wood_smoke,
                        //text: "FirstTimer",
                        /*onTap: () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setString("user_type", "0");
                      Helper.type="0";
                      Navigator.pushNamed(context, "/scanner");
                    }, */
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                          minimumSize: Size(250, 50),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(10)
                          ),// NEW
                        ),
                        onPressed: () async{
    Helper.type="1";
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M/d/y');
    String formatted = formatter.format(now);
    DateFormat formatter1 = DateFormat('jm');
    String formatted1 = formatter1.format(now);
    //print(formatted);
    SharedPreferences sp=await SharedPreferences.getInstance();
    var url = 'https://staging.churchinapp.com/api/currentmember';
    final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    'qrcode':eventid["value"],"member_type":Helper.type.toString(),"user_id":sp.getInt("user_id").toString()};
    print("testing data"+data.toString());
    /*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/
    Map<String,String> dat={"data":encryption(json.encode(data))};
    print("testing data"+dat.toString());
    try{
    final response = await http.post(Uri.parse(url),
    body: json.encode(dat),
    headers:{
    "CONTENT-TYPE":"application/json"
    }).timeout(const Duration(seconds: 20));/*setState(() {
    vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
    });*/
    print("status code:"+response.statusCode.toString());
    if (response.statusCode == 200) {
    Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

    /* final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};*/
    if(result["status"]=="success"){
    setState((){
    successtxt= result["message"];
    errtxt="";

    });
    } else{
    setState((){
    errtxt=result["message"];
    successtxt="";

    });
    }
    }else{
    setState((){
    successtxt="";
    errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data - 3";
    });
    }
    }on TimeoutException catch(e) {
    setState((){
    errtxt="Please Check your Internet Connection And data - 4"
    ;successtxt="";

    });

    }on Exception catch(e){
    }
           }, child: Text(
                        "First Timer",
                      ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        //color: persian_blue,
                        //textColor: white,
                        //borderColor: persian_blue,
                        // text: "Current Member",
                        /*onTap: () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setString("user_type", "1");
                      Helper.type="1";
                      Navigator.pushNamed(context, "/scanner");
                    },*/ onPressed: () async{
    Helper.type="3";
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M/d/y');
    String formatted = formatter.format(now);
    DateFormat formatter1 = DateFormat('jm');
    String formatted1 = formatter1.format(now);
    //String entry_mode="online";

    //print(formatted);
    SharedPreferences sp=await SharedPreferences.getInstance();

    /*showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Select Mode'),
        actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              entry_mode="online";
            });
            Navigator.pop(context, entry_mode);
          }, child: Text('Online')),
          ElevatedButton(onPressed: (){
            setState(() {
              entry_mode="offline";
            });
            Navigator.pop(context, entry_mode);
          }, child: Text('Offline'))
        ],
      );
    });
    print("entry mode"+entry_mode.toString());*/

    var url = 'https://staging.churchinapp.com/api/currentmember';
    final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    'qrcode':eventid["value"],"member_type":Helper.type.toString(),"user_id":sp.getInt("user_id").toString()};
    print("testing data"+data.toString());
    /*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/
    Map<String,String> dat={"data":encryption(json.encode(data))};
    print("testing data"+dat.toString());
    try{
    final response = await http.post(Uri.parse(url),
    body: json.encode(dat),
    headers:{
    "CONTENT-TYPE":"application/json"
    }).timeout(const Duration(seconds: 20));/*setState(() {
    vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
    });*/
    print("status code:"+response.statusCode.toString());
    if (response.statusCode == 200) {
    Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

    /* final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};*/
    if(result["status"]=="success"){
    setState((){
    successtxt= result["message"];
    errtxt="";

    });
    } else{
    setState((){
    errtxt=result["message"];
    successtxt="";

    });
    }
    }else{
    setState((){
    successtxt="";
    errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data - 5";
    });
    }
    }on TimeoutException catch(e) {
    setState((){
    errtxt="Please Check your Internet Connection And data - 6"
    ;successtxt="";

    });

    }on Exception catch(e){
    }
                      }, child: Text("Current member",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          minimumSize: Size(250, 50),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(10)
                          ),// NEW
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        //color: carribean_green,
                        //textColor: white,
                        //borderColor: carribean_green,
                        //text: "Signin For Children",
                        /*onTap: () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setString("user_type", "2");
                      Helper.type="2";
                      Navigator.pushNamed(context, "/scanner");
                    }, */
                        onPressed: ()  {
                          Helper.type="2";

                          Navigator.pushNamed(context, "/register",arguments: eventid);
                        },
                        child: Text(
                            "Sign-in for Children"
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7E56C8),
                          minimumSize: Size(250, 50),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(10)
                          ),// NEW
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        //color: carribean_green,
                        //textColor: white,
                        //borderColor: carribean_green,
                        //text: "Signin For Children",
                        /*onTap: () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      prefs.setString("user_type", "2");
                      Helper.type="2";
                      Navigator.pushNamed(context, "/scanner");
                    }, */
                        onPressed: ()  {
                          Helper.type="4";
                          Navigator.pushNamed(context, "/register",arguments: eventid);
                          /*DateTime now = DateTime.now();
                          DateFormat formatter = DateFormat('M/d/y');
                          String formatted = formatter.format(now);
                          DateFormat formatter1 = DateFormat('jm');
                          String formatted1 = formatter1.format(now);
                          //print(formatted);
                          var url = 'https://staging.churchinapp.com/api/eventregister';
                          SharedPreferences sp=await SharedPreferences.getInstance();

                          final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,"user_id":sp.getInt("user_id").toString(),
                            'qrcode':eventid["value"],"member_type":Helper.type.toString()};
                          print("testing data"+data.toString());
                          print("testing data"+json.encode({"data":encryption(json.encode(data))}));
                          try{
                            final response = await http.post(Uri.parse(url),
                                body: json.encode({"data":encryption(json.encode(data))}),
                                encoding: Encoding.getByName('utf-8'),
                                headers:{
                                  "CONTENT-TYPE":"application/json"
                                }).timeout(Duration(seconds:20));/*setState(() {
      vaue.text=response.statusCode.toString();
    });*/
                            if (response.statusCode == 200) {
                              Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

                              /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                              if(result["status"]=="success"){
                                setState((){
                                  successtxt=result["message"];
                                  errtxt="";
                                  //isShow=true;
                                });
                              } else{
                                setState((){
                                  errtxt=result["message"];
                                  successtxt="";
                                });
                              }
                            }else{
                              setState((){
                                successtxt="";
                                errtxt="Please Check your Internet Connection And data - 7"/*+response.statusCode.toString()+response.body*/;
                              });
                            }/*
    setState((){
    vaue.text="Please Check your Internet Connection And data";
    });*/
                          }on TimeoutException catch (_)  {
                            setState((){
                              successtxt="";
                              errtxt="Please Check your Internet Connection And data - 8";
                            });
                            //return false;
                          }on Exception catch(e){
                            setState((){
                              errtxt=e.toString();
                              successtxt="";

                            });

                          }*/
                        },
                        child: Text(
                            "Event Entry"
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange.shade500,
                          minimumSize: Size(250, 50),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(10)
                          ),// NEW
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: ()  async{
                          DateTime now = DateTime.now();
                          DateFormat formatter = DateFormat('M/d/y');
                          String formatted = formatter.format(now);
                          DateFormat formatter1 = DateFormat('jm');
                          String formatted1 = formatter1.format(now);
                          //print(formatted);
                          SharedPreferences sp=await SharedPreferences.getInstance();
                          var url = 'https://staging.churchinapp.com/api/adminaccountinfo';
                          final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
                          'qrcode':eventid["value"],"user_id":sp.getInt("user_id").toString()};
                          print("testing data"+data.toString());
                          print(url.toString());
                          /*  setState(()
                              {
                                vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
                              });*/
                          Map<String,String> dat={"data":encryption(json.encode(data))};
                          print("testing data"+dat.toString());
                          try{
                          final response = await http.post(Uri.parse(url),
                          body: json.encode(dat),
                          headers:{
                          "CONTENT-TYPE":"application/json"
                          }).timeout(const Duration(seconds: 20));/*setState(() {
                          vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
                          });*/
                          print("Status code:"+response.statusCode.toString());

                          //Navigator.pushNamed(context, "/offerings",arguments: eventid);
                          if (response.statusCode == 200) {
                          Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                          if(result["status"]=="success"){
                          setState((){
                          successtxt= "Redirecting to Offerings";
                          errtxt="";
                          eventid["stripe_id"]=result["stripeconnect_id"];
                          Navigator.pushNamed(context, "/offerings",arguments: eventid);
                          });
                          } else{
                          setState((){
                          errtxt=result["message"];
                          successtxt="";

                          });
                          }
                          }else{
                          setState((){
                          successtxt="";
                          errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data - 7";
                          });
                          }
                          }on TimeoutException catch(e) {
                          setState((){
                          errtxt="Please Check your Internet Connection And data - 8"
                          ;successtxt="";

                          });

                          }on Exception catch(e){
                          }

                        },
                        child: Text(
                            "Giving/Gift"
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent.shade200,
                          minimumSize: Size(250, 50),
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(10)
                          ),// NEW
                        ),
                      ),


                    ],
                  ),

                ],
              ),
            ),
    Column(

    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    Container(
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    TextButton(
    onPressed: (){
    _launchURL();
    },
    child:Text("Privacy Policy" ,
    textAlign: TextAlign.start,
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.blue,
    decoration: TextDecoration.underline,

    ),
    )                          ),
    ],
    ),
    )

    ],
    )
          ]) ),
    ));
  }
}
