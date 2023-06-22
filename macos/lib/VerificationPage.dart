import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:churchIn/utils/colors.dart';
import 'package:churchIn/utils/valiidator.dart';
import 'package:churchIn/widgets/button_plain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/encrypter.dart';
import 'helpers/helper.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String successtxt = "",
      errtxt = "";
  String email = "";
  String password = "";
  bool stay_signed = false;
  final _formkey_2 = GlobalKey<FormState>();
  TextEditingController contrller1 = new TextEditingController();
  TextEditingController contrller2 = new TextEditingController();
  TextEditingController contrller3 = new TextEditingController();
  TextEditingController contrller4 = new TextEditingController();
  TextEditingController contrller5 = new TextEditingController();
  TextEditingController contrller6 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formkey_2,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    // margin: EdgeInsets.fromLTRB(0, 0, 5,5),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //FlutterLogo(size: 100,),
                          SvgPicture.asset(
                            "assets/images/newlogo.svg",
                            width: 50,
                            height: 50,
                          ),
                          //SizedBox(width: 100,),
                        ]
                    ),
                  ),

                  //Image(image: AssetImage('assets/images/UA_170_Logo.png'),width: 200,),
                  SizedBox(
                    height: 20,
                  ),
                  Text('OTP Verification',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ), Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(first: true, last: false, controllerr:
                        contrller1),
                        _textFieldOTP(first: false, last: false, controllerr:
                        contrller2),
                        _textFieldOTP(first: false, last: false, controllerr:
                        contrller3),
                        _textFieldOTP(first: false, last: false, controllerr:
                        contrller4),
                       /* _textFieldOTP(first: false, last: false, controllerr:
                        contrller5),
                        _textFieldOTP(first: false, last: true, controllerr:
                        contrller6)*/
                      ]), //Checkbox
                  SizedBox(
                    height: 15,
                  ),
                  (errtxt != "") ? Text(errtxt,
                    style: TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ) : (successtxt != "") ? Text(successtxt,
                    style: TextStyle(color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ) : Text("",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextButton(onPressed: () async{
                    SharedPreferences sp=await SharedPreferences.getInstance();
                    var user_id=sp.containsKey("user_id")?sp.getInt("user_id"):0;                      //print(formatted);
                    var url = 'https://staging.churchinapp.com/api/resendotp';
                    var email=sp.getString("email");
                    try{
                      var url = 'https://staging.churchinapp.com/api/resendotp';
                      final Map<String,String> data = {"email":email.toString()};
                      final response = await http.post(Uri.parse(url),
                          body: json.encode({"data":encryption(json.encode(data))}),
                          encoding: Encoding.getByName('utf-8'),
                          headers:{
                            "CONTENT-TYPE":"application/json"
                          }).timeout(Duration(seconds:20));/*setState(() {
      vaue.text=response.statusCode.toString();
    });*/
                      Map<String,String> dat={"data":encryption(json.encode(data))};
                      print("testing data"+dat.toString());
                      if (response.statusCode == 200) {
                        Map<String,dynamic> result_1=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

                        /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                        if(result_1["status"]=="success"){
    setState(() {
      successtxt = result_1["message"];
      errtxt = "";
    });
                        }else{
                          setState((){
                            errtxt=result_1["message"];
                            successtxt="";
                          });

                        }
                      }else{
                        setState((){
                          successtxt="";
                          errtxt=="Please Check your Internet Connection And data - 1";
                        });
                      }
                    }on TimeoutException catch (_) {
                      setState((){
                        successtxt="";
                        errtxt="Please Check your Internet Connection And data - 2";
                      });
                      //return false;
                    }on Exception catch(e){
                      setState((){
                        errtxt=e.toString();
                        successtxt="";

                      });

                    }
                  }, child: Text("Resend OTP",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: black),
                  ),),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formkey_2.currentState!.validate ()
                      ) {

                      DateTime now = DateTime.now();
                      DateFormat formatter = DateFormat('M/d/y');
                      String formatted = formatter.format(now);
                      DateFormat formatter1 = DateFormat('jm');
                      String formatted1 = formatter1.format(now);
                      SharedPreferences sp=await SharedPreferences.getInstance();
                      var user_id=sp.containsKey("user_id")?sp.getInt("user_id"):0;                      //print(formatted);
                      var url = 'https://staging.churchinapp.com/api/verifyotp';
                      var email=sp.getString("email");
                      final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
                      "email":email.toString(),"otp":contrller1.text+contrller2.text+contrller3.text+contrller4.text,/*+contrller5.text+contrller6.text,*/"user_id":user_id!.toString()};
                      print("testing data"+data.toString());
                      /* setState(()
          {
            vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
          });*/try{
                      final response = await http.post(Uri.parse(url),
                      body: json.encode({"data":encryption(json.encode(data))}),
                      encoding: Encoding.getByName('utf-8'),
                      headers:{
                      "CONTENT-TYPE":"application/json"
                      }).timeout(Duration(seconds:20));/*setState(() {
      vaue.text=response.statusCode.toString();
    });*/                Map<String,String> dat={"data":encryption(json.encode(data))};
                      print("testing data"+dat.toString());
                      if (response.statusCode == 200) {
                      Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

                      /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
                      if(result["status"]=="success"){

                      Navigator.pushNamed(context, "/scanner");
                      print('success');
                      } else if(result["status"]=="expired"){
                      setState((){
                      errtxt="OTP Expired click resend OTP";
                      successtxt="";
                      });
                      }else{
                      setState((){
                      errtxt=result["message"];
                      successtxt="";
                      });
                      }
                      }else{
                      setState((){
                      successtxt="";
                      errtxt="Please Check your Internet Connection And data statusCode - 3" +response.statusCode.toString();
                      });
                     // Navigator.pushNamed(context, "/scanner");
                      }/*
    setState((){
    vaue.text="Please Check your Internet Connection And data";
    });*/
                      }on TimeoutException catch (_) {
                      setState((){
                      successtxt="";
                      errtxt="Please Check your Internet Connection And data - 4";
                      });
                      //return false;
                      }on Exception catch(e){
                      setState((){
                      errtxt=e.toString();
                      successtxt="";

                      });

                      }
                      }
                    }, child: Text("Verify"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      minimumSize: Size(150, 40),
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(10)
                      ), // NEW
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  Widget _textFieldOTP({bool ? first, last,
    TextEditingController ?
    controllerr}) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      height: height!/12,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextFormField(
          controller: controllerr,
          validator: (value) {
      if (value == null || value.isEmpty) {
      return 'Enter Valid OTP';
      }
      return null;
      },
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black54),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black54),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
