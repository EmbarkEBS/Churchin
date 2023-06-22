import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import 'helpers/encrypter.dart';
String stripePublicKey = 'pk_test_51Lm3WYE19ITEKWtg9MN0eIb8Y2yG6h04zOHYdnSxRV6NgHnGm6upQRbQTfLH6bfZOu7k6dGLR0rk7NgA0BjlSoeK00ieYPz8bA';

class CheckoutPage extends StatefulWidget {


   CheckoutPage() ;

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  final String postCreateIntentURL = "https:/yourserver/postPaymentIntent";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();

  Map<String,dynamic> eventid=new Map<String,dynamic>();

  @override
  Widget build(BuildContext context) {
     eventid = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    final Stripe stripe = Stripe(
    "pk_test_51Lm3WYE19ITEKWtg9MN0eIb8Y2yG6h04zOHYdnSxRV6NgHnGm6upQRbQTfLH6bfZOu7k6dGLR0rk7NgA0BjlSoeK00ieYPz8bA", //Your Publishable Key
    stripeAccount: eventid["stripe_id"], //Merchant Connected Account ID. It is the same ID set on server-side.
    returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
  );
    return Scaffold(
      appBar: AppBar(
        title: Text("Stripe Payment"),
        backgroundColor: Colors.orange,
      ),
      body: new SingleChildScrollView(
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: [
                CardForm(
                    formKey: formKey,
                    card: card
                ),
                Container(
                  child: ElevatedButton(
                      //color: Colors.green,
                     // textColor: Colors.white,

                      child: const Text('Pay Now',),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      minimumSize: Size(150, 40),
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(10)
                      ),// NEW
                    ),
                      onPressed: () {
                        formKey.currentState!.validate();
                        formKey.currentState!.save();
                        buy(context,stripe);
                      },

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buy(context,stripe) async{
    final StripeCard stripeCard = card;
    final Future<String> customerEmail = getCustomerEmail();

    if(!stripeCard.validateCVC()){showAlertDialog(context, "Error", "CVC not valid."); return;}
    if(!stripeCard.validateDate()){showAlertDialog(context, "Errore", "Date not valid."); return;}
    if(!stripeCard.validateNumber()){showAlertDialog(context, "Error", "Number not valid."); return;}

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail.toString(),stripe);
    String clientSecret = paymentIntentRes['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['status'];
    print("bbbbbb "+paymentMethodId+","+status);
    if(status == 'requires_action') //3D secure is enable in this card
      paymentIntentRes = await confirmPayment3DSecure(clientSecret, paymentMethodId,stripe);

    if(paymentIntentRes['status'] != 'succeeded'){
      showAlertDialog(context, "Warning", "Canceled Transaction.");
      return;
    }

    if(paymentIntentRes['status'] == 'succeeded'){
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('M/d/y');
      String formatted = formatter.format(now);
      DateFormat formatter1 = DateFormat('jm');
      String formatted1 = formatter1.format(now);
      //print(formatted);
      SharedPreferences sp=await SharedPreferences.getInstance();
      var url = 'https://staging.churchinapp.com/api/givinggift';
      final Map<String,String> data = {"offer_type":eventid["offer_type"],"offer_amt":eventid["offer_amt"], "entry_date":formatted,"entry_time":formatted1,"member_type":"5"
        ,'qrcode':eventid["value"],"user_id":sp.getInt("user_id").toString(),"payment_status":paymentIntentRes['status'],"payment_id":paymentIntentRes['payment_method']};
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
           showAlertDialog(context, "Success", "Thanks for Offerings!");

          } else{
    showAlertDialog(context, "Failed", result["message"]);
    }
        }else{
    showAlertDialog(context, "Failed", response.statusCode.toString());

    }
      }on TimeoutException catch(e) {
    showAlertDialog(context, "Failed", e.toString());

    }on Exception catch(e){
    showAlertDialog(context, "Failed", e.toString());
    }

      return;
    }
    showAlertDialog(context, "Warning", "Transaction rejected.\nSomething went wrong");
  }

  Future<Map<String, dynamic>> createPaymentIntent(StripeCard stripeCard, String customerEmail,Stripe stripe) async{
    String clientSecret;
    Map<String, dynamic> paymentIntentRes=new Map<String, dynamic>(), paymentMethod;
    try{
      paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
      clientSecret = await postCreatePaymentIntent(customerEmail, paymentMethod['id']);
      paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
    }catch(e){
      print("ERROR_CreatePaymentIntentAndSubmit: $e");
      showAlertDialog(context, "Error", "Something went wrong.");
    }print(paymentIntentRes.toString());
    return paymentIntentRes;
  }

  Future<String> postCreatePaymentIntent(String email, String paymentMethodId) async{
    String clientSecret="";

    SharedPreferences sp=await SharedPreferences.getInstance();
    var url = 'https://staging.churchinapp.com/api/checkoutsession';
    final Map<String,String> data = {"amount":sp.getString("amount")!,"account_id":eventid["stripe_id"],
      'payment_id':paymentMethodId,"email":sp.getString("email")!,"quantity":"1"};
    print("testing data"+data.toString());

/*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/

    Map<String,String> dat={"data":encryption(json.encode(data))};
    print("testing data"+dat.toString());
    try{
      final response = await http.post(Uri.parse(url),
          body: json.encode({"data":encryption(json.encode(data))}),

          headers:{
            "CONTENT-TYPE":"application/json"
          }).timeout(Duration(seconds:20));
/*setState(() {
      vaue.text=response.statusCode.toString();
    });*/

      print(response.statusCode.toString()+"ffhhhh");
      // print("ddfg"+decryption(response.body.toString()));

      if (response.statusCode== 200) {
        Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;


    clientSecret =result["client_secret"];
      }else{
        print(response.statusCode.toString()+"Vfvfv");
    }

    }on TimeoutException catch (e) {
    print(e.toString());

      //return false;
    }on Exception catch(e){
      print(e.toString());
    }



    return clientSecret;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(String clientSecret, String paymentMethodId,Stripe stripe) async{
    Map<String, dynamic> paymentIntentRes_3dSecure=new Map<String,dynamic>();
    try{
      await stripe.confirmPayment(clientSecret, paymentMethodId: paymentMethodId);
      paymentIntentRes_3dSecure = await stripe.api.retrievePaymentIntent(clientSecret);
    }catch(e){
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, "Error", "Something went wrong.");
    }print(paymentIntentRes_3dSecure.toString());
    return paymentIntentRes_3dSecure;
  }


  Future<String> getCustomerEmail() async{

    String customerEmail="",email="ebs.sandbox@gmail.com";
    SharedPreferences sp=await SharedPreferences.getInstance() as SharedPreferences;
    customerEmail=sp.getString("email")!=null?sp.getString("email")!:"ebs.sandbox@gmail.com";
    email=customerEmail;
    return email;
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.popUntil(context,ModalRoute.withName("/offerings")), // dismiss dialog
            ),
          ],
        );
      },
    );
  }
}