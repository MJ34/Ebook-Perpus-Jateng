import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/controller/con_detail.dart';
import 'package:ebook/controller/con_save_favorite.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:ebook/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EbookDetail extends StatefulWidget {
  int ebookId;
  int status;

  EbookDetail({Key? key, required this.ebookId, required this.status})
      : super(key: key);

  @override
  _EbookDetailState createState() => _EbookDetailState();
}

class _EbookDetailState extends State<EbookDetail> {
  Future<List<ModelEbook>>? getDetail;
  List<ModelEbook> listDetail = [];
  String checkFavorite = "0", id = "", name = "", email = "", photo = "";
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    getDetail = fetchDetail(listDetail, widget.ebookId);
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        checkFavorites(id);
      });
    });
  }

  checkFavorites(String id) async {
    var data = {'id_course': widget.ebookId, 'id_user': id};
    var checkFav = await Dio()
        .post(ApiConstant().baseUrl + ApiConstant().checkFavorite, data: data);
    var response = checkFav.data;
    setState(() {
      checkFavorite = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Detail Ebook',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: getDetail,
        builder:
            (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: 25.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.network(
                                    listDetail[index].photo,
                                    fit: BoxFit.cover,
                                    width: 35.w,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                        listDetail[index].title,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Text(
                                        'Author: ${listDetail[index].authorName}',
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Text(
                                        'Publisher: ${listDetail[index].publisherName}',
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                //Save data ke tabel favorite
                                                await showDialog(
                                                    context: context,
                                                    builder: (myFav) =>
                                                        FutureProgressDialog(
                                                            saveFavorite(
                                                                context: myFav,
                                                                idEbook: widget
                                                                    .ebookId
                                                                    .toString(),
                                                                idUser:
                                                                    id))).then(
                                                    (value) async {
                                                  preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  dynamic fav = preferences!
                                                      .get('saveFavorite');
                                                  setState(() {
                                                    checkFavorite = fav;
                                                  });
                                                });
                                              },
                                              child: checkFavorite == "already"
                                                  ? Icon(
                                                      Icons.bookmark,
                                                      color: Colors.blue,
                                                      size: 21.sp,
                                                    )
                                                  : Icon(
                                                      Icons.bookmark_border,
                                                      color: Colors.blue,
                                                      size: 21.sp,
                                                    )),
                                          SizedBox(
                                            width: 1.5.w,
                                          ),
                                          Text(
                                            'Publisher: ${listDetail[index].pages}',
                                            style: const TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w400),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            width: 1.5.w,
                                          ),
                                          listDetail[index].free == 1
                                              ? const Text('Free',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis)
                                              : const Text('Premium',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              _share();
                                            },
                                            child: Icon(
                                              Icons.share,
                                              color: Colors.black87,
                                              size: 21.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          )
                                        ],
                                      )
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                )
                              ],
                            ),
                          ),
                          widget.status == 0
                              ? Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.blueAccent),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Segera Hadir',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 12, right: 12),
                                )
                              : listDetail[index].free == 1
                                  ? GestureDetector(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.blueAccent),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Baca (Gratis)',
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            left: 12, right: 12),
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            const PDF(
                                                enableSwipe: true,
                                                swipeHorizontal: true,
                                                autoSpacing: false,
                                                pageFling: false,
                                                fitPolicy: FitPolicy.BOTH
                                            ).cachedFromUrl(listDetail[index].pdf,
                                                placeholder: (progress)=> MaterialApp(
                                                  debugShowCheckedModeBanner: false,
                                                  home: Scaffold(backgroundColor: Colors.white, body: Center(child: Text('$progress %'),)),
                                                ))));
                                      },
                                    )
                                  : GestureDetector(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.blueAccent),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Baca (Berbayar)',
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            left: 12, right: 12),
                                      ),
                                      onTap: () {},
                                    ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 2.h),
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.black12),
                            child: Column(
                              children: [
                                const Text(
                                  'Deskripsi',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                Html(
                                  data: listDetail[index].description,
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              ],
            );
          } else {
            return const Align(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.blueAccent,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _share() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    Share.share("Saya membaca buku bagus sekali di aplikasi ${pi.appName} '\n'"
        " Download sekarang di: https://play.google.com/store/apps/details?id=${pi.packageName}");
  }
}
