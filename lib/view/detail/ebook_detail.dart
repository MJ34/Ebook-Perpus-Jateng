import 'package:ebook/controller/con_detail.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class EbookDetail extends StatefulWidget {

  int ebookId;
  int status;

  EbookDetail({required this.ebookId, required this.status});

  @override
  _EbookDetailState createState() => _EbookDetailState();
}

class _EbookDetailState extends State<EbookDetail> {

  Future<List<ModelEbook>>? getDetail;
  List<ModelEbook> listDetail = [];

  @override
  void initState() {
    super.initState();
    getDetail = fetchDetail(listDetail, widget.ebookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (

      ),
      body: Container (
        child: FutureBuilder(
          future: getDetail,
          builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  ListView.builder(
                      itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 25.h,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                      '${listDetail[index].photo}',
                                      fit: BoxFit.cover,
                                      width: 35.w,
                                    ),
                                  ),
                                  SizedBox(width: 3.w,),
                                  Flexible(
                                 child: Column(
                                    children: [
                                      Text('${listDetail[index].title}', style: TextStyle(
                                        color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w500
                                      ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                      SizedBox(height: 1.5.h,),
                                      Text('Author: ${listDetail[index].authorName}', style: TextStyle(
                                        color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500
                                      ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                      SizedBox(height: 1.5.h,),
                                      Text('Publisher: ${listDetail[index].publisherName}', style: TextStyle(
                                          color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500
                                      ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                      Spacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){},
                                            child: Icon(Icons.bookmark_border),
                                          ),
                                          SizedBox(width: 1.5.w,),
                                          Text('Publisher: ${listDetail[index].pages}', style: TextStyle(
                                              color: Colors.blueAccent, fontWeight: FontWeight.w400
                                          ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                          SizedBox(width: 1.5.w,),
                                          listDetail[index].free == 1 ? Text('Free', style: TextStyle(
                                              color: Colors.blueAccent, fontWeight: FontWeight.w400
                                          ), maxLines: 1, overflow: TextOverflow.ellipsis) : Text('Premium', style: TextStyle(
                                          color: Colors.blueAccent, fontWeight: FontWeight.w400
                                          ), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: (){
                                              _share();
                                            },
                                            child: Icon(Icons.share, color: Colors.black87, size: 21.sp,),
                                          ),
                                          SizedBox(width: 2.w,)
                                        ],
                                      )
                                    ],
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                  )
                                ],
                              ),
                            ),
                            widget.status == 0 ? Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blueAccent),
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Text('Segera Hadir', style: TextStyle(
                                  color: Colors.white
                                ), textAlign: TextAlign.center,),
                              ),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 12, right: 12),
                            ) : listDetail[index].free == 1 ? GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blueAccent),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Baca (Gratis)', style: TextStyle(
                                    color: Colors.white
                                  ), textAlign: TextAlign.center,),
                                ),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 12, right: 12),
                              ),
                              onTap: (){},
                            ) : GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.blueAccent),
                                child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Baca (Berbayar)', style: TextStyle(
                                color: Colors.white
                                ), textAlign: TextAlign.center,),
                                ),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 12, right: 12),
                                ),
                              onTap: (){},
                              ),
                            SizedBox(height: 3.h,),
                            Container(
                              padding: EdgeInsets.only(top: 2.h),
                              margin: EdgeInsets.only(left: 12, right: 12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.black12),
                              child: Column(
                                children: [
                                  Text('Deskripsi', style: TextStyle(
                                    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500
                                  ),),
                                  Html(
                                    data: '${listDetail[index].description}',
                                  )
                                ],
                              ),
                            )
                              ],
                              );
                              }
                            ),
                          ],
                        );
            }  else {
              return Align(
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.blueAccent,),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _share() async{
    PackageInfo pi = await PackageInfo.fromPlatform();
    Share.share("Saya membaca buku bagus sekali di aplikasi ${pi.appName} '\n'"
    " Download sekarang di: https://play.google.com/store/apps/details?id=${pi.packageName}");
  }
}
