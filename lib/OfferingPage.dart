import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:churchIn/CheckoutPage.dart';
import 'package:churchIn/payment/CheckoutSessionResponse.dart';
import 'package:churchIn/utils/colors.dart';
import 'package:churchIn/utils/valiidator.dart';
import 'package:churchIn/widgets/button_plain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ProfileEditPage.dart';
import 'helpers/encrypter.dart';
import 'helpers/helper.dart';

class OfferingPage extends StatefulWidget {
  OfferingPage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<OfferingPage> createState() => _OfferingPageState();
}

class _OfferingPageState extends State<OfferingPage> {
  String _offerings="Select Offerings >>>";
  String _amnt="\$10";
  String successtxt="",errtxt="";

  final TextEditingController _othercontroller=TextEditingController();
  bool isShow=false,_isreadonly=true;
  String dropdownvalue1 = 'Select Offerings ->';
  var items1 = [
    'Select Offerings ->',
    'Tithe',
    'Pastors Appreciation',
    'Thanks Giving',
    'Children Church',
  ];
  String referred_by = 'Select Amount ->';
  var referrence = [
    'Select Amount ->',
    '\$10',
    '\$25',
    '\$50',
    '\$100',
    '\$250',
    '\$500',
    '\$1000',
    '\$2500',
    'Other'
  ];
  final _formkey=GlobalKey<FormState>();
  bool _loading=true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventid = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    print("ddddddd"+eventid.toString());
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //centerTitle: true,
          title: const Text(
            'ChurchIn',
          ),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, "/menu",arguments: eventid);
                },
                icon: Icon(
                  Icons.home, size: 30,color: Colors.white,
                )
            ),
          ],
        ),
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75, // 75% of screen will be occupied
            child:Drawer(
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
                  Navigator.pushNamed(context, "/change");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                ),
                title: const Text('Logout'),
                onTap: () async{
                  SharedPreferences sp=await SharedPreferences.getInstance();
                  sp.setBool("stay_signed",false);
                  sp.setInt("user_id",0);
                  Navigator.of(context).pushNamedAndRemoveUntil("/login",(route) => route.isFirst);

                },
              ),
            ],
          ),
        )),
    body:  Center(
        child:_loading?CircularProgressIndicator():SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: Form(
    key:_formkey,
    child:Column(
    children: <Widget>[
    SizedBox(
    height: 30,
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
   /* IconButton(
    onPressed: (){
    Navigator.pushNamed(context, "/menu",arguments: eventid);
    },
    icon: Icon(
    Icons.home, size: 30,color: Colors.orange,
    )
    ),*/
    ]
    ),
    ) ,

    //Image(image: AssetImage('assets/images/UA_170_Logo.png'),width: 200,),
      SizedBox(
        height: 20,
      ),
    Text('Donation',
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
    DropdownButtonFormField(
    value: dropdownvalue1,
   // dropdownColor: Colors.orange,
    validator: (value) {
    if (value == null || value=="Select Offerings ->") {
    return 'Please select offerings';
    }
    return null;
    },
    items: items1.map((String items) {
    return DropdownMenuItem(
    value: items,
    child: Text(items),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    dropdownvalue1 = newValue!;
    });
    },

    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.card_giftcard, color: Colors.orange,),
    fillColor:Colors.orange.shade50,
    filled: true,
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
    ),

    SizedBox(
    height: 15,
    ), DropdownButtonFormField(
    value: referred_by,
    validator: (value) {
    if (value == null || value=="Select Amount ->") {
    return 'Please select Amount';
    }
    return null;
    },
    items: referrence.map((String items) {
    return DropdownMenuItem(
    value: items,
    child: Text(items),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _amnt = newValue!;
    if(_amnt!="Other"){
    _othercontroller.text=newValue!.split("\$")[1];
    _amnt=newValue!.split("\$")[1];
    _isreadonly=true;
    }else{
      _isreadonly=false;
    }
    referred_by=newValue!;
    });
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.money, color: Colors.orange,),
    fillColor:Colors.orange.shade50,
    filled: true,
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
    ),

    SizedBox(
    height: 15,
    ), TextFormField(
    controller: _othercontroller,
    readOnly: _isreadonly,
    keyboardType:TextInputType.number,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.money, color: Colors.orange,
    ),
    //labelText: "Email",
    hintText: "Enter Amount",
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
    validator: (value) {
    if (value == null || value.isEmpty || value.length<=0) {
    return 'Please enter amount';
    }
    return null;
    },
    onChanged: (value){
    setState((){
    _amnt=value;
    });
    }
    ),
    SizedBox(
    height: 15,
    ),
    (errtxt!="")?Text(errtxt,
    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
    ):(successtxt!="")?Text(successtxt,
    style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.bold, fontSize: 12),
    ):Text("",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    ),
    SizedBox(
    height: 25,
    ),
    ElevatedButton(
    onPressed: () async{
    if (_formkey.currentState!.validate()) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M/d/y');
    String formatted = formatter.format(now);
    DateFormat formatter1 = DateFormat('jm');
    String formatted1 = formatter1.format(now);

    SharedPreferences sp=await SharedPreferences.getInstance();

    sp.setString("offering_type",_offerings);
    sp.setString("amount",_amnt);
    eventid["offer_type"]=_offerings.toString();
    eventid["offer_amt"]=_amnt.toString();
    Navigator.pushNamed(context, "/checkout",arguments: eventid)
    /*Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(acntId:eventid["stripe_id"]),
    ))*/
    ;
    /* setState(()++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          {
            vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
          });*/
    //print(formatted);
    }
    }, child: Text("Payment",),
    style: ElevatedButton.styleFrom(
    primary: Colors.orange,
    minimumSize: Size(150, 40),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
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
    ],
    ),

    ),
    ),
    )
    ));


  }
  _launchURL() async {
    const url = 'https://churchinapp.com/privacypolicy';
    try {
      final uri = Uri.parse(url);

      await launchUrl(uri);

    }on Exception catch (e){
      print("Exception in launching the url");
    }
  }

}
