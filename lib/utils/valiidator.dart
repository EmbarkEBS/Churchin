class FieldValidator{
  static String? validateEmail(String value){
    if(value.isEmpty)return 'Please Enter Email!';
    final RegExp regex =
    RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value))
      return 'Enter a Valid Email!';
    else
      return null;
  }
  static String? validateFullname(String value){
    if(value.isEmpty)return 'Please Enter Full Name';
    final RegExp regex=
        RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid Fullname!';
    else
      return null;
  }
  static String? validateCity(String value){
    if(value.isEmpty)return 'Please Enter City';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid City!';
    else
      return null;
  }
  static String? validateState(String value){
    if(value.isEmpty)return 'Please Enter State';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid State!';
    else
      return null;
  }
  static String? validateCountry(String value){
    if(value.isEmpty)return 'Please Enter Country';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid Country!';
    else
      return null;
  }
  static String? validateMobile(String value){
    if(value.isEmpty)return 'Please Enter Mobile Number';
    final RegExp regex=
    RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid Mobile Number!';
    else
      return null;
  }
  static String? validateOccupation(String value){
    if(value.isEmpty)return 'Please Enter Occupation';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid Occupation!';
    else
      return null;
  }
  static String? validateTeacherName(String value){
    if(value.isEmpty)return 'Please Enter Teacher Name';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value))
      return 'Enter a Valid Teacher Name!';
    else
      return null;
  }
}