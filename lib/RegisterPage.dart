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
import 'package:url_launcher/url_launcher.dart';

import 'ProfileEditPage.dart';
import 'helpers/encrypter.dart';
import 'helpers/helper.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _gender="Gender";
  String successtxt="",errtxt="";

  final TextEditingController _fullnamecontroller=TextEditingController();
  final TextEditingController _addresscontroller=TextEditingController();
  final TextEditingController _emailcontroller=TextEditingController();
  final TextEditingController _citycontroller=TextEditingController();
  final TextEditingController _statecontroller=TextEditingController();
  final TextEditingController _countrycontroller=TextEditingController();
  final TextEditingController _postalcodecontroller=TextEditingController();
  final TextEditingController _phonecontroller=TextEditingController();
  final TextEditingController _occupationcontroller=TextEditingController();
  final TextEditingController _teachercontroller=TextEditingController();
  //final TextEditingController vaue=TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController anniversaryInput = TextEditingController();
  String imageurl="";
  String fullname="";
  String address="";
  String email="";
  String city="";
  String postalcode="";
  String state_1="";
  String country="";
  String phone="";
  String occupation="";
  bool isShow=false;
  String dropdownvalue1 = 'Gender';
  var items1 = [
    'Gender',
    'Male',
    'Female',
  ];
  String referred_by = 'Referred By';
  var referrence = [
    'Referred By',
    'Invited By Friend',
    'Google',
    'Youtube',
    'Facebook',
    'Instagram',
  ];
  String teacher="";
  String classgroup = 'Select Age(In Years)';
  var items4 = [
    'Select Age(In Years)',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    //'Optional',
   /* '9-12 years',
    '13-18 years',
    '19-25 years',*/
  ];
  String marital = '-';
  var items2 = [
    '-',
    'Married',
    'Unmarried',
  ];
  String children = '0';
  var items3 = [
    '0',
    '1',
    '2',
  ];
  String _selectedType="-";
  final _formkey=GlobalKey<FormState>();
  final _formkey_1=GlobalKey<FormState>();
  final _formkey_2=GlobalKey<FormState>();
  final _formkey_4=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final eventid = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    print("ddddddd"+eventid.toString());
    if(Helper.type=="2"){

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
              onTap: ()  async{
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
                      errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data";
                    });
                  }
                }on TimeoutException catch(e) {
                  Navigator.of(context).pop();
                  setState((){
                    errtxt="Please Check your Internet Connection And data"
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
                Navigator.pushNamed(context, "/change", arguments: eventid);
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
      ),
    body: SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: Form(
    key:_formkey_1,
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
    /*IconButton(
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
    Text('Children Entry',
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
    controller: _fullnamecontroller,

    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.account_circle_rounded, color:Colors.orange),
    //labelText: "Full Name",
    hintText: "Full Name",
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
   /* validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter name';
    }
    return null;
    },*/
      validator: (value)=>FieldValidator.validateFullname(value!),
    onChanged: (value){
    setState((){
    fullname=value;
    });
    },
    ),
    SizedBox(
    height: 15,
    ),
    DropdownButtonFormField(
    value: _gender,

    validator: (value) {
    if (value == null || value=="Gender") {
    return 'Please select Gender';
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
    _gender = newValue!;
    });
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.person, color:Colors.orange),
    fillColor: Colors.orange.shade50,
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
    ),
    TextFormField(
    controller: _teachercontroller,
    validator: (value)=>FieldValidator.validateTeacherName(value!),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.person, color:Colors.orange),
    //labelText: "Full Name",
    hintText: "Teacher Name",
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
    onChanged: (value){
    setState((){
    teacher=value;
    });
    },
    ),
    SizedBox(
    height: 15,
    ),
    DropdownButtonFormField(
    value: classgroup,
    validator: (value) {
    if (value == null || value=="Select Age(In Years)") {
    return 'Please select age';
    }
    return null;
    },
    items: items4.map((String items) {
    return DropdownMenuItem(
    value: items,
    child: Text(items),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    classgroup = newValue!;
    });
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.person, color:Colors.orange),
    fillColor: Colors.orange.shade50,
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
    onPressed: ()async{
    if (_formkey_1.currentState!.validate()) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M/d/y');
    String formatted = formatter.format(now);
    DateFormat formatter1 = DateFormat('jm');
    String formatted1 = formatter1.format(now);
    //print(formatted);

    var url = 'https://staging.churchinapp.com/api/signinchildren';
    SharedPreferences sp=await SharedPreferences.getInstance();
    final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    "user_id":sp.getInt("user_id").toString(),'qrcode':eventid["value"],"member_type":Helper.type.toString(),"name":fullname,"gender":_gender,"teacher":teacher,"class_group":classgroup};
    print("testing data"+data.toString());
    print("testing data"+json.encode({"data":encryption(json.encode(data))}));
    /*  setState(()
    {
    vaue.text=encryption(json.encode(data)).toString();
    });*/
    try{
    final response = await http.post(Uri.parse(url),
    body:json.encode({"data":encryption(json.encode(data))}),
    encoding: Encoding.getByName('utf-8'),
    headers:{
    "CONTENT-TYPE":"application/json"
    }).timeout(const Duration(seconds: 20));/*setState(() {
    vaue.text=response.statusCode.toString();
    });*/
    if (response.statusCode == 200) {
    Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
    /*final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};*/
    if(result["status"]=="success"){
    setState((){
    successtxt=result["message"];
    errtxt="";
    _formkey_1.currentState!.reset();
    _fullnamecontroller.clear();
    classgroup="Select Age(In Years)";
    _teachercontroller.clear();
    _gender='Gender';
    });
    } else{
    setState((){
    errtxt=result["message"];
    successtxt="";
    _formkey_1.currentState!.reset();
    });
    }
    }else{
    setState((){
    errtxt="Please Check your Internet Connection And data";
    successtxt="";
    _formkey_1.currentState!.reset();
    });
    }
    }on TimeoutException catch(e) {
    setState((){
    errtxt="Please Check your Internet Connection And data";
    successtxt="";
    _formkey_1.currentState!.reset();
    });

    }on Exception catch(e){
    setState((){
    errtxt=e.toString();
    successtxt="";
    _formkey_1.currentState!.reset();
    });

    }
    }
    },
    child: Text("Register",),
    style: ElevatedButton.styleFrom(
    primary: Colors.orange,
    minimumSize: Size(150, 40),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
    ),
    ),
    ElevatedButton(onPressed: (){
    /*final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    'qrcode':eventid["value"],"member_type":Helper.type.toString(),"name":fullname,"gender":dropdownvalue1,"dob":dateInput.text,"address":address,"city":city,"state":state_1,"pincode":postalcode,"country":country,"marital_status":marital,"wed_anniversary":anniversaryInput.text,"no_of_child":children,"email":email,"phone_no":phone,"occupation":occupation};
    print("testing data"+data.toString());*/
    setState(()
    {
    _fullnamecontroller.clear();
    classgroup="Select Age(In Years)";
    _teachercontroller.clear();
    _gender='Gender';
    });
    }, child: Text(
    "Reset",
    ),
    style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    minimumSize: Size(150, 40),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
    ),
    ),
    Column(

    mainAxisAlignment: MainAxisAlignment.end,
    children: [

    SizedBox(height: 20,),

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
    decoration: TextDecoration.underline

    ),
    )                          ),
    ],
    ),
    )

    ],
    ),

    ],
    ),
    )
    ),
    ),
    );


    }else {
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
              onTap: ()  async{
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
                      errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data";
                    });
                  }
                }on TimeoutException catch(e) {
                  Navigator.of(context).pop();
                  setState((){
                    errtxt="Please Check your Internet Connection And data"
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
                Navigator.pushNamed(context, "/change", arguments: eventid);
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
      ),
    body:  SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: Form(
    key:_formkey_4,
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
    /*IconButton(
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
    Text('Event Entry',
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
    controller: _fullnamecontroller,
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter name';
    }
    return null;
    },*/
      validator: (value)=>FieldValidator.validateFullname(value!),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.account_circle_rounded,color:Colors.orange),
    //labelText: "Full Name",
    hintText: "Full Name",
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
    onChanged: (value){
    setState((){
    fullname=value;
    });
    },
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
    ), TextFormField(
    controller: _phonecontroller,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.phone, color: Colors.orange,
    ),
    //labelText: "Email",
    hintText: "Enter Phone",
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
    /*validator: (value) {
    if (value == null || value.isEmpty || value.length!=10) {
    return 'Please enter valid phone number';
    }
    return null;
    },*/
          validator:(value)=>FieldValidator.validateMobile(value!),
    keyboardType: TextInputType.phone,
    onChanged: (value){
    setState((){
    phone=value;
    });
    }
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    controller: _occupationcontroller,
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter Occupation';
    }
    return null;
    },*/
        validator: (value)=>FieldValidator.validateOccupation(value!),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.laptop, color: Colors.orange,),
    //labelText: "Email",
    hintText: "Enter Occupation",
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
    onChanged: (value){
    setState((){
    occupation=value;
    });
    }
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
    if (_formkey_4.currentState!.validate()) {

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M/d/y');
    String formatted = formatter.format(now);
    DateFormat formatter1 = DateFormat('jm');
    String formatted1 = formatter1.format(now);
    //print(formatted);
    var url = 'https://staging.churchinapp.com/api/eventregister';
    SharedPreferences sp=await SharedPreferences.getInstance();

    final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,"user_id":sp.getInt("user_id").toString(),
    'qrcode':eventid["value"],"member_type":Helper.type.toString(),"name":fullname,"email":email,"phone_no":phone,"occupation":occupation};
    print("testing data"+data.toString());
    print("testing data"+json.encode({"data":encryption(json.encode(data))}));
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
    if (response.statusCode == 200) {
    Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

    /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
    if(result["status"]=="success"){
    setState((){
    successtxt=result["message"];
    errtxt="";
    _fullnamecontroller.clear();
    _emailcontroller.clear();
    _phonecontroller.clear();
    _occupationcontroller.clear();
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
    errtxt="Please Check your Internet Connection And data"/*+response.statusCode.toString()+response.body*/;
    });
    }/*
    setState((){
    vaue.text="Please Check your Internet Connection And data";
    });*/
    }on TimeoutException catch (_) {
    setState((){
    successtxt="";
    errtxt="Please Check your Internet Connection And data";
    });
    //return false;
    }on Exception catch(e){
    setState((){
    errtxt=e.toString();
    successtxt="";

    });

    }
    }
    }, child: Text("Register",),
    style: ElevatedButton.styleFrom(
    primary: Colors.orange,
    minimumSize: Size(150, 40),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
    ),
    ),
    ElevatedButton(onPressed: (){
    /*final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    'qrcode':eventid["value"],"member_type":Helper.type.toString(),"name":fullname,"gender":dropdownvalue1,"dob":dateInput.text,"address":address,"city":city,"state":state_1,"pincode":postalcode,"country":country,"marital_status":marital,"wed_anniversary":anniversaryInput.text,"no_of_child":children,"email":email,"phone_no":phone,"occupation":occupation};
    print("testing data"+data.toString());*/
    setState(()
    {
    _fullnamecontroller.clear();
    _emailcontroller.clear();
    _phonecontroller.clear();
    _occupationcontroller.clear();
    });
    }, child: Text(
    "Reset",
    ),
    style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    minimumSize: Size(150, 40),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
    ),
    ),
    Column(

    mainAxisAlignment: MainAxisAlignment.end,
    children: [

    SizedBox(
    height: 16,
    ),
    Visibility(visible:isShow,
    child:
    Text("Are you Interested to do offerings")),
    Visibility(visible:isShow,
    child:
    SizedBox(
    height: 16,
    )),

    Visibility(visible:isShow,
    child:TextButton(
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

    Navigator.pushNamed(context, "/offerings",arguments: eventid);
    },
    child: Text(
    "Click Here"
    ),

    style: TextButton.styleFrom(
    primary: Colors.deepOrange.shade500,
    minimumSize: Size(250, 50),
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(10)
    ),// NEW
    ),)
    ),
    Visibility(visible:isShow,
    child:SizedBox(height: 20,),
    ),

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
    decoration: TextDecoration.underline

    ),
    )                          ),
    ],
    ),
    )

    ],
    ),

    ],
    ),
    ),
    )
    ),
    );

    }
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

}
