import 'dart:io';
import 'package:ebook/routers.dart';
import 'package:ebook/view/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EbookAccount extends StatefulWidget {
  const EbookAccount({Key? key}) : super(key: key);

  @override
  _EbookAccountState createState() => _EbookAccountState();
}

class _EbookAccountState extends State<EbookAccount> {
  String photoUser = '';
  File file = File('');
  final picker = ImagePicker();
  String id = "", name = "", email = "";
  late SharedPreferences preferences;

  Future updatePhotoProfile() async {
    var req = http.MultipartRequest(
        'POST', Uri.parse(ApiConstant().baseUrl + ApiConstant().updatePhoto));
    req.fields['iduser'] = id;
    var photo = await http.MultipartFile.fromPath('photo', file.path);
    req.files.add(photo);
    var response = await req.send();
    if (response.statusCode == 200) {
      setState(() {
        file = File('');
      });
      getPhoto(id);
    }
  }

  Future getPhoto(String idUser) async {
    var reqest = await Dio().post(
        ApiConstant().baseUrl + ApiConstant().viewPhoto,
        data: {'id': idUser});
    var decode = reqest.data;
    if (decode != "no_img") {
      setState(() {
        photoUser = decode;
      });
    } else {
      photoUser = "";
    }
  }

  @override
  void initState() {
    super.initState();
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        getPhoto(id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              updatePhotoProfile();
            },
            child: file.path != ''
                ? const Center(
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                : const Text(''),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    imagePicker(context);
                  },
                  child: Container(
                    height: 15.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        photoUser != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  photoUser,
                                  fit: BoxFit.cover,
                                  width: 30.w,
                                  height: 30.h,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  'assets/image/upload.png',
                                  fit: BoxFit.cover,
                                  width: 30.w,
                                  height: 30.h,
                                ),
                              ),
                        file.path == ''
                            ? const Text('')
                            : const Text(
                                'Rubah ke => ',
                                style: TextStyle(color: Colors.black),
                              ),
                        file.path == ''
                            ? const Text('')
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: file.path == ''
                                    ? Image.asset(
                                        'assets/image/upload.png',
                                        width: 30.w,
                                        height: 30.h,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        file,
                                        width: 30.w,
                                        height: 30.h,
                                        fit: BoxFit.cover,
                                      ))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.sp),
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.sp),
                      child: Text(
                        email,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 30.sp),
                    child: const Text(
                      'Ebook App Support',
                      style: TextStyle(
                          color: Colors.black12,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 10.sp),
                      child: const Text(
                        'Tentang App',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 10.sp),
                      child: const Text(
                        'Kebijakan Privasi',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 10.sp),
                      child: const Text(
                        'Beri Rating',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 10.sp),
                      child: const Text(
                        'Bagikan Aplikasi',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                //Fungsi Logout
                GestureDetector(
                  onTap: () async {
                    preferences = await SharedPreferences.getInstance();
                    preferences.remove('login');
                    pushPageRemove(context, const Login());
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                    child: const Text(
                      'LOGOUT',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  imageFromGallery() async {
    var imageGallery = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageGallery != null) {
        file = File(imageGallery.path);
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
        file = File(imageCamera.path);
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
}
