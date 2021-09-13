import 'package:ebook/controller/con_ebook.dart';
import 'package:ebook/model/model_ebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<List<ModelEbook>>? getSlider;
  List<ModelEbook> listSlider = [];

  Future<List<ModelEbook>>? getPost;
  List<ModelEbook> listPostTerbaru = [];

  @override
  void initState() {
    super.initState();
    getSlider = fetchEbook(listSlider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: SingleChildScrollView(
        child: FutureBuilder(
          future: getSlider,
          builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Column(
                children: [
                  //Slider
                  Container(
                    child: FutureBuilder(
                        future: getSlider,
                        builder: (BuildContext context, AsyncSnapshot<List<ModelEbook>> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return SizedBox(
                              height: 30,
                              child: Swiper(
                              itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index){
                                return GestureDetector(
                                  onTap: (){},
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      child: Image.network(
                                        listSlider[index].photo
                                      ),
                                    ),
                                  ),
                                );
                                }
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                    ),
                  )
                  //Item Terbaru

                  //Coming Soon

                  //Category
                ],
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
