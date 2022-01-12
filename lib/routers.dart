import 'package:flutter/material.dart';

void pushPage(BuildContext ctx, Widget widget){
  Navigator.push(ctx, MaterialPageRoute(builder: (ctx)=>widget));
}

void pushPageReplacement(BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>widget));
}

void backButton(BuildContext context){
  Navigator.pop(context, true);
}

void pushPageRemove(BuildContext context, Widget widget){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget), (Route<dynamic>route) => false);
}