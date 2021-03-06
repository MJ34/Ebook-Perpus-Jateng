import 'package:ebook/controller/con_favorite.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:ebook/routers.dart';
import 'package:ebook/shared_pref.dart';
import 'package:ebook/view/detail/ebook_detail.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EbookFavorite extends StatefulWidget {
  const EbookFavorite({Key? key}) : super(key: key);

  @override
  _EbookFavoriteState createState() => _EbookFavoriteState();
}

class _EbookFavoriteState extends State<EbookFavorite> {
  Future<List<ModelEbook>>? getFavorite;
  List<ModelEbook> listFavorite = [];

  String id = "", name = "", email = "", photo = "";

  @override
  void initState() {
    super.initState();
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        //Get Favorite
        getFavorite = fetchFavorite(listFavorite, id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Favorite',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getFavorite,
          builder:
              (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 5.5 / 9.0),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pushPage(
                          context,
                          EbookDetail(
                              ebookId: listFavorite[index].id,
                              status: listFavorite[index].statusNews));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Image.network(
                              listFavorite[index].photo,
                              height: 20.h,
                              width: 30.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          SizedBox(
                            child: Text(
                              listFavorite[index].title,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            width: 30.w,
                          )
                        ],
                      ),
                    ),
                  );
                },
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
