import 'dart:io';
import 'package:ebook/controller/api.dart';
import 'package:ebook/routers.dart';
import 'package:ebook/view/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EbookRegister extends StatefulWidget {
  const EbookRegister({Key? key}) : super(key: key);

  @override
  _EbookRegisterState createState() => _EbookRegisterState();
}

class _EbookRegisterState extends State<EbookRegister> {
  File _file = File('');
  final picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibleloading = false;

  Future register(
      {required TextEditingController name,
      required TextEditingController email,
      required TextEditingController password,
      required BuildContext context,
      required Widget widget}) async {
    setState(() {
      visibleloading = true;
    });

    String getName = name.text;
    String getEmail = email.text;
    String getPassword = password.text;

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstant().baseUrl + ApiConstant().register));
    var photo = await http.MultipartFile.fromPath('photo', _file.path);
    request.fields['name'] = getName;
    request.fields['email'] = getEmail;
    request.fields['password'] = getPassword;
    request.files.add(photo);

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        visibleloading = false;
      });
      //Arahkan langsung ke halaman login
      pushPage(context, const Login());
    } else {
      setState(() {
        visibleloading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Nama or Email sudah tersedia, silahkan input data lain',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Paham'),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Buat Akunmu Sekarang Gratis',
                style: TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  imagePicker(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      right: 30, left: 30, top: 15, bottom: 10),
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _file.path == ''
                        ? Image.asset(
                            'assets/image/upload.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          )
                        : Image.file(_file,
                            width: 35, height: 35, fit: BoxFit.cover),
                  ),
                ),
              ),
              //Field Nama
              Container(
                margin: const EdgeInsets.only(
                    right: 20, left: 20, top: 10, bottom: 10),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                      hintText: 'Inputkan Nama Kamu',
                      prefixIcon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black54,
                      ),
                      filled: true,
                      isDense: true,
                      fillColor: Colors.white70,
                      hintStyle: const TextStyle(color: Colors.black87),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent))),
                ),
              ),
              //Field Email
              Container(
                margin: const EdgeInsets.only(
                    right: 20, left: 20, top: 10, bottom: 10),
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                      hintText: 'Inputkan Email Kamu',
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
                        borderSide: const BorderSide(color: Colors.blueAccent),
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
                      hintText: 'Inputkan Password Kamu',
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
                        borderSide: const BorderSide(color: Colors.blueAccent),
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
                  if (_file.path != "") {
                    if (nameController.text != "") {
                      if (emailController.text != "") {
                        if (passwordController.text != "") {
                          register(
                              name: nameController,
                              email: emailController,
                              password: passwordController,
                              context: context,
                              widget: widget);
                        } else {
                          msgValidation('Password Kosong',
                              'Silahkan input bagian password');
                        }
                      } else {
                        msgValidation(
                            'Email Kosong', 'Silahkan input bagian email');
                      }
                    } else {
                      msgValidation(
                          'Nama Kosong', 'Silahkan input bagian nama');
                    }
                  } else {
                    msgValidation('Photo Kosong', 'Silahkan pilih photo');
                  }
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
                              'Create Account',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
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
                        'Sudah punya akun?',
                        style: TextStyle(fontSize: 17, color: Colors.black87),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          pushPage(context, const Login());
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  imageFromGallery() async {
    var imageGallery = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageGallery != null) {
        _file = File(imageGallery.path);
        print("success ${imageGallery.path}");
      } else {
        print("Tidak berhasil mengambil image");
      }
    });
  }

  imageFromCamera() async {
    var imageCamera = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 100,
        maxWidth: 100);
    setState(() {
      if (imageCamera != null) {
        _file = File(imageCamera.path);
        print("success ${imageCamera.path}");
      } else {
        print("Tidak berhasil mengambil image");
      }
    });
  }

  void imagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.library_add_sharp,
                    color: Colors.blueAccent,
                  ),
                  title: const Text(
                    'Photo dari Galery',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    imageFromGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.blueAccent,
                  ),
                  title: const Text(
                    'Photo dari Kamera',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () {
                    imageFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  //Pesan untuk validasi textbox
  Future msgValidation(String title, String description) {
    return Alert(
        context: context,
        type: AlertType.error,
        onWillPopActive: true,
        title: title,
        desc: description,
        style: const AlertStyle(
            animationType: AnimationType.fromBottom,
            backgroundColor: Colors.white),
        buttons: [
          DialogButton(
            padding: const EdgeInsets.all(1),
            child: const SizedBox(
              height: 40,
              child: Text('Okay'),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]).show();
  }
}
