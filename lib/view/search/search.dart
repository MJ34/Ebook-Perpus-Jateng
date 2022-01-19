import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ebook/controller/api.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:ebook/view/detail/ebook_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../routers.dart';

class EbookSearch extends StatefulWidget {
  const EbookSearch({Key? key}) : super(key: key);

  @override
  _EbookSearchState createState() => _EbookSearchState();
}

class _EbookSearchState extends State<EbookSearch> {
  Future<List<ModelEbook>>? getNewEbook;
  List<ModelEbook> listNewEbook = [];

  bool loading = false;

  Future fetchSearchData(String str) async {
    var response = await Dio()
        .get(ApiConstant().baseUrl + ApiConstant().api + ApiConstant().latest,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));

    for (Map<String, dynamic> sliderData in response.data) {
      listNewEbook.add(ModelEbook(
          id: sliderData['id'],
          title: sliderData['title'],
          photo: sliderData['photo'],
          description: sliderData['description'],
          catId: sliderData['cat_id'],
          statusNews: sliderData['status_news'],
          pdf: sliderData['pdf'],
          date: sliderData['date'],
          authorName: sliderData['author_name'],
          publisherName: sliderData['publisher_name'],
          pages: sliderData['pages'],
          language: sliderData['language'],
          rating: sliderData['rating'],
          free: sliderData['free']));
    }
    loading = false;
  }

  @override
  void initState() {
    super.initState();
    fetchSearchData('');
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
        child: Container(
          width: 8.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/image/search.png',
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        showSearch(context: context, delegate: MangaSearchAction());
      },
    );
  }
}

class MangaSearchAction extends SearchDelegate<String> {
  bool loading = true;

  Future getDataFromJson(String str) async {
    var response = await http.get(
      Uri.parse(ApiConstant().baseUrl +
          ApiConstant().api +
          ApiConstant().search +
          str),
      headers: {"Accept": "application/json"},
    );

    loading = false;
    return response.body;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.white, //new AppBar color
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.black,
        ),
      ),
    );
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          color: Colors.black,
          progress: transitionAnimation),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? const Center(
            child: Text(
              'Pancaharian Buku',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
        : FutureBuilder(
            future: getDataFromJson(query),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
              } else {
                List<ModelEbook> ebook = [];
                for (Map<String, dynamic> sliderData
                    in jsonDecode(snapshot.data)) {
                  ebook.add(ModelEbook(
                      id: sliderData['id'],
                      title: sliderData['title'],
                      photo: sliderData['photo'],
                      description: sliderData['description'],
                      catId: sliderData['cat_id'],
                      statusNews: sliderData['status_news'],
                      pdf: sliderData['pdf'],
                      date: sliderData['date'],
                      authorName: sliderData['author_name'],
                      publisherName: sliderData['publisher_name'],
                      pages: sliderData['pages'],
                      language: sliderData['language'],
                      rating: sliderData['rating'],
                      free: sliderData['free']));
                }
                return SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: ebook.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.0),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              height: 15.h,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 1.0,
                                    spreadRadius: 0.2,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Image.network(
                                          ebook[index].photo,
                                          fit: BoxFit.cover,
                                          width: 20.w,
                                          height: 15.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ebook[index].title,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 1.5.h,
                                            ),
                                            Text(
                                              'Author: ${ebook[index].authorName}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            Text(
                                              'Publisher: ${ebook[index].publisherName}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            pushPage(
                                context,
                                EbookDetail(
                                    ebookId: ebook[index].id,
                                    status: ebook[index].statusNews));
                          },
                        );
                      }),
                );
              }
            },
          );
  }
}
