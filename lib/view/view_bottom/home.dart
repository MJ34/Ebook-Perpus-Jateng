import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/controller/con_category.dart';
import 'package:ebook/controller/con_coming.dart';
import 'package:ebook/controller/con_ebook.dart';
import 'package:ebook/controller/con_latest.dart';
import 'package:ebook/model/model_category.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:ebook/routers.dart';
import 'package:ebook/shared_pref.dart';
import 'package:ebook/view/detail/ebook_detail.dart';
import 'package:ebook/view/ebook_all/all_ebook.dart';
import 'package:ebook/view/ebook_by_cat/ebook_by_cat.dart';
import 'package:ebook/view/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<ModelEbook>>? getSlider;
  List<ModelEbook> listSlider = [];

  Future<List<ModelEbook>>? getPostTerbaru;
  List<ModelEbook> listPostTerbaru = [];

  Future<List<ModelEbook>>? getComing;
  List<ModelEbook> listComing = [];

  //CATEGORY MODEL
  Future<List<ModelCategory>>? getCategory;
  List<ModelCategory> listCategory = [];

  //Model data session dengan shared Preference
  String id = '', name = '', email = '', photo = '';

  @override
  void initState() {
    super.initState();
    //slider
    getSlider = fetchEbook(listSlider);
    //post terbaru
    getPostTerbaru = fetchLatest(listPostTerbaru);
    //list coming
    getComing = fetchComing(listComing);
    //list category buku
    getCategory = fetchCategory(listCategory);
    //Ambil data session dengan shared Preference
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        photo = value[3];
        getPhoto(id);
      });
    });
  }

  Future getPhoto(String idUser) async {
    var request = await Dio().post(
        ApiConstant().baseUrl + ApiConstant().viewPhoto,
        data: {'id': idUser});
    var decode = request.data;
    if (decode != "no_img") {
      setState(() {
        photo = decode;
      });
    } else {
      setState(() {
        photo = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Row(
          children: [
            Container(
                child: photo == ""
                    ? ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: Image.asset(
                          'assets/image/upload.png',
                          fit: BoxFit.cover,
                          width: 12.w,
                          height: 6.h,
                        ))
                    : ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: Image.network(
                          photo,
                          fit: BoxFit.cover,
                          width: 12.w,
                          height: 6.h,
                        ),
                      )
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              'Hello $name',
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
        actions: const [
          EbookSearch(),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getSlider,
          builder:
              (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Slider
                  FutureBuilder(
                    future: getSlider,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ModelEbook>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: 27.h,
                          child: Swiper(
                              autoplay: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    pushPage(
                                        context,
                                        EbookDetail(
                                            ebookId: listSlider[index].id,
                                            status:
                                                listSlider[index].statusNews));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: Image.network(
                                            listSlider[index].photo,
                                            fit: BoxFit.cover,
                                            width: 100.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                ),
                                                gradient: LinearGradient(
                                                    end: const Alignment(
                                                        0.0, -1),
                                                    begin: const Alignment(
                                                        0.0, 0.2),
                                                    colors: [
                                                      Colors.blue,
                                                      Colors.black
                                                          .withOpacity(0.0)
                                                    ])),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                listSlider[index].title,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  //Category
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: getCategory,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ModelCategory>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext cxt, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          pushPage(
                                              context,
                                              EbookByCategory(
                                                idCategory:
                                                    listCategory[index].catId,
                                              ));
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  child: Image.network(
                                                    listCategory[index]
                                                        .photoCat,
                                                    height: 15.h,
                                                    width: 25.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                ClipRRect(
                                                    child: Container(
                                                  height: 15.h,
                                                  width: 25.w,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                )),
                                                Positioned(
                                                  child: Center(
                                                    child: Text(
                                                      listCategory[index].name,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  bottom: 0,
                                                  top: 0,
                                                  right: 0,
                                                  left: 0,
                                                )
                                              ],
                                            )),
                                      );
                                    }),
                                height: 15.h,
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  //========================COMING SOON===================================================
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: getComing,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ModelEbook>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            color: Colors.blueGrey.withOpacity(0.5),
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Segera Hadir',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                          letterSpacing: 2),
                                      textAlign: TextAlign.center,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: 3.h),
                                  ),
                                ),
                                SizedBox(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext ctx, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            pushPage(
                                                context,
                                                EbookDetail(
                                                    ebookId:
                                                        listComing[index].id,
                                                    status: listComing[index]
                                                        .statusNews));
                                          },
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                child: Image.network(
                                                  listComing[index].photo,
                                                  height: 15.h,
                                                  width: 25.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              SizedBox(
                                                width: 25.w,
                                                child: Text(
                                                  listComing[index].title,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                  height: 25.h,
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  //Item Terbaru
                  FutureBuilder(
                    future: getPostTerbaru,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ModelEbook>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'Latest',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  print(
                                      "persamaanIndex $index dan ${snapshot.data!.length}");
                                  if (index == snapshot.data!.length) {
                                    //Item Custom
                                    return GestureDetector(
                                      onTap: () {
                                        pushPage(context, const AllEbook());
                                      },
                                      child: Container(
                                        width: 25.w,
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          'Lihat Semua',
                                          style: TextStyle(color: Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } else {
                                    //Items Buku
                                    return GestureDetector(
                                      onTap: () {
                                        pushPage(
                                            context,
                                            EbookDetail(
                                                ebookId:
                                                    listPostTerbaru[index].id,
                                                status: listPostTerbaru[index]
                                                    .statusNews));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              child: Image.network(
                                                listPostTerbaru[index].photo,
                                                height: 15.h,
                                                width: 25.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            SizedBox(
                                              width: 25.w,
                                              child: Text(
                                                listPostTerbaru[index].title,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemCount: snapshot.data!.length + 1,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  //Jarak
                  SizedBox(
                    height: 2.h,
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
