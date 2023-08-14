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

class ForgotPwdPage extends StatefulWidget {
  ForgotPwdPage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<ForgotPwdPage> createState() => _ForgotPwdPageState();
}

class _ForgotPwdPageState extends State<ForgotPwdPage> {
  String successtxt="",errtxt="";
   final TextEditingController _emailcontroller=TextEditingController();
  String email="";
  final _formkey_2=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    resizeToAvoidBottomInset: false,
    body:  SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: Form(
    key:_formkey_2,
    child:Column(
    children: <Widget>[
    SizedBox(
    height: 100,
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
    ) ,

    //Image(image: AssetImage('assets/images/UA_170_Logo.png'),width: 200,),
      SizedBox(
        height: 20,
      ),
    Text('Forgot Password',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    ),
    textAlign: TextAlign.center,
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    controller: _emailcontroller,
    validator:(value)=>FieldValidator.validateEmail(value!),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.email,color:Colors.orange),
    //labelText: "Full Name",
    hintText: "Email",
    fillColor: Colors.orange.shade50,
    filled: true,
    //labelStyle: TextStyle(fontSize: 15,color: Colors.blue),
    hintStyle: TextStyle(fontSize: 16.0, color: Colors.orange, fontWeight: FontWeight.bold),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
    color: Colors.orange,
    ),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
    color: Colors.deepOrange.shade200,
    width: 1.0,
    ),
    ),
    errorBorder: new OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
    color: Colors.red.shade200,
    width: 1.0,
    ),
    ),
    focusedErrorBorder: new OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
    color: Colors.red.shade200,
    width: 1.0,
    ),
    )
    ),
    keyboardType: TextInputType.emailAddress,
    onChanged: (value){
    setState((){
    email=value;
    });
    },
    ),
    SizedBox(
    height: 15,
    ),

    (errtxt!="" && errtxt!=null)?Text(errtxt,
    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
    ):(successtxt!="")?Text(successtxt,
    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
    ):Text("",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    ),
    SizedBox(
    height: 25,
    ),

    ElevatedButton(
    onPressed: () async{
    if (_formkey_2.currentState!.validate()) {


    //print(formatted);
    var url = 'https://churchinapp.com/api/forgotpassword';
    final Map<String,String> data = {"email":email};
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
    });*/
      Map<String,String> dat={"data":encryption(json.encode(data))};
      print("testing data"+dat.toString());
      print("testing data"+response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
print(result.toString());
      /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
      if(result["status"]=="success"){
      setState((){
      successtxt=result["message"];
      errtxt="";
      _emailcontroller.clear();

      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.pop(context);
        });
      });
      } else{


      setState((){
      successtxt="";
      errtxt=result["message"];
     _emailcontroller.clear();

      });

      }
      }else{
      setState((){
      successtxt="";
      errtxt==response.statusCode.toString()+"Please Check your Internet Connection And data - 1";
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
    }
    }, child: Text("Submit",),
    style: ElevatedButton.styleFrom(
    primary: Colors.orange,
    minimumSize: Size(150, 40),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
    ),
    ),
    ],
    ),
    ),
    )
    ),
    );
  }
}
