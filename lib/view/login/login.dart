import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/shared_pref.dart';
import 'package:ebook/view/register/register.dart';
import 'package:ebook/view/view_bottom/bottom_view.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routers.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibleloading = false;

  Future login(
      {required TextEditingController email,
      required TextEditingController password,
      required BuildContext context,
      required Widget widget}) async {
    String getEmail = email.text;
    String getPassword = password.text;

    setState(() {
      visibleloading = true;
    });

    var data = {'email': getEmail, 'password': getPassword};
    var request = await Dio()
        .post(ApiConstant().baseUrl + ApiConstant().login, data: data);

    var decode = jsonDecode(request.data);

    if (decode[4] == "Successfully login") {
      setState(() {
        visibleloading = false;
      });
      prefLogin(id: decode[0], name: decode[1], email: decode[2], photo: '');
      pushPageRemove(context, widget);
    } else {
      setState(() {
        visibleloading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Email or Password belum terdaftar, Silahkan daftar akun!!',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text('login'),
                )
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    prefLoad().then((value) {
      setState(() {
        if (value != null) {
          pushPageRemove(context, BottomView());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/image/logo.png',
                  width: 120,
                  height: 120,
                ),
                const Text(
                  'Hallo, Silahkan Masuk',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 22),
                ),

                Container(
                  margin: EdgeInsets.only(
                      right: 20, left: 20, top: 6.h, bottom: 10),
                  child: TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        hintText: 'Masukan Email Kamu',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black54,
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white70,
                        hintStyle: const TextStyle(color: Colors.black87),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent))),
                  ),
                ),
                //Field Password
                Container(
                  margin: const EdgeInsets.only(
                      right: 20, left: 20, top: 10, bottom: 10),
                  child: TextField(
                    controller: passwordController,
                    autocorrect: true,
                    obscureText: true,
                    autofocus: false,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        hintText: 'Masukan Password Kamu',
                        prefixIcon: const Icon(
                          Icons.password_outlined,
                          color: Colors.black54,
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white70,
                        hintStyle: const TextStyle(color: Colors.black87),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent))),
                  ),
                ),
                //Button Register
                GestureDetector(
                  onTap: () {
                    login(
                        email: emailController,
                        password: passwordController,
                        context: context,
                        widget: BottomView());
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 10),
                      padding: EdgeInsets.only(
                          top: 1.2.h, bottom: 1.2.h, right: 5.w, left: 5.w),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueAccent),
                      child: !visibleloading
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Visibility(
                              visible: visibleloading,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun?',
                          style: TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            pushPage(context, EbookRegister());
                          },
                          child: const Text(
                            'Daftar',
                            style: TextStyle(color: Colors.blue, fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
