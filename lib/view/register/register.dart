import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EbookRegister extends StatefulWidget {

  @override
  _EbookRegisterState createState() => _EbookRegisterState();
}

class _EbookRegisterState extends State<EbookRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Buat Akun Ebook Sekarang', style: TextStyle(
                color: Colors.black, fontSize: 18
              ),),
              GestureDetector(
                onTap: (){},
                child: Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 10),
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                    child: Image.asset('assets/image/upload.png', width: 30, height: 30, fit: BoxFit.cover,),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
