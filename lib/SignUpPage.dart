import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:churchIn/VerificationPage.dart';
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

class SignUpPage extends StatefulWidget {
  SignUpPage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
  TextEditingController dateInput = TextEditingController();
  TextEditingController anniversaryInput = TextEditingController();
  TextEditingController _passwordcontroller= TextEditingController();
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
  String password="";
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
  //String marital = 'Marital Status';
  String? marital ;
  List<String> items2 = ['Married', 'Unmarried'];
  String? selectedOption;
  List<String> options = [
    'Married',
    'Unmarried',
    // Add more options as needed
  ];

  /*var items2 = [
    //'Marital Status',
    'Married',
    'Unmarried',
  ];*/
  String children = 'Number Of Kids';
  var items3 = [
    'Number Of Kids',
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
    '12'
  ];
  final _formkey=GlobalKey<FormState>();
  bool showpwd=true;
  @override
  Widget build(BuildContext context) {
     return Scaffold(
    resizeToAvoidBottomInset: true,
    body: SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
    child:Form(
    key:_formkey,
    child:Column(
    children: <Widget>[
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
    Navigator.pushNamed(context, "/scanner");
    },
    icon: Icon(
    Icons.home, size: 30,color: Colors.orange,
    )
    ),*/
    ]
    ),
    ) ,
    SizedBox(height: 10,),
    //Image(image: AssetImage('assets/images/UA_170_Logo.png'),width: 200,),
    Text('Registration',
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
    style: TextStyle(height: 0,),
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
    prefixIcon: Icon(Icons.account_circle_rounded,color: Colors.orange,),
    //labelText: "Full Name",
    hintText: "Full Name",
    fillColor: Colors.orange.shade50,
    filled: true,
    hintStyle: TextStyle(fontSize: 16.0, color: Colors.orange, fontWeight: FontWeight.bold),
    //labelStyle: TextStyle(fontSize: 15,color: Colors.blue),
    /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.lightBlue),
                  ),*/
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
    color: Colors.deepPurple.shade200,
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
    DropdownButtonFormField(
    value: dropdownvalue1,
    validator: (value) {
    if (value == null || value=="Gender") {
    return 'Please select gender';
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
    prefixIcon: Icon(Icons.person, color: Colors.orange,),
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
    ),
    TextFormField(
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter date of birth';
    }
    return null;
    },*/
    controller: dateInput,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.calendar_today, color: Colors.orange,), //icon of text field
    // labelText: "Enter DOB",
    hintText: "Enter DOB(Optional)",
    fillColor:Colors.orange.shade50,
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

    readOnly: true,
    //set it true, so that user will not able to edit text
    onTap: () async {
    DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime(2015),
    firstDate: DateTime(1950),
    //DateTime.now() - not to allow to choose before today.
    lastDate: DateTime(2015));

    if (pickedDate != null) {
    print(
    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
    String formattedDate =
    DateFormat('yyyy-MM-dd').format(pickedDate);
    print(
    formattedDate); //formatted date output using intl package =>  2021-03-16
    setState(() {
    dateInput.text =
    formattedDate; //set output date to TextField value.
    });
    } else {}
    },

    ),

    SizedBox(
    height: 15,
    ),
    TextFormField(
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter Address';
    }
    return null;
    },*/
    controller: _addresscontroller,
    keyboardType: TextInputType.multiline,
    textInputAction: TextInputAction.newline,
    maxLines: 5,
    minLines: 1,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.notes,color: Colors.orange,),
    //labelText: "Address",
    hintText: "Enter Address(Optional)",
    fillColor: Colors.orange.shade50,
    filled: true,
    // labelStyle: TextStyle(fontSize: 15,color: Colors.blue),
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
    address=value;
    });
    }
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter City';
    }
    return null;
    },*/

      validator: (value)=>FieldValidator.validateCity(value!),
    controller: _citycontroller,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.location_city, color: Colors.orange,),
    //labelText: "City",
    hintText: "Enter City",
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
    city=value;
    });
    },
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter State';
    }
    return null;
    },*/
      validator: (value)=>FieldValidator.validateState(value!),
    controller: _statecontroller,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.location_city, color: Colors.orange,),
    //labelText: "City",
    hintText: "Enter State",
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
    state_1=value;
    });
    },
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    controller: _countrycontroller,
    /*validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter valid country';
    }
    return null;
    },*/
      validator: (value)=>FieldValidator.validateCountry(value!),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.location_city, color: Colors.orange,),
    //labelText: "City",
    hintText: "Enter Country",
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
    country=value;
    });
    },
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter valid postal code';
    }
    return null;
    },
        keyboardType: TextInputType.number,
    controller: _postalcodecontroller,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.pin_drop, color: Colors.orange,),
    //labelText: "City",
    hintText: "Enter Postal Code",
    fillColor:Colors.orange.shade50,
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
    postalcode=value;
    });}
    ),


    SizedBox(
    height: 15,
    ),
    TextFormField(
    controller: _emailcontroller,
    validator: (value)=>FieldValidator.validateEmail(value!),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.email_outlined, color: Colors.orange,),
    //labelText: "Email",
    hintText: "Enter Email",
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
    email=value;
    });
    }
    ),
    SizedBox(
    height: 15,
    ),
    TextFormField(
    controller: _passwordcontroller,
    obscureText: showpwd,
    validator: (value) {
    if (value == null || (value.isEmpty)) {
    return 'Please enter Password';
    }
    return null;
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.password, color: Colors.orange,),
    //labelText: "Email",
    hintText: "Enter Password",
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
    suffixIcon: IconButton(
      icon: Icon(showpwd
          ? Icons.visibility
          : Icons.visibility_off),
      onPressed: () {
        setState(
              () {
                showpwd = !showpwd;
          },
        );
      },
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
    password=value;
    });
    }
    ),
    SizedBox(
    height: 15,
    ),

      DropdownButtonFormField<String>(
        value: selectedOption, // Set the selected value
        items: [
          DropdownMenuItem<String>(
            value: null, // Set the value as null for the default item
            child: Text('Marital Status(Optional)',style: TextStyle(fontSize: 16.0, color: Colors.orange,fontWeight: FontWeight.bold),),
          ),
          ...options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }),
        ],
        onChanged: (value) {
          setState(() {
            selectedOption = value; // Update the selected value
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            prefixIcon: Icon(Icons.person, color: Colors.orange,),
            fillColor: Colors.orange.shade50,
            filled: true,

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
    /*DropdownButtonFormField(
      value: marital,
      validator: (value) {
        if (value == null || value=="Marital Status") {
          return 'Please enter valid Marital status';
        }
        return null;
      },
      items: items2.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          marital = newValue!;
        });
      },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.person, color: Colors.orange,),
    fillColor: Colors.orange.shade50,
    filled: true,

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
    ),*/
    SizedBox(
    height: 15,
    ),

    TextFormField(
    controller: anniversaryInput,
    validator: (value) {
    if (value == null || (value.isEmpty && marital=="Married")) {
    return 'Please enter anniversary date';
    }
    return null;
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.calendar_today, color: Colors.orange,), //icon of text field
    // labelText: "Enter DOB",
    hintText: "Wedding Anniversary Date",
    fillColor: Colors.orange.shade50,
    filled: true,
    hintStyle: TextStyle(fontSize: 16.0, color: Colors.orange, fontWeight: FontWeight.bold),
    //labelStyle: TextStyle(fontSize: 15,color: Colors.blue),
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

    readOnly: true,
    //set it true, so that user will not able to edit text
    onTap: () async {
    DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    //DateTime.now() - not to allow to choose before today.
    lastDate: DateTime.now());

    if (pickedDate != null) {
    print(
    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
    String formattedDate =
    DateFormat('yyyy-MM-dd').format(pickedDate);
    print(
    formattedDate); //formatted date output using intl package =>  2021-03-16
    setState(() {
    anniversaryInput.text =
    formattedDate; //set output date to TextField value.
    });
    } else {}
    },

    ),

    SizedBox(
    height: 15,
    ),
    DropdownButtonFormField(
    value: children,
      validator: (value) {
        if (value == null || value=="Number Of Kids") {
          return 'Please select number of kids';
        }
        return null;
      },
    items: items3.map((String items) {
    return DropdownMenuItem(
    value: items,
    child: Text(items),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    children = newValue!;
    });
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.person, color: Colors.orange,),
    fillColor: Colors.orange.shade50,
    filled: true,
    hintText: "No of childs",
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
    controller: _phonecontroller,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.phone, color: Colors.orange,
    ),
    //labelText: "Email",
    hintText: "Enter Phone(Optional)",
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
        validator: (value)=>FieldValidator.validateMobile(value!),
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
    DropdownButtonFormField(
    value: referred_by,
    validator: (value) {
    if (value == null || value=="Referred By") {
    return 'Please select how do you know';
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
    referred_by = newValue!;
    });
    },
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    prefixIcon: Icon(Icons.person, color: Colors.orange,),
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
    // color: wood_smoke,
    //textColor: white,
    //borderColor: wood_smoke,
    // text: "Register",
    /* onTap: () async{
    if (_formkey.currentState!.validate()) {
    var url = 'https://churchinapp.com/public/api/memberregister';
    final Map<String,String> data = {
    'id':eventid["id"],"name":fullname,"gender":dropdownvalue1,"dob":dateInput.text,"address":address,"city":city,"state":state_1,"postalcode":postalcode,"country":country,"marital_status":marital,"anniversary":anniversaryInput.text,"no_of_children":children,"email":email,"phone_number":phone,"occupation":occupation};
    print("testing data"+data.toString());
    setState(()
    {
      vaue.text=data.toString();
    });

    /*final response = await http.post(Uri.parse(url),
    body: encryption(json.encode(data)),
    encoding: Encoding.getByName('utf-8'),
    headers:{
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    });
    if (response.statusCode == 200) {
    *///Map<String,dynamic> result=json.decode(decryption(response.body));

    final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};
    if(result["message"]=="success"){
    SharedPreferences prefs = await SharedPreferences
        .getInstance();
    prefs.setString("user_type", "1");
    prefs.setString("user_id", result["user_id"]);
    setState(() {
      Helper.type="1";
    });
    }
    //}
    }
    }, */
    onPressed: () async{
    if (_formkey.currentState!.validate()) {


    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('M/d/y');
    String formatted = formatter.format(now);
    DateFormat formatter1 = DateFormat('jm');
    String formatted1 = formatter1.format(now);
    //print(formatted);

    var url = 'https:'
        '//churchinapp.com/api/memberregister';
    final Map<String,String> data = {"entry_date":formatted,"entry_time":formatted1,
    "password":password,"name":fullname,"gender":dropdownvalue1,"dob":dateInput.text,"address":address,"city":city,"state":state_1,"pincode":postalcode,"country":country,"marital_status":selectedOption.toString(),"wed_anniversary":anniversaryInput.text,"no_of_child":children,"email":email,"phone_no":phone,"occupation":occupation,"referred_by":referred_by};
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
    if (response.statusCode == 200) {
    Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

    /* final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};*/
    if(result["status"]=="success"){
      SharedPreferences sp=await SharedPreferences.getInstance();
      sp.setInt("user_id",result["user_id"]);
      sp.setString("email",email);
      sp.setBool("resend",false);
     // if(result["message"]=="Registered Successfully"){
    setState((){
    successtxt=result["message"];
    errtxt="";
    _fullnamecontroller.clear();
    _addresscontroller.clear();
    _emailcontroller.clear();
    _citycontroller.clear();
    _countrycontroller.clear();
    _occupationcontroller.clear();
    _phonecontroller.clear();
    _postalcodecontroller.clear();
    _statecontroller.clear();
    _passwordcontroller.clear();
    dateInput.clear();
    anniversaryInput.clear();
    dropdownvalue1='Gender';
    //state_1="";
    marital="Marital Status";
    children="Number Of Kids";
    referred_by="Referred By";
    selectedOption=null;
    });
      //}else
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.pushNamed(context,"/verification");
        });
      });
      print('success');
      //Navigator.of(context).push(MaterialPageRoute(builder:(context)=>VerificationPage()));
    } else
    if(result["status"]=="not_verified"){
      print(result.toString());
      SharedPreferences sp=await SharedPreferences.getInstance();
      sp.setInt("user_id",result["user_id"]);
      sp.setString("email",email);
      sp.setBool("resend",false);
      setState((){
      successtxt= "You Already Registered But Not Verified";
      errtxt="";
      _fullnamecontroller.clear();
      _addresscontroller.clear();
      _emailcontroller.clear();
      _citycontroller.clear();
      _countrycontroller.clear();
      _occupationcontroller.clear();
      _phonecontroller.clear();
      _postalcodecontroller.clear();
      _statecontroller.clear();
      _passwordcontroller.clear();
      dateInput.clear();
      anniversaryInput.clear();
      dropdownvalue1='Gender';
      //state_1="";
      marital="Marital Status";
      children="Number Of Kids";

      });
      //Navigator.pushNamed(context,"/verification");
      print('success');
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.pushNamed(context,"/verification");
        });
      });
    }else if(result["status"]=="email_exist"){
      setState((){
      errtxt=result["message"];
      successtxt="";

      });
     // Navigator.pushNamed(context, "/login");
      }else if(result["status"]=="expired"){
      SharedPreferences sp=await SharedPreferences.getInstance();
      // if(stay_signed){
      sp.setInt("user_id", result["user_id"]);
      sp.setString("email", email);
      sp.setBool("resend", true);
      try{
      var url = 'https://churchinapp.com/api/resendotp';
      final Map<String,String> data = {"email":email};
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
      print("testing data"+data.toString());
      if (response.statusCode == 200) {
      Map<String,dynamic> result_1=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;

      /*   final Map<String,dynamic> result = {
            "message":"success","user_id":"1"};*/
      if(result_1["status"]=="success"){
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            Navigator.pushNamed(context,"/verification");
          });
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

      }
    }
    else{
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
    setState((){
    errtxt=e.toString();
    successtxt="";

    });

    }
    }
    }, child: Text(
    "Register",
    ),
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
    _addresscontroller.clear();
    _emailcontroller.clear();
    _citycontroller.clear();
    _countrycontroller.clear();
    _occupationcontroller.clear();
    _phonecontroller.clear();
    _postalcodecontroller.clear();
    _statecontroller.clear();
    _passwordcontroller.clear();
    dateInput.clear();
    anniversaryInput.clear();
    dropdownvalue1='Gender';
    //state_1="";
    marital="Marital Status";
    children="Number Of Kids";
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
    ],
    ),
    )
    ),
    ),
    );
  }
}
