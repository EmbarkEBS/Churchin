import 'package:shared_preferences/shared_preferences.dart';

class Helper{
  static String? type="";
  Future<bool> getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type= prefs.containsKey("user_type")?prefs.getString("user_type"):"";
    return prefs.containsKey("user_type");
  }
}