
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void pushPage(BuildContext ctx, Widget widget){
  Navigator.push(ctx, MaterialPageRoute(builder: (ctx)=>widget));
}

void pushPageRemove(BuildContext context, Widget widget){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget), (Route<dynamic>route) => false);
}