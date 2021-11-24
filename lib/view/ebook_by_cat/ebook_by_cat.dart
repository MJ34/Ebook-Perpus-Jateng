import 'package:ebook/controller/con_by_cat.dart';
import 'package:ebook/controller/con_latest.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:ebook/view/detail/ebook_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routers.dart';

class EbookByCategory extends StatefulWidget {

  int idCategory;

  EbookByCategory({required this.idCategory});

  @override
  _EbookByCategoryState createState() => _EbookByCategoryState();
}

class _EbookByCategoryState extends State<EbookByCategory> {

  Future<List<ModelEbook>>? getLibrary;
  List<ModelEbook> listLibrary = [];

  @override
  void initState() {
    super.initState();
    getLibrary = fetchByCategory(listLibrary, widget.idCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Library', style: TextStyle(
            color: Colors.black
        ),),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
            future: getLibrary,
            builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 5.5 / 9.0
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        pushPage(context, EbookDetail(
                            ebookId: listLibrary[index].id,
                            status: listLibrary[index].statusNews));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            ClipRRect(
                              child: Image.network(
                                '${listLibrary[index].photo}', height: 20.h, width: 30.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 1.w,),
                            Container(
                              child: Text('${listLibrary[index].title}', style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w500
                              ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                              width: 30.w,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}