import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingSharedPrefrence{
 static late  SharedPreferences sharedPreferences;

static Future  initializeSharedPrefrenceStorge()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }

 static bool isFirstTime()  {
    bool isFirst=sharedPreferences.getBool("isFirstTime")??true;
    return isFirst;
  }

 static setFirstTime(){
  sharedPreferences.setBool("isFirstTime",false);
  }
}