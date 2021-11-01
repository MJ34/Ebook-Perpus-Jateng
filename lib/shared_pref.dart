import 'package:shared_preferences/shared_preferences.dart';

prefLogin({required var id, required var name, required var email, required var photo}) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var _id = id;
  var _name = name;
  var _email = email;
  var _photo = photo;

  await preferences.setStringList('login', [_id, _name, _email, _photo]);
}

Future prefLoad() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getStringList('login');
}